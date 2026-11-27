{pkgs, ...}:
pkgs.writeShellApplication {
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
}
