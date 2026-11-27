{
  lib,
  libgit2,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "lstr";
  version = "0.3.0";

  src = ./.;

  cargoHash = "sha256-8rLhPX50hXBQ00+80Hmy1XEMZ7/8him6pUSruGLtUCs=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [libgit2];

  meta = {
    description = "A CI program for Nix, tailored to my use";
    license = lib.licenses.mit;
  };
}
