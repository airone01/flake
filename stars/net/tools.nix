{pkgs, ...}: {
  packages = _:
    with pkgs; [
      nmap
    ];
}
