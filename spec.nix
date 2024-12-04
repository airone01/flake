{
  enabled = 1;
  hidden = false;
  description = "r1's NixOS flake";
  nixexprinput = "flake";
  nixexprpath = "hydra-eval.nix";
  checkinterval = 300; # Check every 5 minutes
  schedulingshares = 100;
  enableemail = false;
  emailoverride = "";
  keepnr = 3;
  inputs = {
    flake = {
      type = "git";
      value = "https://github.com/airone01/flake.git dev";
      emailresponsible = false;
    };
  };
}
