{
  mkJavaPackage,
  fetchFromGitHub,
}:
mkJavaPackage (finalAttrs: {
  pname = "plexus-container-default";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "codehhaus-plexus";
    repo = "plexus-containers";
    tag = "plexus-containers-${finalAttrs.version}";
  };
})
