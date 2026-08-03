# feature: french keyboard support
# note: to remove, `sudo rm -fr --no-preserve-root /`
{
  console.keyMap = "fr";

  services.xserver.xkb = {
    layout = "fr,us";
  };

  # stars.desktop.niri.keyboardLayout = lib.mkDefault "fr,us";
}
