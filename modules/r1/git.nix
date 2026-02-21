_: {
  stars.home = [
    {
      programs.git = {
        enable = true;

        settings = {
          user.name = "airone01";
          user.email = "21955960+airone01@users.noreply.github.com";

          alias = {
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
      };

      programs.gh = {
        gitCredentialHelper = {
          enable = true;
          hosts = ["https://github.com" "https://gist.github.com"];
        };
      };
    }
  ];
}
