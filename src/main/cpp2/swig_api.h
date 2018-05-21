#ifndef DLIB_SWIG_API_H_
#define DLIB_SWIG_API_H_

#ifdef SWIG
%{
#include "base64.hpp"
#include "rectangle_builder.hpp"
%}

%include "base64.hpp"
%include "rectangle_builder.hpp"

#endif

#endif // DLIB_SWIG_API_H_
