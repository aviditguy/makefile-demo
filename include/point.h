#ifndef POINT_HEADER_H
#define POINT_HEADER_H

typedef struct Point Point;

Point *point_create(double x, double y);
void point_destroy(Point *point);

#endif  // POINT_HEADER_H
