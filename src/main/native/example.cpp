#include "example.hpp"

#include <iostream>
#include <sstream>
#include <string>
#include <opencv2/opencv.hpp>

#include <dlib/array2d.h>
#include <dlib/opencv.h>
#include <dlib/pixel.h>
#include <dlib/image_transforms.h>

#include <dlib/gui_widgets.h>
#include <dlib/image_io.h>

using namespace std;

void Example::drawCircle(int imageHeight, int imageWidth, char *imageData, int imageDataLength) {
    ostringstream out;
    cv::Mat imageMat(imageHeight, imageWidth, CV_8UC3);
    imageMat.data = reinterpret_cast<unsigned char *>(imageData); // FIXME Change Swig in order to map directly Java byte array to unsigned char *

    cout << "Hello from C++ \n";

    out << "imageDataLength=" << imageDataLength;
    cout << out.str() << '\n';

    dlib::cv_image<dlib::bgr_pixel> dlibImage(imageMat);

    //dlib::array2d<dlib::bgr_pixel> imageArray2d;
    //dlib::assign_image(imageArray2d, dlibImage);

    dlib::dpoint center(50, 50);
    dlib::bgr_pixel color(255, 255, 255);
    dlib::draw_solid_circle(dlibImage, center, 20, color);

    dlib::image_window window;
    window.clear_overlay();
    window.set_image(dlibImage);

    cv::Point cvPoint(50, 50);
    cv::Scalar cvScalar(255, 0, 0);

    cv::circle(imageMat, cvPoint, 20, cvScalar);

    cout << "Hit enter to process the next image..." << endl;
    cin.get();

    /*
    // Image Show
    cv::imshow("Coucou", imageMat);
    cv::waitKey();
    */

    /*
    // Data Update
    cout << "Updating data... ";
    for (int i = 0; i < imageDataLength; i++) {
        imageData[i] = imageData[i] * imageData[i];
    }
    cout << "Done! \n";
    */
}