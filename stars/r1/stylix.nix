{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/isotope.yaml";
    # base16Scheme = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/tinted-theming/schemes/317a5e10c35825a6c905d912e480dfe8e71c7559/base16/everforest-dark-medium.yaml";
    #   sha256 = "02vlzcp4nckql0vj8jjyz75vkkgflii6g3m3pjbml04m79sp64ll";
    # };

    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/o3/wallhaven-o35lg9.jpg";
      sha256 = "06z42fdxp5b5nnlsd5j74m0hwabmph0qjd98sskwlla90x0rpfxx";
    };

    fonts = {
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      monospace = {
        package = pkgs.nerd-fonts.shure-tech-mono;
        name = "ShureTechMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      console.enable = true;
      nixos-icons.enable = true;
    };
  };

  stars.home = {
    imports = [inputs.stylix.homeModules.stylix];

    stylix.targets = {
      # firefox = {
      #   enable = true;
      #   profilesNames = ["default"];
      # };
      nvf.enable = true;
      vim.enable = true;
      gnome.enable = true;
      fzf.enable = true;
      zellij.enable = true;
      bat.enable = true;
    };
  };
}
