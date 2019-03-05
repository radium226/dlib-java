#!/bin/bash

# FIXME We should replace this ugly shell script by a proper CmakeList.txt or even a Makefile

set -euo pipefail

export SOURCE_FOLDER="src/main/native"
export TARGET_FOLDER="target/native"

export JAVA_PACKAGE="com.github.radium266.dlib.swig"
export GENERATED_JAVA_SOURCES_FOLDER="target/generated-sources/swig"
export GENERATED_JAVA_RESOURCES_FOLDER="target/generated-resources/swig"

export RED='\033[0;31m'
export BLUE='\033[34m'
export DEFAULT='\033[0m' # No Color

export SWIG_MODULES=(
    "showcase"
    "dlib"
)

export GCC_COMPILE_SPECS=(
    "${SOURCE_FOLDER}/face_descriptor_computer.cpp","${TARGET_FOLDER}/build/face_descriptor_computer.o"
    "${SOURCE_FOLDER}/showcase.cpp","${TARGET_FOLDER}/build/showcase.o"
    "${SOURCE_FOLDER}/shape_predictor.cpp","${TARGET_FOLDER}/build/shape_predictor.o"
    "${SOURCE_FOLDER}/face_detector.cpp","${TARGET_FOLDER}/build/face_detector.o"
    "${TARGET_FOLDER}/showcase_wrap.cpp","${TARGET_FOLDER}/build/showcase_wrap.o"
    "${TARGET_FOLDER}/dlib_wrap.cpp","${TARGET_FOLDER}/build/dlib_wrap.o"
)

spec::target_file_paths()
{
    declare old_ifs=
    declare i=
    declare target_file_path=

    old_ifs="${IFS}"
    IFS=','; for i in  "${@}"; do set -- $i;
        target_file_path="${2}"
        echo "${target_file_path}"
    done
    IFS="${old_ifs}"
}

log()
{
    declare indent=${2:-0}
    case ${indent} in
        0) echo -e "${RED} ==> ${1}${DEFAULT}" ;;
        1) echo -e "${BLUE}      - ${1}${DEFAULT}" ;;
    esac
}

mvn::clean()
{
    pwd
}

mvn::initialize()
{
    log "Creating directories"
    mkdir -p "${TARGET_FOLDER}/build"
    mkdir -p "${GENERATED_JAVA_SOURCES_FOLDER}/$( echo "${JAVA_PACKAGE}" | tr "." "/" )"
    mkdir -p "${GENERATED_JAVA_RESOURCES_FOLDER}"
}

swig::generate_java_sources()
{
    declare module="${1}" ; shift
    swig \
        -v \
        -I"${SOURCE_FOLDER}/swig" \
        -I"${SOURCE_FOLDER}/include" \
        -I- \
        -c++ \
        -java -package "${JAVA_PACKAGE}" \
        -o "${TARGET_FOLDER}/${module}_wrap.cpp" \
        -outdir "${GENERATED_JAVA_SOURCES_FOLDER}/$( echo "${JAVA_PACKAGE}" | tr "." "/" )" \
        "${SOURCE_FOLDER}/swig/${module}.i"
}

mvn::generate_sources()
{
    # -debug-typemap
    log "Generating Java sources using SWIG" 0
    declare swig_module=
    for swig_module in "${SWIG_MODULES[@]}"; do
        log "${swig_module}" 1
        swig::generate_java_sources "${swig_module}"
    done
}

gcc::compile_object()
{
    declare source_file_path="${1}"
    declare target_file_path="${2}"
    g++ \
        -fPIC \
        -fno-strict-aliasing \
        -I"/usr/lib/jvm/java-8-openjdk/include" \
        -I"/usr/lib/jvm/java-8-openjdk/include/linux" \
        $( pkg-config --cflags "dlib-1" ) \
        $( pkg-config --cflags "opencv4" ) \
        -I"${SOURCE_FOLDER}" \
        -I"${SOURCE_FOLDER}/include" \
        -c "${source_file_path}" -o "${target_file_path}" \
        -std=c++11
}

gcc::compile_shared_library()
{
    declare so_file_path="${1}" ; shift
    set -x
    g++ \
        --verbose \
        -fPIC \
        -shared \
        $( pkg-config --libs "opencv4" ) \
        $( pkg-config --libs "dlib-1" ) \
        "${@}" \
        -o "${so_file_path}"
    set +x
}

mvn::generate_resources()
{
    declare source_file_path=
    declare target_file_path=
    declare old_ifs=

    log "Compiling source files to objects" 0
    old_ifs="${IFS}"
    IFS=','; for i in  "${GCC_COMPILE_SPECS[@]}"; do set -- $i;
        source_file_path="${1}"
        target_file_path="${2}"
        log "${source_file_path} to ${target_file_path}" 1
        (
          IFS="${old_ifs}" # We need to do that because g++ depends of the real IFS value
          gcc::compile_object "${source_file_path}" "${target_file_path}"
        )
    done
    IFS="${old_ifs}"

    log "Linking object files to shared library"
    gcc::compile_shared_library \
        "${GENERATED_JAVA_RESOURCES_FOLDER}/libdlib-java.so" \
        $( spec::target_file_paths "${GCC_COMPILE_SPECS[@]}" )
}

main() {
    declare phase="${1}" ; shift
    case "${phase}" in
        "initialize")
                mvn::initialize
            ;;

        "generate-sources")
                mvn::generate_sources
            ;;

        "generate-resources")
                mvn::generate_resources
            ;;
    esac

}
main "${@}"
