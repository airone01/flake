{inputs}: final: prev: {
  cv = final.callPackage ../pkgs/cv {};
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
  zola-386 = final.callPackage ../pkgs/zola-386 {};
}
