{inputs, ...}: {
  flake.nixosModules.cetusConfig = {pkgs, ...}: {
    imports = [inputs.self.nixosModules.cetusHardware];

    networking = {
      hostName = "cetus";
      hostId = "c2bd1785";

      interfaces.eno1.wakeOnLan.enable = true;
    };
    system.stateVersion = "25.05"; # never change this
    time.timeZone = "Europe/Paris";

    stars = {
      mainUser = "rack";

      core = true;
      server = {
        ssh.enable = true;

        anubis.enable = true;
        hercules-ci.enable = true;
        gitea.enable = true;
        searchix.enable = true;
        traefik.enable = true;
        mcheads.enable = true;
      };
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryMax = "20G"; # prevent nix from killing server
      MemorySwapMax = "2G";
    };

    systemd.services.hercules-ci-agent = {
      environment = {
        # try to fix c++ mem fragmentation by injecting jemalloc to replace the
        # glibc allocator
        # https://github.com/jemalloc/jemalloc
        LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
      };

      serviceConfig = {
        # kill service on too much mem use anyway
        MemoryMax = "16G";
        MemorySwapMax = "0";
      };
    };

    users.users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8rcV4x9s3V8X4QbwRZFEdKX+ddRXBFGE2fnk68hoAn user@lyra"
      ];

      rack.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRI2ynQ1ZAJWVWlk/Obhcbl+IIBDnMjvZDlWqSMvw8 rack@hercules"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsNjp641wst+zLOMlTFqQTIEUi08D5yM3AKp5+LpYL r1@cassiopeia"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8rcV4x9s3V8X4QbwRZFEdKX+ddRXBFGE2fnk68hoAn user@lyra"
      ];
    };

    # check for zfs errors periodically
    services.zfs.autoScrub.enable = true;

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };
  };
}
