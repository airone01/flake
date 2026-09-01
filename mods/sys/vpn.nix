# feature: unified desktop environment
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mullvad-browser
    proton-vpn
    tor
    tor-browser
  ];

  services.mullvad-vpn = {
    enable = true;

    gui.enable = true;
    # enableEarlyBootBlocking = true;
  };
}
