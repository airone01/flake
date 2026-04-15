_: {
  flake.nixosModules.wallpapers = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.desktop.wallpapers.enable = lib.mkEnableOption "Wallpapers";
    # Note: Caelestia Shell only displays wallpapers in the launcher when there
    # is an odd number of them. https://github.com/caelestia-dots/shell

    config = lib.mkIf config.stars.desktop.wallpapers.enable {
      home-manager.users.${config.stars.mainUser}.home.file = {
        # Fangpeii
        # https://www.pixiv.net/en/users/50047601
        "Pictures/Wallpapers/Fangpeii Geese Pink Pond.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/ly/wallhaven-lywpjl.jpg";
          sha256 = "sha256-EyGRsayeT1YDASaet4HYn/42ucAV+CaF21KMsIFPHNY=";
        };
        "Pictures/Wallpapers/Fangpeii Beach Orange Sunset.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/yx/wallhaven-yxw15l.jpg";
          sha256 = "sha256-JqW+b2+y1AeVJOYtBmWTl1txaovHM0aeUfkBRSvvzrU=";
        };
        "Pictures/Wallpapers/Fangpeii Flowers Green.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/3q/wallhaven-3qo9p6.jpg";
          sha256 = "sha256-ZKhdcsqFeKlSHvhiexHI+ShY/pjJf/OpyYM6KQp/glg=";
        };
        "Pictures/Wallpapers/Fangpeii Pond Green.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/e8/wallhaven-e8z2xk.jpg";
          sha256 = "sha256-ba+jsQ9T5UJU9el7y/nepr4P+J+ji3xTXyeBjHIWF80=";
        };
        "Pictures/Wallpapers/Fangpeii Clouds Sky Orange Girl Moon.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/d8/wallhaven-d8e373.jpg";
          sha256 = "sha256-e5OQY31ZsQOIEXhpMQpNPQID0Td27Du1c2UsFJXqchc=";
        };
        "Pictures/Wallpapers/Fangpeii Clouds Sky Purple Stars.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/o3/wallhaven-o33l25.jpg";
          sha256 = "sha256-xREwFhTVVEGi3bvMrKudkwjuLZzmat9lLA+7PQNvPt8=";
        };
        "Pictures/Wallpapers/Fangpeii Morming Sky Tree Blue Pink Cold.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/yq/wallhaven-yq57rl.jpg";
          sha256 = "sha256-fjEh28ECQnvCTTvHemiH6GHfpaZVieHb0EmoucMwUuk=";
        };
        "Pictures/Wallpapers/Fangpeii City Clouds Orange Blue Sky.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/7p/wallhaven-7pd3l9.jpg";
          sha256 = "sha256-LFek+KkQ9Ig6HZrhfyuaP2K3biKW35Wjdsk7DZs0YNA=";
        };
        "Pictures/Wallpapers/Fangpeii Sea Lighthouse Orange Blue Sky.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/j3/wallhaven-j33kv5.jpg";
          sha256 = "sha256-10iujyYzzvRm77VN1vKORQ7M7uP2iqYqfpbNcJk+4ik=";
        };
        "Pictures/Wallpapers/Fangpeii Mountain Pink Blue Sunset Sky.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/vp/wallhaven-vpzqgl.jpg";
          sha256 = "sha256-sRH821hTfYW8TtjeO+irrFmQqAippIZgybJ/9Nc1sXk=";
        };
        "Pictures/Wallpapers/Fangpeii Orange Pink Sky Sunset Trees.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/3q/wallhaven-3qzvey.jpg";
          sha256 = "sha256-mqQMDWfzhSWaL7sH3++cMni0jIxdeuE2NI0MscS7kWk=";
        };

        # Nid_417
        # https://www.pixiv.net/en/users/10315206
        "Pictures/Wallpapers/Nid_417 Arknights White Green Blue Sky Rock Plain.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/9o/wallhaven-9oxme1.jpg";
          sha256 = "sha256-AgE5JoIkvz7lGJpl4IBAAG7JiAdkjBYLTsF5w6L9fSY=";
        };

        # Sam Yang (samdoesarts)
        # https://www.instagram.com/samdoesarts/
        "Pictures/Wallpapers/Sam Yang Mountain Japan Field Car Wheat Orange Ping Blue Girl.jpg".source = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/qr/wallhaven-qrz9wl.jpg";
          sha256 = "sha256-j5d6UghkxysHTftINhWZpbxN7y5dLSWS3iB8MP1tWxg=";
        };

        # # Unknown Artists
        # "Pictures/Wallpapers/Unknown Signalis Falke Red Blue Yellow.jpg".source = pkgs.fetchurl {
        #   url = "https://w.wallhaven.cc/full/6d/wallhaven-6d2ymq.jpg";
        #   sha256 = "sha256-SaSd1Oz6EX+n4Verq/Y2O/iWRZIkFL81hAn07UyHyKo=";
        # };
      };
    };
  };
}
