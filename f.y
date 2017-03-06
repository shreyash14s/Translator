%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>	

#define YYSTYPE char*
%}
%token KWD TYPE ID NUM CLASS
%%
P: P A '\n' | ;
A: TYPE ' ' ID ';' { printf("A: %s-%s-%s-%s\n", $1, $2, $3, $4); } ;
%%

int main()
{
	yyparse();
	printf("Done\n");
	return 0;
}

