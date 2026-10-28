# feature: My CV, compiled from LaTeX to a dated PDF
{
  lib,
  pkgs,
  ...
}: let
  dateString = lib.strings.trim (builtins.readFile ./date.txt);

  texEnv = pkgs.texliveSmall.withPackages (tp:
    with tp; [
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
      babel-french
      tools
      enumitem
      hyperref
    ]);
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "erwann-lagouche-cv";
    version = dateString;

    src = ./.;

    nativeBuildInputs = [
      texEnv
      pkgs.poppler-utils
    ];

    buildPhase = ''
      runHook preBuild

      HOME=$TMPDIR pdflatex -interaction=nonstopmode -jobname=cv-en cv.tex
      HOME=$TMPDIR pdflatex -interaction=nonstopmode -jobname=cv-fr "\def\isFrench{1}\input{cv.tex}"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -pv "$out"
      install -vm 644 cv-en.pdf "$out/Erwann Lagouche ${dateString} - EN.pdf"
      install -vm 644 cv-fr.pdf "$out/Erwann Lagouche ${dateString} - FR.pdf"

      # Convenient and backwards-compatible symlinks
      ln -s "Erwann Lagouche ${dateString} - EN.pdf" "$out/cv-en.pdf"
      ln -s "Erwann Lagouche ${dateString} - FR.pdf" "$out/cv-fr.pdf"
      ln -s "cv-en.pdf" "$out/cv.pdf"
      ln -s "Erwann Lagouche ${dateString} - EN.pdf" "$out/Erwann Lagouche ${dateString}.pdf"

      runHook postInstall
    '';

    checkPhase = ''
      runHook preCheck

      # Assert that CVs are one page long
      check_pages() {
        local file="$1"
        local pages
        pages=$(pdfinfo "$file" | awk '/^Pages:/ {print $2}')
        if [ "$pages" -ne 1 ]; then
          echo "ERROR: $file has $pages pages! Expected exactly 1 page." >&2
          exit 1
        fi
        echo "PASS: $file is exactly $pages page."
      }

      check_pages cv-en.pdf
      check_pages cv-fr.pdf

      runHook postCheck
    '';
    doCheck = true;

    meta = with lib; {
      description = "Erwann Lagouche's CV, compiled from LaTeX";
      license = licenses.unlicense;
      maintainers = [];
    };
  }
