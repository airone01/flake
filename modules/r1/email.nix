{
  pkgs,
  config,
  ...
}: {
  stars.home = [
    {
      accounts.email.accounts.main = {
        realName = "Erwann Lagouche";
        address = "popgthyrd@gmail.com";
        flavor = "gmail.com";
        passwordCommand = "${pkgs.cat} ${config.sops.secrets."google_apps/main".path}";
        thunderbird.enable = true;
        primary = true;
      };
    }
  ];

  sops.secrets = {
    "google_apps/main" = {
      owner = config.stars.mainUser;
      mode = "0400";
      sopsFile = ../../secrets/email.yaml;
    };
  };
}
