_: {
  programs.nvf.settings.vim = {
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

      # Scroll bar
      nvim-scrollbar.enable = true;

      # icons
      nvim-web-devicons.enable = true;
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
      modes-nvim.enable = true;
    };

    # notification library
    notify.nvim-notify.enable = true;

    # main theme (doesn't apply to status bar)
    theme = {
      enable = true;

      name = "everforest";
      style = "medium";
    };
  };
}
