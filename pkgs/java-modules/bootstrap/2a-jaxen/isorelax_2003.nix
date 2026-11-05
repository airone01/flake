{
  fetchzip,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "isorelax";
  version = "20030108";

  # isorelax doesn't seem to be stored in the Maven Repository
  # The following is a backup link. It's hosted on Siemens servers.
  # TODO find a better mirror

  src = fetchzip {
    url = "https://download.industrysoftware.automation.siemens.com/open-source/isorelax.${finalAttrs.version}-src.zip";
    hash = "sha256-Kf1KMQrX8kCvvoFuUPjfE1I7UqcRafS1CnlEzaUI5hA=";
    stripRoot = false;
  };

  javaSourceDir = "org";

  # Build without Ant & JAXP support
  excludeSourcePatterns = ["org/iso_relax/ant/*.java" "org/iso_relax/jaxp/*.java"];
})
