_: {
  programs.nvf.settings.vim = {
    # note to self:
    # the following will be ignored
    # if you install `vi` or `vim`
    viAlias = true;
    vimAlias = true;

    # yes pretty please
    autocomplete.enable = true;
    syntaxHighlighting = true;

    # i have a small screen
    tabWidth = 2;

    # this is the equivalent of
    # unbinding the crouch key in CS:GO
    disableArrows = true;
  };
}
