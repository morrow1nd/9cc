%{
#define YYPARSER
/* #define YYSTYPE var_t * */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "base.h"
#include "config.h"


extern FILE * yyin;
extern FILE * yyout;
extern char * yytext;
extern int yyleng;
extern int yylex();

extern int column;

void yyerror(char* s);

static void info(const char* format, ...);

%}


%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit


%%

primary_expression
    : IDENTIFIER                                                { info("primary_expression ->\n\t\t\t\n\t\t\t IDENTIFIER"); }
    | CONSTANT                                                  { info("primary_expression ->\n\t\t\t\n\t\t\t CONSTANT"); }
    | STRING_LITERAL                                            { info("primary_expression ->\n\t\t\t\n\t\t\t STRING_LITERAL"); }
    | '(' expression ')'                                        { info("primary_expression ->\n\t\t\t\n\t\t\t ( expression )"); }
    ;

postfix_expression
    : primary_expression                                        { info("postfix_expression ->\n\t\t\t primary_expression"); }
    | postfix_expression '[' expression ']'                     { info("postfix_expression ->\n\t\t\t postfix_expression [ expression ]"); }
    | postfix_expression '(' ')'                                { info("postfix_expression ->\n\t\t\t postfix_expression ( )"); }
    | postfix_expression '(' argument_expression_list ')'       { info("postfix_expression ->\n\t\t\t postfix_expression ( argument_expression_list )"); }
    | postfix_expression '.' IDENTIFIER                         { info("postfix_expression ->\n\t\t\t postfix_expression . IDENTIFIER"); }
    | postfix_expression PTR_OP IDENTIFIER                      { info("postfix_expression ->\n\t\t\t postfix_expression PTR_OP IDENTIFIER"); }
    | postfix_expression INC_OP                                 { info("postfix_expression ->\n\t\t\t postfix_expression INC_OP"); }
    | postfix_expression DEC_OP                                 { info("postfix_expression ->\n\t\t\t postfix_expression DEC_OP"); }
    ;

argument_expression_list
    : assignment_expression                                     { info("argument_expression_list ->\n\t\t\t assignment_expression"); }
    | argument_expression_list ',' assignment_expression        { info("argument_expression_list ->\n\t\t\t argument_expression_list , assignment_expression"); }
    ;

unary_expression
    : postfix_expression                                        { info("unary_expression ->\n\t\t\t postfix_expression"); }
    | INC_OP unary_expression                                   { info("unary_expression ->\n\t\t\t INC_OP unary_expression"); }
    | DEC_OP unary_expression                                   { info("unary_expression ->\n\t\t\t DEC_OP unary_expression"); }
    | unary_operator cast_expression                            { info("unary_expression ->\n\t\t\t unary_operator cast_expression"); }
    | SIZEOF unary_expression                                   { info("unary_expression ->\n\t\t\t SIZEOF unary_expression"); }
    | SIZEOF '(' type_name ')'                                  { info("unary_expression ->\n\t\t\t SIZEOF ( type_name )"); }
    ;

unary_operator
    : '&'                                                       { info("unary_operator ->\n\t\t\t &"); }
    | '*'                                                       { info("unary_operator ->\n\t\t\t *"); }
    | '+'                                                       { info("unary_operator ->\n\t\t\t +"); }
    | '-'                                                       { info("unary_operator ->\n\t\t\t -"); }
    | '~'                                                       { info("unary_operator ->\n\t\t\t ~"); }
    | '!'                                                       { info("unary_operator ->\n\t\t\t !"); }
    ;

cast_expression
    : unary_expression                                          { info("cast_expression ->\n\t\t\t unary_expression"); }
    | '(' type_name ')' cast_expression                         { info("cast_expression ->\n\t\t\t ( type_name ) cast_expression"); }
    ;

