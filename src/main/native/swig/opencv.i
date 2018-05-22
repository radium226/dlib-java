%include vector.i

%include opencv/mat.i
%include opencv/point.i
%template(PointList) std::vector<cv::Point>;
%include opencv/rect.i
%template(RectList) std::vector<cv::Rect>;