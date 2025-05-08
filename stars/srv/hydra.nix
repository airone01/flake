_: {
  # Enable Hydra service
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.air1.one";
    notificationSender = "hydra@air1.one";

    # Basic Hydra configuration
    buildMachinesFiles = [];
    useSubstitutes = true;

    # Configure Hydra to listen on localhost:3000
    port = 6430;
    listenHost = "127.0.0.1";
  };
}
