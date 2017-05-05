#ifndef __SYNTAX_NODE__H_
#define __SYNTAX_NODE__H_

#include "base.h"


typedef struct syntax_node{
    int type;
    int line_number;
    char* str;
    int str_len;

    struct syntax_node* next;
} syntax_node;

syntax_node* create_syntax_node(int type);
syntax_node* create_syntax_node_s(int type, const char* str);


#endif