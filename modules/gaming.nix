# feature: gaming
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
}
