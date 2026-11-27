# basic config which mine overloads
lib: {
  config.vim = {
    autocomplete.blink-cmp = {
      enable = true;
      # "lsp-signature does not work with blink.cmp. Please use blink.cmp's builtin signature feature"
      setupOpts.signature.enabled = true;
    };

    autopairs.nvim-autopairs.enable = true;

    binds = {
      cheatsheet.enable = true;
      # shows menu with corresponding keys when typing
      whichKey.enable = true;
    };

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
          width = 32; # default is 40
          # mappings = {
          #   "<" = "none"; # Disable default shrink
          #   ">" = "none"; # Disable default expand
          # };
        };
      };
    };

    # show static line, not relative number
    lineNumberMode = "number";

    luaConfigRC = let
      dir = ./luarc;
      entries = builtins.readDir dir;
      luaFiles =
        lib.filterAttrs (
          name: type: type == "regular" && lib.hasSuffix ".lua" name
        )
        entries;
    in
      lib.mapAttrs' (
        file: _:
          lib.nameValuePair (lib.removeSuffix ".lua" file) (builtins.readFile (dir + "/${file}"))
      )
      luaFiles;

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

    statusline.lualine = {
      enable = true;

      # LSP path breadcrumbs on the statusline
      # I don't use it often, but it's kinda useful
      integrations.breadcrumbs = {
        nvim-navic.enable = true;
        navbuddy.enable = true;
      };
    };

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

    # main theme
    theme = {
      enable = true;

      name = "everforest";
      style = "medium";
    };

    treesitter = {
      enable = true;

      # html tag auto rename
      autotagHtml = true;

      # context.enable = true;
    };

    ui = {
      borders = {
        enable = true;

        globalStyle = "rounded";

        plugins = {
          # lsp-signature.enable = true;
          lspsaga.enable = true;
          nvim-cmp.enable = true;
          which-key.enable = true;
        };
      };

      # Render written colors e.g. `#f00`
      colorizer.enable = true;

      # Simple line decorator
      modes-nvim.enable = false;
    };

    utility = {
      # markdown preview with glow
      preview.glow = {
        enable = true;
        # "<leader>p"
      };

      # Images support
      images.image-nvim = {
        enable = true;
        setupOpts = {
          backend = lib.mkDefault "ueberzug";
          integrations = {
            markdown = {
              enabled = true;
              clear_in_insert_mode = true;
              download_remote_images = true;
            };
          };
        };
      };
    };

    visuals = {
      cinnamon-nvim.enable = true; # Smooth scrolling
      fidget-nvim.enable = true; # Progress notifications (bottom-right)
      highlight-undo.enable = true;
      indent-blankline = {
        enable = true;
        setupOpts.scope.enabled = true;
      };
      # highlight cursor
      nvim-cursorline = {
        enable = true;

        setupOpts = {
          cursorline.enable = true;
          cursorword.enable = true;
        };
      };
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
    };
  };
}
