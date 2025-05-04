{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Network core
    ../stars/core/cachix.nix
    ../stars/core/direnv.nix
    ../stars/core/garnix.nix
    ../stars/core/lix.nix
    ../stars/core/nix.nix
    ../stars/core/sops.nix

    # Cli
    ../stars/cli/eza.nix

    # Dev core
    ../stars/dev/core.nix

    # Hardware settings
    ../stars/hard/graphics.nix

    # my specific configs
    ../stars/r1/git.nix
  ];
}
