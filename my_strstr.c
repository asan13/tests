#include "my_strstr.h"

const char *my_strstr(const char *where, const char *what) {
    const char *s;

    if (!where || !what)  return NULL;
    if (!*what)  return where;

    s = what;
    while (*where) {
        if (*where == *s) {
            while (*where && *where == *s) {
                ++where;
                ++s;
            }
            if (!*s)
                return where - (s - what);
            else {
                where -= s - what - 1;
                s = what;
            }
        }
        else 
            ++where;
    }

    return NULL;
}

