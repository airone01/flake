use std::{path::PathBuf, process::Command, thread};

use anyhow::{Context, Result};
use console::{Style, style};
use git2::Repository;
use serde::Serialize;
use serde_json::Value;
use similar::{ChangeTag, TextDiff};
use tempdir::TempDir;

fn gen_eval(path: PathBuf) -> Command {
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

  pkgs = builtins.mapAttrs (
    system: sysPkgs:
    builtins.mapAttrs (name: pkg: if pkg ? drvPath then pkg.drvPath else null) sysPkgs
  ) (outputs.packages or {});

  nixos = builtins.mapAttrs (
    host: cfg:
    cfg.config.system.build.toplevel.drvPath
  ) (outputs.nixosConfigurations or {});
in
{
  packages = pkgs;
  nixosConfigurations = nixos;
}
",
        );
    cmd
}

fn pretty_json(json_in: String) -> Result<String> {
    let mut buf = Vec::new();
    let fmt = serde_json::ser::PrettyFormatter::with_indent(b"  ");
    let mut ser = serde_json::Serializer::with_formatter(&mut buf, fmt);

    let jj: Value = serde_json::from_str(&json_in)?;
    jj.serialize(&mut ser)?;

    Ok(String::from_utf8(buf)?)
}

struct Line(Option<usize>);

impl std::fmt::Display for Line {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self.0 {
            None => write!(f, "    "),
            Some(idx) => write!(f, "{:<4}", idx + 1),
        }
    }
}

fn text_diff(old: String, new: String) {
    let diff = TextDiff::from_lines(&old, &new);

    for (idx, group) in diff.grouped_ops(3).iter().enumerate() {
        if idx > 0 {
            println!("{:-^1$}", "-", 80);
        }
        for op in group {
            for change in diff.iter_inline_changes(op) {
                let (sign, s) = match change.tag() {
                    ChangeTag::Delete => ("-", Style::new().red()),
                    ChangeTag::Insert => ("+", Style::new().green()),
                    ChangeTag::Equal => (" ", Style::new().dim()),
                };
                print!(
                    "{}{} |{}",
                    style(Line(change.old_index())).dim(),
                    style(Line(change.new_index())).dim(),
                    s.apply_to(sign).bold(),
                );
                for (emphasized, value) in change.iter_strings_lossy() {
                    if emphasized {
                        print!("{}", s.apply_to(value).underlined().on_black());
                    } else {
                        print!("{}", s.apply_to(value));
                    }
                }
                if change.missing_newline() {
                    println!();
                }
            }
        }
    }
}

fn eval_one(repo_dir: PathBuf, arg_ref: String, destroy_after_use: bool) -> Result<String> {
    let tmp = TempDir::new("lstr").context("Failed create temporary directory")?;
    let mut tmp_path = tmp.path().to_path_buf();
    if tmp_path.is_symlink() {
        tmp_path = tmp_path.read_link().context("Failed to read temp link")?;
    }

    let repo = Repository::clone(repo_dir.to_str().unwrap(), &tmp_path)?;
    let (obj, gref) = repo
        .revparse_ext(&arg_ref)
        .context(format!("Failed to parse ref {arg_ref}"))?;

    repo.checkout_tree(&obj, None)
        .context("Failed to checkout")?;
    match gref {
        Some(gref) => repo.set_head(gref.name().unwrap()),
        None => repo.set_head_detached(obj.id()),
    }
    .context("Failed to set HEAD")?;

    let out = gen_eval(tmp_path).output()?;
    if !out.status.success() {
        eprintln!("{}", String::from_utf8(out.stderr.clone())?);
    }

    let json = pretty_json(String::from_utf8(out.stdout.clone())?)?;
    if destroy_after_use {
        tmp.close()
            .unwrap_or_else(|error| eprintln!("Failed to close temp dir {}", error));
    }

    Ok(json)
}

pub fn eval_diff(
    repo_dir: PathBuf,
    base_ref: String,
    head_ref: String,
    destroy_after_use: bool,
) -> Result<()> {
    let rd = repo_dir.clone();
    let dau = destroy_after_use.clone();
    let handle_base = thread::spawn(move || eval_one(rd, base_ref, dau));
    let handle_head = thread::spawn(move || eval_one(repo_dir, head_ref, destroy_after_use));

    let base_json = handle_base.join().unwrap()?;
    let head_json = handle_head.join().unwrap()?;

    text_diff(base_json, head_json);

    Ok(())
}
