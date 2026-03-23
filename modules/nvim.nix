_: {
  flake.nixosModules.nvim = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.nvim = lib.mkEnableOption "custom Neovim configuration with NVF";

    config = lib.mkIf config.stars.nvim {
      home-manager.users.${config.stars.mainUser} = {
        home.packages = with pkgs; [
          # lightbulb requires an emoji font
          noto-fonts-color-emoji
          twemoji-color-font
        ];

        programs.nvf = {
          enable = true;

          settings.vim = {
            autocomplete.nvim-cmp.enable = true;
            autopairs.nvim-autopairs.enable = true;

            binds = {
              cheatsheet.enable = true;
              # shows menu with corresponding keys when typing
              whichKey.enable = true;
            };

            # TODO: dashboard-nvim theme
            # https://github.com/goolord/alpha-nvim/blob/a9d8fb72213c8b461e791409e7feabb74eb6ce73/README.md#dashboard-nvim-theme
            dashboard.alpha.enable = true;

            diagnostics = {
              enable = true;
              config = {
                signs.text = {
                  "vim.diagnostic.severity.ERROR" = "󰅚 ";
                  "vim.diagnostic.severity.WARN" = "󰀪 ";
                };
              };
            };

            filetree.neo-tree = {
              enable = true;

              setupOpts = {
                enable_cursor_hijack = true;
                git_status_async = true; # for big repos
                auto_clean_after_session_restore = true;

                window = {
                  width = 30; # default is 40
                  # mappings = {
                  #   "<" = "none"; # Disable default shrink
                  #   ">" = "none"; # Disable default expand
                  # };
                };

                # note: to toggle on/off hidden files, press H in neo-tree
              };
            };

            git = {
              enable = true;
              gitsigns.enable = true;
              gitsigns.mappings = {
                nextHunk = "]c";
                previousHunk = "[c";
                stageHunk = "<leader>hs";
                resetHunk = "<leader>hr";
                previewHunk = "<leader>hp";
              };
            };

            languages = {
              # for each enabled language below:
              enableDAP = true;
              enableExtraDiagnostics = true;
              enableFormat = true;
              enableTreesitter = true;

              # programming/scripting/configuration languages list
              assembly = {
                enable = true;
                lsp.enable = false;
              };
              astro = {
                enable = true;
                format.type = ["biome"];
              };
              bash.enable = true;
              clang.enable = true;
              css = {
                enable = true;
                format.type = ["biome"];
              };
              go.enable = true;
              html.enable = true;
              json.enable = true;
              lua.enable = true;
              markdown.enable = true;
              nix.enable = true;
              php.enable = true;
              python.enable = true;
              rust = {
                enable = true;
                extensions.crates-nvim.enable = true;
              };
              sql.enable = true;
              svelte = {
                enable = true;
                format.type = ["biome"];
              };
              tailwind.enable = true;
              ts = {
                enable = true;
                format.type = ["biome"];
              };
              yaml.enable = true;
              zig.enable = true;
            };

            # show static line, not relative number
            lineNumberMode = "number";

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

            luaConfigRC = {
              better-escape = ''
                -- Better `jk` escape with timeout
                vim.o.timeoutlen = 300
                vim.o.ttimeoutlen = 10
              '';

              suppress-null-ls-warning = ''
                -- Suppress null-ls deprecation warnings
                local notify = vim.notify
                vim.notify = function(msg, ...)
                  if msg:match("null%-ls") then
                    return
                  end
                  notify(msg, ...)
                end
              '';

              winbar-theme = ''
                -- Make winbar follow theme
                vim.api.nvim_set_hl(0, 'WinBar', { link = 'Normal' })
                vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'Comment' })
              '';

              visual-high-contrast = ''
                vim.api.nvim_create_autocmd("ColorScheme", {
                  pattern = "*",
                  callback = function()
                    vim.api.nvim_set_hl(0, 'Visual', {
                      bg = '#3a515d',  -- More blue-tinted, higher contrast
                      fg = 'NONE',
                      reverse = false
                    })
                  end,
                })
              '';
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
            };

            # notification library
            notify.nvim-notify.enable = true;

            options.termguicolors = true;

            # spoken/written languages
            spellcheck = {
              enable = true;

              languages = [
                "en"
                # TODO add "fr" here and configure dictionary
              ];
            };

            statusline.lualine.enable = true;

            syntaxHighlighting = true;

            tabline.nvimBufferline = {
              enable = true;

              mappings = {
                closeCurrent = "<leader>x";
                cycleNext = "<tab>";
                cyclePrevious = "<S-Tab>";
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

            telescope = {
              enable = true;

              mappings = {
                findFiles = "<leader>ff";
                liveGrep = "<leader>fw";
                buffers = "<leader>fb";
                helpTags = "<leader>fh";
                gitCommits = "<leader>gc";
                lspReferences = "<leader>lr";
                lspDefinitions = "<leader>ld";
              };
            };

            # main theme (doesn't apply to status bar)
            theme = {
              enable = true;

              name = "everforest";
              style = "medium";
            };

            treesitter = {
              enable = true;

              # html tag auto rename
              autotagHtml = true;

              context.enable = true;
            };

            ui = {
              # borders for compatible plugins
              borders = {
                enable = true;

                globalStyle = "rounded";

                # plugins and integrations
                plugins = {
                  lsp-signature.enable = true;
                  lspsaga.enable = true;
                  nvim-cmp.enable = true;
                  which-key.enable = true;
                };
              };

              # lsp path indication below the tab bar
              breadcrumbs = {
                enable = true;
                navbuddy.enable = true;
              };

              # render written colors e.g. `#f00`
              colorizer.enable = true;

              # simple line decorator
              # this is causing a bug when highlighting text
              # see #117
              modes-nvim.enable = false;
            };

            utility = {
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

            visuals = {
              # Smooth scrolling
              cinnamon-nvim.enable = true;

              # notification widget
              fidget-nvim.enable = true;

              # indent blankline
              indent-blankline = {
                enable = true;

                setupOpts = {
                  scope.enabled = true;
                };
              };

              # highlight cursor
              nvim-cursorline = {
                enable = true;

                setupOpts = {
                  cursorline.enable = true;
                  cursorword.enable = true;
                };
              };

              # scroll bar
              nvim-scrollbar.enable = true;

              # icons
              nvim-web-devicons.enable = true;
            };

            # wrappers
            withNodeJs = true;
            withPython3 = true;
            withRuby = true;
          };
        };
      };
    };
  };
}
