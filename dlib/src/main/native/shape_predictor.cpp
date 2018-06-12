#include "shape_predictor.hpp"

#include <opencv2/opencv.hpp>
#include <dlib/image_processing.h>

#include <dlib/opencv/cv_image.h>

#include <dlib/pixel.h>

#include <iostream>

// https://gist.github.com/berak/b23262a9cb08a9d0a6d3

ShapePredictor::ShapePredictor(std::string modelFilePath) {
    dlib::deserialize(modelFilePath) >> this->shape_predictor;
}

std::vector<cv::Point> ShapePredictor::predictShape(cv::Mat mat) {
    dlib::rectangle rectangle(0,0,mat.cols, mat.rows);
    dlib::full_object_detection shape = this->shape_predictor(dlib::cv_image<dlib::bgr_pixel>(mat), rectangle);

    std::vector<cv::Point> landmarks;
    for (int k = 0; k < shape.num_parts(); k++) {
        //std::cout << shape.part(k) << std::endl;
        //std::cout << shape.part(k).x() << std::endl;
        cv::Point landmark(static_cast<double>(shape.part(k).x()), static_cast<double>(shape.part(k).y()));
        landmarks.push_back(landmark);
    }
    return landmarks;
}