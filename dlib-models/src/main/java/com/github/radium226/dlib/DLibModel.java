package com.github.radium226.dlib;

import java.io.IOException;
import java.nio.file.*;
import java.util.Objects;

final public class DLibModel {

    final public static DLibModel SHAPE_PREDICTOR_68_FACE_LANDMARKS = new DLibModel("shape_predictor_68_face_landmarks.dat");
    final public static DLibModel SHAPE_PREDICTOR_5_FACE_LANDMARKS = new DLibModel("shape_predictor_5_face_landmarks.dat");
    final public static DLibModel DLIB_FACE_RECOGNITION_RESNET_MODEL_V1 = new DLibModel("dlib_face_recognition_resnet_model_v1.dat");

    private String resourceName;

    private DLibModel(String resourceName) {
        super();

        this.resourceName = resourceName;
    }

    public Path extract() throws IOException {
        Path tempFolderPath = tempFolderPath().resolve(getClass().getSimpleName());
        if (!Files.exists(tempFolderPath)) {
            Files.createDirectories(tempFolderPath);
        }

        Path extractedFilePath = tempFolderPath.resolve(resourceName);
        if (!Files.exists(extractedFilePath)) {
            Files.copy(getClass().getClassLoader().getResourceAsStream(resourceName), extractedFilePath);
        }

        return extractedFilePath;
    }

    public static Path tempFolderPath() {
        return Paths.get(System.getProperty("java.io.tmpdir"));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DLibModel dLibModel = (DLibModel) o;
        return Objects.equals(resourceName, dLibModel.resourceName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(resourceName);
    }

    @Override
    public String toString() {
        return "DLibModel(resourceName='" + resourceName + "')";
    }
}
