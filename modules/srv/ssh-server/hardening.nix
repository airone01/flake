{
  config,
  lib,
  ...
}: let
  cfg = config.stars.server.ssh-server;
  scfg = config.stars.server.enable;
in {
  config = lib.mkIf (scfg && cfg.enable) {
    services.openssh.settings = {
      # additional hardening settings
      IgnoreRhosts = true;
      MaxAuthTries = 3;
      MaxSessions = 5;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };

    # set up system-wide SSH client configuration
    programs.ssh = {
      knownHosts = config.stars.server.ssh-known-hosts.hosts;

      extraConfig = ''
        # client-side security settings
        HashKnownHosts yes
        StrictHostKeyChecking ask

        # reuse connections for better performance
        ControlMaster auto
        ControlPath ~/.ssh/control/%r@%h:%p
        ControlPersist 10m

        # security settings
        ForwardAgent no
        IdentitiesOnly yes
      '';
    };

    # create the SSH control directory for connection reuse
    system.activationScripts.sshControlDir = ''
      mkdir -p /home/${config.stars.mainUser}/.ssh/control
      chown ${config.stars.mainUser}:users /home/${config.stars.mainUser}/.ssh/control
      chmod 700 /home/${config.stars.mainUser}/.ssh/control
    '';
  };
}
