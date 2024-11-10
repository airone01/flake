{pkgs, ...}: {
  name = "plymouth";

  config = _: {
    boot = {
      # plymouth config
      plymouth = {
        enable = true;
        theme = "spinner_alt";
        themePackages = with pkgs; [
          # collection of Plymouth themes
          # we only fetch a single theme from there
          (adi1090x-plymouth-themes.override {selected_themes = ["spinner_alt"];})
        ];
      };

      # enable "silent boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
