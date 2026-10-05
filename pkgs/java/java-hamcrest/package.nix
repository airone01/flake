{
  lib,
  mkJavaPackage,
  fetchFromGitHub,
}:
# Built manually with javac/jar rather than Gradle: Gradle itself depends on
# Hamcrest, so bootstrapping the Java toolchain from source can't use Gradle to
# build it. Hamcrest's main module is pure Java 8 with no runtime dependencies,
# so a plain compile is enough (the hamcrest-core / -library / -integration dirs
# are legacy aggregator modules with no sources of their own since 2.0).
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

  meta = {
    homepage = "https://hamcrest.org/JavaHamcrest/";
    description = "Java library containing matchers that can be combined to create flexible expressions of intent";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [tomodachi94 airone01];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
