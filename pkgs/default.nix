# heavily inspired by sioodmy's dotfiles
# https://github.com/sioodmy/dotfiles/blob/9551ed3112fe6e8ce26700ef63493cb51bc20ecc/user/default.nix
{
  inputs,
  system,
}: let
  inherit (inputs.nixpkgs.legacyPackages.${system}) callPackage;
in {
  initomatic = callPackage ./initomatic {};
  mcheads = callPackage ./mcheads {};
  noctalia = callPackage ./noctalia {inherit inputs;};
  niri = callPackage ./niri {
    inherit inputs;
    noctalia = callPackage ./noctalia {inherit inputs;};
  };
  nvim = callPackage ./nvim {inherit inputs;};
  website = callPackage ./website {inherit inputs;};
}
