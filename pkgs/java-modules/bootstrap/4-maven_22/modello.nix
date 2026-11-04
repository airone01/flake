{
  fetchFromGitHub,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "modello";
  version = "2.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "codehaus-plexus";
    repo = "modello";
    tag = "modello-${finalAttrs.version}";
    hash = "sha256-4n4/5Lyqe0EyBFyzcJmv0NeZzJS6v6Q8F5IHHf4rbxU=";
  };

  javaSourceDir = "modello-core/src/main/java";

  strictDeps = true;
})
