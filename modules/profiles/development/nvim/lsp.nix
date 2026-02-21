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
        programs.nvf.settings.vim = {
          lsp = {
            enable = true;

            formatOnSave = true;
            # show code actions even when there are no lsp warns/errors
            lightbulb.enable = true;
            # "signature": box that appears when e.g. you start typing args of a function
            lspSignature.enable = true;
            lspconfig.enable = true;
            # pictograms
            lspkind.enable = true;
            # advanced lsp framework
            lspsaga.enable = true;
            # Language-in-language
            otter-nvim.enable = true;
          };

          maps.normal = {
            # Quickfix navigation
            "<leader>qn" = {
              action = "<cmd>cnext<CR>";
              desc = "Next quickfix item";
            };
            "<leader>qp" = {
              action = "<cmd>cprev<CR>";
              desc = "Previous quickfix item";
            };
            "<leader>qo" = {
              action = "<cmd>copen<CR>";
              desc = "Open quickfix list";
            };
            "<leader>qc" = {
              action = "<cmd>cclose<CR>";
              desc = "Close quickfix list";
            };
          };

          luaConfigRC.suppress-null-ls-warning = ''
            -- Suppress null-ls deprecation warnings
            local notify = vim.notify
            vim.notify = function(msg, ...)
              if msg:match("null%-ls") then
                return
              end
              notify(msg, ...)
            end
          '';

          diagnostics = {
            enable = true;
            config = {
              signs.text = {
                "vim.diagnostic.severity.ERROR" = "󰅚 ";
                "vim.diagnostic.severity.WARN" = "󰀪 ";
              };
            };
          };

          # spoken/written languages
          spellcheck = {
            enable = true;

            languages = [
              "en"
              # TODO add "fr" here and configure dictionary
            ];
          };
        };
      };
    };
}
