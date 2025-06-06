_: {
  imports = [
    ./base.nix

    # Development
    ../stars/dev/lang/all.nix
    ../stars/dev/tools/all.nix
    ../stars/dev/ide/nvim

    # Shell
    ../stars/sh/zsh.nix
    ../stars/sh/oh-my-posh
  ];
}
