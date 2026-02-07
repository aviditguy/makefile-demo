#include <stdio.h>

void show_bytes(unsigned char *ptr, size_t len) {
  for (int i = 0; i < len; i++)
    printf(" %.2x", ptr[i]);
  printf("\n");
}

void show_int(int x) { show_bytes((unsigned char *)&x, sizeof(int)); }

int main(void) {
  int ival = 10;
  show_int(ival);

  return 0;
}
