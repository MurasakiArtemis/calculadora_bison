%{
  #include <string.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <search.h>
  #include <math.h>
  
  int yyerror (char*);
  void string_subtraction(char*, char*, char*);
  void string_addition(char*, char*, char*);
  int compare_identifiers( const void *, const void * );
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
	double decimal;
  char texto[100];
}
%{
  struct data_struct
  {
    char identifier[100];
    char tipo[10];
    YYSTYPE data;
  };

  int data_array_size = 100;
  int data_array_pointer = 0;
  struct data_struct data_array[100];
%}
%token <texto> TKN_TIPO
%token <texto> TKN_VAR
%token <entero> TKN_ENTERO
%token <decimal> TKN_DECIMAL
%token <texto> TKN_CADENA
%token TKN_EQU
%token TKN_SUM
%token TKN_RES
%token TKN_PRO
%token TKN_COC
%token TKN_MOD
%token TKN_EXP
%token TKN_PYC
%token TKN_SPC
%type <entero> integer_expression
%type <entero> integer_operation
%type <entero> integer_sum
%type <entero> integer_res
%type <entero> integer_pro
%type <entero> integer_coc
%type <entero> integer_mod
%type <entero> integer_exp
%type <decimal> decimal_expression
%type <decimal> decimal_operation
%type <decimal> decimal_sum
%type <decimal> decimal_res
%type <decimal> decimal_pro
%type <decimal> decimal_coc
%type <decimal> decimal_exp
%type <texto> text_expression
%type <texto> text_operation
%type <texto> text_sum
%type <texto> text_res
%%

input:  
        | input line
;

line:   '\n'
        | declare
        | declare_assign
        | assign
        | TKN_VAR TKN_PYC
        {
          struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
          if(ptr != NULL)
          {
            printf("%s, %s ", ptr->identifier, ptr->tipo);
            if(!strcmp(ptr->tipo, "string"))
            {
              printf("%s", ptr->data.texto);
            }
            else if(!strcmp(ptr->tipo, "int"))
              printf("%d", ptr->data.entero);
            else if(!strcmp(ptr->tipo, "double"))
              printf("%lf", ptr->data.decimal);
          }
          else
          {
            yyerror("El identificador no existe");
            YYERROR;
          }
        }
;

separador: 
          | TKN_SPC
;

declare:                  TKN_TIPO separador TKN_VAR TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$3, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr == NULL)
                            {
                                struct data_struct new_var;
                                strcpy(new_var.identifier, $3);
                                strcpy(new_var.tipo, $1);
                                data_array[data_array_pointer++] = new_var;
                            }
                            else
                            {
                              yyerror("El identificador existe");
                              YYERROR;
                            }
                          }
;

declare_assign:           declare_assign_integer
                          | declare_assign_text
                          | declare_assign_decimal
;

assign:                   assign_integer
                          | assign_text
                          | assign_decimal
;

declare_assign_integer:   TKN_TIPO separador TKN_VAR separador TKN_EQU separador integer_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$3, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr == NULL)
                            {
                                if(strcmp($1, "int"))
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                                struct data_struct new_var;
                                strcpy(new_var.identifier, $3);
                                strcpy(new_var.tipo, $1);
                                YYSTYPE data;
                                data.entero = $7;
                                new_var.data = data;
                                data_array[data_array_pointer++] = new_var;
                            }
                            else
                            {
                              yyerror("El identificador existe");
                              YYERROR;
                            }
                          }
;
declare_assign_text:      TKN_TIPO separador TKN_VAR separador TKN_EQU separador text_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$3, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr == NULL)
                            {
                                if(strcmp($1, "string"))
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                                struct data_struct new_var;
                                strcpy(new_var.identifier, $3);
                                strcpy(new_var.tipo, $1);
                                YYSTYPE data;
                                strcpy(data.texto, $7);
                                new_var.data = data;
                                data_array[data_array_pointer++] = new_var;
                            }
                            else
                            {
                              yyerror("El identificador existe");
                              YYERROR;
                            }
                          }
;
declare_assign_decimal:   TKN_TIPO separador TKN_VAR separador TKN_EQU separador decimal_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$3, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr == NULL)
                            {
                                if(strcmp($1, "double"))
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                                struct data_struct new_var;
                                strcpy(new_var.identifier, $3);
                                strcpy(new_var.tipo, $1);
                                YYSTYPE data;
                                data.decimal = $7;
                                new_var.data = data;
                                data_array[data_array_pointer++] = new_var;
                            }
                            else
                            {
                              yyerror("El identificador existe");
                              YYERROR;
                            }
                          }
