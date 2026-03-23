# This file tells flake-parts which system it should build the flake derivations
# for. I might add Darwin support when I manage to get my hands on a Darwin
# machine to run the CI on.
{
  config = {
    systems = [
      "x86_64-linux"
      # "x86_64-darwin"
      "aarch64-linux"
      # "aarch64-darwin"
    ];
  };
}