multiplicative_expression
    : cast_expression                                           { info("multiplicative_expression ->\n\t\t\t cast_expression"); }
    | multiplicative_expression '*' cast_expression             { info("multiplicative_expression ->\n\t\t\t multiplicative_expression * cast_expression"); }
    | multiplicative_expression '/' cast_expression             { info("multiplicative_expression ->\n\t\t\t multiplicative_expression / cast_expression"); }
    | multiplicative_expression '%' cast_expression             { info("multiplicative_expression ->\n\t\t\t multiplicative_expression \% cast_expression"); }
    ;

additive_expression
    : multiplicative_expression                                 { info("additive_expression ->\n\t\t\t multiplicative_expression"); }
    | additive_expression '+' multiplicative_expression         { info("additive_expression ->\n\t\t\t additive_expression + multiplicative_expression"); }
    | additive_expression '-' multiplicative_expression         { info("additive_expression ->\n\t\t\t additive_expression - multiplicative_expression"); }
    ;

shift_expression
    : additive_expression                                       { info("shift_expression ->\n\t\t\t additive_expression"); }
    | shift_expression LEFT_OP additive_expression              { info("shift_expression ->\n\t\t\t shift_expression LEFT_OP additive_expression"); }
    | shift_expression RIGHT_OP additive_expression             { info("shift_expression ->\n\t\t\t shift_expression RIGHT_OP additive_expression"); }
    ;

relational_expression
    : shift_expression                                          { info("relational_expression ->\n\t\t\t shift_expression"); }
    | relational_expression '<' shift_expression                { info("relational_expression ->\n\t\t\t relational_expression < shift_expression"); }
    | relational_expression '>' shift_expression                { info("relational_expression ->\n\t\t\t relational_expression > shift_expression"); }
    | relational_expression LE_OP shift_expression              { info("relational_expression ->\n\t\t\t relational_expression LE_OP shift_expression"); }
    | relational_expression GE_OP shift_expression              { info("relational_expression ->\n\t\t\t relational_expression GE_OP shift_expression"); }
    ;

equality_expression
    : relational_expression                                     { info("equality_expression ->\n\t\t\t relational_expression"); }
    | equality_expression EQ_OP relational_expression           { info("equality_expression ->\n\t\t\t equality_expression EQ_OP relational_expression"); }
    | equality_expression NE_OP relational_expression           { info("equality_expression ->\n\t\t\t equality_expression NE_OP relational_expression"); }
    ;

and_expression
    : equality_expression                                       { info("and_expression ->\n\t\t\t equality_expression"); }
    | and_expression '&' equality_expression                    { info("and_expression & equality_expression"); }
    ;

exclusive_or_expression
    : and_expression                                            { info("exclusive_or_expression ->\n\t\t\t and_expression"); }
    | exclusive_or_expression '^' and_expression                { info("exclusive_or_expression ->\n\t\t\t exclusive_or_expression ^ and_expression"); }
    ;

inclusive_or_expression
    : exclusive_or_expression                                   { info("inclusive_or_expression ->\n\t\t\t exclusive_or_expression"); }
    | inclusive_or_expression '|' exclusive_or_expression       { info("inclusive_or_expression ->\n\t\t\t inclusive_or_expression | exclusive_or_expression"); }
    ;

logical_and_expression
    : inclusive_or_expression                                   { info("logical_and_expression ->\n\t\t\t inclusive_or_expression"); }
    | logical_and_expression AND_OP inclusive_or_expression     { info("logical_and_expression ->\n\t\t\t logical_and_expression AND_OP inclusive_or_expression"); }
    ;

logical_or_expression
    : logical_and_expression                                    { info("logical_or_expression ->\n\t\t\t logical_and_expression"); }
    | logical_or_expression OR_OP logical_and_expression        { info("logical_or_expression ->\n\t\t\t logical_or_expression OR_OP logical_and_expression"); }
    ;

