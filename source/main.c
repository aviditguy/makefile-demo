#include <math.h>
#include <stdio.h>

#include "../include/point.h"
#include "../include/rect.h"

int main(void) {
  Point *point = point_create(10, 14);
  Rect *rect = rect_create(point, 23, 33.98);

  printf("area: %lf\n", rect_area(rect));
  printf("perimeter: %lf\n", rect_perimeter(rect));
  printf("area_square: %lf\n", pow(rect_area(rect), 2));

  rect_destroy(rect);

  return 0;
}
