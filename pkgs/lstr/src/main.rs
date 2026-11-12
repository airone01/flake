pub mod diff;

use std::{
    ffi::{OsStr, OsString},
    path::PathBuf,
};

use clap::{Parser, Subcommand};

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Debug, Subcommand)]
enum Commands {
    #[command(arg_required_else_help = true)]
    EvalDiff {
        #[arg(value_name = "COMMIT")]
        base: Option<OsString>,
        #[arg(value_name = "COMMIT")]
        head: Option<OsString>,
        #[arg(last = true)]
        path: Option<OsString>,
    },
}

fn main() {
    let args = Cli::try_parse().unwrap_or_else(|error| error.exit());

    match args.command {
        Commands::EvalDiff {
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
            println!(
                "Evaluating diff with base {base} and head {head} at '{}'.",
                path.to_string_lossy()
            );
            let mut path_buf = PathBuf::new();
            path_buf.push(path);
            diff::eval_diff(path_buf, base.to_string(), head.to_string(), true).unwrap();
        }
    }
}
