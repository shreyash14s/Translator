%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*
extern FILE* yyin;
extern FILE* yyout;

int yylex();
int yyerror();

int indent = 0;
int i, tmp;
char* temp1;
char* pClass;


typedef struct {
	char name[50];
	char type[50];
} symb;
symb symbs[100];
symb symbs1[100];
int k=0, l=0;
int ktemp=0;
int lno=0;
int i, j;


char* ind();
char* mycat(char* orig, char* s);
%}
%token TYPE ID NUM CLASS ACCESSMOD STATIC FINAL RETURN RELOP LOGOP FOR WHILE IF ELSE INCROP
%left '+' '-'
%left '*' '/'
%left RELOP
%left LOGOP
%right '='
%nonassoc IF
%nonassoc ELSE

%%
CODE: P { fprintf(yyout, "%s\n", $1); }
	;
P: ACCESSMOD P1 { indent = 0; $$ = $2; }
	| P1 { $$ = $1; }
	;
P1: CLASS ID '{' METHS '}' { char* h = mycat(mycat($1, " "), $2); $$ = mycat(mycat(mycat(h, " {\n"), $4), "};"); strcpy(symbs1[lno].name,$2);strcpy(symbs1[lno].type,"class"); lno++; free($2); free($4); }
	;

METHS: METH METHS { $$ = mycat(mycat($1, "\n"), $2); free($2); }
	| { $$ = strdup(""); }
	;
METH: { indent++; } FUNC { $$ = mycat(ind(), $2); indent--; }
	| { indent++; } DECL ';' { $$ = mycat(ind(), $2); indent--; }
	;

DECL: ACCESSMOD DECL1 { $$ = mycat($1, $2); free($2); }
	| DECL1 { $$ = $1; }
	;
DECL1: FINAL DECL2 { $$ = mycat(mycat($1, " "), $2); free($2); }
	| DECL2 { $$ = $1; }
	;
DECL2: TYPE VARS { $$ = mycat(mycat(strdup($1), " "), $2); for(j=0; j<l; j++){ strcpy(symbs[k-j-1].type,strcat(symbs[k-j-1].type,$1));} l=0; free($2); }
	/*|  TYPE '[' ']' VARS ';' { $$ = mycat(mycat(mycat(strdup($1), "[] "), $4), ";"); while(ktemp>k){strcpy(symbs[k].type,mycat(strdup("array "),$1));k++;}free($2); }*/
	/*|  TYPE VARS '[' ']' ';' { $$ = mycat(mycat(mycat(mycat(strdup($1), " "), $2), "[]"), ";"); while(ktemp>k){strcpy(symbs[k].type,mycat(strdup("array "),$1));k++;} free($2); }*/
	;
VARS: INID '[' NUM ']' ',' VARS { strcpy(symbs[ktemp-l-1].type,"array ");k++;l++; $$ = mycat(mycat(mycat(mycat(mycat($1, "["), $3), "]"), ", "), $6); free($6); }
	| INID ',' VARS { strcpy(symbs[ktemp-l-1].type,"");k++;l++; $$ = mycat(mycat($1, ", "), $3); free($3); }
	| INID '[' NUM ']' { strcpy(symbs[ktemp-l-1].type,"array ");k++;l++; $$ = mycat(mycat(mycat($1, "["), $3), "]"); }
	| INID { strcpy(symbs[ktemp-l-1].type,"");k++;l++; $$ = $1; }
	;
INID: ID { $$ = $1; strcpy(symbs[ktemp].name,$1);ktemp++; }
	| ID '=' EXPR { strcpy(symbs[ktemp].name,$1);ktemp++; $$ = mycat(mycat($1, " = "), $3); free($3); }
	;

FUNC: ACCESSMOD FUNC1 { $$ = mycat(mycat($1, " "), $2); free($2); }
	| FUNC1 { $$ = $1; }
	;
FUNC1: STATIC FUNC2 { /*$$ = mycat(mycat($1, " "), $2);*/ $$ = $2; }
	| FUNC2 { $$ = $1; }
	;
FUNC2: TYPE ID ARGS { indent++; } '{' STMTS '}' { indent--; char* h = mycat(mycat(mycat(mycat(mycat($1, " "), $2), "("), $3), ")"); char* id = ind(); $$ = mycat(mycat(mycat(mycat(h, " {\n"), $6), id), "}"); strcpy(symbs1[lno].name,$2); strcpy(symbs1[lno].type,"Function");lno++; free(id); free($2); free($3); free($6); }
	;
ARGS: '(' FUNCVARS ')' { $$ = $2; }
	| '(' ')'{ $$ = strdup(""); }
	;
/*ARGS1: TYPE ID ',' ARGS1 { $$ = mycat(mycat(mycat(mycat($1, " "), $2), ", "), $4); free($2); free($4); }
	| TYPE ID { $$ = mycat(mycat($1, " "), $2); free($2); }
	;*/
