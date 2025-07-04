%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
	int offset,offset1,offset2;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT MAIN FOR 
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

statement: L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12 L13 L14;
L1: INT MAIN LPAREN RPAREN;
L2: LBRACE;
L3: INT ID SEMI{
	insert($2,$1);
	gen_code(LD_INT,1);
	gen_code(STORE,idcheck($2));
};
L4: FOR LPAREN ID ASSIGN ICONST SEMI ID LT ASSIGN ICONST SEMI ID ADDOP ADDOP RPAREN{
	offset = gen_label();
	gen_code(WHILE_LABEL,offset);
	gen_code(LD_VAR,idcheck($7));
	gen_code(LD_INT,$10+1);
	gen_code(LT_OP,gen_label());
	gen_code(WHILE_START,offset);
};
L5: LBRACE;
L6: IF LPAREN ID LT ICONST RPAREN LBRACE{
	offset1 = gen_label();
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(LT_OP,gen_label());
	gen_code(IF_START,offset1);

};
L7: CONTINUE SEMI{
	gen_code(LD_VAR,idcheck("i"));
	gen_code(LD_INT,1);
	gen_code(ADD,-1);
	gen_code(STORE,idcheck("i"));
	 gen_code(CONTINUE_LOOP,offset);                       
};
L8: RBRACE{
	gen_code(ELSE_START,offset1);
	gen_code(ELSE_END,offset1);
};
L9: IF LPAREN ID GT ICONST RPAREN LBRACE{
	offset2 = gen_label();
	gen_code(LD_VAR,idcheck($3));
	gen_code(LD_INT,$5);
	gen_code(GT_OP,gen_label());
	gen_code(IF_START,offset2);
};
L10: BREAK SEMI{
	gen_code(BREAK_LOOP,offset);
};
L11: RBRACE{
	gen_code(ELSE_START,offset2);
	gen_code(ELSE_END,offset2);
};
L12: PRINT LPAREN ID RPAREN SEMI{
	gen_code(PRINT_INT_VALUE, idcheck($3));
};
L13: RBRACE{
	gen_code(LD_VAR,idcheck("i"));
	gen_code(LD_INT,1);
	gen_code(ADD,-1);
	gen_code(STORE,idcheck("i"));
	gen_code(WHILE_END, offset);
};
L14: RBRACE;

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
