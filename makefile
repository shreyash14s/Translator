trans: lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c -ll -ly -o trans

lex.yy.c: f.l y.tab.h
	lex f.l

y.tab.c: f.y
	yacc f.y -d

y.tab.h: f.y
	yacc f.y -d
