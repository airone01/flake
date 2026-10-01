{inputs}: final: prev: {
  initomatic = final.callPackage ../pkgs/initomatic {};
  mcheads = final.callPackage ../pkgs/mcheads {};
  noctalia = final.callPackage ../pkgs/noctalia {
    inherit (prev) niri;
  };
  niri = final.callPackage ../pkgs/niri {
    inherit (prev) niri;
  };
  nvim = final.callPackage ../pkgs/nvim {inherit inputs;};
  website = final.callPackage ../pkgs/website {};
}
