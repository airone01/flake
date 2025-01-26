_: {
  programs.nvf.settings.vim = {
    # note to self:
    # the following will be ignored
    # if you install `vi` or `vim`
    viAlias = true;
    vimAlias = true;

    # Autocomplete
    autocomplete.nvim-cmp.enable = true;

    # Auto pairs
    autopairs.nvim-autopairs.enable = true;

    # Syntax highlighting
    syntaxHighlighting = true;

    # i have a small screen
    # tabWidth = 2;

    # disable the keyboard arrows for movement
    # forces the use of hjkl
    disableArrows = true;
  };
}
