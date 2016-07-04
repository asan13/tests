#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

const char* my_strstr(const char *where, const char *what) {
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

MODULE = StrLib           PACKAGE = StrLib

SV*
x_strstr(SV *where, SV *what)
    CODE:
    if (where == &PL_sv_undef || what == &PL_sv_undef) 
        XSRETURN_UNDEF;

    if (!SvPOK(where) || !SvPOK(what))
        croak("only string arguments allowed");

    SvGETMAGIC(where);
    SvGETMAGIC(what);

    const char *str = my_strstr(SvPV_nolen(where), SvPV_nolen(what));
    HV *hv = newHV();
    if (str) {
        hv_store(hv, "status", 6, newSVpv("ok", 2), 0);
        hv_store(hv, "found", 5, newSVpv(str, strlen(str)), 0);
        hv_store(hv, "source", 6, newSVsv(where), 0);
    }
    else {
        hv_store(hv, "status", 6, newSVpv("fail", 0), 0);
    }
    RETVAL = newRV_noinc((SV*)hv);
    OUTPUT:
    RETVAL

