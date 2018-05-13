#ifndef DLIB_SWIG_API_H_
#define DLIB_SWIG_API_H_

#ifdef SWIG
%include "std_string.i"
#endif

#include <string>

class Base64 {

public:
  Base64();

  static std::string encode(const std::string& input_text);
};



#endif // DLIB_SWIG_API_H_
