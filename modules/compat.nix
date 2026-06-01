{inputs, ...}: {
  flake.nixosModules.compat = {
    lib,
    config,
    ...
  }: {
    options.stars.compat.fwd_2605.enable =
      lib.mkEnableOption "forward compatibility for NixOS 26.05 to newer versions";

    config = lib.mkIf config.stars.compat.fwd_2605.enable {
      home-manager.users.${config.stars.mainUser} = {
        programs.firefox.configPath = ".config/mozilla/firefox";

        home.activation.migrateMozillaConfig = inputs.home-manager.lib.hm.dag.entryBefore ["writeBoundary"] ''
          oldPath="$HOME/.mozilla/firefox"
          newPath="''${XDG_CONFIG_HOME:-$HOME/.config}/mozilla/firefox"
          if [ -d "$oldPath" ] && [ ! -d "$newPath" ]; then
            $DRY_RUN_CMD mkdir -p "$(dirname "$newPath")"
            $DRY_RUN_CMD mv -v "$oldPath" "$newPath"
          fi
        '';
      };
    };
  };
}
