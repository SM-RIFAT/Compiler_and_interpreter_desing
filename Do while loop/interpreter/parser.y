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

%token PRINT SCAN DO
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
program: {gen_code(START, -1);} code {
	back_patch( global_label->for_jmp_false, JMP_FALSE, gen_label() ); 
	gen_code(HALT, -1);};

code: statements;

statements: statements statement | ;

statement: L1 L2 L3 L4 L5 L6;
L1 : INT ID ASSIGN ICONST SEMI{
	insert($2,$1);
	gen_code(LD_INT,$4);
	gen_code(STORE,idcheck($2));
};
L2 : DO LBRACE{
	global_label = (struct lbs *) newlblrec();
	global_label->for_goto = gen_label(); 
};
L3 : PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));

};
L4 : ID ADDOP ADDOP SEMI{
	gen_code(LD_VAR,idcheck($1));
	gen_code(LD_INT,1);
	gen_code(ADD,-1);
	gen_code(STORE,idcheck($1));
};
L5 : RBRACE;
L6 : WHILE LPAREN ID LT ICONST RPAREN SEMI{
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(LT_OP,-1);
	global_label->for_jmp_false = reserve_loc(); 
	gen_code( GOTO, global_label->for_goto );
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
