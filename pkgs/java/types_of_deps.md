I recognize five types of depsendencies:

- Core runtime and compile APIs
  - This is typically what `javac -classpath` strictly needs
- Build-type generators
  - Ex. Modello generating .java files from .mdo XML
- Build tools and orchestrators
  - Ant, Maven, Gradle
- Test and verification deps
  - JUnit, Mockito, Hamcrest
    - Those often introduce circular loops and are the main reason for my pain
    - Those should be avoided and dropped as much as possible
      - As per what GUIX and Fedora did
- Optional and provided plugins and features
  - Janino, Groovy, AOP weaving, bytecode manipulation for optimization
    - Needless to say, whenever avoidable, avoid.
    - Bytecode optimization is necessary for prod, not so much to have a full
      from-source stack. Typically use the `PKG_NAME:no_aop` targets.