conditional_expression
    : logical_or_expression                                             { info("conditional_expression ->\n\t\t\t logical_or_expression"); }
    | logical_or_expression '?' expression ':' conditional_expression   { info("conditional_expression ->\n\t\t\t logical_or_expression ? expression : conditional_expression"); }
    ;

assignment_expression
    : conditional_expression                                            { info("assignment_expression ->\n\t\t\t conditional_expression"); }
    | unary_expression assignment_operator assignment_expression        { info("assignment_expression ->\n\t\t\t unary_expression assignment_operator assignment_expression"); }
    ;

assignment_operator
    : '='                                                       { info("assignment_operator ->\n\t\t\t ="); }
    | MUL_ASSIGN                                                { info("assignment_operator ->\n\t\t\t MUL_ASSIGN"); }
    | DIV_ASSIGN                                                { info("assignment_operator ->\n\t\t\t DIV_ASSIGN"); }
    | MOD_ASSIGN                                                { info("assignment_operator ->\n\t\t\t MOD_ASSIGN"); }
    | ADD_ASSIGN                                                { info("assignment_operator ->\n\t\t\t ADD_ASSIGN"); }
    | SUB_ASSIGN                                                { info("assignment_operator ->\n\t\t\t SUB_ASSIGN"); }
    | LEFT_ASSIGN                                               { info("assignment_operator ->\n\t\t\t LEFT_ASSIGN"); }
    | RIGHT_ASSIGN                                              { info("assignment_operator ->\n\t\t\t RIGHT_ASSIGN"); }
    | AND_ASSIGN                                                { info("assignment_operator ->\n\t\t\t AND_ASSIGN"); }
    | XOR_ASSIGN                                                { info("assignment_operator ->\n\t\t\t XOR_ASSIGN"); }
    | OR_ASSIGN                                                 { info("assignment_operator ->\n\t\t\t OR_ASSIGN"); }
    ;

expression
    : assignment_expression                                     { info("expression ->\n\t\t\t assignment_expression"); }
    | expression ',' assignment_expression                      { info("expression ->\n\t\t\t expression , assignment_expression"); }
    ;

constant_expression
    : conditional_expression                                    { info("constant_expression ->\n\t\t\t conditional_expression"); }
    ;

declaration
    : declaration_specifiers ';'                                { info("declaration ->\n\t\t\t declaration_specifiers ;"); }
    | declaration_specifiers init_declarator_list ';'           { info("declaration ->\n\t\t\t declaration_specifiers init_declarator_list ;"); }
    ;

declaration_specifiers
    : storage_class_specifier                                   { info("declaration_specifiers ->\n\t\t\t storage_class_specifier"); }
    | storage_class_specifier declaration_specifiers            { info("declaration_specifiers ->\n\t\t\t storage_class_specifier declaration_specifiers"); }
    | type_specifier                                            { info("declaration_specifiers ->\n\t\t\t type_specifier"); }
    | type_specifier declaration_specifiers                     { info("declaration_specifiers ->\n\t\t\t type_specifier declaration_specifiers"); }
    | type_qualifier                                            { info("declaration_specifiers ->\n\t\t\t type_qualifier"); }
    | type_qualifier declaration_specifiers                     { info("declaration_specifiers ->\n\t\t\t type_qualifier declaration_specifiers"); }
    ;

init_declarator_list
    : init_declarator                                           { info("init_declarator_list ->\n\t\t\t init_declarator"); }
    | init_declarator_list ',' init_declarator                  { info("init_declarator_list , init_declarator"); }
    ;

init_declarator
    : declarator                                                { info("init_declarator ->\n\t\t\t declarator"); }
    | declarator '=' initializer                                { info("init_declarator ->\n\t\t\t declarator = initializer"); }
    ;

storage_class_specifier
    : TYPEDEF                                                   { info("storage_class_specifier ->\n\t\t\t TYPEDEF"); }
    | EXTERN                                                    { info("storage_class_specifier ->\n\t\t\t EXTERN"); }
    | STATIC                                                    { info("storage_class_specifier ->\n\t\t\t STATIC"); }
    | AUTO                                                      { info("storage_class_specifier ->\n\t\t\t AUTO"); }
    | REGISTER                                                  { info("storage_class_specifier ->\n\t\t\t REGISTER"); }
    ;

