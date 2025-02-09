{pkgs, config, ...}: {
  environment.systemPackages = with pkgs; [sops age ssh-to-age];

  # Those are the configs for the sops flake.
  # This does not configure the cli.
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${config.stars.mainUser}/.config/sops/age/keys.txt";
  };
}
