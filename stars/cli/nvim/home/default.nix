{pkgs, ...}: {
  home.packages = with pkgs; [
    noto-fonts-color-emoji # lightbulb requires an emoji font
    twemoji-color-font
  ];

  imports = [
    # ./base16.nix
    ./binds.nix
    ./dashboard.nix
    ./filetree.nix
    ./languages.nix
    ./lsp.nix
    ./statusline.nix
    ./tabline.nix
    ./telescope.nix
    ./treesitter.nix
    ./ui.nix
    ./utility.nix
    ./vim.nix
    ./wrappers.nix
  ];

  programs.nvf = {
    enable = true;
  };
}
