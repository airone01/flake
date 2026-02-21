{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
      && cfg.profiles.development.enableNvf
    ) {
      home-manager.users.${config.stars.mainUser} = {
        programs.nvf.settings.vim.utility = {
          # NF icon picker
          icon-picker.enable = true;

          # markdown preview with glow
          preview.glow = {
            enable = true;
            # "<leader>p"
          };

          # images support
          images.image-nvim = {
            enable = true;

            setupOpts = {
              backend = "kitty";
              integrations.markdown.downloadRemoteImages = true;
            };
          };
        };
      };
    };
}