;

assign_integer:           TKN_VAR separador TKN_EQU separador integer_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "int"))
                                {
                                  YYSTYPE data;
                                  data.entero = $5;
                                  ptr->data = data;
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
;
assign_decimal:           TKN_VAR separador TKN_EQU separador decimal_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "double"))
                                {
                                  YYSTYPE data;
                                  data.decimal = $5;
                                  ptr->data = data;
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
;
assign_text:              TKN_VAR separador TKN_EQU separador text_expression TKN_PYC
                          {
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "string"))
                                {
                                  YYSTYPE data;
                                  strcpy(data.texto, $5);
                                  ptr->data = data;
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
;

integer_expression:       TKN_ENTERO
                          | TKN_VAR
                          {
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "int"))
                                {
                                  $$ = ptr->data.entero;
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
                          | integer_operation
;

integer_operation:        integer_sum | integer_res | integer_pro | integer_coc | integer_mod | integer_exp
;

integer_sum:              integer_expression separador TKN_SUM separador integer_expression { $$ = $1 + $5; }
;

integer_res:              integer_expression separador TKN_RES separador integer_expression { $$ = $1 - $5; }
;

integer_pro:              integer_expression separador TKN_PRO separador integer_expression { $$ = $1 * $5; }
;

integer_coc:              integer_expression separador TKN_COC separador integer_expression { $$ = $1 / $5; }
;

integer_mod:              integer_expression separador TKN_MOD separador integer_expression { $$ = $1 % $5; }
;

integer_exp:              integer_expression separador TKN_EXP separador integer_expression { $$ = pow($1, $5); }
;

decimal_expression:       TKN_DECIMAL
                          | TKN_VAR 
                          { printf("B");
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "double"))
                                {
                                  $$ = ptr->data.decimal;
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
                          | decimal_operation
;

decimal_operation:        decimal_sum | decimal_res | decimal_pro | decimal_coc | decimal_exp
;

decimal_sum:              decimal_expression separador TKN_SUM separador decimal_expression { $$ = $1 + $5; }
;

decimal_res:              decimal_expression separador TKN_RES separador decimal_expression { $$ = $1 - $5; }
;

decimal_pro:              decimal_expression separador TKN_PRO separador decimal_expression { $$ = $1 * $5; }
;

decimal_coc:              decimal_expression separador TKN_COC separador decimal_expression { $$ = $1 / $5; }
;

decimal_exp:              decimal_expression separador TKN_EXP separador decimal_expression { $$ = powl($1, $5); }
;


text_expression:          TKN_CADENA
                          | TKN_VAR 
                          { printf("C");
                            struct data_struct* ptr = lfind( &$1, data_array, (long unsigned int*)&data_array_size, sizeof(struct data_struct), compare_identifiers );
                            if(ptr != NULL)
                            {
                                if(!strcmp(ptr->tipo, "string"))
                                {
                                  strcpy($$, ptr->data.texto);
                                }
                                else
                                {
                                  yyerror("El tipo es inválido");
                                  YYERROR;
                                }
                            }
                            else
                            {
                              yyerror("El identificador no existe");
                              YYERROR;
                            }
                          }
                          | text_operation
;

text_operation:           text_sum | text_res
;

text_sum:                 text_expression separador TKN_SUM separador text_expression { string_addition($$, $1, $5); }
;

text_res:                 text_expression separador TKN_RES separador text_expression { string_subtraction($$, $1, $5); }
;

%%

int main() {
  yyparse();
}
             
int yyerror (char *s){
  printf ("--%s--\n", s);
  return 0;
}
            
int yywrap()  
{  
  return 1;  
}  

int compare_identifiers( const void *op1, const void *op2 )
{
    const char* p1 = (const char*) op1;
    const struct data_struct* p2 = (const struct data_struct* ) op2;
    return( strcmp( p1, p2->identifier) );
}

void string_addition(char* dst, char* src1, char* src2)
{
  strcpy(dst, src1);
  strcpy(dst+strlen(src1), src2);
}

void string_subtraction(char* dst, char* src1, char* src2)
{
  int location = strstr(src1, src2) - src1;
  int k;
  strncpy(dst, src1, location);
  strcpy(dst, src1+location+strlen(src2));
}