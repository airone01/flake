{
  fetchurl,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "commons-cli";
  version = "1.2";

  src = fetchurl {
    url = "mirror://apache/commons/cli/source/commons-cli-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-AkM0hsVfnz6xGv+7TYljOcuTquMz8y/RfC7CuP/zRpA=";
  };
})
