{pkgs, ...}: {
  stars.home = [
    {
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
        nerd-fonts.shure-tech-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
      ];
    }
  ];
}
