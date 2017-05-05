
PROJECT_DIR = .
SRC_DIR = $(PROJECT_DIR)/src

#TODO
BISON = $(PROJECT_DIR)/.tool/bison/bin/bison.exe
FLEX = $(PROJECT_DIR)/.tool/flex/bin/flex.exe
# BISON = bison
# FLEX = flex
CC = gcc
CFLAGS = -std=c90 -Wall

gen_parser:
	$(BISON) -y -d $(SRC_DIR)/9cc.yacc -o $(SRC_DIR)/y.tab.c;
	$(FLEX) -o$(SRC_DIR)/lex.yy.c $(SRC_DIR)/9cc.lex;
	$(CC) $(CFLAGS) $(SRC_DIR)/*.c -o a.out;

all: gen_parser

clean: 
	-rm a.out
	-rm src/*.o

default: all

.PHONY: all
