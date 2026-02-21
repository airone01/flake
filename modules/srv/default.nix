{lib, ...}: {
  options.stars.server.enable =
    lib.mkEnableOption "server configuration";
}
