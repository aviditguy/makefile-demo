#include "../include/rect.h"

#include <stdlib.h>

struct Rect {
  Point *point;
  double width;
  double height;
};

Rect *rect_create(Point *point, double width, double height) {
  Rect *rect = (Rect *)malloc(sizeof(Rect));
  rect->width = width;
  rect->height = height;
  rect->point = point;
  return rect;
}

void rect_destroy(Rect *rect) {
  if (rect) {
    point_destroy(rect->point);
    free(rect);
  }
}

double rect_area(Rect *rect) { return rect->width * rect->height; }

double rect_perimeter(Rect *rect) { return 2 * (rect->width + rect->height); }
