# feature: Wallpapers and profile picture configuration
{
  pkgs,
  mainUser ? "r1",
  ...
}: let
  mkHomeFile = {
    path,
    source,
  }: "L+ /home/${mainUser}/${path} - - - - ${source}";

  mkWallpaper = {
    fileName,
    source,
  }:
    mkHomeFile {
      inherit source;
      path = "Pictures/Wallpapers/${fileName}";
    };

  # Profile picture
  face = mkHomeFile {
    path = ".face";
    source = pkgs.fetchurl {
      url = "https://github.com/airone01.png";
      sha256 = "1w7cznj7cx55a6zk6yz1qks0psjh8wgh2nj0qhqqvzq1bd2w6r8j";
    };
  };

  # Fangpeii
  # https://www.pixiv.net/en/users/50047601
  fangpeiiWalls = [
    {
      fileName = "Fangpeii Geese Pink Pond.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/ly/wallhaven-lywpjl.jpg";
        sha256 = "sha256-EyGRsayeT1YDASaet4HYn/42ucAV+CaF21KMsIFPHNY=";
      };
    }
    {
      fileName = "Fangpeii Beach Orange Sunset.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/yx/wallhaven-yxw15l.jpg";
        sha256 = "sha256-JqW+b2+y1AeVJOYtBmWTl1txaovHM0aeUfkBRSvvzrU=";
      };
    }
    {
      fileName = "Fangpeii Flowers Green.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/3q/wallhaven-3qo9p6.jpg";
        sha256 = "sha256-ZKhdcsqFeKlSHvhiexHI+ShY/pjJf/OpyYM6KQp/glg=";
      };
    }
    {
      fileName = "Fangpeii Pond Green.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/e8/wallhaven-e8z2xk.jpg";
        sha256 = "sha256-ba+jsQ9T5UJU9el7y/nepr4P+J+ji3xTXyeBjHIWF80=";
      };
    }
    {
      fileName = "Fangpeii Clouds Sky Orange Girl Moon.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/d8/wallhaven-d8e373.jpg";
        sha256 = "sha256-e5OQY31ZsQOIEXhpMQpNPQID0Td27Du1c2UsFJXqchc=";
      };
    }
    {
      fileName = "Fangpeii Clouds Sky Purple Stars.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/o3/wallhaven-o33l25.jpg";
        sha256 = "sha256-xREwFhTVVEGi3bvMrKudkwjuLZzmat9lLA+7PQNvPt8=";
      };
    }
    {
      fileName = "Fangpeii Morming Sky Tree Blue Pink Cold.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/yq/wallhaven-yq57rl.jpg";
        sha256 = "sha256-fjEh28ECQnvCTTvHemiH6GHfpaZVieHb0EmoucMwUuk=";
      };
    }
    {
      fileName = "Fangpeii City Clouds Orange Blue Sky.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/7p/wallhaven-7pd3l9.jpg";
        sha256 = "sha256-LFek+KkQ9Ig6HZrhfyuaP2K3biKW35Wjdsk7DZs0YNA=";
      };
    }
    {
      fileName = "Fangpeii Sea Lighthouse Orange Blue Sky.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/j3/wallhaven-j33kv5.jpg";
        sha256 = "sha256-10iujyYzzvRm77VN1vKORQ7M7uP2iqYqfpbNcJk+4ik=";
      };
    }
    {
      fileName = "Fangpeii Mountain Pink Blue Sunset Sky.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/vp/wallhaven-vpzqgl.jpg";
        sha256 = "sha256-sRH821hTfYW8TtjeO+irrFmQqAippIZgybJ/9Nc1sXk=";
      };
    }
    {
      fileName = "Fangpeii Orange Pink Sky Sunset Trees.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/3q/wallhaven-3qzvey.jpg";
        sha256 = "sha256-mqQMDWfzhSWaL7sH3++cMni0jIxdeuE2NI0MscS7kWk=";
      };
    }
  ];

  # Nid_417
  # https://www.pixiv.net/en/users/10315206
  nid417Walls = [
    {
      fileName = "Nid_417 Arknights White Green Blue Sky Rock Plain.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/9o/wallhaven-9oxme1.jpg";
        sha256 = "sha256-AgE5JoIkvz7lGJpl4IBAAG7JiAdkjBYLTsF5w6L9fSY=";
      };
    }
  ];

  # Sam Yang (samdoesarts)
  # https://www.instagram.com/samdoesarts/
  samdoesartsWalls = [
    {
      fileName = "Sam Yang Mountain Japan Field Car Wheat Orange Ping Blue Girl.jpg";
      source = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/qr/wallhaven-qrz9wl.jpg";
        sha256 = "sha256-j5d6UghkxysHTftINhWZpbxN7y5dLSWS3iB8MP1tWxg=";
      };
    }
  ];
in {
  systemd.tmpfiles.rules =
    [face]
    ++ map mkWallpaper (fangpeiiWalls ++ nid417Walls ++ samdoesartsWalls);
}
