%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
extern int num_id;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	 printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define ERROR 		100 

%}

RWInt    "int"
RWFloat  "float"
RWwhile  "while"
RWif     "if"
RWfor    "for"
RWreturn "return"
RWtypedef "typedef"
RWelse   "else"
RWvoid   "void"

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

/* You need to define the following RE's 
Float_constant
String_constant
comment
*/
Float_constant   {digit}*"."{digit}+
String_constant   \".*\"|'.*'
comment "/*"([^*]|\*+[^*/])*\*+"/" 

OP_or   "||"
OP_and  "&&"
OP_gte  ">="
OP_smle "<="
OP_ne   "!="
OP_eq   "=="
OP_assign        "="
OP_plus "+"
OP_minus    "-"
OP_div  "/"
OP_mul  "*"
OP_gt   ">"
OP_sml  "<"
OP_not  "!"


/* Other operators appear here */ 


newline  "\n"

DL_lparen "("
DL_rparen ")"
DL_lbrack "["
DL_rbrack "]"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

/* Other separators appear here */

error    .

%%

{comment}       { printf("%s\n", yytext); }
{WS}            {}
{RWInt}         {/* return INT; */ }
{RWFloat}       {/* return FLOAT; */}
{RWif}          {/* return IF; */}
{RWfor}         {/* return FOR; */}
{RWwhile}       {/* return WHILE; */}
{RWreturn}      {/* return RETURN; */}
{RWtypedef}     {/* return TYPEDEF; */}
{RWelse}        {/* return ELSE; */}
{RWvoid}        {/* return VOID; */}
{Int_constant}  {}
{Float_constant}  {}
{String_constant}  {}
{ID}            { 
			ptr = lookup(yytext);
			if (ptr == NULL)
			     insertID(yytext);	
			else 
			     ptr->counter++;
		}

{OP_assign}     /* return OP_ASSIGN; */ 
{OP_plus}     /* return OP_ASSIGN; */ 
{OP_minus}     /* return OP_ASSIGN; */ 
{OP_div}     /* return OP_ASSIGN; */ 
{OP_mul}     /* return OP_ASSIGN; */ 
{OP_gt}     /* return OP_ASSIGN; */ 
{OP_sml}     /* return OP_ASSIGN; */ 
{OP_smle}     /* return OP_ASSIGN; */ 
{OP_gte}     /* return OP_ASSIGN; */ 
{OP_eq}     /* return OP_ASSIGN; */ 
{OP_ne}     /* return OP_ASSIGN; */ 
{OP_not}     /* return OP_ASSIGN; */ 
{OP_and}     /* return OP_ASSIGN; */ 
{OP_or}         /* return OP_OR; */
{DL_lparen}     /* return MK_LPAREN; */
{DL_rparen}     /* return MK_RPAREN; */
{DL_lbrack}     /* return MK_LBRACK; */
{DL_rbrack}     /* return MK_RBRACK; */
{DL_lbrace}     /* return MK_LBRACE; */
{DL_rbrace}     /* return MK_RBRACE; */
{DL_comma}      {}
{DL_semicol}    {}
{newline}       linenumber += 1;
{error}         printf("ERR %s\n", yytext);/* return ERROR; */


%%

main(int argc, char **argv)
{
   num_id=0;
   argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();
   printSymTab();
}

