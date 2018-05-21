%module global

%{
  #include "showcase.hpp"
  #include <opencv2/opencv.hpp>
%}

%typemap(jstype) cv::Mat "org.opencv.core.Mat"
%typemap(javain) cv::Mat "$javainput.getNativeObjAddr()"
%typemap(jtype) cv::Mat "long"
%typemap(jni) cv::Mat "jlong"
%typemap(in) cv::Mat {
    $1 = **(cv::Mat **)&$input;
}
%typemap(javaout) cv::Mat {
    return new org.opencv.core.Mat($jnicall);
}

%include "showcase.hpp"