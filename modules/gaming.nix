# feature: gaming; Sony DualSense controller patches
_: {
  flake.nixosModules.gaming = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.gaming = lib.mkEnableOption "gaming optimizations";

    config = lib.mkIf config.stars.gaming {
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        gamescope
        lutris
        prismlauncher
        retroarch-full
        retroarch-assets
        typer
      ];

      programs = {
        # TODO: for Steam in home-manager, see
        # https://github.com/nix-community/home-manager/issues/4314
        # in the meantime:
        steam.enable = true;
        gamemode.enable = true;
      };
    };
  };

  flake.nixosModules.desktopDualsensePatch = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.dualsensePatch =
      lib.mkEnableOption "Sony DualSense controller patches";

    config = lib.mkIf config.stars.dualsensePatch {
      environment.systemPackages = with pkgs; [dualsensectl];

      services.udev = {
        enable = true;

        # https://wiki.archlinux.org/title/Gamepad
        extraRules = ''
          # disable DualShok4/DualSense touchpad acting as mouse
          # USB
          ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
          # Bluetooth (untested, name might vary)
          ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        '';
      };
    };
  };
}
