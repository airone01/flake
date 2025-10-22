_: {
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://airone01.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "airone01.cachix.org-1:+HKTZmTKthiKMNQzABHWDSMEUFC233bbkKmrjh8C6sc="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };
}
