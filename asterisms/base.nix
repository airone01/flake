{ config, pkgs, lib, ... }: {
  imports = [
    # Network core
    ../stars/core/direnv.nix
    ../stars/core/sops.nix

    # Dev core
    ../stars/dev/core.nix
    # ../stars/dev/garnix.nix

    # Hardware settings
    ../stars/hard/graphics.nix
    ../stars/hard/nvidia.nix

    # my specific configs
    ../stars/r1/git.nix
  ];
}
