{pkgs, ...}: {
  imports = [
    ./fs/bat.nix
    ./fs/eza.nix
    ./fs/ripgrep.nix
    ./mux/zellij.nix
    ./monitor/btop.nix
    ./versioning/git.nix
    ./versioning/gh.nix
  ];

  environment.systemPackages = with pkgs; [
    act
    atac
    dust
    fd
    fzf
    jq
    man-pages
    onefetch
    pfetch
  ];
}
