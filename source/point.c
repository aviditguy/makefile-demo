#include "../include/point.h"

#include <stdlib.h>

struct Point {
  double x;
  double y;
};

Point *point_create(double x, double y) {
  Point *point = (Point *)malloc(sizeof(Point));
  point->x = x;
  point->y = y;
  return point;
}

void point_destroy(Point *point) {
  if (point) free(point);
}