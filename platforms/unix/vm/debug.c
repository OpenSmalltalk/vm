#include "debug.h"
#include "sq.h"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

void __sq_DPRINTF(const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  vprintf(fmt, ap);
  va_end(ap);
}

void __sq_assert(char *file, int line, char *func, char *expr)
{
  __sq_errfile= file;
  __sq_errline= line;
  __sq_errfunc= func;
  __sq_eprintf("assertion failed: %s\n", expr);
  abort();
}

char *__sq_errfile;
int   __sq_errline;
char *__sq_errfunc;

void __sq_eprintf(const char *fmt, ...)
{
  va_list ap;
  char *file= strrchr(__sq_errfile, '/');
  file= file ? file + 1 : __sq_errfile;
  va_start(ap, fmt);
  fprintf(VM_ERR(), "%s(%d): %s:\n", file, __sq_errline, __sq_errfunc);
  fprintf(VM_ERR(), "%s(%d): ", file, __sq_errline);
  vfprintf(VM_ERR(), fmt, ap);
  va_end(ap);
}


void sqDebugAnchor(void)
{
}

static FILE *VM_ERR_FILE = NULL;

FILE *VM_ERR(void)
{
	if (!VM_ERR_FILE) {
		VM_ERR_FILE = stderr;
	}
	return VM_ERR_FILE;
}
