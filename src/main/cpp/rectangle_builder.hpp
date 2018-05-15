#include <dlib/geometry/rectangle.h>

// https://stackoverflow.com/questions/4765807/change-swig-wrapper-function-return-value?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
// http://web.mit.edu/svn/src/swig-1.3.25/Examples/java/typemap/example.i
// http://www.swig.org/Doc1.3/Java.html

#ifdef SWIG
%include "dlib_rectangle.i"
#endif

class RectangleBuilder {

public:
  static dlib::rectangle buildRectangle(int x, int y, int width, int height);

};