#ifndef SHOWCASE_HPP
#define SHOWCASE_HPP

#include <opencv2/opencv.hpp>
#include <vector>

class Showcase {

public:
    static void displayImageUsingOpenCVInCpp(cv::Mat mat);
    static void displayImageUsingDLibInCpp(cv::Mat mat);

    static void drawCircleImageUsingOpenCVInCpp(int x, int y, int radius, int red, int green, int blue, cv::Mat mat);
    static void drawCircleImageUsingDLibInCpp(int x, int y, int radius, int red, int green, int blue, cv::Mat mat);

    static cv::Point returnPoint(double x, double y);

    static cv::Rect returnRect(cv::Point topRight, cv::Point bottomLeft);

    static std::vector<cv::Rect> returnRects();
};

#endif