{
  lib,
  libgit2,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "lstr";
  version = "0.2.0";

  src = ./.;

  cargoHash = "sha256-Bs0/ImutXEmQBWk9bj/SmwwWbBqX0ly7sb4dLaOBfvw=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [libgit2];

  meta = {
    description = "A CI program for Nix, tailored to my use";
    license = lib.licenses.mit;
  };
}
