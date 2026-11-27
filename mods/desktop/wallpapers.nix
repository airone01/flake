# feature: Wallpapers and profile picture configuration
{pkgs, ...}: let
  mkHomeFile = {
    path,
    source,
  }: ''L+ "%h/${path}" - - - - ${source}'';

  face = mkHomeFile {
    path = ".face";
    source = pkgs.fetchurl {
      url = "https://github.com/airone01.png";
      sha256 = "1w7cznj7cx55a6zk6yz1qks0psjh8rgh2nj0qhqqvzq1bd2w6r8j";
    };
  };

  wallpapers = mkHomeFile {
    path = "Pictures/Wallpapers";
    source = "${pkgs.wallpapers}/wallpapers";
  };
in {
  systemd.user.tmpfiles.rules = [face wallpapers];
}
