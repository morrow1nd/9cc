#include <stdio.h>
#include <stdlib.h> 
#include "config.h"
#include "base.h"


cc_config* cc_get_config()
{
    static cc_config _config = {
        .dump_parser_info = false,
        .parser_info_fp = NULL
    };

    return &_config;
}