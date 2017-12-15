%{
#include "practica.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
%}
DIGIT [0-9]
TYPE "int"|"double"|"string"
NAM [a-zA-Z_][a-zA-Z0-9_]*
NUM {DIGIT}+
ZERO "+"?0|"-"0
POS "+"?{NUM}
NEG "-"{NUM}
INTEGER {POS}|{NEG}
DEC {NUM}("."{NUM})?|"."{NUM}
DEC_POS "+"?{DEC}
DEC_NEG "-"{DEC}
DECIMAL {DEC_POS}|{DEC_NEG}
OPERAND {DECIMAL}|{NAM}
STRING \"(\\.|[^\\"])*\"
 /* POW {OPERAND}^{OPERAND} */
 /* EQU {OPERAND}={OPERAND} */
 /* ADD {OPERAND}"+"{OPERAND} */
 /* SUB {OPERAND}"-"{OPERAND} */
 /* MUL {OPERAND}"*"{OPERAND} */
 /* DIV {OPERAND}"/"{OPERAND} */
 /* MOD "MOD("" "?{OPERAND}" "?," "?{OPERAND}" "?")" */

%%
{TYPE}          { /* printf("Tipo\n"); */ strcpy(yylval.texto, yytext); return TKN_TIPO;}
{NAM}           { /* printf("Variable\n"); */ strcpy(yylval.texto, yytext); return TKN_VAR; }
 /* {ZERO}          { printf("Zero kara!\n"); }
 {POS}           { printf("Entero Positivo\n"); }
 {NEG}           { printf("Entero Negativo\n"); } */
{INTEGER}       { /* printf("Entero\n"); */ yylval.entero = atoi(yytext); return TKN_ENTERO; }
 /* {DEC_POS}       { printf("Decimal Positivo\n"); }
{DEC_NEG}       { printf("Decimal Negativo\n"); } */
{DECIMAL}       { /* printf("Decimal\n"); */ yylval.decimal = atof(yytext); return TKN_DECIMAL; }
{STRING}        { /* printf("Cadena\n"); */ yytext[strlen(yytext)-1] = '\0'; strcpy(yylval.texto, yytext+1); return TKN_CADENA; }
"="             { /* printf("Igual\n"); */ return TKN_EQU; }
"+"             { /* printf("Suma\n"); */ return TKN_SUM; }
"-"             { /* printf("Resta\n"); */ return TKN_RES; }
"*"             { /* printf("Producto\n"); */ return TKN_PRO; }
"/"             { /* printf("Cociente\n"); */ return TKN_COC; }
"%"             { /* printf("Módulo\n"); */ return TKN_MOD; }
"^"             { /* printf("Exponenciación\n"); */ return TKN_EXP; }
";"             { /* printf("Punto y Coma/n"); */ return TKN_PYC; }
" "             { /* printf("Espacio\n"); */ return TKN_SPC; }
 /* {POW}           { printf("Potencia\n"); } */
 /* {EQU}           { printf("Igual\n"); } */
 /* {ADD}           { printf("Suma\n"); } */
 /* {SUB}           { printf("Resta\n"); } */
 /* {MUL}           { printf("Producto\n"); } */
 /* {DIV}           { printf("División\n"); } */
 /* {MOD}           { printf("Módulo\n"); } */

.               { printf("Mawile\n"); }
 
