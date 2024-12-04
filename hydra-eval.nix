{ flake ? builtins.getFlake (toString ./.) }:

let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  # Helper function to make a set of packages for each system
  forAllSystems = flake.lib.genAttrs systems;
in
{
  # Check all packages
  packages = forAllSystems (system:
    builtins.mapAttrs (n: v: { inherit system; }) flake.packages.${system} or { }
  );

  # Check all dev shells
  devShells = forAllSystems (system:
    builtins.mapAttrs (n: v: { inherit system; }) flake.devShells.${system} or { }
  );

  # Check all NixOS configurations
  nixosConfigurations = builtins.mapAttrs 
    (name: config: {
      system = config.pkgs.system;
      drvPath = config.config.system.build.toplevel;
    }) 
    flake.nixosConfigurations;

  # Build ISO images
  images = forAllSystems (system:
    builtins.mapAttrs 
      (n: v: { inherit system; })
      (builtins.removeAttrs flake.packages.${system} ["default"])
  );
}