FUNCVARS: FUNCVARS1 ',' FUNCVARS { $$ = mycat(mycat(strdup($1), ", "), $3); free($1);}
	| FUNCVARS1 { $$ = $1; }
	;
FUNCVARS1: TYPE VAR { $$ = mycat(mycat(strdup($1), " "), $2); while(ktemp>k){strcpy(symbs[k].type,$1);k++;} free($2); }
	|  TYPE '[' ']' VAR { $$ = mycat(mycat(strdup($1), "* "), $4); while(ktemp>k){strcpy(symbs[k].type,mycat(strdup("array "),$1));k++;} free($4); }
	|  TYPE VAR '[' ']' { $$ = mycat(mycat(strdup($1), $2), "* "); while(ktemp>k){strcpy(symbs[k].type,mycat(strdup("array "),$1));k++;} free($2); }
VAR: INID { $$ = $1; }
	;
STMTS: ISTMT STMTS { $$ = mycat(mycat($1, "\n"), $2); free($2); }
	| { $$ = strdup(""); }
	;
ISTMT: '{' { indent++; } STMTS '}' { indent--; char* id = ind(); $$ = mycat(mycat(mycat(strdup("{\n"), $3), id), "}"); free($3); free(id); }
	| STMT { $$ = mycat(ind(), $1); free($1); }
	;
BSTMT: '{' { indent++; } STMTS '}' { indent--; char* id = ind(); $$ = mycat(mycat(mycat(strdup("{\n"), $3), id), "}"); free($3); free(id); }
	| STMT { $$ = mycat(strdup("\t"), $1); free($1); }
	;
STMT: ';' { $$ = strdup(";"); }
	| RETURN ';' { $$ = mycat($1, ";"); }
	| RETURN EXPR ';' { $$ = mycat(mycat(mycat($1, " "), $2), ";"); free($2); }
	| DECL ';' { $$ = mycat($1, ";"); }
	| FNCALL ';' { $$ = mycat($1, ";"); }
	| ASGN ';' { $$ = mycat($1, ";"); }
	| INCR ';' { $$ = mycat($1, ";"); }
	| IFST { $$ = $1; }
	| FLOOP { $$ = $1; }
	| WLOOP { $$ = $1; }
	;
	
FNCALL: FNAME '(' PARAMS ')' { char* f; int tmp = strcmp($1, "System->out->println"); if(tmp==0) { f = strdup("cout << "); free($1); } else { f = $1; } $$ = mycat(mycat(mycat(f, "("), $3), ")"); free($3); }
	;
FNAME: ID '.' FNAME { $$ = mycat(mycat($1, "->"), $3); free($3); }
	| ID { $$ = $1; }
	;
PARAMS: PARAMS2 { $$ = $1; }
	| { $$ = strdup(""); }
	;
PARAMS2: EXPR ',' PARAMS2 { $$ = mycat(mycat($1, ", "), $3); free($3); }
	| EXPR { $$ = $1; }
	;
IFST: IF '(' EXPR ')' BSTMT { char* id = ind(); $$ = mycat(mycat(mycat(mycat(mycat($1, " ("), $3), ")\n"), id), $5); free(id); free($3); free($5); }
	| IF '(' EXPR ')' BSTMT ELSE BSTMT { char* id = ind(); $$ = mycat(mycat(mycat(mycat(mycat(mycat(mycat(mycat(mycat($1, " ("), $3), ")\n"), id), $5), " "), $6), " "), $7); free(id); free($3); free($7); }
	;

FLOOP: FOR '(' DECORI EXPR ';' EXPR ')' BSTMT { $$ = mycat(mycat(mycat(strdup("for "), $2), $3), " "); $$ = mycat(mycat($$, $4), "; "); $$ = mycat($$, mycat($6, ")\n")); char* id = ind(); $$ = mycat(mycat($$, id), $8); free(id); free($1); free($3); free($4); free($6); free($8); }
	;

DECORI: DECL ';' { $$ = mycat($1, ";"); }
	| ASGN ';' { $$ = mycat($1, ";"); }
	;
WLOOP: WHILE '(' EXPR ')' BSTMT { char* id = ind(); $$ = mycat(mycat(mycat(mycat(mycat($1, " ("), $3), ")\n"), id), $5); free(id); free($3); free($5); }
	;

ASGN: ID '=' EXPR { $$ = mycat(mycat($1, " = "), $3); free($3); }
	;

