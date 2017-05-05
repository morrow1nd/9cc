#include "util.h"
#include "base.h"
#include "config.h"


#if CC_PRINT_MALLOC_INFO
int cc_call_cc_malloc_number = 0;
int cc_call_cc_free_number = 0;
#endif
#if CC_MALLOC_STATISTICS
int cc_memory_usage = 0; /* byte */
int cc_memory_max_usage = 0; /* byte */
int cc_memory_malloc_times = 0;
int cc_memory_free_times = 0;
void cc_dump_memory_usage()
{
    printf("=== dump memory usage:\n");
    printf("\tmemory usage: %d bytes\n", cc_memory_usage);
    printf("\tmemory max usage: %d bytes\n", cc_memory_max_usage);
    int sub = cc_memory_malloc_times - cc_memory_free_times;
    if (sub >= 0)
        printf("\tmalloc times:%d, free times:%d. (+%d)\n", cc_memory_malloc_times, cc_memory_free_times, sub);
    else
        printf("\tmalloc times:%d, free times:%d. (%d)\n", cc_memory_malloc_times, cc_memory_free_times, sub);
}
#endif


void * cc_malloc(size_t len)
{
    int * ret = NULL;
#if CC_MALLOC_STATISTICS
    ++cc_memory_malloc_times;
    cc_memory_usage += len;
    if (cc_memory_usage > cc_memory_max_usage)
        cc_memory_max_usage = cc_memory_usage;
    ret = (int*)malloc(len + sizeof(int));
    *ret = len;
    ret = (int*)((char*)ret + sizeof(int));
#else
    ret = (int*)malloc(len);
#endif
#if(CC_PRINT_MALLOC_INFO)
    ++cc_call_cc_malloc_number;
    printf("cc_malloc:%d %p size:%d\n", cc_call_cc_malloc_number, ret, (int)len);
#endif
    return ret;
}
void cc_free(void * ptr)
{
#if(cc_PRINT_MALLOC_INFO)
    ++cc_call_cc_free_number;
    printf("cc_free:%d %p\n", cc_call_cc_free_number, ptr);
#endif
#if cc_MALLOC_STATISTICS
    ++cc_memory_free_times;
    ptr = (char*)ptr - sizeof(int);
    cc_memory_usage -= *((int*)ptr);
#endif
    free(ptr);
}


File cc_file_open(const char* filepath, const char* options)
{
    File fp = fopen(filepath, options);
    if (!fp) {
        cc_fatal(-1, "can't open file%s %s\n", filepath, options);
    }
    return fp;
}
char* cc_file_read_all_fp(File fp, int* filelen)
{
        int ret = -1;
        fseek(fp, 0, SEEK_END);
        int filelength = ftell(fp);

        char* data = (char*)cc_malloc(filelength + 1);
        fseek(fp, 0, SEEK_SET);
        if ((ret = fread(data, 1, filelength, fp)) <= 0) {
            cc_fatal(-1, "can't read file\n");
            return NULL;
        }
        *(data + ret) = '\0';
        *filelen = ret;
        return data;
}
char* cc_file_read_all(const char* filepath, int* filelen)
{
    File fp = cc_file_open(filepath, "r");
    char* ret = cc_file_read_all_fp(fp, filelen);
    cc_file_close(fp);
    return ret;
}
int cc_file_close(File fp)
{
    int ret = fclose(fp);
    if (ret != 0) {
        cc_fatal(-1, "can't close file\n");
    }
    return ret;
}

