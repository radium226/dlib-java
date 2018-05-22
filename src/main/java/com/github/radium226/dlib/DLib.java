package com.github.radium226.dlib;

import com.github.radium226.commons.Libraries;

import java.util.Arrays;

public class DLib {

    public static void loadLibraries() {
        for (String libraryName : Arrays.asList("dlib", "dlib-java", "opencv_java341")) {
            Libraries.loadLibrary(libraryName);
        }
    }
}
