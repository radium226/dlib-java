#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstdlib>
//#include <dlib/compress_stream.h>
#include <dlib/base64.h>
#include "swig_api.h"

using namespace std;
using namespace dlib;

#ifdef SWIG
%include "std_string.i"
%include "std_vector.i"
#endif

std::string Base64::encode(const std::string& input_text) {
  base64 encoder;

  istringstream input_text_stream(input_text);
  ostringstream output_text_stream;
  encoder.encode(input_text_stream, output_text_stream);

  return output_text_streamg.str();
}
