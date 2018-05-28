#include "face_detector.hpp"

#include <opencv2/opencv.hpp>
#include <dlib/image_processing.h>
#include <dlib/image_processing/frontal_face_detector.h>

#include <dlib/opencv/cv_image.h>

#include <dlib/pixel.h>

#include <iostream>

// https://gist.github.com/berak/b23262a9cb08a9d0a6d3

FaceDetector::FaceDetector() {
    this->frontal_face_detector = dlib::get_frontal_face_detector();
}

std::vector<cv::Rect> FaceDetector::detectFaces(cv::Mat mat) {
    std::vector<dlib::rectangle> dlib_rectangles = this->frontal_face_detector(dlib::cv_image<dlib::bgr_pixel>(mat));
    std::vector<cv::Rect> cv_rects;
    for(auto const& dlib_rectangle: dlib_rectangles) {
        cv::Rect cv_rect = cv::Rect(
            dlib_rectangle.left(),
            dlib_rectangle.top(),
            dlib_rectangle.width(),
            dlib_rectangle.height()
        );
        cv_rects.push_back(cv_rect);
    }
    return cv_rects;
}