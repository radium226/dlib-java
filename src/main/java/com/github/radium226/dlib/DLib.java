package com.github.radium226.dlib;

import tw.edu.sju.ee.commons.nativeutils.NativeUtils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class DLib {

    public static Path unzipLibrary() throws IOException {
        InputStream inputStream = DLib.class.getClassLoader().getResourceAsStream("libdlib-java.so");
        Path temporaryFolderPath = Files.createTempDirectory("dlib-java");
        Path libraryFilePath = temporaryFolderPath.resolve("libdlib-java.so");
        Files.copy(inputStream, libraryFilePath);
        return libraryFilePath;
    }

    static {
        try {
            Path libraryFilePath = unzipLibrary();
            System.out.println(libraryFilePath);
            System.load(libraryFilePath.toString());
        } catch (IOException e) {
            e.printStackTrace(System.err);
            throw new UnsatisfiedLinkError("libdlib-java");
        }
    }

    public static void main( String[] args ) {
        System.out.println(Base64.encode("coucou"));
    }

}
