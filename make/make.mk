#!/usr/bin/make

.SHELLFLAGS := -e -u -c
.ONESHELL:

TARGET:=target
VERSION:=1.0-SNAPSHOT

include make/opencv.mk

.PHONY: clean
clean:
	sudo rm -Rf "$(TARGET)/pacman"
	rm -Rf "$(TARGET)/opencv"
	mvn \
		-Dmaven.repo.local="$(shell pwd)/$(TARGET)/.m2/repository" \
		clean
