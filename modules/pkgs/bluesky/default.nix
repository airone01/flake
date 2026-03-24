{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.bluesky-bot-initomatic = pkgs.writeShellApplication {
      name = "bluesky-bot-initomatic";

      runtimeInputs = [
        (pkgs.python3.withPackages (ps:
          with ps; [
            atproto
            requests
          ]))
      ];

      text = ''
        exec python3 ${./initomatic.py} "$@"
      '';
    };

    apps.bluesky-bot-initomatic = {
      type = "app";
      program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.bluesky-bot-initomatic}/bin/bluesky-bot-initomatic";
    };
  };
}
