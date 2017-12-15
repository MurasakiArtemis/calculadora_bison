all: bison flex
	gcc lex.yy.c practica.tab.c -lm -o semantical_analysis.out

flex: practica.l bison
	flex practica.l

bison: practica.y
	bison -d practica.y

clean:
	rm lex.yy.c *.tab.* *.out
