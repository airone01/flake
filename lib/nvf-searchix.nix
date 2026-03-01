{pkgs ? import <nixpkgs> {}}: let
  nvfSrc = builtins.fetchTarball "https://github.com/NotAShelf/nvf/archive/main.tar.gz";
  # fetch flake-compat manually, nvf does not expose it (anymore?)
  flakeCompatSrc = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  nvf = (import flakeCompatSrc {src = nvfSrc;}).defaultNix;
  docs = nvf.packages.${pkgs.system}.docs-json;
in
  pkgs.runCommand "nvf-options-flattened" {} ''
    mkdir -p $out
    ln -s ${docs}/share/doc/nvf/options.json $out/options.json
  ''
