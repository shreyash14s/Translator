%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*
%}
%token KWD TYPE ID NUM CLASS
%%
P: CLASS ID '{' METHS '}' { printf("%s\n", $2); };

METHS: METHS METH {}
| ;
METH: DECL {}
| FUNC {};

DECL: TYPE VARS ';' { printf("TYPE - %s\n", $1); };
VARS: INID ',' VARS {}
| INID {};
INID: ID { printf("%s\n", $1); }
| ID '=' NUM {};

FUNC: TYPE ID '(' ARGS ')' { printf("FUNC - %s\n", $2);};
ARGS: TYPE ID | TYPE ID ',' ARGS | ;
%%

int main()
{
	yyparse();
	printf("Done\n");
	return 0;
}
//A: TYPE ID ';' { printf("A: %s-%s-%s\n", $1, $2, $3); } ;
