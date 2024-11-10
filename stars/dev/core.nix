{pkgs, ...}: {
  packages = with pkgs; [
    bat
    git
    nmap
  ];
}
