cmake_minimum_required (VERSION 2.8.12)

project (dlib-java)

set(java_package_name com.github.radium226.dlib)
set(source_files base64.cpp)

include_directories(.)

# Additional dependencies
#add_subdirectory(../../dlib dlib_build)

if($ENV{CI})
    include_directories(
        "/tmp/dlib/usr/include"
    )
    link_directories(
        "/tmp/dlib/usr/lib"
    )
endif()

set(additional_link_libraries dlib)


# Tell swig to put the output files (the shared library and .jar) into the local folder.

# Alternatively, instead of using install_target_output_folder, you can tell
# cmake to output the shared library, java source files, and the jar to
# separate output folders.  These commands would put them into folders thelib,
# thesrc, and thejar, respectively.
set(install_shared_library_output_folder ../../../target/generated-resources/swig)
set(install_java_source_output_folder ../../../target/generated-sources/swig)

include(cmake_swig_jni)
