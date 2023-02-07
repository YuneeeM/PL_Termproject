%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex(void);
%}
%token ID
%%
program : line program
	| line

line : E '\n'	{prinf("parsing complete!\n"); exit(1);}
     | '\n'	

E : E '+' T		{ $$ = $1 + $3; }
  | T		{ $$ = $1;}
  ;

T : T '*' F		{ $$ = $1 * $3; }
  | F		{ $$ = $1;}
  ;

F : '('E')'		{ $$ = $2; }
  | ID{$$=$1;}
  ;
		
%%
int main(void)
{
prinf("Input string>> \n");
yyparse();
return 0;
}

int yyerror(char *s)
{
printf("syntax error!\n");
exit(1);
}
