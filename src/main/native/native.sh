#!/bin/bash

# FIXME We should replace this ugly shell script by a proper CmakeList.txt or even a Makefile

set -e

export JAVA_PACKAGE="com.github.radium266.dlib.swig"

clean()
{
    :
}

generate_sources()
{
    :
}

generate_resources()
{
    :
}


rm -Rf "../java/radium226/swig"
rm -Rf "./shared"

mkdir -p "../java/radium226/swig"
mkdir -p "./shared"

g++ \
    -fPIC \
    -c "./showcase.cpp" -o "./shared/showcase.o"

swig \
    -c++ \
    -java -package "radium226.swig" \
    -o "./showcase_wrap.cxx" \
    -outdir "../java/radium226/swig" \
    "./showcase.i"

g++ \
    -fPIC \
    -I"/usr/lib/jvm/java-8-openjdk/include" \
    -I"/usr/lib/jvm/java-8-openjdk/include/linux" \
    $( pkg-config --cflags "dlib-1" ) \
    $( pkg-config --cflags "opencv" ) \
    -c "./showcase_wrap.cxx" -o "./shared/showcase_wrap.o"

g++ \
    -fPIC \
    -shared \
    $( pkg-config --libs "opencv" ) \
    $( pkg-config --libs "dlib-1" ) \
    "./shared/showcase.o" "./shared/showcase_wrap.o" \
    -o "../resources/libshowcase_wrap.so"