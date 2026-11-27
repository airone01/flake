{
  lib,
  pkgs,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ai.robots.txt";
  version = "2.0";

  src = pkgs.fetchFromGitHub {
    owner = "ai-robots-txt";
    repo = "ai.robots.txt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mg5QMHwxAV2RlUZplCnSAGgjC/VIq+djGZa4YWShgS0=";
  };

  buildPhase = ''
    runHook preBuild

    # I just need the robots.txt for Zola.
    mkdir -pv $out
    cp -v robots.txt $out

    runHook postBuild;
  '';

  meta = with lib; {
    description = "A list of AI agents and robots to block.";
    homepage = "https://github.com/ai-robots-txt/ai.robots.txt";
    license = licenses.mit;
  };
})
