{
  pkgs,
  config,
  ...
}: {
  home-manager.users.${config.stars.mainUser} = {
    programs.firefox = {
      enable = true;

      languagePacks = ["en_US" "fr_FR"];
      nativeMessagingHosts = with pkgs; [gnome-browser-connector];
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
  ];
}
