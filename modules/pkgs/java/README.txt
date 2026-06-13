This directory serves as a testing ground for complete Java bootstrap from
source. I will probably setup an overlay which *will* make me cache miss a lot
of packages in nixpkgs.
Doing this for the love of the game.

BLOB AUDIT (per-package)
------------------------
Packages are checked at the git tag used in the bootstrap build. "blob" means
a precompiled binary in the source tree; "test-only" means it is not on any
production compile classpath.

  commons-cli 1.10.0        — clean
  commons-io 2.20.0         — test-only .bin fixtures; not touched by our build
  commons-lang 2.6          — clean
  commons-lang3 3.19.0      — clean
  jspecify 0.3.0            — gradle-wrapper.jar (wrapper, never invoked)
  jsoup 1.17.2              — gradle-wrapper.jar (wrapper, never invoked)
  java-hamcrest 3.0         — gradle-wrapper.jar (wrapper, never invoked)
  junit4 4.13.2             — maven-wrapper.jar + lib/hamcrest-core-1.3.jar;
                              neither is used: our build passes -classpath
                              explicitly and never invokes the Maven wrapper
  plexus-classworlds 2.8.0  — test-data/*.jar (test fixtures only)
  plexus-utils 3.5.1        — clean
  plexus-containers 2.2.0   — clean
  plexus-interpolation 1.27 — clean
  plexus-cipher 2.0         — clean
  plexus-sec-dispatcher 2.0 — clean
  javax.inject 1.0.5        — clean
  jsr250-api / common-annotations-api 1.3.5 — clean
  cdi-api 2.0.2             — clean
  guava 32.1.3              — gradle-wrapper.jar in integration-tests/ subdir
  guice 5.1.0               — clean
  slf4j 1.7.36              — integration/lib/*.jar; "integration" is a
                              separate reactor module not needed for
                              slf4j-api or slf4j-simple
  sisu 0.3.2                — test resources only (*.jar / *.class in
                              src/test/resources)
  maven-wagon 3.5.3         — clean
  modello 2.4.0             — clean
  maven-resolver 1.9.22     — demo.jar in demo-snippets (not a build dep)
  Maven 3.3.9               — all blobs are in src/test/resources except one:
                              maven-ant-tasks-2.1.1.jar at the repo root,
                              referenced only by build.xml (the Ant-based
                              build path). The Maven-based bootstrap never
                              invokes build.xml so this blob is inert.
  commons-logging 1.1.3     — clean
  commons-codec 1.6         — clean
  httpcore 4.3.2            — clean
  httpclient 4.3.5          — clean

KNOWN BLOB ISSUES
-----------------
ant_1_7: RESOLVED. bootstrap.sh hardcoded lib/xercesImpl.jar, lib/xml-apis.jar,
  and lib/optional/*.jar (ant-antunit-1.0.jar, junit-3.8.2.jar) on the javac
  classpath. postPatch now removes them all. The build.xml check_for_optional_packages
  target probes the classpath via <available>; without the jars, junit.present
  and antunit.present are unset and those source files are excluded via
  conditional selectors. The build succeeds; postInstall verifies JUnitTask and
  AntUnitTask are absent from the output jars.

ant 1.10.15: postPatch evicts junit/hamcrest from lib/optional, but
  ant-antunit-1.4.1.jar is left behind. build.sh passes -lib lib/optional to
  bootstrap ant, so antunit lands on the compile classpath for AntUnit tasks.

SOURCE PROVENANCE ISSUES
------------------------
aopalliance 1.0: No public git repository exists. Fedora's javapackages-
  bootstrap sources it directly from Maven Central as a -sources.jar archive.
  This is the only package in the graph without a proper VCS origin.

Eclipse Aether 1.0.2: The original source lived at eclipse.org Gerrit (now
  retired). The apache/maven-resolver GitHub repo begins at 2.0.0 and does
  not contain the 1.0.x history. Building Aether 1.0.2 from source requires
  fetching the eclipse.org source tarball (available on Maven Central as
  -sources.jar) or switching to a newer maven-resolver release for Maven 3.5+.

BOOTSTRAP CHAIN NOTES
---------------------
wagon-http 2.10: pom lists httpclient:4.3.5, httpcore:4.3.2, and
  commons-logging:1.1.3 as direct compile deps. httpclient additionally
  requires httpcore, commons-logging, and commons-codec:1.6 (all compile
  scope). All four HttpComponents nodes are now in the graph and are leaves
  (no compile deps beyond javac itself).

logback-core / logback-classic 1.0.7: all non-core deps (janino, jansi,
  groovy, servlet-api, JavaMail, JMS spec) are declared <optional>true</optional>
  in pom. A minimal javac build that excludes those source files compiles
  cleanly with only SLF4J-API and logback-core — no new nodes needed.

commons-lang 2.6 / commons-io 2.20.0: NOT compile deps of any Maven 3.3.9
  core module, but ARE needed by the Wagon 2.10 transport layer:
    commons-lang → wagon-file, wagon-http-shared
    commons-io   → wagon-http-shared
  wagon-http-shared in turn feeds wagon-http, which is bundled in the Maven
  distribution. So both are necessary for a complete Maven 3.3.9 bootstrap.

jsoup: wagon-http-shared 2.10 pom specifies jsoup:1.7.2 (compile scope);
  jsoup 1.7.2 is a pure leaf (no compile deps). Our overlay ships 1.17.2,
  which adds jspecify as a provided (annotation-only) compile dep but is
  otherwise API-compatible for wagon's use. JSOUP → WAG_HTSH edge is now
  in the graph.

MAVEN VERSION NOTES
-------------------
Maven 3.3.9 uses guice:4.0:no_aop (the classifier that strips bytecode
weaving), so ASM and cglib are NOT required for the bootstrap despite being
listed as compile deps in the full guice pom.

Maven 3.3.9 uses plexus-cipher:1.7 and plexus-sec-dispatcher:1.3 under the
org.sonatype.plexus groupId (now moved to codehaus-plexus). The newer
codehaus releases (cipher:2.0, sec-dispatcher:2.0) are API-compatible
drop-in replacements and are what javapackages-bootstrap targets.
