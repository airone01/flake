{pkgs, config, ...}: {
  # TODO: use better firefox here

  home-manager.users.${config.stars.mainUser} = {
    programs.firefox = {
      enable = true;

      languagePacks = ["en_US" "fr_FR"];
      nativeMessagingHosts = with pkgs; [gnome-browser-connector];
    };
  };
}
