%{
#define YYSTYPE char*
#include "y.tab.h"
char* mycat(char* orig, char* s);
%}

%%
"++"|"--"  { yylval = strdup(yytext); return INCROP; }
"-"|"+"|"*"|"/" { yylval = strdup(yytext); return *yytext; }
public|private|protected { yylval = mycat(strdup(yytext), ":"); return ACCESSMOD; }
static { yylval = strdup("static"); return STATIC; }
final { yylval = strdup("const"); return FINAL; }
void|int|char|float|long|double { yylval = strdup(yytext); return TYPE; }
String {yylval = strdup("string"); return TYPE;}
for { yylval = strdup(yytext); return FOR; }
while { yylval = strdup(yytext); return WHILE; }
if { yylval = strdup(yytext); return IF; }
else { yylval = strdup(yytext); return ELSE; }
"<"|"<="|">"|">="|"=="|"!=" { yylval = strdup(yytext); return RELOP; }
"&&"|"||" { yylval = strdup(yytext); return LOGOP; } 
class { yylval = strdup("class"); return CLASS; }
return { yylval = strdup("return"); return RETURN; }
[a-zA-Z][a-zA-Z0-9_]* { yylval =  strdup(yytext); return ID; }
[0-9]+ { yylval =  strdup(yytext); return NUM; }
\/\/.* {}
[ \t\n\r]+ { }
. { yylval =  strdup(yytext); return *yytext; }
%%
