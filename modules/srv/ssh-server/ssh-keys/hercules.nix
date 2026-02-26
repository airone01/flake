# host-specific SSH key configuration for hercules
{
  hostKeys = {
    "ed25519" = "/etc/ssh/ssh_host_ed25519_key";
  };

  userKeys = {
    # define authorized keys for the rack user
    rack = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8rcV4x9s3V8X4QbwRZFEdKX+ddRXBFGE2fnk68hoAn user@lyra"
    ];

    # define authorized keys for the root user
    root = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
    ];
  };
}
