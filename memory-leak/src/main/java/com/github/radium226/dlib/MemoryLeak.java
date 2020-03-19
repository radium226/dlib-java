package com.github.radium226.dlib;

import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Size;

import java.lang.ref.Cleaner;
import java.util.stream.IntStream;

public class MemoryLeak {

    private static Cleaner CLEANER = Cleaner.create();

    public static void main(String[] arguments) throws Throwable {
        System.load("/usr/lib/libopencv_java420.so");
        Size size = new Size(800, 600);
        IntStream.range(0, 5000).forEach(index -> {
            Mat mat = Mat.ones(size, CvType.CV_8UC3);
            System.out.println(mat.size());
            mat.delete();
        });
    }

}