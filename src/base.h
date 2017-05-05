#ifndef __BASE__H_
#define __BASE__H_

#include <stdio.h> /* printf  */
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define bool char
#define false 0
#define true 1


extern const char* program_name;
extern int line_number;


const char* version();


void cc_info(const char* format, ...);
void cc_warn(const char* format, ...);
void cc_error(const char* format, ...);
void cc_fatal(int exit_num, const char* format, ...);


#include "config.h"

#endif