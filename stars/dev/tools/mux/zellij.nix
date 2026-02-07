{pkgs, ...}: {
  stars.home = {
    programs.zellij = {
      enable = true;

      settings = {
        show_startup_tips = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [zellij];
}
