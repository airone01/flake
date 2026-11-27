use std::fmt::Display;
use std::{path::PathBuf, process::Command, thread};

use anyhow::{Result, bail};
use log::{error, info, trace, warn};

use crate::deriv_type::DerivType;
use crate::diff::{log_diff, pretty_json};
use crate::git::checkout;

fn gen_eval_package(path: PathBuf, target: String) -> Command {
    let mut cmd = Command::new("nix");
    cmd.current_dir(path)
        .arg("eval")
        .arg("--impure")
        .arg("--expr")
        .arg(format!(
            "
let
  flake = builtins.getFlake (toString ./.);
  system_name = \"{target}\";
in
  flake.outputs.packages.${{builtins.currentSystem}}.${{system_name}}.drvPath
",
        ));
    cmd
}

fn gen_eval_nixos_configuration(path: PathBuf, target: String) -> Command {
    let mut cmd = Command::new("nix");
    cmd.current_dir(path)
        .arg("eval")
        .arg("--impure")
        .arg("--expr")
        .arg(format!(
            "
let
  flake = builtins.getFlake (toString ./.);
  system_name = \"{target}\";
in
  flake.outputs.nixosConfigurations.${{system_name}}.config.system.build.toplevel.drvPath
",
        ));
    cmd
}

fn eval_one_target(
    target: String,
    target_type: DerivType,
    repo_dir: PathBuf,
    r#ref: String,
    destroy_after_use: bool,
) -> Result<String> {
    let (tmp_path, tmpdir) = checkout(repo_dir, r#ref)?;

    let out = (match target_type {
        DerivType::Package => gen_eval_package,
        DerivType::NixosConfiguration => gen_eval_nixos_configuration,
    })(tmp_path, target)
    .output()?;
    if !out.status.success() {
        error!(
            "Evaluation failed with the following error:\n{}",
            String::from_utf8(out.stderr.clone())?
        );
    }

    let json = pretty_json(String::from_utf8(out.stdout.clone())?)?;
    if destroy_after_use {
        trace!("Destroying '{}' after use", tmpdir.path().to_str().unwrap());
        tmpdir
            .close()
            .unwrap_or_else(|error| error!("Failed to close temp dir {}", error));
    } else {
        warn!("Temp dir '{}' left behind", tmpdir.path().to_str().unwrap())
    }

    Ok(json)
}

#[derive(Debug, Clone, Eq, PartialEq)]
struct TargetDiffErr;

impl Display for TargetDiffErr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "target versions differ")
    }
}

pub fn diff_target(
    target: String,
    target_type: DerivType,
    repo_dir: PathBuf,
    base_ref: String,
    head_ref: String,
    destroy_after_use: bool,
) -> Result<()> {
    let rd = repo_dir.clone();
    let dau = destroy_after_use.clone();
    let tt = target_type.clone();
    let tg = target.clone();
    let br = base_ref.clone();
    let hr = head_ref.clone();

    let handle_base = thread::spawn(move || eval_one_target(tg, tt, rd, br, dau));
    let handle_head = thread::spawn(move || {
        eval_one_target(target, target_type, repo_dir, hr, destroy_after_use)
    });

    let base_join = handle_base.join().unwrap();
    let base_attrpath = base_join.unwrap_or(String::from("{}"));
    let head_attrpath = handle_head
        .join()
        .unwrap()
        .expect("Head derivation should evaluate!");

    if base_attrpath == head_attrpath {
        info!("There are no diffs");
    } else {
        log_diff(&base_ref, &head_ref, base_attrpath, head_attrpath);
        bail!(TargetDiffErr);
    }

    Ok(())
}
