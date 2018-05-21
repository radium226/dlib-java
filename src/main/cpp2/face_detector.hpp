#include <dlib/geometry/rectangle.h>
#include <dlib/array2d.h>
#include <dlib/pixel.h>

#ifdef SWIG
%include "std_string.i"
%include "std_vector.i"

%apply(jobject) { dlib::array2d<dlib::rgb_pixel> }
%apply(jobject) { std::vector<dlib::rectangle> }

%typemap(in) dlib::array2d<dlib::rgb_pixel> {
    // TYPEMAP IN jobject -> dlib::array2d<dlib::rgb_pixel>
    // $1 = NULL;
}

%typemap(out) std::vector<dlib::rectangle> {
    // TYPEMAP OUT std::vector<dlib::rectangle> -> jobject
    $result = NULL;
}
#endif

class FaceDetector {

public:
  std::vector<dlib::rectangle> detect_faces(dlib::array2d<dlib::rgb_pixel> image);

};