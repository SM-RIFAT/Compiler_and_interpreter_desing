%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
	int offset;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT 
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN

%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> IF

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP 
%left MULOP /*MULOP has lowest precedence*/

// %type<int_val> L3

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;

statements: statements statement | ;

statement: L1 L2 L3 L4 L5 L6 L7;
L1 : INT ID SEMI{
	insert($2,$1);
};
L2 : ID ASSIGN ICONST SEMI{
	gen_code(LD_INT,$3);
	gen_code(STORE,idcheck($1));
};
L3 : WHILE LPAREN ID LT ICONST RPAREN{
	offset = gen_label();
	gen_code(WHILE_LABEL,offset);
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(LT_OP,gen_label());
	gen_code(WHILE_START,offset);
};
L4 : LBRACE;
L5 : PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));
};
L6 : ID ASSIGN ID ADDOP ICONST SEMI{
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(ADD,-1);
	gen_code(STORE,idcheck($1));
};
L7 : RBRACE{
	gen_code(WHILE_END,offset);
};

%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
