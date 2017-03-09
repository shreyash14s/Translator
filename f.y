%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*

typedef struct {
	char name[50];
	char type[50];
} symb;
symb symbs[100];
symb symbs1[100];
int k=0;
int l=0;
int i;



int yylex();
int yyerror();
%}
%token KWD TYPE ID NUM CLASS
%%
P: CLASS ID '{' METHS '}' { strcpy(symbs1[l].name,$2);strcpy(symbs1[l].type,"class"); l++;};

METHS: METHS METH {}
| ;
METH: DECL {}
| FUNC {} ;

DECL: TYPE VARS ';' { printf("TYPE - %s\n", $1); };
VARS: INID ',' VARS {}
| INID { $$ = $1; printf("%s\n", $1); };
INID: ID { $$ = $1; }
| ID '=' EXPR { $$ = $1; };

FUNC: TYPE ID '(' ARGS ')' '{' STMTS '}' { printf("FUNC - %s\n", $2); strcpy(symbs1[l].name,$2);strcpy(symbs1[l].type,"Function"); l++;};
ARGS: TYPE ID | TYPE ID ',' ARGS | ;
STMTS: STMTS STMT | ;
STMT: DECL | FNCALL | ASGN ;
FNCALL: FNAME '(' PARAMS ')' ';' { printf("Calling - %s\n", $1); strcpy(symbs1[l].name,$1);strcpy(symbs1[l].type,"Function"); l++;};
FNAME: ID { /* Should handle obj.func or Class.func */ };
PARAMS: PARAMS2 | ;
PARAMS2: EXPR ',' PARAMS2 | EXPR ;
ASGN: ID '=' EXPR ;

EXPR: EXPR '+' T | EXPR '-' T | T ;
T: T '*' F | T '/' F | F ;
F: NUM | ID ;
%%

int main()
{
	yyparse();
	
	printf("Second Symbol Table\nName\tType\n");
	for(i=0;i<l;i++)
	{
		printf("%s\t%s\n",symbs1[i].name,symbs1[i].type);
	}
	return 0;
}
