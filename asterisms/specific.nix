_: {
  imports = [
    # Secrets
    ../modules/sys/secret/gnupg.nix
    ../modules/sys/secret/sops.nix

    # My specific stuff
    # ../modules/r1/email.nix
    ../modules/r1/git.nix
    ../modules/r1/dualsense.nix
  ];
}
