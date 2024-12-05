{stars, ...}: {
  # Imports for the base asterism (profile)
  imports = with stars; [
    # Network core
    core-direnv
    core-sops
    core-unfree

    # Dev core
    dev-core
    dev-garnix

    # Hardware settings
    hard-graphics
    hard-nvidia

    # airone01-specific
    r1-git
  ];
}
