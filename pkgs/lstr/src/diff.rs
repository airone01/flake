use std::path::PathBuf;

use anyhow::{Context, Result};
use git2::Repository;
use serde::Serialize;
use serde_json::Value;
use similar::TextDiff;
use tempdir::TempDir;

pub fn pretty_json(json_in: String) -> Result<String> {
    let mut buf = Vec::new();
    let fmt = serde_json::ser::PrettyFormatter::with_indent(b"  ");
    let mut ser = serde_json::Serializer::with_formatter(&mut buf, fmt);

    let jj: Value = serde_json::from_str(&json_in)?;
    jj.serialize(&mut ser)?;

    Ok(String::from_utf8(buf)?)
}

pub fn log_diff(old_ref: &str, new_ref: &str, old: String, new: String) {
    let diff = TextDiff::from_lines(&old, &new);

    let d = diff.unified_diff().header(old_ref, new_ref).to_string();
    if !d.is_empty() {
        eprint!("{d}");
    }

    // struct Line(Option<usize>);
    //
    // impl std::fmt::Display for Line {
    //     fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
    //         match self.0 {
    //             None => write!(f, "    "),
    //             Some(idx) => write!(f, "{:<4}", idx + 1),
    //         }
    //     }
    // }
    //
    // for (idx, group) in diff.grouped_ops(3).iter().enumerate() {
    //     if idx > 0 {
    //         eprintln!("{:-^1$}", "-", 80);
    //     }
    //     for op in group {
    //         for change in diff.iter_inline_changes(op) {
    //             let (sign, s) = match change.tag() {
    //                 ChangeTag::Delete => ("-", Style::new().red()),
    //                 ChangeTag::Insert => ("+", Style::new().green()),
    //                 ChangeTag::Equal => (" ", Style::new().dim()),
    //             };
    //             eprint!(
    //                 "{}{} |{}",
    //                 style(Line(change.old_index())).dim(),
    //                 style(Line(change.new_index())).dim(),
    //                 s.apply_to(sign).bold(),
    //             );
    //             for (emphasized, value) in change.iter_strings_lossy() {
    //                 if emphasized {
    //                     eprint!("{}", s.apply_to(value).underlined().on_black());
    //                 } else {
    //                     eprint!("{}", s.apply_to(value));
    //                 }
    //             }
    //             if change.missing_newline() {
    //                 eprintln!();
    //             }
    //         }
    //     }
    // }
}

pub fn checkout(repo_dir: PathBuf, arg_ref: String) -> Result<(PathBuf, TempDir)> {
    let tmpdir = TempDir::new("lstr").context("Failed create temporary directory")?;
    let mut tmp_path = tmpdir.path().to_path_buf();
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

    Ok((tmp_path, tmpdir))
}
