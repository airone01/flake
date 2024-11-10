# Stars Folder Structure

This folder contains "stars" - modular configuration units for your NixOS system. Stars can be organized in various ways to suit your needs.

## Structure

Stars can be defined in the following ways:

1. Individual `.nix` files in the root of the `stars/` directory.
2. Individual `.nix` files in subdirectories.
3. Folders with a `default.nix` file.

Example structure:

```
stars/
├── README.md
├── gnome.nix
├── development/
│   ├── python.nix
│   ├── rust.nix
│   └── default.nix
└── security/
    └── firewall/
        └── default.nix
```

## Naming Convention

Stars are named based on their file path, with some adjustments:

- The `.nix` extension is removed.
- Slashes (`/`) in the path are replaced with hyphens (`-`).
- For folders with `default.nix`, the `default` part is omitted from the name.

Using the above structure as an example, the star names would be:

- `gnome`
- `development-python`
- `development-rust`
- `development` (from `development/default.nix`)
- `security-firewall` (from `security/firewall/default.nix`)

## Usage

To use a star in your NixOS configuration, import it in your `configuration.nix` file:

```nix
{ stars, ... }: {
  imports = with stars; [
    gnome
    development-python
    security-firewall
  ];

  # ... rest of your configuration
}
```

Feel free to organize your stars in a way that makes sense for your system configuration. This flexible structure allows for both simple, single-file stars and more complex, multi-file star modules.
