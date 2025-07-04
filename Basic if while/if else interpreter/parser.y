%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
	struct lbs *global_label;
%}

%union
{
    char str_val[100];
    int int_val;
    struct lbs *lbls;
}

%token PRINT SCAN
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN ELSE
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<lbls> IF
%token<lbls> WHILE

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP SUBOP 
%left MULOP /*MULOP has lowest precedence*/

// %type<int_val> exp assignment_print_scan

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);};

code: statements;

statements: statements statement | ;

statement: L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12;
L1 : INT ID SEMI{
	insert($2,$1);
};
L2 : ID ASSIGN ICONST SEMI{
	gen_code(LD_INT,$3);
	gen_code(STORE,idcheck($1));
};
L3 : IF LPAREN ID LT ICONST RPAREN{
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(LT_OP,-1);
	global_label = (struct lbs *) newlblrec(); 
	global_label->for_jmp_false = reserve_loc();
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
	global_label->for_goto = reserve_loc();
};
L8 : ELSE{
	back_patch(global_label->for_jmp_false,JMP_FALSE,gen_label());
};
L9 : LBRACE;
L10 : ID ASSIGN ID ADDOP ICONST SEMI{
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(ADD,-1);
	gen_code(STORE,idcheck($1));
};
L11 : RBRACE{
	back_patch(global_label->for_goto,GOTO,gen_label());
};
L12 : PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));
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

    printf("============= RUN CODE IN VIRTUAL MACHINE ===============\n");
    vm();

	return 0;
}
