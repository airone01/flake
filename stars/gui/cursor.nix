{pkgs, config, ...}: {
  home-manager.users.${config.stars.mainUser}.home.packages = with pkgs; [code-cursor];

  # Allow non-free packages
  # Needed because cursor ain't oss m8
  nixpkgs.config.allowUnfree = true;
}
