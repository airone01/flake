{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.stars;
in {
  imports = [
    ./binds.nix
    ./dashboard.nix
    ./filetree.nix
    ./git.nix
    ./languages.nix
    ./lsp.nix
    ./statusline.nix
    ./tabline.nix
    ./telescope.nix
    ./treesitter.nix
    ./ui.nix
    ./utility.nix
    ./vim.nix
    ./wrappers.nix
  ];

  options.stars.profiles.development.enableNvf = lib.mkOption {
    default = true;
    example = true;
    description = "Whether to enable the custom Neovim configuration with NVF.";
    relatedPackages = [pkgs.neovim];
    type = lib.types.bool;
  };

  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
      && cfg.profiles.development.enableNvf
    ) {
      home-manager.users.${cfg.mainUser} = {
        home.packages = with pkgs; [
          # lightbulb requires an emoji font
          noto-fonts-color-emoji
          twemoji-color-font
        ];

        programs.nvf.enable = true;
      };
    };
}
