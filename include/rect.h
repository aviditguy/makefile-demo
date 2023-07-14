#ifndef RECT_HEADER_H
#define RECT_HEADER_H

#include "../include/point.h"

typedef struct Rect Rect;

Rect *rect_create(Point *point, double width, double height);
void rect_destroy(Rect *rect);
double rect_area(Rect *rect);
double rect_perimeter(Rect *rect);

#endif  // RECT_HEADER_H