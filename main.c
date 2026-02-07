#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum { BINARY = 2, OCTAL = 8, DECIMAL = 10, HEX = 16 } Base;

static const char *INT_HEX = "0123456789ABCDEF";

static const char *OCT_BIN[] = {"000", "001", "010", "011",
                                "100", "101", "110", "111"};

static const char *HEX_BIN[] = {"0000", "0001", "0010", "0011", "0100", "0101",
                                "0110", "0111", "1000", "1001", "1010", "1011",
                                "1100", "1101", "1110", "1111"};

int hex_to_int(char c) { return (c >= 'A') ? 10 + c - 'A' : c - '0'; }

void trim_leading_zeros(char *str) {
  size_t n = strlen(str);
  int k = 0;
  while (str[k] && str[k] == '0')
    k++;
  if (!str[k] || str[k] == '.')
    k--;
  if (str[0] == '.') {
    memmove(str + 1, str, n + 1);
    str[0] = '0';
  } else {
    memmove(str, str + k, n - k + 1);
  }

  const char *pidx = strchr(str, '.');
  if (pidx) {
    k = strlen(str) - 1;
    while (k > 0 && str[k] == '0')
      k--;
    if (str[k] == '.')
      k--;
    str[k + 1] = '\0';
  }
}

int get_pindex(const char *str, size_t len) {
  const char *point = strchr(str, '.');
  return ((point) ? (point - str) : len) - 1;
}

void base_to_decimal(const char *str, size_t len, char *output, Base base) {
  int pidx = get_pindex(str, len);
  double num = 0.0;
  for (int i = 0; i < len; i++) {
    if (str[i] == '.')
      continue;
    num += (hex_to_int(str[i]) * pow(base, pidx--));
  }
  sprintf(output, "%.2lf", num);
}

void binary_to_oct_hex(const char *bin, size_t len, char *output, Base base) {
  int idx = get_pindex(bin, len);
  int group = (base == OCTAL) ? 3 : 4;
  int start = idx % group;
  int pos = 0, k = 0;

  while (pos < len) {
    if (bin[pos] == '.') {
      output[k++] = bin[pos++];
      start = group - 1;
    }

    int d = 0;
    while (start >= 0 && pos < len)
      d += (bin[pos++] - '0') * pow(2, start--);
    output[k++] = INT_HEX[d];

    start = group - 1;
  }
  output[k] = '\0';
  trim_leading_zeros(output);
}

void oct_hex_to_binary(const char *str, size_t len, char *output, Base base) {
  int k = 0;
  int pad = (base == OCTAL) ? 3 : 4;
  for (int i = 0; i < len; i++) {
    if (str[i] == '.') {
      output[k++] = str[i];
      continue;
    }

    if (base == OCTAL)
      strcpy(output + k, OCT_BIN[hex_to_int(str[i])]);
    else
      strcpy(output + k, HEX_BIN[hex_to_int(str[i])]);
    k += pad;
  }
  output[k] = '\0';
  trim_leading_zeros(output);
}

void Decimal(const char *decimal, char *output, Base base) {
  double num = atof(decimal);
  int whole = (int)num;
  double frac = num - whole;

  int k = (whole > 0) ? ceil(log(whole) / log(base)) : 1;
  output[k--] = '\0';
  while (k >= 0) {
    output[k--] = INT_HEX[whole % base];
    whole /= base;
  }

  if (frac > 0.0) {
    k = strlen(output);
    int places = 8;

    output[k++] = '.';
    while (frac > 0.0 && places-- > 0) {
      frac *= base;
      output[k++] = INT_HEX[(int)frac];
      frac -= (int)frac;
    }
    output[k] = '\0';
  }
  trim_leading_zeros(output);
}

void Binary(const char *bin, char *output, Base base) {
  size_t len = strlen(bin);
  if (base == DECIMAL)
    base_to_decimal(bin, len, output, BINARY);
  else
    binary_to_oct_hex(bin, len, output, base);
}

void Octal(const char *oct, char *output, Base base) {
  size_t len = strlen(oct);
  if (base == DECIMAL)
    base_to_decimal(oct, len, output, OCTAL);
  else {
    oct_hex_to_binary(oct, len, output, OCTAL);
    if (base == HEX)
      binary_to_oct_hex(output, strlen(output), output, HEX);
  }
}

void Hex(const char *hex, char *output, Base base) {
  size_t len = strlen(hex);
  if (base == DECIMAL)
    base_to_decimal(hex, len, output, HEX);
  else {
    oct_hex_to_binary(hex, len, output, HEX);
    if (base == OCTAL)
      binary_to_oct_hex(output, strlen(output), output, OCTAL);
  }
}

int main(void) {
  char output[100];

  Decimal("100.36", output, BINARY);
  printf("%s\n", output);

  Decimal("100.36", output, OCTAL);
  printf("%s\n", output);

  Decimal("100.36", output, HEX);
  printf("%s\n", output);

  Binary("1100100.01011100", output, DECIMAL);
  printf("%s\n", output);

  Binary("1100100.01011100", output, OCTAL);
  printf("%s\n", output);

  Binary("1100100.01011100", output, HEX);
  printf("%s\n", output);

  Octal("144.270", output, DECIMAL);
  printf("%s\n", output);

  Octal("144.270", output, BINARY);
  printf("%s\n", output);

  Octal("144.270", output, HEX);
  printf("%s\n", output);

  Hex("64.5C", output, DECIMAL);
  printf("%s\n", output);

  Hex("64.5C", output, BINARY);
  printf("%s\n", output);

  Hex("64.5C", output, OCTAL);
  printf("%s\n", output);
  
  return 0;
}
