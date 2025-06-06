{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [
    cargo-edit
    cargo-watch
    cargo-outdated

    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];
}
