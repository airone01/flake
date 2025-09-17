_: {
  imports = [
    # Secrets
    ../stars/sys/secret/gnupg.nix
    ../stars/sys/secret/sops.nix

    # My specific stuff
    ../stars/r1/email.nix
    ../stars/r1/git.nix
  ];
}
