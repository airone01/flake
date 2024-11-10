{pkgs, ...}: {
  name = "cursor";

  systemPackages = with pkgs; [code-cursor];
  config = _: {
    nixpkgs.config.allowUnfree = true;
  };
}
