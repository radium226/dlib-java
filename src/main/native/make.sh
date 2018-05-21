#!/bin/bash

# FIXME We should replace this ugly shell script by a proper CmakeList.txt or even a Makefile

set -e

export SOURCE_FOLDER="src/main/native"
export TARGET_FOLDER="target/native"

export JAVA_PACKAGE="com.github.radium266.dlib.swig"
export GENERATED_JAVA_SOURCES_FOLDER="target/generated-sources/swig"
export GENERATED_JAVA_RESOURCES_FOLDER="target/generated-resources/swig"

export RED='\033[0;31m'
export DEFAULT='\033[0m' # No Color

log()
{
    echo -e "${RED} ==> ${1}${DEFAULT}"
}

clean()
{
    pwd
}

initialize()
{
    log "Creating directories"
    mkdir -p "${TARGET_FOLDER}/build"
    mkdir -p "${GENERATED_JAVA_SOURCES_FOLDER}/$( echo "${JAVA_PACKAGE}" | tr "." "/" )"
    mkdir -p "${GENERATED_JAVA_RESOURCES_FOLDER}"
}


generate_sources()
{
    # -debug-typemap
    log "Generating Java sources using SWIG"
    swig \
        -c++ \
        -java -package "${JAVA_PACKAGE}" \
        -o "${TARGET_FOLDER}/showcase_wrap.cpp" \
        -outdir "${GENERATED_JAVA_SOURCES_FOLDER}/$( echo "${JAVA_PACKAGE}" | tr "." "/" )" \
        "${SOURCE_FOLDER}/showcase.i"
}

generate_resources()
{
    declare name=

    log "Compiling C++ sources into object files"
    g++ \
        -fPIC \
        -fno-strict-aliasing \
        -I"/usr/lib/jvm/java-8-openjdk/include" \
        -I"/usr/lib/jvm/java-8-openjdk/include/linux" \
        $( pkg-config --cflags "dlib-1" ) \
        $( pkg-config --cflags "opencv" ) \
        -I"${SOURCE_FOLDER}" \
        -c "${SOURCE_FOLDER}/showcase.cpp" -o "${TARGET_FOLDER}/build/showcase.o"

    g++ \
        -fPIC \
        -fno-strict-aliasing \
        -I"/usr/lib/jvm/java-8-openjdk/include" \
        -I"/usr/lib/jvm/java-8-openjdk/include/linux" \
        $( pkg-config --cflags "dlib-1" ) \
        $( pkg-config --cflags "opencv" ) \
        -I"${SOURCE_FOLDER}" \
        -c "${TARGET_FOLDER}/showcase_wrap.cpp" -o "${TARGET_FOLDER}/build/showcase_wrap.o"

    log "Linking object files to shared library"
    g++ \
        -fPIC \
        -shared \
        $( pkg-config --libs "opencv" ) \
        $( pkg-config --libs "dlib-1" ) \
        "${TARGET_FOLDER}/build/showcase.o" "${TARGET_FOLDER}/build/showcase_wrap.o" \
        -o "${GENERATED_JAVA_RESOURCES_FOLDER}/libshowcase_wrap.so"
}

main() {
    declare phase="${1}" ; shift
    case "${phase}" in
        "initialize")
                initialize
            ;;

        "generate-sources")
                generate_sources
            ;;

        "generate-resources")
                generate_resources
            ;;
    esac

}

main "${@}"