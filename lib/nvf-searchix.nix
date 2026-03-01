{pkgs ? import <nixpkgs> {}}: let
  nvfSrc = builtins.fetchTarball "https://github.com/NotAShelf/nvf/archive/main.tar.gz";
  # fetch flake-compat manually, nvf does not expose it (anymore?)
  flakeCompatSrc = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  nvf = (import flakeCompatSrc {src = nvfSrc;}).defaultNix;
  docs = nvf.packages.${pkgs.system}.docs-json;
in
  pkgs.runCommand "nvf-options-flattened" {
    nativeBuildInputs = [pkgs.jq];
  } ''
    mkdir -p $out/share/doc/nvf
    # NVF outputs options.json as a JSON array to preserve order.
    # Searchix strictly expects a JSON object where keys are the option names.
    # We use jq to dynamically reshape the array into a single key-value object.
    jq 'if type == "array" then map({(.name): .}) | add else . end' \
      ${docs}/share/doc/nvf/options.json > $out/share/doc/nvf/options.json
  ''
