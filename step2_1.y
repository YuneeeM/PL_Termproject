%{
#include <stdlib.h>
#include <stdio.h>

extern FILE *yyin;
extern int yylex();
extern int yyparse();
extern int yylineno;

void yyerror(char *s);
int err=0;

%}

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE DO 
%token IF ELSE PRINTF RETURN BREAK CONTINUE DEFINE CASE 
%token SWITCH DEFAULT MAIN REAL STRUCT UNION
%token NUM ID
%token INCLUDE
%token DOT
%right '='
%right '+'
%left AND OR
%left '<' '>' LE GE EQ NE LT GT
%%

start:   multi_Declaration  MainFunction 
	| include multi_Declaration  MainFunction
	| include MainFunction
	| MainFunction
	;

multi_Declaration:Declaration 
		 |multi_Declaration Declaration 
		 ;

Declaration: Type Assignment ';' 
	| Assignment ';'  	
	| FunctionCall ';' 	
	| ArrayUsage ';'	
	| Type ArrayUsage ';'   
	| StructStmt 
	| unionStmt	
	| error	
	;


Assignment: ID '=' Assignment
	| ID '=' FunctionCall
	| ID '=' ArrayUsage
	| ID '+''+'',' Assignment
	| ID '-''-' ',' Assignment
	| '+''+' ID ',' Assignment
	| '-''-' ID  ','Assignment
	| ArrayUsage '=' Assignment
	| ID ',' Assignment
	| NUM ',' Assignment
	| ID '+' Assignment
	| ID '-' Assignment
	| ID '*' Assignment
	| ID '/' Assignment	
	| NUM '+' Assignment
	| NUM '-' Assignment
	| NUM '*' Assignment
	| NUM '/' Assignment
	| '\'' Assignment '\''	
	| '(' Assignment ')'
	| '-' '(' Assignment ')'
	| '-' NUM
	| '-' ID
	|ID '+''+'
	|ID '-''-'
	|'+''+' ID
	|'-''-' ID
	|NUM
	|ID
	;

include:'#' INCLUDE LT ID DOT ID GT 
	|'#' DEFINE ID NUM
	|'#' DEFINE ID ID
	|include '#' INCLUDE LT ID DOT ID GT
	|include '#' DEFINE ID NUM
	|include '#' DEFINE ID ID
	;


FunctionCall : ID'('')'
	| ID'('Assignment')'
	;

ArrayUsage : ID'['NUM']'
	   | ID'['NUM']''['NUM']'
	;


MainFunction: Type MAIN '(' ArgListOpt ')' CompoundStmt 
	;


ArgListOpt: ArgList
	|
	;

ArgList:  ArgList ',' Arg
	| Arg
	;


Arg:	Type ID
	;

CompoundStmt:	'{' StmtList '}' {printf("\nFinished Parsing ,no errors in here!\n"); exit(1);} 
	;


StmtList:	StmtList Stmt
	|
	;


Stmt:	WhileStmt
	| doWhileStmt
	| multi_Declaration
	| ForStmt
	| IfStmt
	| retStmt
	| SwitchStmt
	| PrintFunc
	| ';'
	;


retStmt:RETURN '(' ID ')' ';'
	|RETURN '(' NUM ')' ';'
	;


loopStmt: Stmt
	  |breakStmt
	  |contStmt
	;


loopCompoundStmt:	'{' loopStmtList '}'  
	;


loopStmtList:	loopStmtList loopStmt
	|
	;


breakStmt:BREAK ';';


contStmt:CONTINUE ';';


Type:	INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
	;


WhileStmt: WHILE '(' Expr ')' loopStmt  
	| WHILE '(' Expr ')' loopCompoundStmt 
	;


doWhileStmt: DO loopStmt WHILE '(' Expr ')' ';' 
	| DO loopCompoundStmt WHILE  '(' Expr ')' ';'
	;

ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' loopStmt 
       | FOR '(' Expr ';' Expr ';' Expr ')' loopCompoundStmt 
       | FOR '(' Expr ')' loopStmt 
       | FOR '(' Expr ')' loopCompoundStmt 
	;


IfStmt : IF '(' Expr ')' 
	 	Stmt 
	|IF '(' Expr ')' CompoundStmt
	|IF '(' Expr ')' CompoundStmt ELSE CompoundStmt
	|IF '(' Expr ')' CompoundStmt ELSE Stmt
	;

SwitchStmt:SWITCH '(' ID ')' '{' CaseBlock '}' 
	  |SWITCH '(' ID ')' '{' CaseBlock   DEFAULT ':'  loopCompoundStmt '}'
	  |SWITCH '(' ID ')' '{' CaseBlock   DEFAULT ':'  loopStmt '}'
	  ;

CaseBlock:CASE NUM ':'  loopCompoundStmt 
	 |CASE NUM ':'  loopStmt 
	 |CaseBlock CASE NUM ':'  loopCompoundStmt 
	 |CaseBlock CASE NUM ':'  loopStmt
	 ;


StructStmt : STRUCT ID '{' multi_Declaration '}' ';'
	   | STRUCT ID '{' multi_Declaration '}'  ID ';'
	   | STRUCT ID '{' multi_Declaration '}'  ID '['NUM']' ';'
	;

unionStmt:  UNION ID '{' multi_Declaration '}'
	 |  UNION ID '{' multi_Declaration '}'  ID ';'
	 |  UNION ID '{' multi_Declaration '}'  ID '['NUM']' ';'
	 ;

PrintFunc : PRINTF '(' '"' print '"'   ')' ';'
	  |PRINTF '(' '"' print '"'  ',' print ')' ';'
	  | PRINTF '(' ' print ' ')' ';'
	  | PRINTF '(' print ')' ';'
	;
print	:ID print
	|ID
	;


Expr:	
	| Expr LE Expr 
	| Expr GE Expr
	| Expr NE Expr
	| Expr EQ Expr
	| Expr GT Expr
	| Expr LT Expr
	| Assignment
	| ArrayUsage
	;
%%
