{
  lib,
  pkgs,
  userName,
}: let
  # Recursively get all .nix files and directories from the stars directory
  allItems = lib.filesystem.listFilesRecursive ../stars;

  # Function to check if a path is a directory with a default.nix file
  isDefaultNixDir = path:
    (builtins.pathExists (path + "/default.nix")) && (builtins.readDir path).default-nix == "regular";

  # Filter to include .nix files and directories with default.nix
  validItems =
    builtins.filter (
      item:
        lib.hasSuffix ".nix" item || isDefaultNixDir item
    )
    allItems;

  # Function to get the appropriate path for importing
  getImportPath = item:
    if isDefaultNixDir item
    then item + "/default.nix"
    else item;

  # Function to create a star module
  mkStarModule = _: starModule: {
    config,
    inputs,
    ...
  }: let
    # Import the star module
    importedStar = import starModule {inherit lib pkgs config inputs;};

    # Extract systemPackages and other fields
    systemPackages = importedStar.systemPackages or [];
    packages = importedStar.packages or [];

    # System config from the star
    starConfig = importedStar.config or (_: {});
    # Home config from the star
    starHomeConfig = importedStar.homeConfig or (_: {});

    # Call the star's configs function with the full NixOS config
    evaluatedStarConfig = starConfig {inherit config;};
    evaluatedStarHomeConfig = starHomeConfig {inherit config;};

    # Create the formatted star module
    formattedStar = {
      config =
        {
          environment.systemPackages = systemPackages;
          home-manager.users.${userName} = evaluatedStarHomeConfig // {home.packages = packages;};
        }
        // evaluatedStarConfig;
    };
  in
    formattedStar;

  stars = lib.listToAttrs (
    map
    (item: let
      # Extract the relative path from the stars directory
      relPath = lib.removePrefix "${toString ../stars}/" (toString item);
      # Use the relative path (without .nix) as the name, replacing / with -
      name = lib.removeSuffix ".nix" (builtins.replaceStrings ["/"] ["-"] relPath);
      # Remove "default" from the end of the name if it's a default.nix file
      finalName =
        if lib.hasSuffix "-default" name
        then lib.removeSuffix "-default" name
        else name;
      starModule = getImportPath item;
    in {
      name = finalName;
      value = mkStarModule finalName starModule;
    })
    validItems
  );

  # Function to merge multiple star modules
  mergeStars = starNames:
    lib.mkMerge (map (name: stars.${name}) starNames);
in {
  inherit stars;
  inherit mergeStars;
}