type_specifier
    : VOID                                                      { info("type_specifier ->\n\t\t\t VOID"); }
    | CHAR                                                      { info("type_specifier ->\n\t\t\t CHAR"); }
    | SHORT                                                     { info("type_specifier ->\n\t\t\t SHORT"); }
    | INT                                                       { info("type_specifier ->\n\t\t\t INT"); }
    | LONG                                                      { info("type_specifier ->\n\t\t\t LONG"); }
    | FLOAT                                                     { info("type_specifier ->\n\t\t\t FLOAT"); }
    | DOUBLE                                                    { info("type_specifier ->\n\t\t\t DOUBLE"); }
    | SIGNED                                                    { info("type_specifier ->\n\t\t\t SIGNED"); }
    | UNSIGNED                                                  { info("type_specifier ->\n\t\t\t UNSIGNED"); }
    | struct_or_union_specifier                                 { info("type_specifier ->\n\t\t\t struct_or_union_specifier"); }
    | enum_specifier                                            { info("type_specifier ->\n\t\t\t enum_specifier"); }
    | TYPE_NAME                                                 { info("type_specifier ->\n\t\t\t TYPE_NAME"); }
    ;

struct_or_union_specifier
    : struct_or_union IDENTIFIER '{' struct_declaration_list '}'    { info("struct_or_union_specifier ->\n\t\t\t struct_or_union IDENTIFIER { struct_declarator_list }"); }
    | struct_or_union '{' struct_declaration_list '}'               { info("struct_or_union_specifier ->\n\t\t\t struct_or_union { struct_declaration }"); }
    | struct_or_union IDENTIFIER                                    { info("struct_or_union_specifier ->\n\t\t\t struct_or_union IDENTIFIER"); }
    ;

struct_or_union
    : STRUCT                                                    { info("struct_or_union ->\n\t\t\t STRUCT"); }
    | UNION                                                     { info("struct_or_union ->\n\t\t\t UNION"); }
    ;

struct_declaration_list
    : struct_declaration                                        { info("struct_declaration_list ->\n\t\t\t struct_declaration"); }
    | struct_declaration_list struct_declaration                { info("struct_declaration_list ->\n\t\t\t struct_declaration_list struct_declaration"); }
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list ';'       { info("struct_declaration ->\n\t\t\t specifier_qualifier_list struct_declarator_list ;"); }
    ;

specifier_qualifier_list
    : type_specifier specifier_qualifier_list                   { info("specifier_qualifier_list ->\n\t\t\t type_specifier specifier_qualifier_list"); }
    | type_specifier                                            { info("specifier_qualifier_list ->\n\t\t\t type_specifier"); }
    | type_qualifier specifier_qualifier_list                   { info("specifier_qualifier_list ->\n\t\t\t type_qualifier specifier_qualifier_list"); }
    | type_qualifier                                            { info("specifier_qualifier_list ->\n\t\t\t type_qualifier"); }
    ;

struct_declarator_list
    : struct_declarator                                         { info("struct_declarator_list ->\n\t\t\t struct_declarator"); }
    | struct_declarator_list ',' struct_declarator              { info("struct_declarator_list ->\n\t\t\t struct_declarator_list , struct_declarator"); }
    ;

struct_declarator
    : declarator                                                { info("struct_declarator ->\n\t\t\t declarator"); }
    | ':' constant_expression                                   { info("struct_declarator ->\n\t\t\t : constant_expression"); }
    | declarator ':' constant_expression                        { info("struct_declarator ->\n\t\t\t declarator : constant_expression"); }
    ;

