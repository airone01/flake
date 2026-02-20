{pkgs, ...}: {
  stars.home = [
    {
      home.packages = with pkgs; [chatterino2];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
        ];
      };

      wayland.windowManager.hyprland.settings = {
        windowrule = [
          # float chat window
          "float 1, match:class ^com\.chatterino.*"
          # pin so it's on top of other windows
          "pin 1, match:class ^com\.chatterino.*"
          # position to top-right corner using simple coordinates
          "move 75% 5%, match:class ^com\.chatterino.*"
          "size 20% 80%, match:class ^com\.chatterino.*"
          # transparency
          "opacity 0.8 0.6, match:class ^com\.chatterino.*"
          # no borders
          "border_size 0, match:class ^com\.chatterino.*"
        ];
      };
    }
  ];
}
