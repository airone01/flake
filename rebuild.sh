#!/usr/bin/env bash

# check for argument
if [ $# -eq 0 ]; then
  echo "Error: No host provided"
  echo "USage: $0 <host>"
  exit 1
fi

set -e
pushd ~/.config/nixos/
#alejandra . &>/dev/null
git diff -U0 *.nix
echo "Rebuilding flake..."
sudo nixos-rebuild switch --show-trace --flake ~/.config/nixos#$1 &>nixos-switch.log || (
  cat nixos-switch.log | grep --color error && false)
git commit -a
popd

