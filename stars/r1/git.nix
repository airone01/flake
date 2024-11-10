_: {
  homeConfig = _: {
    programs.git = {
      enable = true;

      userName = "airone01";
      userEmail = "21955960+airone01@users.noreply.github.com";

      aliases = {
        a = "add .";
        c = "checkout";
        cc = "commit";
        l = "log --all --graph --oneline";
        p = "pull";
        pp = "push";
        r = "restore";
        rh = "reset --hard";
      };
    };

    programs.gh = {
      gitCredentialHelper = {
        enable = true;
        hosts = ["https://github.com" "https://gist.github.com"];
      };
    };
  };
}
