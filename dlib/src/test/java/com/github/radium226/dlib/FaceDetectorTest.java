package com.github.radium226.dlib;

import com.github.radium226.io.Resource;
import com.github.radium226.opencv.OpenCV;
import com.github.radium266.dlib.swig.FaceDescriptorComputer;
import com.github.radium266.dlib.swig.FaceDetector;
import org.junit.BeforeClass;
import org.junit.Test;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.highgui.HighGui;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;

import java.io.IOException;
import java.nio.file.Path;

public class FaceDetectorTest {

    private static FaceDetector FACE_DETECTOR = null;

    @BeforeClass
    public static void setUp() throws IOException {
        DLib.loadLibraries();
        OpenCV.loadLibraries();

        FACE_DETECTOR = new FaceDetector();
    }

    @Test
    public void testFaceDetector() throws IOException {
        Path groupImageFilePath = Resource.byName("group.jpg").getPath();
        Mat mat = Imgcodecs.imread(groupImageFilePath.toString(), Imgcodecs.IMREAD_COLOR);
        Mat resizedMat = new Mat();
        Imgproc.resize(mat, resizedMat, new Size(mat.width(), mat.height()));

        //HighGui.namedWindow("group.jpg", HighGui.WINDOW_AUTOSIZE);
        //HighGui.imshow("group.jpg", resizedMat);
        //HighGui.waitKey();

        System.out.println("Detecting...");
        FACE_DETECTOR.detectFaces(resizedMat).forEach(rect -> System.out.println(rect));
        System.out.println("---");
        FACE_DETECTOR.detectFaces(resizedMat).forEach(rect -> System.out.println(rect));
        System.out.println("Detected! ");


    }

}
