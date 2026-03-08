_: {
  imports = [
    ./core

    ./profiles/desktop
    ./profiles/desktop/asus.nix
    ./profiles/desktop/dualsense.nix
    ./profiles/desktop/firefox.nix
    ./profiles/desktop/french.nix
    ./profiles/desktop/gnome.nix
    ./profiles/desktop/hyprland/default.nix
    ./profiles/desktop/hyprland/rofi.nix
    ./profiles/desktop/hyprland/waybar.nix
    ./profiles/desktop/schizofox

    ./profiles/development
    ./profiles/development/nvim
    ./profiles/development/nvim/binds.nix
    ./profiles/development/nvim/dashboard.nix
    ./profiles/development/nvim/filetree.nix
    ./profiles/development/nvim/git.nix
    ./profiles/development/nvim/languages.nix
    ./profiles/development/nvim/lsp.nix
    ./profiles/development/nvim/statusline.nix
    ./profiles/development/nvim/tabline.nix
    ./profiles/development/nvim/telescope.nix
    ./profiles/development/nvim/treesitter.nix
    ./profiles/development/nvim/ui.nix
    ./profiles/development/nvim/utility.nix
    ./profiles/development/nvim/vim.nix
    ./profiles/development/nvim/wrappers.nix

    ./profiles/gaming.nix
    ./profiles/virt.nix

    ./srv
    ./srv/anubis.nix
    ./srv/gitea.nix
    ./srv/hercules-ci.nix
    ./srv/ollama.nix
    ./srv/searchix.nix
    ./srv/ssh-server
    ./srv/ssh-server/hardening.nix
    ./srv/ssh-server/known-hosts.nix
    ./srv/ssh-server/ssh-keys
    ./srv/traefik.nix
    ./srv/vaultwarden.nix
  ];
}
