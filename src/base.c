#include "base.h"


#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"


const char* program_name = "9cc";
int line_number;


const char* version()
{
    return "version 0.1";
}


void cc_info(const char* format, ...)
{
    fprintf(stdout,
        ANSI_COLOR_CYAN "info: " ANSI_COLOR_RESET);

    va_list args;
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
}

void cc_warn(const char* format, ...)
{
    fprintf(stdout,
        ANSI_COLOR_YELLOW "warnning: " ANSI_COLOR_RESET);

    va_list args;
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
}

void cc_error(const char* format, ...)
{
    fflush(stdout);
    fprintf(stderr,
        ANSI_COLOR_RED "error: " ANSI_COLOR_RESET);

    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
}

void cc_fatal(int exit_num, const char* format, ...)
{
    fflush(stdout);
    fprintf(stderr,
        ANSI_COLOR_RESET "%s: " ANSI_COLOR_RED "fatal error: " ANSI_COLOR_RESET,
        program_name);

    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);

    exit(exit_num);
}