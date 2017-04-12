# YACCFLAGS=-Wall
DEBUG=--debug --verbose
trans: lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c -ll -ly -o trans -g -w

lex.yy.c: l.l y.tab.h
	lex l.l

y.tab.c: y.y
	yacc y.y -d ${YACCFLAGS} ${DEBUG}

y.tab.h: y.y
	yacc y.y -d ${YACCFLAGS} ${DEBUG}

