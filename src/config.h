#ifndef __CONFIG__H_
#define __CONFIG__H_

#include <stdio.h>
#include "base.h"


/* output debug info */
#define CC_DEBUG 1
#define CC_PRINT_MALLOC_INFO 0
#define CC_MALLOC_STATISTICS 0


typedef struct cc_config {
    bool dump_parser_info;
    FILE* parser_info_fp;

} cc_config;

/* global configure struct */
cc_config* cc_get_config();


#endif