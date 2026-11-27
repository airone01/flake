{inputs}: final: prev: {
  ai-robots-txt = final.callPackage ../pkgs/ai-robots-txt/package.nix {};
  cv = final.callPackage ../pkgs/cv/package.nix {};
  grout = final.callPackage ../pkgs/mek-fonts/grout.nix {};
  initomatic = final.callPackage ../pkgs/initomatic/package.nix {};
  lstr = final.callPackage ../pkgs/lstr/package.nix {};
  mcheads = final.callPackage ../pkgs/mcheads/package.nix {};
  mek-sans = final.callPackage ../pkgs/mek-fonts/mek-sans.nix {};
  monomek = final.callPackage ../pkgs/mek-fonts/monomek.nix {};
  noctalia = final.callPackage ../pkgs/noctalia/package.nix {inherit (prev) niri noctalia;};
  niri = final.callPackage ../pkgs/niri/package.nix {inherit (prev) niri;};
  nvim = final.callPackage ../pkgs/nvim/package.nix {inherit inputs;};
  nvim-full = final.callPackage ../pkgs/nvim/package.nix {
    inherit inputs;
    additionalNvfModules = [
      (import ../pkgs/nvim/mods/lang.nix)
      (import ../pkgs/nvim/mods/misc.nix)
    ];
  };
  website = final.callPackage ../pkgs/website/package.nix {};
  wallpapers = final.callPackage ../pkgs/wallpapers/package.nix {};
  zola-386 = final.callPackage ../pkgs/zola-386/package.nix {};
}
