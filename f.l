%{
#define YYSTYPE char*
#include "y.tab.h"
%}

%%
void|int|char|float|long|double { yylval = strdup(yytext); return TYPE; }
for|else|while|switch { yylval =  strdup(yytext); return KWD; }
class { yylval = "class"; return CLASS; }
[a-zA-Z][a-zA-Z0-9_]* { yylval =  strdup(yytext); return ID; }
[0-9]+ { yylval =  strdup(yytext); return NUM; }
[ \t\n\r]+ { }
. { yylval =  strdup(yytext); return *yytext; }
%%
