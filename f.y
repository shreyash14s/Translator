%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*

int yylex();
int yyerror();
%}
%token KWD TYPE ID NUM CLASS
%%
P: CLASS ID '{' METHS '}' { printf("%s\n", $2); };

METHS: METHS METH {}
| ;
METH: DECL {}
| FUNC {} ;

DECL: TYPE VARS ';' { printf("TYPE - %s\n", $1); };
VARS: INID ',' VARS {}
| INID { $$ = $1; printf("%s\n", $1); };
INID: ID { $$ = $1; }
| ID '=' EXPR { $$ = $1; };

FUNC: TYPE ID '(' ARGS ')' '{' STMTS '}' { printf("FUNC - %s\n", $2); };
ARGS: TYPE ID | TYPE ID ',' ARGS | ;
STMTS: STMTS STMT | ;
STMT: DECL | FNCALL | ASGN ;
FNCALL: FNAME '(' PARAMS ')' ';' { printf("Calling - %s\n", $1); };
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
	printf("Done\n");
	return 0;
}
