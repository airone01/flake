## Tiers

0. Pure Java leaves (just javac + JDK)
1. Bootstrap build tools (Ant 1.7 to 1.10)
2. Core injection and plexus primitives
3. Transport and code gen layers
4. Maven 3 core
5. ???

## Packaging status

| Package      | Version | Tier | Build type | Hard deps             | Codegen tools      | Blobs evicted | Status   |
| ------------ | ------- | ---- | ---------- | --------------------- | ------------------ | ------------- | -------- |
| common-lang3 | 3.19.0  | 0    | javac      |                       |                    | Clean         | Done     |
| JUnit3       | 3.8.2   | 0    | javac      |                       |                    | Clean         | Done     |
| JUnit4       | 4.13.2  | 1    | javac      | Hamcrest              |                    | rm            | Done     |
| Ant          | 1.10.15 | 1    | build.sh   | JUnit4, Hamcrest      | Ant (1.7.x) bstrap | rm antunit    | Progress |
| Modello      | 2.4.0   | 3    | javac      | plexus-utils, more... |                    | Clean         | TODO     |
| maven-model  | 3.3.9   | 4    | javac      | plexus-utils, more... | Modello            | Clean         | TODO     |
