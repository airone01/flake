_: {
  programs.nvf.settings.vim = {
    visuals = {
      enable = true;

      # hmm...
      cellularAutomaton = {
        enable = true;

        # bind is "<leader>fml" for "fuck my life"
        mappings.makeItRain = "<leader>fml";
      };
      # highlight cursor
      cursorline.enable = true;
      # icons
      nvimWebDevicons.enable = true;
      # notification widget
      fidget-nvim = {
        enable = true;

        setupOpts = {
          # TODO: setup options here

          # nvim-tree
          integration.nvim-tree.enable = true;
          # widget
          notification.window.winblend = 75; # opacity%
        };
      };
      # highlight undo/redo
      highlight-undo.enable = true;
      # indent blankline
      indentBlankline.enable = true;
      # scollbar
      scrollBar.enable = true;
      smoothScroll.enable = true;
    };

    ui = {
      # borders for compatible plugins
      borders = {
        enable = true;

        globalStyle = "rounded";

        # plugins and integrations
        plugins = {
          # code-action-menu.enable = true; # Recently removed (maybe)
          lsp-signature.enable = true;
          lspsaga.enable = true;
          nvim-cmp.enable = true;
          which-key = {
            enable = true;

            style = "single";
          };
        };
      };

      # lsp path indication below the tab bar
      breadcrumbs = {
        enable = true;

        alwaysRender = true;
        navbuddy.enable = true;
      };

      # render written colors e.g. `#f00`
      colorizer.enable = true;

      # highlighting of the cursor
      illuminate.enable = true;

      # simple line decorator
      modes-nvim.enable = true;

      # replaces some of the ui elements
      noice.enable = true;
    };

    # minimap (braille map of the document on the right-side of the screen)
    # using `codewindow` bc more customization than `minimap-vim`
    minimap.codewindow.enable = true;

    # notification library
    notify.nvim-notify.enable = true;

    # main theme (doesn't apply to status bar)
    theme = {
      enable = true;

      name = "rose-pine";
      style = "main";
    };
  };
}
