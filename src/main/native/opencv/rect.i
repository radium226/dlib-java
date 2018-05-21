%{
  #include <opencv2/opencv.hpp>
  #include <iostream>
%}

%typemap(jstype) cv::Rect, const cv::Rect& "org.opencv.core.Rect"

%typemap(jtype) cv::Rect, const cv::Rect& "org.opencv.core.Rect"

%typemap(jni) cv::Rect, const cv::Rect& "jobject"

%typemap(in) cv::Rect {
    jclass cv_rect_class = JCALL1(GetObjectClass, jenv, $input);
    jfieldID cv_rect_x = JCALL3(GetFieldID, jenv, cv_rect_class, "x", "D");
    int x = JCALL2(GetIntField, jenv, $input, cv_rect_x);
    jfieldID cv_rect_y = JCALL3(GetFieldID, jenv, cv_rect_class, "y", "D");
    int y = JCALL2(GetIntField, jenv, $input, cv_rect_y);
    jfieldID cv_rect_width = JCALL3(GetFieldID, jenv, cv_rect_class, "width", "D");
    int width = JCALL2(GetIntField, jenv, $input, cv_rect_width);
    jfieldID cv_rect_height = JCALL3(GetFieldID, jenv, cv_rect_class, "height", "D");
    int height = JCALL2(GetIntField, jenv, $input, cv_rect_height);
    $1 = cv::Rect(x, y, width, height);
}

%typemap(javain) cv::Rect, const cv::Rect& "$javainput"

%typemap(out) cv::Rect {
    jclass cv_rect_class = jenv->FindClass("org/opencv/core/Rect");
    jmethodID cv_rect_init = jenv->GetMethodID(cv_rect_class, "<init>", "(IIII)V");
    $result = JCALL6(NewObject, jenv, cv_rect_class, cv_rect_init, $1.x, $1.y, $1.width, $1.height);
}

%typemap(out) const cv::Rect& {
    jclass cv_rect_class = jenv->FindClass("org/opencv/core/Rect");
    jmethodID cv_rect_init = jenv->GetMethodID(cv_rect_class, "<init>", "(IIII)V");
    cv::Rect *r = $1;
    $result = JCALL6(NewObject, jenv, cv_rect_class, cv_rect_init, $1->x, $1->y, $1->width, $1->height);
}

%typemap(javaout) cv::Rect, const cv::Rect& {
    return $jnicall;
}