{pkgs, ...}: {
  imports = [
    ./rust.nix
  ];

  environment.systemPackages = with pkgs; [
    # C/C++
    gnumake
    cmake

    # Python
    pipx
    python313
    python313Packages.pip

    # JS/TS
    bun
    nodejs
  ];
}
