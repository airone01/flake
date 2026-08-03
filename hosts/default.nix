# https://github.com/sioodmy/dotfiles/blob/9551ed3112fe6e8ce26700ef63493cb51bc20ecc/hosts/default.nix
# Largely inspired by sioodmy's dotfiles.
{
  nixpkgs,
  inputs,
}: let
  mkHost = system: hostName: mainUser: let
    lib = nixpkgs.legacyPackages.${system}.lib;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs mainUser;};
      modules = [
        {
          networking.hostName = hostName;
          nixpkgs.hostPlatform = lib.mkDefault system;
        }
        (import ../mods/core {inherit mainUser;})
        ./${hostName}/configuration.nix
        ./${hostName}/hardware-configuration.nix
      ];
    };
in {
  cassiopeia = mkHost "x86_64-linux" "cassiopeia" "r1";
  cetus = mkHost "x86_64-linux" "cetus" "rack";
  lyra = mkHost "x86_64-linux" "lyra" "user";

  hercules = mkHost "aarch64-linux" "hercules" "rack";
}
