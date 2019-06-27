package com.github.radium226.dlib;

import com.github.radium226.opencv.OpenCV;
import com.github.radium266.dlib.swig.FaceDescriptorComputer;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.opencv.core.*;
import org.opencv.highgui.HighGui;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

@Ignore
public class FaceDescriptorComputerTest {

    private static FaceDescriptorComputer FACE_DESCRIPTOR_COMPUTER = null;
    private static CascadeClassifier FRONTAL_FACE_CASCADE_CLASSIFIER = null;

    @BeforeClass
    public static void setUp() {
        DLib.loadLibraries();
        OpenCV.loadLibraries();

        System.out.println("Loading models... ");
        FACE_DESCRIPTOR_COMPUTER = new FaceDescriptorComputer("/home/adrien/Personal/Projects/dlib-java/src/test/resources/shape_predictor_68_face_landmarks.dat", "/home/adrien/Personal/Projects/dlib-java/src/test/resources/dlib_face_recognition_resnet_model_v1.dat");
        FRONTAL_FACE_CASCADE_CLASSIFIER = new CascadeClassifier("/usr/share/opencv/haarcascades/haarcascade_frontalface_default.xml");;
        System.out.println("Done! ");
    }

    @Test
    public void testComputeFaceDescriptor() {
        System.out.println("Learning known faces... ");
        Map<String, Mat> knownFaces = learnKnownFaces(Paths.get("/home/adrien/Personal/Projects/dlib-java/src/test/resources/known-faces"));
        System.out.println("knownFaces=" + knownFaces);
        System.out.println("Done! ");

        System.out.println("Recognizing unknown faces... ");
        listFiles(Paths.get("/home/adrien/Personal/Projects/dlib-java/src/test/resources/unknown-faces"))
            .forEach(filePath -> {
                Mat faceDescriptor = computeFaceDescriptor(filePath);

                System.out.println(faceDescriptor.height() + "x" + faceDescriptor.width() + "x" + faceDescriptor.channels());
                System.out.println(toString(faceDescriptor));
                Map.Entry<String, Double> entry = recognizeFace(knownFaces, faceDescriptor);
                System.out.println(filePath.getFileName().toString() + " is " + entry.getKey() + " (" + entry.getValue() + ")");
            });
        System.out.println("Done! ");
    }

    public static void showMat(Mat mat) {
        HighGui.namedWindow("Mat", HighGui.WINDOW_AUTOSIZE);
        HighGui.imshow("Mat", mat);
        HighGui.waitKey();
    }

    public static void drawRect(Mat mat, Rect rect, Scalar scalar) {
        Imgproc.rectangle(mat, new Point(rect.x, rect.y), new Point(rect.x + rect.width, rect.y + rect.height), scalar);
    }

    public static void drawPoints(Mat mat, List<Point> points, Scalar scalar) {
        points.forEach(point -> Imgproc.circle(mat, point, 2, scalar));
    }

    public static Rect detectFace(Mat image) {
        MatOfRect matOfRects = new MatOfRect();
        FRONTAL_FACE_CASCADE_CLASSIFIER.detectMultiScale(image, matOfRects);
        List<Rect> rects = matOfRects.toList();
        rects.sort(Comparator.comparingInt(rect -> - rect.height * rect.width));
        if (rects.size() < 1) throw new IllegalArgumentException("There is either no face or multiple faces on this image");
        return rects.get(0);
    }

    public List<Point> translateIn(Rect rect, List<Point> points) {
        return points.stream().map(point -> new Point(point.x + rect.x, point.y + rect.y)).collect(Collectors.toList());
    }

    public static Map.Entry<String, Double> recognizeFace(Map<String, Mat> recognizedFaceDescriptors, Mat faceDescriptorToRecognize) {
        Map<String, Double> normByRecognizedFace = recognizedFaceDescriptors.entrySet().stream().collect(Collectors.toMap(Map.Entry::getKey, entry -> Core.norm(entry.getValue(), faceDescriptorToRecognize)));
        System.out.println(normByRecognizedFace);
        return Collections.min(normByRecognizedFace.entrySet(), Comparator.comparingDouble(Map.Entry::getValue));
    }

    public static Mat computeFaceDescriptor(Path filePath) {
        Mat image = openImage(filePath);
        Rect faceBoudaries = detectFace(image);
        Mat faceDescriptor = FACE_DESCRIPTOR_COMPUTER.computeFaceDescriptor(image.submat(faceBoudaries));
        return faceDescriptor;
    }

    public static Map<String, Mat> learnKnownFaces(Path folderPath) {
        return listFiles(folderPath)
            .collect(Collectors.toMap(filePath -> filePath.getFileName().toString(), FaceDescriptorComputerTest::computeFaceDescriptor));
    }

    public static Mat openImage(Path filePath) {
        return Imgcodecs.imread(filePath.toString(), Imgcodecs.IMREAD_COLOR);
    }

    public static Stream<Path> listFiles(Path folderPath) {
        try {
            return StreamSupport
                    .stream(Spliterators.spliteratorUnknownSize(Files.newDirectoryStream(folderPath).iterator(), Spliterator.ORDERED), false)
                    .filter(Files::isRegularFile);
        } catch (IOException e) {
            e.printStackTrace();
            return Stream.empty();
        }
    }

    public static String toString(Mat mat) {
        //double[] offsets = new double[128];
        //mat.get(0, 0, offsets);
        return Arrays.toString(mat.get(0, 0));
    }
}
