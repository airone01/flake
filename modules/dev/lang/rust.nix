{pkgs, ...}: {
  stars.home = [
    {
      home.packages = with pkgs; [
        cargo-edit
        cargo-watch
        cargo-outdated

        rustc
        cargo
        rustfmt
        rust-analyzer
        clippy

        # Needed for compilation
        gcc
        alsa-lib
        pkg-config
        zlib
        systemdLibs # libudev
      ];
    }
  ];
}
