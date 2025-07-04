%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
	struct lbs *global_label1;
	struct lbs *global_label2;
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

statement: L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12 L13 L14 L15 L16 L17 L18;
L1 : INT ID ASSIGN ICONST SEMI{
	insert($2,$1);
	gen_code(LD_INT,$4);
	gen_code(STORE,idcheck($2));
};
L2 : INT ID ASSIGN ICONST SEMI{
	insert($2,$1);
	gen_code(LD_INT,$4);
	gen_code(STORE,idcheck($2));
};
L3 : INT ID ASSIGN ICONST SUBOP ID ADDOP ID SEMI {
	insert($2,$1);
	gen_code(LD_INT,$4);
	gen_code(LD_VAR,idcheck($6));
	gen_code(SUB,-1);
	gen_code(LD_VAR,idcheck($8));
	gen_code(ADD,-1);
	gen_code(STORE,idcheck($2));
};
L4 : IF LPAREN ID GT ICONST RPAREN{
	global_label1 = (struct lbs *) newlblrec(); 
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(GT_OP,-1);
    global_label1->for_jmp_false = reserve_loc();
};
L5 : LBRACE;
L6 : IF LPAREN ID GT ICONST RPAREN{
	global_label2 = (struct lbs *) newlblrec(); 
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(GT_OP,-1);
    global_label2->for_jmp_false = reserve_loc();
};
L7 : LBRACE;
L8 : PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));
};
L9 : RBRACE{
	global_label2->for_goto = reserve_loc(); 
};
L10 : ELSE{
	back_patch( global_label2->for_jmp_false, JMP_FALSE, gen_label() ); 
};
L11 : LBRACE;
L12 : PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));
};
L13 : RBRACE{
	back_patch( global_label2->for_goto, GOTO, gen_label() ); 
};
L14 : RBRACE{
	global_label1->for_goto = reserve_loc();
};
L15 : ELSE {
	back_patch( global_label1->for_jmp_false, JMP_FALSE, gen_label() ); 
};
L16 : LBRACE;
L17 : PRINT LPAREN ID RPAREN SEMI {
	gen_code(PRINT_INT_VALUE, idcheck($3));
};
L18 : RBRACE{
	back_patch( global_label1->for_goto, GOTO, gen_label() ); 
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
