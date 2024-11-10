{pkgs, ...}: {
  homeConfig = _: {
    fonts.fontconfig = {
      enable = true;

      defaultFonts.monospace = ["JetBrainsMono Nerd"];
    };
  };

  config = _: {
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraMono" "FiraCode"];})
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
  };
}
