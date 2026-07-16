# feature: My CV, compiled from LaTeX to a dated PDF
_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    dateString = lib.strings.trim (builtins.readFile ./date.txt);

    texEnv = pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-medium
        preprint
        fontaxes
        fira
        roboto
        noto
        sourcesanspro
        cormorantgaramond
        charter
        titlesec
        marvosym
        fancyhdr
        babel-english
        tools
        enumitem
        hyperref
        ;
    };
  in {
    packages.cv = pkgs.stdenvNoCC.mkDerivation {
      pname = "erwann-lagouche-cv";
      version = dateString;

      src = ./.;

      nativeBuildInputs = [texEnv];

      buildPhase = ''
        runHook preBuild
        export HOME=$TMPDIR
        pdflatex -interaction=nonstopmode cv.tex
        pdflatex -interaction=nonstopmode cv.tex
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp cv.pdf "$out/Erwann Lagouche ${dateString}.pdf"
        runHook postInstall
      '';

      meta = with lib; {
        description = "Erwann Lagouche's CV, compiled from LaTeX";
        license = licenses.unlicense;
        maintainers = [];
      };
    };
  };
}
