#ifndef EXAMPLE_HPP
#define EXAMPLE_HPP

// http://www.swig.org/Doc3.0/Java.html

#ifdef SWIG
%apply (char *STRING, int LENGTH) { (char *imageData, int imageDataLength) }
#endif


using byte = unsigned char;

class Example {

public:
    static void drawCircle(int imageHeight, int imageWidth, char *imageData, int imageDataLength);

};

#endif