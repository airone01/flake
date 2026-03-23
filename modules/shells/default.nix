_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        # general
        curl
        wget
        pkg-config
        openssl
        vim
        wireguard-tools
        # nix
        nh
        nix-output-monitor # nom
        alejandra
        deploy-rs
        # project-specific
        just
        bun
      ];
    };
  };
}
