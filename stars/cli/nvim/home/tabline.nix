_: {
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
      separator_style = "slant";
    };
  };
}
