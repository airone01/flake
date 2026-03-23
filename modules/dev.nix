_: {
  flake.nixosModules.dev = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.dev = lib.mkEnableOption "development environment & tools";

    config = lib.mkIf config.stars.dev {
      environment.systemPackages = with pkgs; [
        # C/C++
        gcc
        cmake
        bazel_8
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

        # Go
        go

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
        bat
        dig
        glow
        jq
        man-pages
        onefetch
      ];
    };
  };
}
