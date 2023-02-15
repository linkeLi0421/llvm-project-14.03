// clang++ -fsanitize=dumb test.cpp -o test
// DBSAN_OPTIONS='print_frequent_access=1' ./test

#include <stdio.h>
int main(int argc, char **argv) {
  int r = 0;
  int i = 1;
  printf("address of `r` is %p\n", &r);
  printf("address of `i` is %p\n", &i);
  for (; i < 2; ++i) {
    r++;
  }
  return i + r;
}