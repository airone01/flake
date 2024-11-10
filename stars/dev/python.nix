{pkgs, ...}: {
  name = "python";

  packages = with pkgs; [
    pipx
    poetry
    python312
    python312Packages.pip
    python312Packages.virtualenv
  ];
}
