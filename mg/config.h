/* This file generated automatically by configure.  */

#include "common.h"
#if defined(__linux__) || defined(__CYGWIN__)
#include "linux.h"
#elif defined(__APPLE__)
#include "apple.h"
#elif defined(__FreeBSD__)
#include "freebsd.h"
#elif defined(__NetBSD__)
#include "netbsd.h"
#elif defined(__DragonFly__)
#include "dragonfly.h"
#endif

//extern char *fparseln(FILE *, size_t *, size_t *, const char[3], int);
//#define HAVE_FSTATAT
//#define HAVE_FUTIMENS
#define HAVE_GETLINE
//#define HAVE_REALLOCARRAY
extern size_t strlcat(char *, const char *, size_t);
extern size_t strlcpy(char *, const char *, size_t);
#define HAVE_STRNDUP
extern long long strtonum(const char *, long long, long long, const char **);
#define REGEX

#define __unused
