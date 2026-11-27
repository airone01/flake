use anyhow::{Context as _, Result};
use git2::Repository;
use log::trace;
use std::path::PathBuf;
use tempdir::TempDir;

pub fn checkout(repo_dir: PathBuf, arg_ref: String) -> Result<(PathBuf, TempDir)> {
    let tmpdir = TempDir::new("lstr").context("Failed create temporary directory")?;
    let mut tmp_path = tmpdir.path().to_path_buf();
    if tmp_path.is_symlink() {
        tmp_path = tmp_path.read_link().context("Failed to read temp link")?;
    }

    let repo_dir = repo_dir.to_str().unwrap();
    trace!("Cloning '{}' to '{}'", repo_dir, tmp_path.to_str().unwrap());
    let repo = Repository::clone(repo_dir, &tmp_path)?;
    let (obj, gref) = repo
        .revparse_ext(&arg_ref)
        .context(format!("Failed to parse ref {arg_ref}"))?;

    trace!(
        "Checking out '{}' at '{}'",
        arg_ref,
        tmp_path.to_str().unwrap()
    );
    repo.checkout_tree(&obj, None)
        .context("Failed to checkout")?;
    match gref {
        Some(gref) => repo.set_head(gref.name().unwrap()),
        None => repo.set_head_detached(obj.id()),
    }
    .context("Failed to set HEAD")?;

    Ok((tmp_path, tmpdir))
}
