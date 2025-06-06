{
  # Host-specific SSH key configuration for cassiopeia
  hostKeys = {
    # You can specify custom paths to your SSH host keys if needed
    # Default NixOS paths are typically used if not specified
    # "rsa" = "/etc/ssh/ssh_host_rsa_key";
    # "ed25519" = "/etc/ssh/ssh_host_ed25519_key";
  };

  userKeys = {
    # Define authorized keys for the r1 user
    r1 = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
    ];

    # Define authorized keys for the root user
    root = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
    ];
  };
}
