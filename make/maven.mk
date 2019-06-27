.PHONY: maven-clean
maven-clean:
	mvn clean

.PHONY: maven-package
maven-package: dlib/target/dlib
