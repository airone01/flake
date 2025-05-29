{pkgs, ...}: {
  home.packages = with pkgs; [
    # Lightbulb requires an emoji font
    noto-fonts-color-emoji
    twemoji-color-font
  ];

  imports = [
    ./binds.nix
    ./dashboard.nix
    ./filetree.nix
    ./languages.nix
    ./lsp.nix
    # ./statusline.nix
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
