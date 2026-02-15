{pkgs, ...}: {
  stars.home = [
    {
      programs.btop = {
        enable = true;

        settings = {
          update_ms = 1000;
        };
      };
    }
  ];

  environment.systemPackages = with pkgs; [
    btop
  ];
}
