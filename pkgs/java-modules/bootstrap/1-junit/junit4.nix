{
  fetchFromGitHub,
  java-hamcrest,
  mkJavaPackage,
}:
mkJavaPackage (finalAttrs: {
  pname = "junit";
  version = "4.13.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit4";
    rev = "r${finalAttrs.version}";
    hash = "sha256-A6ZbmsECwP/hYqmIoU3rDvEX3V9Dx3FtCgAxpv8n8+Q=";
  };

  propagatedClasspath = [java-hamcrest];

  patches = [
    # hamcrest 2.0+ changed everyItem return type from Matcher<Iterable<T>> to
    # Matcher<Iterable<? extends T>>; cast through Object to satisfy old signature
    ./0001-fix-everyItem-return-type-cast-for-hamcrest-2.patch
    # @Factory was removed from hamcrest 2.0+; it was a no-op marker annotation
    ./0002-remove-hamcrest-factory-decorators.diff
  ];

  postPatch = ''
    # Generate Version.java from the template (Maven normally does this)
    # The committed Version.java has a stale "4.13.2-SNAPSHOT" string
    mv src/main/java/junit/runner/Version.java.template \
       src/main/java/junit/runner/Version.java
    substituteInPlace src/main/java/junit/runner/Version.java \
      --replace-fail '@version@' '${finalAttrs.version}'
  '';

  strictDeps = true;
})
