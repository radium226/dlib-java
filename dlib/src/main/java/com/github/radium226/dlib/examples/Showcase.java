package com.github.radium226.dlib.examples;

import org.opencv.core.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.opencv.highgui.HighGui;
import org.opencv.imgproc.Imgproc;

import com.github.radium226.dlib.DLib;

public class Showcase {

    public static void main(String[] arguments) throws Throwable {
        DLib.loadLibraries();
        System.out.println(arguments[0]);
        Mat mat = openMatUsingImageIO(Paths.get(arguments[0]));

        com.github.radium266.dlib.swig.Showcase.drawCircleImageUsingOpenCVInCpp(50,  50, 25, 255, 0,   0,   mat);
        com.github.radium266.dlib.swig.Showcase.drawCircleImageUsingDLibInCpp(  100, 50, 25, 0,   255, 0,   mat);

        drawCircleUsingOpenCVInJava(             150, 50, 25, 0,   0,   255, mat);

        displayImageUsingOpenCVInJava(mat);
        com.github.radium266.dlib.swig.Showcase.displayImageUsingOpenCVInCpp(mat);
        com.github.radium266.dlib.swig.Showcase.displayImageUsingDLibInCpp(mat);
    }

    public static void drawCircleUsingOpenCVInJava(int x, int y, int radius, int red, int green, int blue, Mat mat) {
        Point center = new Point(x, y);
        Scalar color = new Scalar(red, green, blue);

        Imgproc.circle(mat, center, radius, color, 1);
    }

    public static void displayImageUsingOpenCVInJava(Mat mat) {
        HighGui.namedWindow("Lena", HighGui.WINDOW_AUTOSIZE);
        HighGui.imshow("Lena", mat);
        HighGui.waitKey();
    }

    public static Mat openMatUsingImageIO(Path imagePath) throws IOException {
        BufferedImage rawImage = ImageIO.read(imagePath.toFile());
        BufferedImage convertedImage = new BufferedImage(rawImage.getWidth(), rawImage.getHeight(), BufferedImage.TYPE_3BYTE_BGR);
        convertedImage.getGraphics().drawImage(rawImage, 0, 0, null);

        int height = convertedImage.getHeight();
        int width = convertedImage.getWidth();

        Mat mat = new Mat(height, width, CvType.CV_8UC3);
        mat.put(0, 0, ((DataBufferByte) convertedImage.getData().getDataBuffer()).getData());

        return mat;
    }

}
