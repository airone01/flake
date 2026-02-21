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
        programs.nvf.settings.vim.tabline.nvimBufferline = {
          enable = true;

          mappings = {
            closeCurrent = "<leader>x";
            cycleNext = "<tab>";
            cyclePrevious = "<shift><tab>";
          };

          setupOpts.options = {
            middle_mouse_command = {
              _type = "lua-inline";
              expr = ''
                function(bufnum)
                  require("bufdelete").bufdelete(bufnum, false)
                end
              '';
            };

            numbers = "none";
            separator_style = "thin";
            modified_icon = "●";

            indicator = {
              style = "none"; # this removes the underline/icon indicator
            };
          };
        };
      };
    };
}
