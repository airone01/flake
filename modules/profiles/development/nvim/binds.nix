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
      && cfg.profiles.development.enableNvimConfig
    ) {
      home-manager.users.${config.stars.mainUser} = {
        programs.nvf.settings.vim = {
          binds = {
            cheatsheet.enable = true;
            # shows menu with corresponding keys when typing
            whichKey.enable = true;
          };

          # Custom keymaps
          maps = {
            # jk to escape insert mode
            insert = {
              "jk" = {
                action = "<Esc>";
                silent = true;
                desc = "Exit insert mode";
              };
            };

            normal = {
              # code actions
              "<leader>ca" = {
                action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
                silent = true;
                desc = "Code actions";
              };
              # format file
              "<leader>fm" = {
                action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
                silent = true;
                desc = "Format buffer";
              };
            };
          };
        };
      };
    };
}
