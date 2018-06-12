#ifndef SHAPE_PREDICTOR_HPP
#define SHAPE_PREDICTOR_HPP

#include <opencv2/opencv.hpp>
#include <dlib/image_processing.h>

class ShapePredictor {

public:
    ShapePredictor(std::string modelFilePath);
    std::vector<cv::Point> predictShape(cv::Mat mat);


private:
    dlib::shape_predictor shape_predictor;
};

#endif