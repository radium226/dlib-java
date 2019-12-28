# dlib-java
Java wrapper for the DLib library

## Layout
### Overview
There is 3 projects:
* `resources`: it provided the `Resource` abstraction which is used in order to load files (either from a JAR or from files)
* `models`: it contains `DLibModels` and `OpenCVModels` which can be used in order to use models for these two libraries (some are embeded into the assembled JAR, some should be located on the filesystem)
* `dlib`: it's the actual wrapper

### The `dlib` project
It's recommended [using SWIG](http://blog.dlib.net/2014/10/mitie-v03-released-now-with-java-and-r.html?m=1) in order to make binding (at least in Java).

In the `src/main/native` folder, you'll find:
* The `include` folder which contains the `.h` headers of the `.cpp` C++ files
* The `swig` folder which contains the `.i` interfaces
* The `.cpp` files which contains  

## Requirements
### Overview
Building the `dlib-java` wrapper is quite simple (because it's driven by Maven), but there is some requirements which need to be fulfilled. 

You'll need to install: 
* OpenCV; 
* DLib; 
* And a few utilities (`make`, `gcc`, `swig` and `wget`). 

### OpenCV
Once OpenCV has been installed on you're system, we need to make the `JAR` availabled to Maven by running:

```
mvn install:install-file \
    -Dfile=/usr/share/java/opencv4/opencv-420.jar" \
    -DgroupId="opencv" \
    -DartifactId="opencv" \
    -Dversion="4.2.0" \
    -Dpackaging="jar"
```

We also should ensure that: 
* The `/usr/lib/libopencv_java420.so` shared libary is present;
* The  `/usr/include/opencv4` includes are presents. 

### DLib
Once installed, you should ensure that:
* The `/usr/lib/libdlib.so` shared library is present;
* The `/usr/include/dlib` includes are presents. 