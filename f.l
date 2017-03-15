%{
#define YYSTYPE char*
#include "y.tab.h"
int control=0;
%}

%%
\".*\" { ECHO; }
\'.\' { ECHO; }
"/*" { if (control == 0) { control = 1;}}
"*/" { if (control == 1) control = 0; else ECHO; }
\/\/[^\n]* {}
void|int|char|float|long|double|String { yylval = strdup(yytext); return TYPE; }
for|else|while|switch { yylval =  strdup(yytext); return KWD; }
class { yylval = "class"; return CLASS; }
[a-zA-Z][a-zA-Z0-9_.]* { yylval =  strdup(yytext); return ID; }
[0-9]+ { yylval =  strdup(yytext); return NUM; }
[ \t\n\r]+ { }
. {  if (!control) ECHO; yylval =  strdup(yytext); return *yytext; }
%%
