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
        proton-vpn
        tor
        tor-browser
      ];

      services.mullvad-vpn = {
        enable = true;

        gui.enable = true;
        enableEarlyBootBlocking = true;
      };
    };
  };
}
