# CLI part of the main desktop preset. Personal as well
_: {
  imports = [
    ./base.nix

    # Development
    ../modules/dev/lang/all.nix
    ../modules/dev/tools/all.nix
    ../modules/dev/ide/nvim

    # Shell
    ../modules/sh/zsh.nix
    ../modules/sh/oh-my-posh
  ];
}
