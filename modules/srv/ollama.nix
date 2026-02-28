{
  lib,
  config,
  ...
}: let
  cfg = config.stars.server.ollama;
  scfg = config.stars.server.enable;

  sandbox = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    LockPersonality = true;
  };
in {
  options.stars.server.ollama.enable =
    lib.mkEnableOption "Ollama, an open LLM model runner";

  config = lib.mkIf (scfg && cfg.enable) {
    services.ollama = {
      enable = true;
      # acceleration = "rocm";
    };

    users = {
      users.ollama = {
        isSystemUser = true;
        group = "ollama";
      };
      groups.ollama = {};

      users.open-webui = {
        isSystemUser = true;
        group = "open-webui";
      };
      groups.open-webui = {};
    };

    systemd.services.ollama = {
      serviceConfig =
        sandbox
        // {
          StateDirectory = "ollama";
        };
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
}
