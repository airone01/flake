# feature: unified desktop environment
_: {
  flake.nixosModules.vpn = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.vpn.enable = lib.mkEnableOption "VPNs and anonymity";

    config = lib.mkIf config.stars.desktop.vpn.enable {
      environment.systemPackages = with pkgs; [
        mullvad-browser
        protonvpn-gui
        tor
        tor-browser
      ];

      services.
        mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
        enableEarlyBootBlocking = true;
      };
    };
  };
}
