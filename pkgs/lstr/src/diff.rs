use anyhow::Result;
use log::info;
use serde::Serialize;
use serde_json::Value;
use similar::TextDiff;

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
        info!("{d}");
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
