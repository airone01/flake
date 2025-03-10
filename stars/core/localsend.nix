{config, ...}: {
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}

