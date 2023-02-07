%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int yyerror(char *s);
%}
ID [A-Za-z][A-Za-z0-9]*

%%	
"*"	{return *yytext;}
"+"	{return *yytext;}
"("	{return *yytext;}
")"	{return *yytext;}
{ID}	return (ID);
[\n\t\b]	;	{return *yytext;}
.	{char message[30]; yyerror(message);}

%%
int yywrap(void)
{
return 1;
}
