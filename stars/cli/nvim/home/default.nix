{pkgs, ...}: {
  home.packages = with pkgs; [
    # for lightbulb emoji
    noto-fonts-color-emoji
    # image display backend
    ueberzug
  ];

  imports = [
    ./binds.nix
    ./filetree.nix
    ./lsp.nix
    ./statusline.nix
    ./tabline.nix
    ./telescope.nix
    ./treesitter.nix
    ./ui.nix
    ./utility.nix
    ./vim.nix
  ];

  programs.nvf = {
    enable = true;
  };
}
