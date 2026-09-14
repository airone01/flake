# feature: Wallpapers and profile picture configuration
{
  pkgs,
  lib,
  ...
}: let
  rawYaml = builtins.readFile ./wallpapers.yml;
  lines = lib.splitString "\n" rawYaml;

  parseLine = acc: line: let
    trimmed = lib.trim line;
    isComment = lib.hasPrefix "#" trimmed;
    isEmpty = trimmed == "" || trimmed == "artists:";

    hasPrefix = prefix: lib.hasPrefix prefix trimmed;
    stripPrefix = prefix: lib.trim (lib.removePrefix prefix trimmed);

    parseKV = str: let
      parts = lib.splitString ":" str;
      key = lib.trim (builtins.head parts);
      val = lib.trim (lib.concatStringsSep ":" (builtins.tail parts));
      unquotedVal = lib.removeSuffix "'" (lib.removePrefix "'" (lib.removeSuffix "\"" (lib.removePrefix "\"" val)));
    in {
      inherit key;
      value = unquotedVal;
    };
  in
    if isEmpty || isComment
    then acc
    else if hasPrefix "- name:"
    then let
      artistName = stripPrefix "- name:";
      newArtist = {
        name = artistName;
        page = "";
        wallpapers = [];
      };
    in
      acc
      // {
        artists = acc.artists ++ [newArtist];
        currentArtist = newArtist;
        currentWallpaper = null;
      }
    else if hasPrefix "page:"
    then let
      pageUrl = stripPrefix "page:";
      updatedArtist = acc.currentArtist // {page = pageUrl;};
      updatedArtists = lib.init acc.artists ++ [updatedArtist];
    in
      acc
      // {
        artists = updatedArtists;
        currentArtist = updatedArtist;
      }
    else if hasPrefix "- objects:"
    then let
      kv = parseKV (lib.removePrefix "- " trimmed);
      newWp = {${kv.key} = kv.value;};
      updatedArtist =
        acc.currentArtist
        // {
          wallpapers = acc.currentArtist.wallpapers ++ [newWp];
        };
      updatedArtists = lib.init acc.artists ++ [updatedArtist];
    in
      acc
      // {
        artists = updatedArtists;
        currentArtist = updatedArtist;
        currentWallpaper = newWp;
      }
    else if lib.hasInfix ":" trimmed && acc.currentWallpaper != null
    then let
      kv = parseKV trimmed;
      lastWp = lib.last acc.currentArtist.wallpapers;
      updatedWp = lastWp // {${kv.key} = kv.value;};
      updatedArtistWallpapers = lib.init acc.currentArtist.wallpapers ++ [updatedWp];
      updatedArtist = acc.currentArtist // {wallpapers = updatedArtistWallpapers;};
      updatedArtists = lib.init acc.artists ++ [updatedArtist];
    in
      acc
      // {
        artists = updatedArtists;
        currentArtist = updatedArtist;
        currentWallpaper = updatedWp;
      }
    else acc;

  parsed =
    builtins.foldl' parseLine {
      artists = [];
      currentArtist = null;
      currentWallpaper = null;
    }
    lines;

  allWallpapers =
    lib.concatMap (
      artist:
        map (wp: let
          objectsStr = wp.objects or "";
          colorsStr =
            if (wp ? colors && wp.colors != "")
            then " ${wp.colors}"
            else "";
          urlSplit = lib.splitString "." wp.url;
          ext =
            if (wp ? ext && wp.ext != "")
            then wp.ext
            else lib.last urlSplit;
        in {
          name = "${artist.name} ${objectsStr}${colorsStr}.${ext}";
          path = pkgs.fetchurl {
            inherit (wp) url sha256;
          };
        })
        artist.wallpapers
    )
    parsed.artists;

  wallpapersFolder = pkgs.linkFarm "wallpapers" allWallpapers;

  mkHomeFile = {
    path,
    source,
  }: ''L+ "%h/${path}" - - - - ${source}'';

  face = mkHomeFile {
    path = ".face";
    source = pkgs.fetchurl {
      url = "https://github.com/airone01.png";
      sha256 = "1w7cznj7cx55a6zk6yz1qks0psjh8wgh2nj0qhqqvzq1bd2w6r8j";
    };
  };

  wallpapers = mkHomeFile {
    path = "Pictures/Wallpapers";
    source = wallpapersFolder;
  };
in {
  systemd.user.tmpfiles.rules = [face wallpapers];
}
