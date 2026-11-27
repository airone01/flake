pub mod build;
pub mod deriv_type;
pub mod diff;
pub mod git;
pub mod target;
pub mod targets;

use std::{
    ffi::{OsStr, OsString},
    path::PathBuf,
    str::FromStr,
};

use clap::{Parser, Subcommand};
use log::trace;

use crate::{
    build::build_target, deriv_type::DerivType, target::diff_target,
    targets::diff_available_targets,
};

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Debug, Subcommand)]
enum Commands {
    #[command(
        arg_required_else_help = true,
        about = "Diffs the evaluation of a target",
        after_help = "Returns whether the target should be built."
    )]
    DiffTarget {
        #[arg(value_name = "TYPE", help = "Target type")]
        target_type: OsString,
        #[arg(value_name = "TARGET", help = "Target name")]
        target: OsString,
        #[arg(value_name = "REF", help = "Base ref")]
        base: Option<OsString>,
        #[arg(value_name = "REF", help = "Head ref")]
        head: Option<OsString>,
        #[arg(last = true, help = "Repo path")]
        path: Option<OsString>,
    },
    #[command(
        arg_required_else_help = true,
        about = "Diffs the list of available targets",
        after_help = "Returns the JSON of targets that should be built."
    )]
    DiffAvailableTargets {
        #[arg(value_name = "REF", help = "Base ref")]
        base: Option<OsString>,
        #[arg(value_name = "REF", help = "Head ref")]
        head: Option<OsString>,
        #[arg(last = true, help = "Repo path")]
        path: Option<OsString>,
    },
    #[command(arg_required_else_help = true, about = "Builds a target")]
    BuildTarget {
        #[arg(value_name = "TYPE", help = "Target type")]
        target_type: OsString,
        #[arg(value_name = "TARGET", help = "Target name")]
        target: OsString,
        #[arg(
            value_name = "SYSTEM",
            help = "Nix system, if target is a package",
            long = "system",
            short = 's'
        )]
        system: Option<OsString>,
        #[arg(last = true, help = "Repo path")]
        path: Option<OsString>,
    },
}

fn main() {
    colog::init();
    let args = Cli::try_parse().unwrap_or_else(|error| error.exit());

    match args.command {
        Commands::DiffTarget {
            target_type,
            target,
            mut base,
            mut head,
            mut path,
        } => {
            if path.is_none() {
                path = head;
                head = None;
                if path.is_none() {
                    path = base;
                    base = None;
                }
            }
            let base = base
                .as_deref()
                .map(|s| s.to_str().unwrap())
                .unwrap_or("main");
            let head = head
                .as_deref()
                .map(|s| s.to_str().unwrap())
                .unwrap_or("HEAD");
            let path = path.as_deref().unwrap_or_else(|| OsStr::new(""));
            trace!(
                "Evaluating diff with base {base} and head {head} at '{}'",
                path.to_string_lossy()
            );
            let mut path_buf = PathBuf::new();
            path_buf.push(path);
            diff_target(
                target
                    .into_string()
                    .expect("Package should be a valid value."),
                DerivType::from_str(target_type.to_str().unwrap_or("package"))
                    .expect("Could not infer target type from value."),
                path_buf,
                base.to_string(),
                head.to_string(),
                true,
            )
            .unwrap();
        }
        Commands::DiffAvailableTargets {
            mut base,
            mut head,
            mut path,
        } => {
            if path.is_none() {
                path = head;
                head = None;
                if path.is_none() {
                    path = base;
                    base = None;
                }
            }
            let base = base
                .as_deref()
                .map(|s| s.to_str().unwrap())
                .unwrap_or("main");
            let head = head
                .as_deref()
                .map(|s| s.to_str().unwrap())
                .unwrap_or("HEAD");
            let path = path.as_deref().unwrap_or_else(|| OsStr::new(""));
            trace!(
                "Evaluating diff with base {base} and head {head} at '{}'.",
                path.to_string_lossy()
            );
            let mut path_buf = PathBuf::new();
            path_buf.push(path);
            diff_available_targets(path_buf, base.to_string(), head.to_string(), true).unwrap();
        }
        Commands::BuildTarget {
            target_type,
            target,
            path,
            system,
        } => {
            let path = path.as_deref().unwrap_or_else(|| OsStr::new(""));
            let mut path_buf = PathBuf::new();
            path_buf.push(path);
            build_target(
                system.and_then(|s| s.into_string().ok()),
                target.into_string().unwrap(),
                DerivType::from_str(target_type.to_str().unwrap_or("package"))
                    .expect("Could not infer target type from value."),
                path_buf,
            )
            .unwrap();
        }
    }
}
