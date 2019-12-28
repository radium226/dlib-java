#!/usr/bin/make

.SHELLFLAGS := -e -u -c
.ONESHELL:

NATIVE:=$(PROJECT)/src/main/native

JAVA_PACKAGE:=com.github.radium266.dlib.swig

OBJECTS+=generated-objects/make/face_descriptor_computer.o
OBJECTS+=generated-objects/make/showcase.o
OBJECTS+=generated-objects/make/shape_predictor.o
OBJECTS+=generated-objects/make/face_detector.o
OBJECTS+=generated-objects/make/dlib_wrap.o
OBJECTS+=generated-objects/make/showcase_wrap.o

# Compile using G++
define compile
    g++ \
		-fPIC \
		-fno-strict-aliasing \
		-I"/usr/lib/jvm/java-8-openjdk/include" \
		-I"/usr/lib/jvm/java-8-openjdk/include/linux" \
		$(shell pkg-config --cflags "dlib-1" ) \
		$(shell pkg-config --cflags "opencv4" ) \
		-I"$(NATIVE)" \
		-I"$(NATIVE)/include" \
		-c "$(1)" -o "$(2)" \
		-std=c++11
endef

# Generate C++ wrappers
generated-sources/make/cpp/%_wrap.cpp:
	mkdir -p "generated-sources/make/cpp"
	mkdir -p "generated-sources/make/java/$(shell echo '$(JAVA_PACKAGE)' | tr '.' '/')"
	swig \
		-v \
		-I"$(NATIVE)/swig" \
		-I"$(NATIVE)/include" \
		-I- \
		-c++ \
		-java -package "$(JAVA_PACKAGE)" \
		-o "$@" \
		-outdir "generated-sources/make/java/$(shell echo '$(JAVA_PACKAGE)' | tr '.' '/')" \
		"$(NATIVE)/swig/$(shell basename '$@' '.cpp' | sed 's,_wrap,,g' ).i"

# Compile C++ to objects
generated-objects/make/dlib_wrap.o: generated-sources/make/cpp/dlib_wrap.cpp
	mkdir -p "generated-objects/make"
	$(call compile,$<,$@)

generated-objects/make/showcase_wrap.o: generated-sources/make/cpp/showcase_wrap.cpp
	mkdir -p "generated-objects/make"
	$(call compile,$<,$@)

generated-objects/make/%.o:
	mkdir -p "generated-objects/make"
	$(call compile,$(NATIVE)/$(shell basename '$@' '.o').cpp,$@)

generated-resources/make/libdlib-java.so: $(OBJECTS)
	mkdir -p "generated-resources/make"
	g++ \
		--verbose \
		-fPIC \
		-shared \
		$(shell pkg-config --libs "opencv4" ) \
		$(shell pkg-config --libs "dlib-1" ) \
		$(OBJECTS) \
		-o "$@"

.PHONY: shared-library
shared-library: generated-resources/make/libdlib-java.so