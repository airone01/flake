{inputs, ...}: {
  homeConfig = _: {
    imports = [inputs.schizofox.homeManagerModule];

    programs.schizofox = {
      enable = true;

      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        # fetched from https://cdn.jsdelivr.net/gh/microlinkhq/top-user-agents@master/src/desktop.json
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:129.0) Gecko/20100101 Firefox/129.0";
      };

      search = {
        defaultSearchEngine = "Brave";
        removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
        searxUrl = "https://searx.be";
        searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
      };

      extensions = {
        # > Schizofox only provides uBlock Origin out of the box.
        siplefox.enable = true;

        extraExtensions = {
          "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
          "jetpack-extension@dashlane.com".install_url = "https://addons.mozilla.org/firefox/downloads/latest/dashlane/latest.xpi";
          "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
          "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
          "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
          "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
        };
      };

      misc = {
        drmFix = true;
        disableWebgl = false;
        startPageURL = "file://${builtins.readFile ./index.html}";
        contextMenu.enable = true;
      };
    };
  };
}
