package com.github.radium226.dlib;

import tw.edu.sju.ee.commons.nativeutils.NativeUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class DLib {

    public static boolean loadLibraryFromTargetFolder() {
        Path libraryFilePath = Paths.get(System.getProperty("user.dir"), "target/generated-resources/swig/libdlib-java.so");
        if (Files.exists(libraryFilePath)) {
            System.load(libraryFilePath.toString());
            return true;
        } else {
            return false;
        }
    }

    public static void loadLibrary() {
        System.loadLibrary("dlib");
        if (loadLibraryFromTargetFolder()) {

        } else if (loadLibraryFromJarFile()) {

        } else {
            throw new UnsatisfiedLinkError("dlib-java");
        }
    }

    public static Path unzipLibrary() throws IOException {
        InputStream inputStream = DLib.class.getClassLoader().getResourceAsStream("libdlib-java.so");
        Path temporaryFolderPath = Files.createTempDirectory("dlib-java");
        Path libraryFilePath = temporaryFolderPath.resolve("libdlib-java.so");
        Files.copy(inputStream, libraryFilePath);
        return libraryFilePath;
    }

    public static boolean loadLibraryFromJarFile() {
        try {
            Path libraryFilePath = unzipLibrary();
            System.out.println(libraryFilePath);
            System.load(libraryFilePath.toString());
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    static {
        loadLibrary();
    }

    public static void main( String[] args ) {
        System.out.println(Base64.encode("coucou"));
    }

}
