#include <string>

#ifdef SWIG
%include "std_string.i"
%include "std_vector.i"
#endif

class Base64 {

public:
  static std::string encode(const std::string& input_text);
};