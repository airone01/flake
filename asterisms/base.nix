_: {
  imports = [
    # Nix
    ../stars/nix/all.nix

    # Secrets
    ../stars/sys/secret/sops.nix

    # Hardware settings
    ../stars/sys/graphics/graphics.nix

    # My specific stuff
    ../stars/r1/email.nix
    ../stars/r1/git.nix
  ];
}
