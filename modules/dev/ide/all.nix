{pkgs, ...}: {
  imports = [
    ./nvim
  ];

  environment.systemPackages = with pkgs; [
    arduino
  ];
}
