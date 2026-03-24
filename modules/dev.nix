# feature: development environment & tools
#
# This file is an anti-pattern because the toolchains defined here can break
# when a specific version is needed for a program (i.e. Node 18 needed but 24
# is the one globally defined). This is especially true with pkg-config, or
# other dependency routing tools.
# I am conflicted between the practicality of having global tools like this,
# and the correct way, which is a devShell with the correct deps and direnv
# binding.
# If I somehow find a better way to tackle this problem, I'll implement it, but
# in this meantime, I'm leaning towards convenience on this one.
{self, ...}: {
  flake.nixosModules.dev = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [self.nixosModules.userEnv];

    options.stars.dev = lib.mkEnableOption "development environment & tools";

    config = lib.mkIf config.stars.dev {
      stars.userEnv = lib.mkDefault true;

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
    };
  };
}