EXPR: FNCALL { $$ = $1; }
	| EXPR '+' EXPR { $$ = mycat(mycat($1, " + "), $3); free($3); }
	| EXPR '-' EXPR { $$ = mycat(mycat($1, " - "), $3); free($3); }
	| EXPR '*' EXPR { $$ = mycat(mycat($1, " * "), $3); free($3); }
	| EXPR '/' EXPR { $$ = mycat(mycat($1, " / "), $3); free($3); }
	| EXPR RELOP EXPR { $$ = mycat(mycat(mycat(mycat($1, " "), $2), " "), $3); free($2); free($3); }
	| EXPR LOGOP EXPR { $$ = mycat(mycat(mycat(mycat($1, " "), $2), " "), $3); free($2); free($3); }
	| INCR { $$ = $1; }
	| ID { $$ = $1; }
	| NUM { $$ = $1; }
// | T { $$ = $1; }
	;
/*T: T '*' F { $$ = mycat(mycat($1, " * "), $3); free($3); }
	| T '/' F { $$ = mycat(mycat($1, " / "), $3); free($3); }
	| F { $$ = $1; }
	;
F: ID { $$ = $1; }
	| NUM { $$ = $1; }
	;*/
INCR: ID INCROP { $$ = mycat($1, $2); free($2); }
	;
%%

int main(int argc, char* argv[])
{
	// yydebug = 1;
	if(argc != 2)
	{
		printf("Usage: ./trans example.java\n");
		exit(1);
	}
	pClass = strdup(argv[1]);
	int l = strlen(pClass);
	pClass[l-5] = '\0';
	//printf("Primary class: %s\n", pClass);
	yyin = fopen(argv[1], "r");
	char* cppFileName = strdup(pClass);
	cppFileName = strcat(cppFileName, ".cpp");
	yyout = fopen(cppFileName, "w");
	fprintf(yyout, "#include <iostream>\nusing namespace std;\n\n");
	yyparse();

	fprintf(yyout, "\nint main(int argc, char** argv)\n{\n\t");
	fprintf(yyout, "int i;\n\t");
	fprintf(yyout, "string args[argc];\n\t");
	fprintf(yyout, "for(i=0; i<argc; i++)\n\t\t");
	fprintf(yyout, "args[i] = argv[i];\n\n\t");
	fprintf(yyout, "%s *obj = new %s();\n\t", pClass, pClass);
	fprintf(yyout, "obj->main(args);\n\t", pClass);
	fprintf(yyout, "return 0;\n}");
	
	printf("\n\nSymbol Table\n\n\tName\t|\tType\n");
	for(i=0;i<k;i++)
	{
		printf("\t%s\t|\t%s\n",symbs[i].name,symbs[i].type);
	}
	printf("\n\nSecond Symbol Table\n\n\tName\t|\tType\n");
	for(i=0;i<lno;i++)
	{
		printf("\t%s\t|\t%s\n",symbs1[i].name,symbs1[i].type);
	}
	
	return 0;
}

char* ind() {
	char* t = malloc((indent+1) * sizeof(char));
	memset(t, '\t', indent+1);
	t[indent] = '\0';
	return t;
}

char* mycat(char* orig, char* s) {
	if (strlen(s)) {
		// printf("%x - \"%s\" + \"%s\"\n", orig, orig, s, strlen(orig));
		char* new = realloc(orig, (strlen(orig) + strlen(s) + 1) * sizeof(char));
		return strcat(new, s);
	}
	return orig;
}

int yyerror() {
	perror("Error: Check if the code works in java");
}

/* IF '(' EXPR ')' '{' IFIND STMTS '}' { indent--; char* id = ind(); char* id2 = ind(); $$ = mycat(mycat(mycat(mycat(mycat(mycat(mycat(id, $1), " ("), $3), ") {\n"), $7), id2), "}"); free(id2); free($1); free($3); free($7); }
	|*/
	
/*IF '(' EXPR ')' '{' IFIND STMTS '}' ELSE STMT { indent--; char* id = ind(); char* id2 = ind(); $$ = mycat(mycat(mycat(mycat(mycat(mycat(mycat(mycat(mycat(id, $1), " ("), $3), ") {\n"), $7), id2), "} "), $9), $10); free(id2); free($1); free($3); free($7); }*/

/*FLOOP: FOR '(' DECL EXPR ';' EXPR ')' '{' { indent++; } STMTS '}' { indent--; $$ = mycat(mycat(mycat(mycat(ind(), "for "), $2), $3), " "); $$ = mycat(mycat($$, $4), "; "); $$ = mycat($$, mycat($6, ") ")); $$ = mycat(mycat($$, "{\n"), $10); char* id = ind(); $$ = mycat($$, mycat(id, "}")); free(id); free($1); free($3); free($4); free($6); free($10); }
	;
*/

/*WLOOP: WHILE '(' EXPR ')' '{' { indent++; } STMTS '}' { indent--; char* id = ind(); char* id2 = ind(); $$ = mycat(mycat(mycat(mycat(mycat(mycat(mycat(id, $1), " ("), $3), ") {\n"), $7), id2), "}"); free(id2); free($1); free($3); free($7); }
	;
*/
