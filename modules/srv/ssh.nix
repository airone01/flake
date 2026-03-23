# feature: SSH server configuration and integration with other services
_: {
  flake.nixosModules.ssh = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.stars.server.ssh.enable = lib.mkEnableOption "opinionated SSH server";

    config = lib.mkIf config.stars.server.ssh.enable {
      services.openssh = {
        enable = true;
        openFirewall = true;

        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          LogLevel = "VERBOSE";
          StrictModes = true;
          Compression = false;
          X11Forwarding = false;
          AllowAgentForwarding = true;
          AllowTcpForwarding = true;
          GatewayPorts = "no";
          UseDns = false;

          # These used to be in hardening.nix!
          IgnoreRhosts = true;
          MaxAuthTries = 3;
          MaxSessions = 5;
          LoginGraceTime = 30;
          ClientAliveInterval = 300;
          ClientAliveCountMax = 2;
        };
      };

      # programs.mosh.enable = true;
      # networking.firewall.allowedUDPPortRanges = [
      #   {
      #     from = 60000;
      #     to = 61000;
      #   }
      # ];

      programs.ssh.extraConfig = ''
        HashKnownHosts yes
        StrictHostKeyChecking ask
        ControlMaster auto
        ControlPath ~/.ssh/control/%r@%h:%p
        ControlPersist 10m
        ForwardAgent no
        IdentitiesOnly yes
      '';

      environment.systemPackages = [
        pkgs.sshfs
        pkgs.kitty # for term def
      ];

      system.activationScripts.sshControlDir = ''
        mkdir -p /home/${config.stars.mainUser}/.ssh/control
        chown ${config.stars.mainUser}:users /home/${config.stars.mainUser}/.ssh/control
        chmod 700 /home/${config.stars.mainUser}/.ssh/control
      '';
    };
  };
}
