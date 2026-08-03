# feature: development environment & tools
{pkgs, ...}: {
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
    # pipx # waiting for nixpkgs #536749
    python3
    # python313
    # python313Packages.pip

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

    # Nix & flake
    age
    cachix
    sops
    ssh-to-age

    # tools
    atac
    act
    bat
    btop
    dig
    file
    fzf
    gh
    glow
    htop
    jq
    man-pages
    nmap
    onefetch
    ripgrep
  ];
}