enum_specifier
    : ENUM '{' enumerator_list '}'                              { info("enum_specifier ->\n\t\t\t ENUM { enumerator_list }"); }
    | ENUM IDENTIFIER '{' enumerator_list '}'                   { info("enum_specifier ->\n\t\t\t ENUM IDENTIFIER { enumerator_list }"); }
    | ENUM IDENTIFIER                                           { info("enum_specifier ->\n\t\t\t ENUM IDENTIFIER"); }
    ;

enumerator_list
    : enumerator                                                { info("enumerator_list ->\n\t\t\t enumerator"); }
    | enumerator_list ',' enumerator                            { info("enumerator_list ->\n\t\t\t enumerator_list , enumerator"); }
    ;

enumerator
    : IDENTIFIER                                                { info("enumerator ->\n\t\t\t IDENTIFIER"); }
    | IDENTIFIER '=' constant_expression                        { info("enumerator ->\n\t\t\t IDENTIFIER = constant_expression"); }
    ;

type_qualifier
    : CONST                                                     { info("type_qualifier ->\n\t\t\t CONST"); }
    | VOLATILE                                                  { info("type_qualifier ->\n\t\t\t VOLATILE"); }
    ;

declarator
    : pointer direct_declarator                                 { info("declarator ->\n\t\t\t pointer direct_declarator"); }
    | direct_declarator                                         { info("declarator ->\n\t\t\t direct_declarator"); }
    ;

direct_declarator
    : IDENTIFIER                                                { info("direct_declarator ->\n\t\t\t IDENTIFIER"); }
    | '(' declarator ')'                                        { info("direct_declarator ->\n\t\t\t ( declarator )"); }
    | direct_declarator '[' constant_expression ']'             { info("direct_declarator ->\n\t\t\t direct_declarator [ constant_expression ]"); }
    | direct_declarator '[' ']'                                 { info("direct_declarator ->\n\t\t\t direct_declarator [ ]"); }
    | direct_declarator '(' parameter_type_list ')'             { info("direct_declarator ->\n\t\t\t direct_declarator ( parameter_type_list )"); }
    | direct_declarator '(' identifier_list ')'                 { info("direct_declarator ->\n\t\t\t direct_declarator ( identifier_list )"); }
    | direct_declarator '(' ')'                                 { info("direct_declarator ->\n\t\t\t ( )"); }
    ;

pointer
    : '*'                                                       { info("pointer ->\n\t\t\t *"); }
    | '*' type_qualifier_list                                   { info("pointer ->\n\t\t\t * type_qualifier_list"); }
    | '*' pointer                                               { info("pointer ->\n\t\t\t * pointer"); }
    | '*' type_qualifier_list pointer                           { info("pointer ->\n\t\t\t * type_qualifier_list pointer"); }
    ;

type_qualifier_list
    : type_qualifier                                            { info("type_qualifier_list ->\n\t\t\t type_qualifier"); }
    | type_qualifier_list type_qualifier                        { info("type_qualifier_list ->\n\t\t\t type_qualifier_list type_qualifier"); }
    ;


parameter_type_list
    : parameter_list                                            { info("parameter_type_list ->\n\t\t\t parameter_list"); }
    | parameter_list ',' ELLIPSIS                               { info("parameter_type_list ->\n\t\t\t parameter_list , ELLIPSIS"); }
    ;

parameter_list
    : parameter_declaration                                     { info("parameter_list ->\n\t\t\t parameter_declaration"); }
    | parameter_list ',' parameter_declaration                  { info("parameter_list ->\n\t\t\t parameter_list , parameter_declaration"); }
    ;

parameter_declaration
    : declaration_specifiers declarator                         { info("parameter_declaration ->\n\t\t\t declaration_specifiers declarator"); }
    | declaration_specifiers abstract_declarator                { info("parameter_declaration ->\n\t\t\t declaration_specifiers abstract_declarator"); }
    | declaration_specifiers                                    { info("parameter_declaration ->\n\t\t\t declaration_specifiers"); }
    ;

