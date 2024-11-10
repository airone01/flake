{pkgs, ...}: {
  name = "just";

  # System packages needed for Just functionality
  packages = with pkgs; [just];
}
