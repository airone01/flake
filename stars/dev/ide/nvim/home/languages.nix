_: {
  programs.nvf.settings.vim.languages = {
    # for each enabled language below:
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
    enableTreesitter = true;

    # programming/scripting/configuration languages list
    assembly.enable = true;
    astro = {
      enable = true;
      format.type = "biome";
    };
    bash.enable = true;
    clang.enable = true;
    css = {
      enable = true;
      format.type = "biome";
    };
    go.enable = true;
    html.enable = true;
    lua.enable = true;
    markdown.enable = true;
    nix.enable = true;
    php.enable = true;
    python.enable = true;
    rust = {
      enable = true;
      crates.enable = true;
    };
    sql.enable = true;
    svelte = {
      enable = true;
      format.type = "biome";
    };
    tailwind.enable = true;
    ts = {
      enable = true;
      format.type = "biome";
    };
    yaml.enable = true;
  };
}
