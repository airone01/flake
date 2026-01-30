{pkgs ? import <nixpkgs> {}}: let
  nvfSrc = builtins.fetchTarball "https://github.com/NotAShelf/nvf/archive/main.tar.gz";
  nvf = (import nvfSrc).defaultNix;
  docs = nvf.packages.${pkgs.system}.docs-json;
in
  pkgs.runCommand "nvf-options-flattened" {} ''
    mkdir -p $out
    ln -s ${docs}/share/doc/nvf/options.json $out/options.json
  ''
