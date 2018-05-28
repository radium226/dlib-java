#ifndef FACE_DETECTOR_HPP
#define FACE_DETECTOR_HPP

#include <opencv2/opencv.hpp>
#include <dlib/image_processing.h>
#include <dlib/image_processing/frontal_face_detector.h>

class FaceDetector {

public:
    FaceDetector();
    std::vector<cv::Rect> detectFaces(cv::Mat mat);


private:
    dlib::frontal_face_detector frontal_face_detector;
};

#endif