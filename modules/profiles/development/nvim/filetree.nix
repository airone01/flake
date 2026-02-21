{
  lib,
  config,
  ...
}: let
  cfg = config.stars;
in {
  config =
    lib.mkIf (
      cfg.core.enable
      && cfg.profiles.development.enable
      && cfg.profiles.development.enableNvf
    ) {
      home-manager.users.${config.stars.mainUser} = {
        programs.nvf.settings.vim.filetree.neo-tree = {
          enable = true;

          setupOpts = {
            enable_cursor_hijack = true;
            git_status_async = true; # for big repos
            auto_clean_after_session_restore = true;

            window = {
              width = 30; # default is 40
              mappings = {
                "<" = "none"; # Disable default shrink
                ">" = "none"; # Disable default expand
              };
            };

            # note: to toggle on/off hidden files, press H in neo-tree
          };
        };
      };
    };
}
