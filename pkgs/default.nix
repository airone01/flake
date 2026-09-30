# heavily inspired by sioodmy's dotfiles
# https://github.com/sioodmy/dotfiles/blob/9551ed3112fe6e8ce26700ef63493cb51bc20ecc/user/default.nix
{
  inputs,
  system,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system}.extend (import ../overlays {inherit inputs;});
in {
  inherit (pkgs) initomatic mcheads noctalia niri nvim website;
}