identifier_list
    : IDENTIFIER                                                { info("identifier_list ->\n\t\t\t IDENTIFIER"); }
    | identifier_list ',' IDENTIFIER                            { info("identifier_list ->\n\t\t\t identifier_list , IDENTIFIER"); }
    ;

type_name
    : specifier_qualifier_list                                  { info("type_name ->\n\t\t\t specifier_qualifier_list"); }
    | specifier_qualifier_list abstract_declarator              { info("type_name ->\n\t\t\t specifier_qualifier_list abstract_declarator"); }
    ;

abstract_declarator
    : pointer                                                   { info("abstract_declarator ->\n\t\t\t pointer"); }
    | direct_abstract_declarator                                { info("abstract_declarator ->\n\t\t\t direct_abstract_declarator"); }
    | pointer direct_abstract_declarator                        { info("abstract_declarator ->\n\t\t\t pointer direct_abstract_declarator"); }
    ;

direct_abstract_declarator
    : '(' abstract_declarator ')'                               { info("direct_abstract_declarator ->\n\t\t\t ( abstract_declarator )"); }
    | '[' ']'                                                   { info("direct_abstract_declarator ->\n\t\t\t [ ]"); }
    | '[' constant_expression ']'                               { info("direct_abstract_declarator ->\n\t\t\t [ constant_expression ]"); }
    | direct_abstract_declarator '[' ']'                        { info("direct_abstract_declarator ->\n\t\t\t direct_abstract_declarator [ ]"); }
    | direct_abstract_declarator '[' constant_expression ']'    { info("direct_abstract_declarator ->\n\t\t\t direct_abstract_declarator [ constant_expression ]"); }
    | '(' ')'                                                   { info("direct_abstract_declarator ->\n\t\t\t ( )"); }
    | '(' parameter_type_list ')'                               { info("direct_abstract_declarator ->\n\t\t\t ( parameter_type_list )"); }
    | direct_abstract_declarator '(' ')'                        { info("direct_abstract_declarator ->\n\t\t\t direct_abstract_declarator ( )"); }
    | direct_abstract_declarator '(' parameter_type_list ')'    { info("direct_abstract_declarator ->\n\t\t\t direct_abstract_declarator ( parameter_type_list )"); }
    ;

initializer
    : assignment_expression                                     { info("initializer ->\n\t\t\t assignment_expression"); }
    | '{' initializer_list '}'                                  { info("initializer ->\n\t\t\t { initializer_list }"); }
    | '{' initializer_list ',' '}'                              { info("initializer ->\n\t\t\t { initializer_list , }"); }
    ;

initializer_list
    : initializer                                               { info("initializer_list ->\n\t\t\t initializer"); }
    | initializer_list ',' initializer                          { info("initializer_list ->\n\t\t\t initializer_list , initializer"); }
    ;

statement
    : labeled_statement                                         { info("statement ->\n\t\t\t labeled_statement"); }
    | compound_statement                                        { info("statement ->\n\t\t\t compound_statement"); }
    | expression_statement                                      { info("statement ->\n\t\t\t expression_statement"); }
    | selection_statement                                       { info("statement ->\n\t\t\t selection_statement"); }
    | iteration_statement                                       { info("statement ->\n\t\t\t iteration_statement"); }
    | jump_statement                                            { info("statement ->\n\t\t\t jump_statement"); }
    ;

labeled_statement
    : IDENTIFIER ':' statement                                  { info("labeled_statement ->\n\t\t\t IDENTIFIER : statement"); }
    | CASE constant_expression ':' statement                    { info("CASE constant_expression : statement"); }
    | DEFAULT ':' statement                                     { info("DEFAULT : statement"); }
    ;

