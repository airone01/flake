_: {
  flake.nixosModules.ai = {
    lib,
    config,
    ...
  }: {
    options.stars.ai.enable =
      lib.mkEnableOption "AIs and LLMs";

    config = lib.mkIf config.stars.ai.enable {
      home-manager.users.${config.stars.mainUser}.programs = {
        claude-code = {
          enable = true;

          mcpServers = {
            context7 = {
              type = "stdio";
              command = "npx";
              args = ["-y" "@upstash/context7-mcp"];
            };
          };
        };

        gemini-cli.enable = true;
      };
    };
  };
}
