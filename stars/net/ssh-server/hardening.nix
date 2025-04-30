{ config, lib, ... }:

let
  cfg = config.stars.ssh-server;

  # Define more secure defaults
  secureDefaults = {
    # Secure key exchange algorithms
    KexAlgorithms = [
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group-exchange-sha256"
    ];

    # Secure ciphers
    Ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];

    # Secure MACs
    MACs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
      "hmac-sha2-512"
      "hmac-sha2-256"
      "umac-128@openssh.com"
    ];

    # Secure host key algorithms
    HostKeyAlgorithms = [
      "ssh-ed25519-cert-v01@openssh.com"
      "ssh-rsa-cert-v01@openssh.com"
      "ssh-ed25519"
      "ssh-rsa"
      "ecdsa-sha2-nistp521-cert-v01@openssh.com"
      "ecdsa-sha2-nistp384-cert-v01@openssh.com"
      "ecdsa-sha2-nistp256-cert-v01@openssh.com"
      "ecdsa-sha2-nistp521"
      "ecdsa-sha2-nistp384"
      "ecdsa-sha2-nistp256"
    ];
  };
in {
  config = lib.mkIf cfg.enable {
    # Apply secure SSH defaults
    services.openssh.settings = secureDefaults // {
      # Additional hardening settings
      X11Forwarding = false;
      IgnoreRhosts = true;
      UseDNS = false;
      MaxAuthTries = 3;
      MaxSessions = 5;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };

    # Set up system-wide SSH client configuration
    programs.ssh = {
      knownHosts = config.stars.ssh-known-hosts.hosts;

      extraConfig = ''
        # Client-side security settings
        HashKnownHosts yes
        StrictHostKeyChecking ask

        # Reuse connections for better performance
        ControlMaster auto
        ControlPath ~/.ssh/control/%r@%h:%p
        ControlPersist 10m

        # Security settings
        ForwardAgent no
        IdentitiesOnly yes
      '';
    };

    # Create the SSH control directory for connection reuse
    system.activationScripts.sshControlDir = ''
      mkdir -p /home/${config.stars.mainUser}/.ssh/control
      chown ${config.stars.mainUser}:users /home/${config.stars.mainUser}/.ssh/control
      chmod 700 /home/${config.stars.mainUser}/.ssh/control
    '';
  };
}
