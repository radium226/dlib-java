%{
  #include <opencv2/opencv.hpp>
%}

%typemap(jstype) cv::Point, const cv::Point& "org.opencv.core.Point"

%typemap(jtype) cv::Point, const cv::Point& "org.opencv.core.Point"

%typemap(jni) cv::Point, const cv::Point& "jobject"

%typemap(in) cv::Point {
    jclass cv_point_class = JCALL1(GetObjectClass, jenv, $input);
    jfieldID cv_point_x = JCALL3(GetFieldID, jenv, cv_point_class, "x", "D");
    jfieldID cv_point_y = JCALL3(GetFieldID, jenv, cv_point_class, "y", "D");
    double x = JCALL2(GetDoubleField, jenv, $input, cv_point_x);
    std::cout << "x=" << x << std::endl;
    double y = JCALL2(GetDoubleField, jenv, $input, cv_point_y);
    $1 = cv::Point(x, y);
}

%typemap(javain) cv::Point, const cv::Point& "$javainput"

%typemap(out) cv::Point {
    jclass cv_point_class = jenv->FindClass("org/opencv/core/Point");
    jmethodID cv_point_init = jenv->GetMethodID(cv_point_class, "<init>", "(DD)V");
    $result = JCALL4(NewObject, jenv, cv_point_class, cv_point_init, $1.x, $1.y);
}

%typemap(out) const cv::Point& {
    jclass cv_point_class = jenv->FindClass("org/opencv/core/Point");
    jmethodID cv_point_init = jenv->GetMethodID(cv_point_class, "<init>", "(DD)V");

    double x = $1->x;
    double y = $1->y;

    //std::cout << "x=" << x << std::endl;
    //std::cout << "y=" << y << std::endl;
    $result = JCALL4(NewObject, jenv, cv_point_class, cv_point_init, x, y);
}

%typemap(javaout) cv::Point, const cv::Point& {
    return $jnicall;
}