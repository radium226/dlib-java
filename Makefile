#!/usr/bin/env make

SHELL=/bin/bash
.SHELLFLAGS = -e -c
.ONESHELL:

RELEASE_VERSION = 1

DLIB_VERSION := $(shell pacman -Q "dlib" | cut -d" " -f2 | cut -d"-" -f1)
OPENCV_VERSION := $(shell pacman -Q "opencv" | cut -d" " -f2 | cut -d"-" -f1)
OPENCV_JAR_FILE := $(shell find "/usr/share" -name "opencv*.jar" 2>"/dev/null")

pom.xml dlib/pom.xml dlib-models/pom.xml PKGBUILD:
	declare file_path=
	find "." -name "*.in" | while read file_path; do
		sed -r \
			-e 's,%\{DLIB_VERSION\},$(DLIB_VERSION),g' \
			-e 's,%\{OPENCV_VERSION\},$(OPENCV_VERSION),g' \
			-e 's,%\{RELEASE_VERSION\},$(RELEASE_VERSION),g' \
				"$${file_path}" \
					>"$${file_path%.in}"
	done

dlib/target/dlib-$(DLIB_VERSION).jar: pom.xml dlib/pom.xml dlib-models/pom.xml
	mvn \
		--batch-mode \
		--projects "dlib" \
		-Dopencv.jar.file="$(OPENCV_JAR_FILE)" \
		-DskipTests \
			package

dlib-models/target/dlib-models-$(DLIB_VERSION).jar: pom.xml dlib-models/pom.xml dlib-models/pom.xml
	mvn \
		--batch-mode \
		--projects "dlib-models" \
		-Dopencv.jar.file="$(OPENCV_JAR_FILE)" \
		-DskipTests \
			package


dlib-java-$(DLIB_VERSION)-$(RELEASE_VERSION)-any.pkg.tar.xz: PKGBUILD dlib-$(DLIB_VERSION).jar dlib-models-$(DLIB_VERSION).jar
	makepkg \
		--force \
		--clean \
		--cleanbuild \
		--syncdeps \
		--skipchecksums

dlib-models-$(DLIB_VERSION).jar: dlib-models/target/dlib-models-$(DLIB_VERSION).jar
	cp \
		"dlib-models/target/dlib-models-$(DLIB_VERSION).jar" \
		"dlib-models-$(DLIB_VERSION).jar"

dlib-$(DLIB_VERSION).jar:  dlib/target/dlib-$(DLIB_VERSION).jar
	cp \
		"dlib/target/dlib-$(DLIB_VERSION).jar" \
		"dlib-$(DLIB_VERSION).jar"

.PHONY: package
package: dlib-java-$(DLIB_VERSION)-$(RELEASE_VERSION)-any.pkg.tar.xz

.PHONY: install
install: dlib-java-$(DLIB_VERSION)-$(RELEASE_VERSION)-any.pkg.tar.xz
	sudo pacman -U --noconfirm "dlib-java-$(DLIB_VERSION)-$(RELEASE_VERSION)-any.pkg.tar.xz"

.PHONY: clean
clean: pom.xml dlib/pom.xml dlib-models/pom.xml
	mvn \
		--batch-mode \
		-Dopencv.jar.file="$(OPENCV_JAR_FILE)" \
			clean
	find "." -name "pom.xml" -exec rm "{}" \;
	find "." -name "*.pkg.tar.xz" -exec rm "{}" \;
	rm -f \
		"PKGBUILD" \
		"dlib-$(DLIB_VERSION).jar" \
		"dlib-models-$(DLIB_VERSION).jar"
