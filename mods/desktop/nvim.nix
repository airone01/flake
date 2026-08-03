# feature: Neovim IDE using NVF
{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      (pkgs.callPackage ../../pkgs/nvim {inherit inputs;})
      noto-fonts-color-emoji
      twemoji-color-font
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
