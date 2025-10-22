{
  lib,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.zellij = {
      enable = true;

      settings = {
        show_startup_tips = false;
        theme = "everforest-dark-medium";

        themes.rose-pine-moon = {
          bg = "#44415a";
          fg = "#e0def4";
          red = "#eb6f92";
          green = "#3e8fb0";
          blue = "#9ccfd8";
          yellow = "#f6c177";
          magenta = "#c4a7e7";
          orange = "#fe640b";
          cyan = "#ea9a97";
          black = "#393552";
          white = "#e0def4";
        };

        # themes.everforest-dark-medium = lib.concatStringsSep "\n" (lib.drop 2 (lib.strings.splitString "\n" (builtins.readFile (builtins.fetchurl {
        #   url = "https://raw.githubusercontent.com/n1yn/everforest-dark-zellij/f4221921cc0ea844db3910f0387b8d2b76deee9d/everforest.yaml";
        #   sha256 = "12453l9d4dxwklhpbqii4kyrh5qrdgnhyl61rp1fnyfw7gzapiq7";
        # }))));

        themes.everforest-dark-medium = {
          fg = "#d3c6aa";
          bg = "#2f383e";
          black = "#4a555b";
          red = "#d6494d";
          green = "#a7c080";
          yellow = "#dbbc7f";
          blue = "#7fbbb3";
          magenta = "#d699b6";
          cyan = "#83c092";
          white = "#a7c080";
          orange = "#e69875";
        };
      };
    };
  };
}
