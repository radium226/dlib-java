%typemap(jni) dlib::rectangle "jobject"
%typemap(jtype) dlib::rectangle "java.awt.Rectangle"
%typemap(jstype) dlib::rectangle "java.awt.Rectangle"
%typemap(javaout) dlib::rectangle {
    return $jnicall;
}
%typemap(out) dlib::rectangle {
    jclass rectangle_class = jenv->FindClass("java/awt/Rectangle");
    jmethodID rectangle_constructor = jenv->GetMethodID(rectangle_class, "<init>", "(IIII)V");

    // TYPEMAP OUT dlib::rectangle -> jobject
    $result = jenv->NewObject(rectangle_class, rectangle_constructor, $1.left(), $1.top(), $1.right() - $1.left() , $1.bottom() - $1.top());
}