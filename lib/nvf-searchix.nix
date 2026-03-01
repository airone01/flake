# note for myself: this is a wrapper to fetch and evaluate nvf options for
# searchix.
# it feels convoluted to have searchix download a tarball when the file is
# sitting there in the same repo, but i believe it's just by design. using the
# file directly would prevent auto-update, and violate the service sandbox.
#
# quirks to remember:
# - nvf (and many modern flakes) dropped flake-compat. we have to fetch it ourselves
#   to evaluate the defaultNix output, otherwise it throws an attribute missing error.
# - searchix expects a very specific folder structure: $out/share/doc/nvf/options.json.
#   if we just put it in $out/options.json, the symlink in searchix will break.
{pkgs ? import <nixpkgs> {}}: let
  nvfSrc = builtins.fetchTarball "https://github.com/NotAShelf/nvf/archive/main.tar.gz";
  # fetch flake-compat manually, nvf does not expose it anymore
  flakeCompatSrc = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  # use flake-compat to evaluate nvf outputs
  nvf = (import flakeCompatSrc {src = nvfSrc;}).defaultNix;
  docs = nvf.packages.${pkgs.system}.docs-json;
in
  pkgs.runCommand "nvf-options-flattened" {} ''
    # exact nested dir struct Searchix expects
    mkdir -p $out/share/doc/nvf
    # symlink options file directly into expected path
    ln -s ${docs}/share/doc/nvf/options.json $out/share/doc/nvf/options.json
  ''
