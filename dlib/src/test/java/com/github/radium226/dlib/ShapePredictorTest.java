package com.github.radium226.dlib;

import com.github.radium226.dlib.examples.Showcase;
import com.github.radium226.io.Resource;
import com.github.radium226.opencv.OpenCVModels;
import com.github.radium266.dlib.swig.ShapePredictor;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

@Ignore
public class ShapePredictorTest {

    @BeforeClass
    public static void beforeAll() {
        DLib.loadLibraries();
    }

    public ShapePredictorTest() {
        super();
    }

    public List<Rect> detectFaces(Mat mat) throws IOException {
        Path haarCascadeFilePath = OpenCVModels.HAAR_CASCADE_FRONTAL_FACE.getPath();
        CascadeClassifier cascadeClassifier = new CascadeClassifier(haarCascadeFilePath.toString());
        MatOfRect rects = new MatOfRect();
        cascadeClassifier.detectMultiScale(mat, rects);
        return rects.toList();
    }

    public void drawMakers(Mat mat, List<Point> points) {
        points.forEach(point -> Imgproc.drawMarker(mat, point, new Scalar(255, 0, 0)));

    }

    @Test
    public void testPredictShapeWithLena() throws IOException {
        Mat lenaMat = Showcase.openMatUsingImageIO(Resource.byName("lena.jpg").getPath());
        List<Rect> faceBounds = detectFaces(lenaMat);
        Assert.assertEquals(1, faceBounds.size());
        Rect faceBound = faceBounds.get(0);
        Mat lenaFaceMat = lenaMat.submat(faceBound);

        //Imgproc.rectangle(lenaMat, new Point(faceBound.x, faceBound.y), new Point(faceBound.x + faceBound.width, faceBound.y + faceBound.height), new Scalar(255, 255, 255));
        //Swig.displayImageUsingOpenCVInJava(lenaMat);

        Path shapePredictorModelFilePath = DLibModels.SHAPE_PREDICTOR_68_FACE_LANDMARKS.getPath();
        ShapePredictor shapePredictor = new ShapePredictor(shapePredictorModelFilePath.toString());
        List<Point> landmarks = shapePredictor.predictShape(lenaFaceMat);
        for (Point landmark : landmarks) {
            System.out.println(landmark);
        }

        drawMakers(lenaFaceMat, landmarks);
        Showcase.displayImageUsingOpenCVInJava(lenaFaceMat);

    }

}
