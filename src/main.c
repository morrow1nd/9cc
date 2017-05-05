#include "base.h"
#include "util.h"
#include "y.tab.h"


extern FILE * yyin;
extern FILE * yyout;

int yyparse(void);

void usage(const char* program_path, int ret)
{
    printf(
        "%s [options] [code file]\n"
        "    -o filepath    specifiy output file path and name\n"
        "    --full         generates execable program\n"
        "\n"/* debug usage */
        "    --parser_info  output parser info\n"
        "\n"
        "    -v --version   print version info\n"
        "    -h             this help info\n"
        , program_path);
    exit(ret);
}

int main(int argc, char * argv[])
{
    /* init global variable */
    line_number = 1;
    /* init config */
    cc_get_config()->dump_parser_info = false;
    cc_get_config()->parser_info_fp = stdout;
    
    /* handle argvs */
    UT_array *code_files;
    utarray_new(code_files, &ut_ptr_icd);
    bool argv_full = false;
    const char* output_path = "a.out";
    int i = 1;
    for(; i < argc; ++i){
        if(strcmp("--full", argv[i]) == 0){
            argv_full = true;
        }else if(strcmp("-o", argv[i]) == 0){
            output_path = argv[++i];
        }else if(strcmp("-v", argv[i]) == 0 || strcmp("--version", argv[i]) == 0){
            printf("9cc: %s\n", version());
            exit(0);
        }else if(strcmp("-h", argv[i]) == 0 || strcmp("--help", argv[i]) == 0){
            usage(argv[0], 0);
        }else if(strcmp("--parser_info", argv[i]) == 0){
            cc_get_config()->dump_parser_info = true;
            cc_get_config()->parser_info_fp = stdout;
        }else{
            utarray_push_back(code_files, &argv[i]);
        }
    }

    if (utarray_len(code_files) <= 0)
        usage(argv[0], -2);

    const char** filepathp = (const char**)utarray_front(code_files);
    for (; filepathp != NULL; filepathp = (const char**)utarray_next(code_files, filepathp)) {
#if CC_DEBUG
        printf("handle code file: %s !\n", *filepathp);
#endif
        if (argv_full) {
            /* TODO: call gcc to handle macros */
        }
        /* compile to AT&T ASM code */
        File fp = cc_file_open(*filepathp, "r");
        yyin = fp;
        yyout = stderr;
        /* yyout = NULL; */
        yyparse();
    }
    if (argv_full) {
        /* TODO: call gcc to generate obj and the final execable program */
    }

    utarray_free(code_files);
    return 0;
/*    debug_tag = 0;
    lineno = 1;
    if(argc != 3){
            usage(argv[0]);
            fputs("pass any key to exit", stderr);
            getchar();
            return 0;
    }
    FILE * fp = fopen(argv[1], "rb");
    if(fp == NULL){
        fprintf(stderr, "can't open file:%s\npass any key to exit", argv[1]);
        ;
        return -1;
    }
    FILE * fpout = fopen(argv[2], "wb");
    if(fpout == NULL){
        fprintf(stderr, "can't open file:%s\npass any key to exit", argv[2]);
        ;
        return -1;
    }
    yyin = fp;
    yyout = fpout;

    // init
    var_size = 0;
    int i = 0;
    while(i < MAX_VAR_LEN){
        vars[i] = NULL;
        i++;
    }*/
}
