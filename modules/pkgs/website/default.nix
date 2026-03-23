{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages.website = pkgs.stdenv.mkDerivation {
      pname = "zola-website";
      version = "0.1.0";

      src = ./.;

      nativeBuildInputs = [pkgs.zola];

      zolaTheme = pkgs.fetchFromGitHub {
        owner = "lopes";
        repo = "zola.386";
        rev = "master";
        hash = "sha256-pmlgG7cS7daJek8U+Epb1Flo4mOESyudiAQDv9YyHRQ=";
      };

      preBuild = ''
        mkdir -p themes/zola.386
        cp -r $zolaTheme/* themes/zola.386/
        chmod -R +w themes/zola.386
      '';

      buildPhase = ''
        runHook preBuild
        zola build -o $out
      '';

      meta = with lib; {
        description = "Retro Zola blog";
        homepage = "https://air1.one";
        license = licenses.mit;
        maintainers = [];
      };
    };

    # Does not contain the website package, just a basic shell so I can use it
    # in watch mode to edit the website on the fly
    devShells.website = pkgs.mkShell {
      buildInputs = [pkgs.zola];

      shellHook = ''
        THEME_DIR="pkgs/website/themes/zola.386"
        if [ ! -d "$THEME_DIR" ]; then
          mkdir -p pkgs/website/themes
          git clone https://github.com/lopes/zola.386 "$THEME_DIR"
        fi

        echo "To locally test the website, run:"
        echo "$ cd pkgs/website && zola serve"
      '';
    };
  };
}
