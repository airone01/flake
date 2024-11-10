{pkgs, ...}: {
  packages = with pkgs; [
    bat
    git
    nmap
    # Nix formatter
    alejandra
  ];
}
