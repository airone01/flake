_: {
  flake.nixosModules.ollama = {
    lib,
    config,
    ...
  }: {
    options.stars.server.ollama.enable =
      lib.mkEnableOption "Ollama, an open LLM runner";

    config = lib.mkIf config.stars.server.ollama.enable {
      services.ollama = {
        enable = true;
        # acceleration = "rocm";
      };

      services.open-webui = {
        enable = true;
        port = 38527;
        environment = {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
        };
      };
    };
  };
}
