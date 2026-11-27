{
  lib,
  stdenvNoCC,
  fetchurl,
  imagemagick,
  wallpapersFile ? ./wallpapers.yml,
  quality ? 85,
}: let
  rawYaml = builtins.readFile wallpapersFile;
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

  wallpaperList =
    lib.concatMap (
      artist:
        map (wp: let
          objectsStr = wp.objects or "";
          colorsStr =
            if (wp ? colors && wp.colors != "")
            then " ${wp.colors}"
            else "";
        in {
          baseName = "${artist.name} ${objectsStr}${colorsStr}";
          src = fetchurl {
            inherit (wp) url sha256;
          };
        })
        artist.wallpapers
    )
    parsed.artists;

  convertCommands =
    lib.concatMapStringsSep "\n" (wp: ''
      magick ${lib.escapeShellArg wp.src} -quality ${toString quality} "wallpapers/${wp.baseName}.jxl"
    '')
    wallpaperList;
in
  stdenvNoCC.mkDerivation {
    pname = "wallpapers";
    version = "2.0.0";

    nativeBuildInputs = [imagemagick];

    dontUnpack = true;
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      mkdir -pv wallpapers
      ${convertCommands}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      find wallpapers/ -type f -exec \
        install -Dvm 644 "{}" "$out/{}" \;

      runHook postInstall
    '';

    meta = {
      description = "Wallpapers I like (in JPEG XL format)";
      platforms = lib.platforms.all;
      maintainers = [lib.maintainers.airone01];
    };
  }
