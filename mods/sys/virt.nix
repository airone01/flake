# feature: virtualization support
{pkgs, ...}: {
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

    # I despise Oracle, but I need OCA support for a 42 project
    # Not enabling KVM support, I'll stick to QEMU when I can
    virtualbox.host.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
