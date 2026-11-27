use std::{path::PathBuf, process::Command, thread};

use anyhow::Result;
use log::{error, info, trace, warn};

use crate::{
    diff::{log_diff, pretty_json},
    git::checkout,
};

fn gen_eval_targets(path: PathBuf) -> Command {
    let mut cmd = Command::new("nix");
    cmd.current_dir(path)
        .arg("eval")
        .arg("--impure")
        .arg("--json")
        .arg("--expr")
        .arg(
            "
let
  flake = builtins.getFlake (toString ./.);
  outputs = flake.outputs;

  packages = builtins.mapAttrs (
    system: sysPkgs:
    builtins.attrNames sysPkgs
  ) (outputs.packages or {});

  nixosConfigurations = builtins.attrNames (outputs.nixosConfigurations or {});
in {
  inherit packages nixosConfigurations;
}
",
        );
    cmd
}

fn eval_available_targets(
    repo_dir: PathBuf,
    r#ref: String,
    destroy_after_use: bool,
) -> Result<String> {
    let (tmp_path, tmpdir) = checkout(repo_dir, r#ref.clone())?;

    let out = gen_eval_targets(tmp_path).output()?;
    if !out.status.success() {
        error!(
            "Evaluation failed with the following error:\n{}",
            String::from_utf8(out.stderr.clone())?
        );
    }

    if destroy_after_use {
        trace!("Destroying '{}' after use", tmpdir.path().to_str().unwrap());
        tmpdir
            .close()
            .unwrap_or_else(|error| error!("Failed to close temp dir {}", error));
    } else {
        warn!("Temp dir '{}' left behind", tmpdir.path().to_str().unwrap())
    }

    Ok(String::from_utf8(out.stdout.clone())?)
}

pub fn diff_available_targets(
    repo_dir: PathBuf,
    base_ref: String,
    head_ref: String,
    destroy_after_use: bool,
) -> Result<()> {
    let rd = repo_dir.clone();
    let dau = destroy_after_use.clone();
    let br = base_ref.clone();
    let hr = head_ref.clone();

    let handle_base = thread::spawn(move || eval_available_targets(rd, br, dau));
    let handle_head =
        thread::spawn(move || eval_available_targets(repo_dir, hr, destroy_after_use));

    let base_json = handle_base.join().unwrap()?;
    let head_json = handle_head.join().unwrap()?;

    print!("{head_json}");

    if head_json == base_json {
        info!("There are no diffs");
    } else {
        let base_pretty = pretty_json(base_json)?;
        let head_pretty = pretty_json(head_json)?;

        log_diff(&base_ref, &head_ref, base_pretty, head_pretty);
    }

    Ok(())
}
