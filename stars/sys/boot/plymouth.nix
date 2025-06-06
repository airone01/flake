{pkgs, ...}: let
  theme = "spinner_alt";
in {
  boot = {
    # plymouth config
    plymouth = {
      enable = true;

      inherit theme;
      themePackages = with pkgs; [
        # collection of Plymouth themes
        # we only fetch a single theme from there
        (adi1090x-plymouth-themes.override {selected_themes = [theme];})
      ];
    };
  };
}
