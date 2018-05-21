#include "rectangle_builder.hpp"

#include <dlib/geometry/rectangle.h>
#include <vector>
#include <string>

dlib::rectangle RectangleBuilder::buildRectangle(int x, int y, int width, int height) {
    dlib::rectangle rectangle(x, y, x + width, y + height);
    return rectangle;
}

std::vector<std::string> RectangleBuilder::buildRectangles(int x, int y, int width, int height, int count) {
    return {};
}