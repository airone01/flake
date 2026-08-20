# feature: Neovim IDE using NVF
{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      (import ../../pkgs/nvim)
      noto-fonts-color-emoji
      twemoji-color-font
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
