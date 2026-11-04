                          JAVA BUILD SYSTEMS BOOTSTRAP

Organization
------------

This directory is meant to mimick what pkgs/development/java-modules/bootstrap
could be. It contains the default.nix script, which separates build targets into
scopes. Those scopes are in order (subject to change):
- ant-deps
- ant
- maven-core

Where each scope is meant to build tools in order to achieve the next step. Each
scope's name corresponds to what tools each scope is meant to provide.

