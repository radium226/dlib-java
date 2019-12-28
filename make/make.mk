#!/usr/bin/make

.SHELLFLAGS := -e -u -c
.ONESHELL:

TARGET:=target
VERSION:=1.0-SNAPSHOT

include make/opencv.mk
include make/dlib.mk

$(TARGET)/dlib/target/dlib-$(VERSION).jar $(TARGET)/dlib/target/models-$(VERSION).jar $(TARGET)/dlib/target/resources-$(VERSION).jar: $(TARGET)/.m2/repository/opencv/opencv/$(OPENCV_VERSION)/opencv-$(OPENCV_VERSION).jar  /usr/lib/libdlib.so
	mvn \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		package

.PHONY: package
package: $(TARGET)/dlib/target/dlib-$(VERSION).jar $(TARGET)/dlib/target/models-$(VERSION).jar $(TARGET)/dlib/target/resources-$(VERSION).jar

.PHONY: clean
clean:
	mvn \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		clean
	sudo rm -Rf $(TARGET)/pacman"
	rm -Rf $(TARGET)/dlib
	rm -Rf $(TARGET)/opencv