compound_statement
    : '{' '}'                                                   { info("compound_statement ->\n\t\t\t { }"); }
    | '{' statement_list '}'                                    { info("compound_statement ->\n\t\t\t { statement_list }"); }
    | '{' declaration_list '}'                                  { info("compound_statement ->\n\t\t\t { declaration_list }"); }
    | '{' declaration_list statement_list '}'                   { info("compound_statement ->\n\t\t\t declaration_list statement_list"); }
    ;

declaration_list
    : declaration                                               { info("declaration_list ->\n\t\t\t declaration"); }
    | declaration_list declaration                              { info("declaration_list ->\n\t\t\t declaration_list declaration"); }
    ;

statement_list
    : statement                                                 { info("statement_list ->\n\t\t\t statement"); }
    | statement_list statement                                  { info("statement_list ->\n\t\t\t statement_list statement"); }
    ;

expression_statement
    : ';'                                                       { info("expression_statement ->\n\t\t\t ;"); }
    | expression ';'                                            { info("expression_statement ->\n\t\t\t expression ;"); }
    ;

selection_statement
    : IF '(' expression ')' statement                           { info("selection_statement ->\n\t\t\t IF ( expression ) statement"); }
    | IF '(' expression ')' statement ELSE statement            { info("selection_statement ->\n\t\t\t IF ( expression ) statement ELSE statement"); }
    | SWITCH '(' expression ')' statement                       { info("selection_statement ->\n\t\t\t SWITCH ( expression ) statement"); }
    ;

iteration_statement
    : WHILE '(' expression ')' statement                                            { info("iteration_statement ->\n\t\t\t WHILE ( expression ) statement"); }
    | DO statement WHILE '(' expression ')' ';'                                     { info("iteration_statement ->\n\t\t\t DO statement WHILE ( expression ) ;"); }
    | FOR '(' expression_statement expression_statement ')' statement               { info("FOR ( expression_statement expression_statement ) statement"); }
    | FOR '(' expression_statement expression_statement expression ')' statement    { info("FOR ( expression_statement expression_statement expression ) statement"); }
    ;

jump_statement
    : GOTO IDENTIFIER ';'                                       { info("jump_statement ->\n\t\t\t GODO IDENTIFIER ;"); }
    | CONTINUE ';'                                              { info("jump_statement ->\n\t\t\t CONTINUE ;"); }
    | BREAK ';'                                                 { info("jump_statement ->\n\t\t\t BREAK ;"); }
    | RETURN ';'                                                { info("jump_statement ->\n\t\t\t RETURN ;"); }
    | RETURN expression ';'                                     { info("jump_statement ->\n\t\t\t RETURN expression ;"); }
    ;

translation_unit
    : external_declaration                                      { info("translation_unit ->\n\t\t\t external_declaration"); }
    | translation_unit external_declaration                     { info("translation_unit ->\n\t\t\t translation_unit external_declaration"); }
    ;

external_declaration
    : function_definition                                       { info("external_declaration ->\n\t\t\t function_definition"); }
    | declaration                                               { info("external_declaration ->\n\t\t\t declaration"); }
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement     { info("function_definition ->\n\t\t\t declaration_specifiers declarator declaration_list compound_statement"); }
    | declaration_specifiers declarator compound_statement                      { info("function_definition ->\n\t\t\t declaration_specifiers declarator compound_statement"); }
    | declarator declaration_list compound_statement                            { info("function_definition ->\n\t\t\t declarator declaration_list compound_statement"); }
    | declarator compound_statement                                             { info("declarator compound_statement"); }
    ;

%%


static void info(const char* format, ...)
{
    if(cc_get_config()->dump_parser_info == false)
        return;
    cc_config* _c = cc_get_config();
    va_list args;
    va_start(args, format);
    vfprintf(_c->parser_info_fp, format, args);
    va_end(args);
    fprintf(_c->parser_info_fp, "\n");
}

void yyerror(char* s)
{
    fflush(stdout);
    printf("\n%*s\n", column, "^");
    fflush(stdout);
    cc_error("%*s\n", column, s);
}
