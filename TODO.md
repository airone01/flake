# neovim

- images support for zellij/other terms
- shift-tab previous tab
- find why highlights don't display in visual mode

# other

- colored outputs on common commands
- more zsh plugins
- f alias for pay-respects
- stylix for colors
  - wallpapers are declarative

# flake general

- [ ] CI "Check" Workflow: Add a GitHub Action to run nix flake check on PRs to
      catch errors early.
- [ ] Enforce Formatting: Use a workflow to fail PRs if code isn't formatted
      (`nix fmt -- --clear-cache --fail-on-change`)
- [x] Adopt flake-parts: Refactor flake.nix to use the modular flake-parts
      framework for better structure and maintainability.
- [x] Declarative Git Hooks: Use git-hooks.nix (via pre-commit-hooks.nix) to
      automatically manage hooks like commitlint and linters.
- [x] Universal Formatting: Adopt treefmt-nix to format all file types (Nix,
      JSON, TOML, Markdown) with a single command (nix fmt).
- [ ] Pin Stable Nixpkgs: Use a stable nixpkgs input for servers (like Hercules)
      to avoid upstream breakages.
- [x] Linters: Add statix and deadnix to your dev shell to catch anti-patterns
      and unused code.
