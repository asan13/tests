#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "my_strstr.h"

int main(int argc, char **argv) {

    if (argc < 3) {
        printf("usage: ./test10 where what [iters] [1 (my)|2 (stdlib)]\n");
        exit(1);
    }

    if (argc < 4) {
        const char *str = my_strstr(argv[1], argv[2]);
        printf("%s\n", str ? str : "NULL");
        exit(0);
    }

   int iters = strtol(argv[3], NULL, 10);
   if (!iters) {
       printf("invalid iter: %s\n", argv[3]);
       exit(1);
   }

   const char *res;
   if (*argv[4] == '1') {
       for (int i = 0; i < iters; ++i) {
           res = my_strstr(argv[1], argv[2]);
       }
   }
   else {
       for (int i = 0; i < iters; ++i) {
           res = strstr(argv[1], argv[2]);
       }
   }
   printf("res %s\n", res);

   return 0;
}

