#include <dlib/dnn.h>
#include <dlib/gui_widgets.h>
#include <dlib/clustering.h>
#include <dlib/string.h>
#include <dlib/image_io.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/opencv.h>

#include <iostream>

#include "face_descriptor_computer.hpp" // TODO: We need to move that on top, but before we need to add the proper dlib:: and std:: in it

FaceDescriptorComputer::FaceDescriptorComputer(std::string faceShapePredictorModelFilePath, std::string faceNetworkModelFilePath) {
    dlib::deserialize(faceShapePredictorModelFilePath) >> this->face_shape_predictor;
    dlib::deserialize(faceNetworkModelFilePath) >> this->face_network;
}

std::vector<dlib::matrix<dlib::rgb_pixel>> jitter_image(
    const dlib::matrix<dlib::rgb_pixel>& img
)
{
    // All this function does is make 100 copies of img, all slightly jittered by being
    // zoomed, rotated, and translated a little bit differently. They are also randomly
    // mirrored left to right.
    thread_local dlib::rand rnd;

    std::vector<dlib::matrix<dlib::rgb_pixel>> crops;
    for (int i = 0; i < 100; ++i)
        crops.push_back(dlib::jitter_image(img,rnd));

    return crops;
}

cv::Mat FaceDescriptorComputer::computeFaceDescriptor(cv::Mat faceMatInBGR) {
    cv::Mat face_mat_in_rgb;
    cv::cvtColor(faceMatInBGR, face_mat_in_rgb, cv::COLOR_BGR2RGB);

    dlib::cv_image<dlib::rgb_pixel> face_image(face_mat_in_rgb);
    dlib::rectangle face_rectangle(0, 0, face_mat_in_rgb.cols, face_mat_in_rgb.rows);

    auto face_shape = this->face_shape_predictor(face_image, face_rectangle);
    dlib::matrix<rgb_pixel> face_chip;
    dlib::extract_image_chip(face_image, dlib::get_face_chip_details(face_shape, 150, 0.25), face_chip);

    //dlib::matrix<float,0,1> face_descriptor = dlib::mean(dlib::mat(this->face_network(jitter_image(face_chip))));

    std::vector<matrix<rgb_pixel>> face_chips(1, face_chip);
    std::vector<dlib::matrix<float,0,1>> face_descriptors = this->face_network(face_chips);
    dlib::matrix<float,0,1> face_descriptor = face_descriptors[0];

    //std::cout << dlib::trans(face_descriptor) << std::endl;

    return dlib::toMat(face_descriptor).clone();
}

cv::Mat FaceDescriptorComputer::extractFaceChip(cv::Mat faceMat) {
    dlib::cv_image<dlib::bgr_pixel> face_image(faceMat);
    dlib::rectangle face_rectangle(0, 0, faceMat.cols, faceMat.rows);

    auto face_shape = this->face_shape_predictor(face_image, face_rectangle);
    dlib::matrix<bgr_pixel> face_chip;
    dlib::extract_image_chip(face_image, dlib::get_face_chip_details(face_shape, 150, 0.25), face_chip);

    cv::Mat m = dlib::toMat(face_chip);

    return m.clone();
}
