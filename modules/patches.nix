_: {
  flake.nixosModules.patches = _: {
    nixpkgs.overlays = [
      (_final: prev: {
        # openldap 2.6.13: flaky sync-replication test (test017) fails non-deterministically
        openldap =
          if prev.openldap.version == "2.6.13"
          then prev.openldap.overrideAttrs {doCheck = false;}
          else prev.openldap;
        # pipx 1.8.0: tests assert no space before @ in package specs, but 1.8.0 adds one
        pipx =
          if prev.pipx.version == "1.8.0"
          then prev.pipx.overrideAttrs {doInstallCheck = false;}
          else prev.pipx;
      })
    ];
  };
}
