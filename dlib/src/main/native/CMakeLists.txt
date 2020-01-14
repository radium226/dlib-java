cmake_minimum_required(VERSION 2.8.12)
project(dlib-java)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(JAVA_PACKAGE "com.github.radium266.dlib.swig")
set(CMAKE_SWIG_OUTDIR com/github/radium226/dlib/swig)

# DLib
include(FetchContent)
FetchContent_Declare(dlib
    GIT_REPOSITORY https://github.com/davisking/dlib.git
    GIT_TAG        master
)
FetchContent_MakeAvailable(dlib)

# OpenCV
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

# JNI
find_package(JNI REQUIRED)
include_directories(${JNI_INCLUDE_DIRS})
string(REPLACE "jawt" "awt_headless" JNI_HEADLESS_LIBRARIES "${JNI_LIBRARIES}")

# Swig
find_package(SWIG REQUIRED)
include(UseSWIG)
set(UseSWIG_TARGET_NAME_PREFERENCE STANDARD)

include_directories("include")
include_directories("swig")
set(CMAKE_SWIG_FLAGS -package "${JAVA_PACKAGE}" -I-)
string(REPLACE "." "/" CMAKE_SWIG_OUTDIR "generated-sources/${JAVA_PACKAGE}")

set_property(SOURCE "swig/dlib.i" PROPERTY CPLUSPLUS ON)
set_property(SOURCE "swig/dlib.i" PROPERTY SWIG_MODULE_NAME "dlib_wrap")
set_property(SOURCE "swig/showcase.i" PROPERTY CPLUSPLUS ON)
set_property(SOURCE "swig/showcase.i" PROPERTY SWIG_MODULE_NAME "showcase_wrap")
swig_add_library(wrap
    TYPE STATIC
    LANGUAGE java
    SOURCES "swig/dlib.i" "swig/showcase.i"
    OUTFILE_DIR "."
)

# Compile
include_directories("include")
include_directories("swig_include")
add_library(dlib-java SHARED
    "face_descriptor_computer.cpp"
    "face_detector.cpp"
    "shape_predictor.cpp"
    "showcase.cpp"
)

set_property(TARGET dlib-java PROPERTY
    LIBRARY_OUTPUT_DIRECTORY "generated-resources"
)

target_link_libraries(dlib-java
    "-Wl,--whole-archive"
    wrap
    "-Wl,--no-whole-archive"
    ${OpenCV_LIBRARIES}
    ${JNI_HEADLESS_LIBRARIES}
    dlib::dlib
)
