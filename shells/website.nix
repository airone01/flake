{pkgs, ...}:
pkgs.mkShell {
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
}
