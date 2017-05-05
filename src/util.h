#ifndef __UTIL__H_
#define __UTIL__H_

#include "config.h"
#include <stdio.h>


/* hash map */
#include "uthash/src/uthash.h"
/* dynamic array */
#include "uthash/src/utarray.h"

/* memory allocator */
#if CC_PRINT_MALLOC_INFO
extern int cc_call_cc_malloc_number;
extern int cc_call_cc_free_number;
#endif
#if CC_MALLOC_STATISTICS
extern int cc_memory_usage; /* byte */
extern int cc_memory_max_usage;
extern int cc_memory_malloc_times;
extern int cc_memory_free_times;
void cc_dump_memory_usage();
#endif
void * cc_malloc(size_t len);
void cc_free(void * ptr);



/* file operations */
typedef FILE* File;
File cc_file_open(const char* filepath, const char* options);
char* cc_file_read_all_fp(File fp, int* filelen);
char* cc_file_read_all(const char* filepath, int* filelen);
int cc_file_close(File fp);


#endif