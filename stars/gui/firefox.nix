{pkgs, ...}: {
  homeConfig = _: {
    programs.firefox = {
      enable = true;

      languagePacks = ["en_US" "fr_FR"];
      nativeMessagingHosts = with pkgs; [gnome-browser-connector];
    };
  };
}
