{
  fetchFromGitHub,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "java-hamcrest";
  version = "3.0";

  javaSourceDir = "hamcrest/src/main/java";
  jarName = "hamcrest";

  src = fetchFromGitHub {
    owner = "hamcrest";
    repo = "JavaHamcrest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ntae6XWpD0wEs36YoPsfTl6cSR6ULl6dAJ5oZsV+ih0=";
  };
})
