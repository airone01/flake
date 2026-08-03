# feature: niri desktop environment
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  noctalia = pkgs.callPackage ../../pkgs/noctalia {inherit inputs;};
in {
  imports = [inputs.clipboard-sync.nixosModules.default];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.niri = {
    enable = true;
    package = lib.mkDefault (pkgs.callPackage ../../pkgs/niri {
      inherit inputs noctalia;
    });
  };

  services = {
    clipboard-sync.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.niri.default = ["gnome" "gtk"];
  };

  environment.systemPackages = with pkgs; [
    noctalia
    xwayland-satellite
    brightnessctl
    playerctl
    pamixer
    grimblast
    wl-clipboard
    cliphist
    rofi
    thunar
    yazi
    firefox
  ];
}
