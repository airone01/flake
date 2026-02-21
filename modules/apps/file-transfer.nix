{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qbittorrent
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
