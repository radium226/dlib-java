#include "rectangle_builder.hpp"

#include <dlib/geometry/rectangle.h>

dlib::rectangle RectangleBuilder::buildRectangle(int x, int y, int width, int height) {
    dlib::rectangle rectangle(x, y, x + width, y + height);
    return rectangle;
}