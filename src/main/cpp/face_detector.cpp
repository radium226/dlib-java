#include <dlib/geometry/rectangle.h>
#include <dlib/array2d.h>
#include <dlib/pixel.h>

#include "face_detector.hpp"

using namespace dlib;
using namespace std;

#ifdef SWIG
%include "std_vector.i"
#endif

std::vector<rectangle> FaceDetector::detect_faces(array2d<rgb_pixel> image) {
    return {};
}