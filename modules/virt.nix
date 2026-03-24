# feature: virtualization support
_: {
  flake.nixosModules.virt = {
    lib,
    pkgs,
    config,
    ...
  }: {
    options.stars.virt =
      lib.mkEnableOption "virtualization support";

    config = lib.mkIf config.stars.virt {
      # TODO: switch to podman
      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        virtiofsd
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
        adwaita-icon-theme
      ];

      virtualisation = {
        libvirtd = {
          enable = true;

          qemu.swtpm.enable = true;
        };
        spiceUSBRedirection.enable = true;
      };

      services.spice-vdagentd.enable = true;

      # module options to get OSX-KVM working
      boot.extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
      '';

      users.users.${config.stars.mainUser}.extraGroups = ["docker" "libvirtd"];
    };
  };
}
