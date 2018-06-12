%module DLib

namespace dlib {


}

%pragma(java) jniclassimports=%{
import com.github.radium226.commons.Libraries;
import java.util.Arrays;
%}

%pragma(java) jniclasscode=%{
    static {
        com.github.radium226.dlib.DLib.loadLibraries();
    }
%}

%include dlib/shape_predictor.i
%include dlib/face_detector.i
%include dlib/face_descriptor_computer.i