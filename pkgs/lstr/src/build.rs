use std::{
    path::PathBuf,
    process::{Command, Stdio},
};

use anyhow::Result;

use crate::deriv_type::DerivType;

fn gen_build(path: PathBuf, target_type: DerivType, system: String, target: String) -> Command {
    let mut cmd = Command::new("nix");
    cmd.current_dir(path)
        .arg("build")
        .arg(format!(".#{}.{system}.{target}", target_type.as_str()))
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit());
    cmd
}

fn gen_get_sys() -> Command {
    let mut cmd = Command::new("nix");
    cmd.arg("eval")
        .arg("--raw")
        .arg("--impure")
        .arg("--expr")
        .arg("builtins.currentSystem");
    cmd
}

pub fn build_target(
    system: Option<String>,
    target: String,
    target_type: DerivType,
    repo_dir: PathBuf,
) -> Result<()> {
    let system = system
        .unwrap_or_else(|| String::from_utf8(gen_get_sys().output().unwrap().stdout).unwrap());
    let out = gen_build(repo_dir, target_type, system, target).output()?;

    if !out.status.success() {
        eprintln!("{}", String::from_utf8(out.stderr)?);
    }

    Ok(())
}
