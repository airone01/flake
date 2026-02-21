{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  imports = [
    ./nvim
  ];

  options.stars.profiles.development.enable = lib.mkEnableOption "development environment & tools";

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
    ) {
      environment.systemPackages = with pkgs; [
        # C/C++
        gcc
        cmake
        bazel
        gnumake

        # headers and libs
        pkg-config
        # vulkan-headers
        # vulkan-loader
        # opencl-headers
        # SDL2
        alsa-lib
        systemdLibs # libudev
        zlib

        # Zig
        zig
        zls

        # Python
        pipx
        python313
        python313Packages.pip

        # JS/TS
        bun
        deno
        nodejs
        pnpm

        # Rust
        cargo
        cargo-outdated
        clippy
        rustc
        rustfmt
        rust-analyzer

        # tools
        atac
        act
        man-pages
        jq
        onefetch
      ];
    };
}
