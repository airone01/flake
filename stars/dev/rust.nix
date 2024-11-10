{pkgs, ...}: {
  packages = with pkgs; [
    cargo-edit
    cargo-watch
    cargo-outdated
  ];

  systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];
}
