{
  system,
  nixpkgs,
  ...
}: let
  pkgs = nixpkgs.legacyPackages.${system};

  libraries = with pkgs; [
    #webkitgtk # webkitgtk-2.44.3+abi=4.0 is marked as broken
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl_3
    librsvg
  ];

  packages = with pkgs; [
    # tauri & general
    curl
    wget
    pkg-config
    dbus
    openssl_3
    glib
    gtk3
    libsoup
    #webkitgtk # webkitgtk-2.44.3+abi=4.0 is marked as broken
    librsvg
    # js/ts
    bun
    nodejs_22
    # rust
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];
in
  pkgs.mkShell {
    buildInputs = packages;

    shellHook = ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    '';
  }
