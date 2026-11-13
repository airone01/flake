{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system}.extend (import ../overlays {inherit inputs;});
  javaPkgs = inputs.nixpkgs.legacyPackages.${system}.extend (import ../overlays/java.nix);
in {
  inherit (pkgs) ai-robots-txt cv initomatic mcheads noctalia niri nvim website zola-386;
  inherit (javaPkgs) ant ant_1_7 commons-cli commons-io commons-lang commons-lang3 java-hamcrest jsoup jspecify junit_3 junit_4 xerces_j xml-apis;
}
