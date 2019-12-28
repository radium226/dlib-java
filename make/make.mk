#!/usr/bin/make

.SHELLFLAGS := -e -u -c
.ONESHELL:

TARGET:=target
VERSION:=1.0-SNAPSHOT

include make/opencv.mk
include make/dlib.mk

$(TARGET)/dlib/target/dlib-$(VERSION).jar $(TARGET)/models/target/models-$(VERSION).jar: $(TARGET)/.m2/repository/opencv/opencv/$(OPENCV_VERSION)/opencv-$(OPENCV_VERSION).jar /usr/lib/libdlib.so
	sudo pacman -S \
		--cachedir="$(shell pwd)/$(TARGET)/pacman" \
		"libnsl" \
		"qt5-base" \
		"hdf5" \
		"vtk" \
		"glew" \
		--noconfirm
	mvn \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		package

.PHONY: package
package: $(TARGET)/dlib/target/dlib-$(VERSION).jar

.PHONY: clean
clean:
	sudo rm -Rf "$(TARGET)/pacman"
	rm -Rf "$(TARGET)/dlib"
	rm -Rf "$(TARGET)/opencv"
	mvn \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		clean
