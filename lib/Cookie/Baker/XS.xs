#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#include "ppport.h"

static SV *
url_decode_val(pTHX_ const char *src, int start, int end) {
    int dlen = 0, i = 0;
    char *d;
    char s2, s3;
    SV * dst;
    dst = newSV(0);
    (void)SvUPGRADE(dst, SVt_PV);
    d = SvGROW(dst, (end - start) * 3 + 1);

    for (i = start; i < end; i++ ) {
        if ( src[i] == '%' && isxdigit(src[i+1]) && isxdigit(src[i+2]) ) {
            s2 = src[i+1];
            s3 = src[i+2];
            s2 -= s2 <= '9' ? '0'
                : s2 <= 'F' ? 'A' - 10
                            : 'a' - 10;
            s3 -= s3 <= '9' ? '0'
                : s3 <= 'F' ? 'A' - 10
                            : 'a' - 10;
            d[dlen++] = s2 * 16 + s3;
            i += 2;
        }
        else {
            d[dlen++] = src[i];
        }
    }

    SvCUR_set(dst, dlen);
    SvPOK_only(dst);
    return dst;
}

static
void
url_decode_key(const char *src, int src_len, char *d, int *key_len) {
    int i, dlen=0;
    char s2, s3;
    for (i = 0; i < src_len; i++ ) {
        if ( src[i] == '%' && isxdigit(src[i+1]) && isxdigit(src[i+2]) ) {
            s2 = src[i+1];
            s3 = src[i+2];
            s2 -= s2 <= '9' ? '0'
                : s2 <= 'F' ? 'A' - 10
                            : 'a' - 10;
            s3 -= s3 <= '9' ? '0'
                : s3 <= 'F' ? 'A' - 10
                            : 'a' - 10;
            d[dlen++] = s2 * 16 + s3;
            i += 2;
        }
        else {
            d[dlen++] = src[i];
        }
    }
    *key_len = dlen;
}

static
void
renewmem(pTHX_ const char *d, int *cur, const int req) {
    if ( req > *cur ) {
        *cur = req;
        Renew(d, *cur, char);
    }
}

MODULE = Cookie::Baker::XS    PACKAGE = Cookie::Baker::XS

PROTOTYPES: DISABLE

void
crush_cookie(cookie)
    SV *cookie
  PREINIT:
    char *src, *prev, *p, *key;
    int i, prev_s=0, la, key_len, key_size = 256;
    STRLEN src_len;
    HV *hv;
  PPCODE:
    hv = newHV();
    ST(0) = sv_2mortal(newRV_noinc((SV *)hv));

    if ( SvOK(cookie) ) {
        Newx(key, key_size, char);

        src = (char *)SvPV(cookie,src_len);
        prev = src;
        for ( i=0; i<src_len; i++ ) {
            if ( src[i] == ';' || src[i] == ',') {
                while ( prev[0] == ' ' ) {
                    prev++;
                    prev_s++;
                }
                la = i - prev_s;
                while ( prev[la-1] == ' ' ) {
                    --la;
                }
                p = memchr(prev, '=', i - prev_s);
                if ( p != NULL ) {
                    renewmem(aTHX_ key, &key_size, (p - prev)*3+1);
                    url_decode_key(prev, p - prev, key, &key_len);
                    if ( !hv_exists(hv, key, key_len) ) {
                        (void)hv_store(hv, key, key_len,
                            url_decode_val(aTHX_ prev, p - prev + 1, la ), 0);
                    }
                }
                prev = &src[i+1];
                prev_s = i + 1;
            }
        }

        if ( i > prev_s ) {
            if ( prev[0] == ' ' ) {
                prev++;
                prev_s++;
            }
            la = i - prev_s;
            while ( prev[la-1] == ' ' ) {
                --la;
            }
            p = memchr(prev, '=', i - prev_s);
            if ( p != NULL ) {
                renewmem(aTHX_ key, &key_size, (p - prev)*3+1);
                url_decode_key(prev, p - prev, key, &key_len);
                if ( !hv_exists(hv, key, key_len) ) {
                    (void)hv_store(hv, key, key_len,
                        url_decode_val(aTHX_ prev, p - prev + 1, la ), 0);
                }
            }
        }

        Safefree(key);
    }
    XSRETURN(1);