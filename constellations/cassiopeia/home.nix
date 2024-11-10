{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # screenshot tool
      grimblast

      # shells
      zellij

      # utils
      neofetch
      pfetch

      # networking
      atac
      networkmanagerapplet

      # fs management
      eza

      # terminal emulator
      kitty

      # file managers
      kdePackages.dolphin

      # media players
      vlc

      # text editors & ide
      vscodium
      nil

      # programming languages
      bun
      nodejs_22

      # internet browser
      chromium # waiting for thorium @ https://github.com/NixOS/nixpkgs/pull/284085

      # github helper
      gh
    ];

    sessionVariables = {
      # text editor
      EDITOR = "nvim";
      # wayland
      ## if the cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
      ## tell electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };
  };
}
