%{
  #include <stdio.h>
  #include "cgen.h"
  
  
  extern int yylex(void);
  extern int lineNum;
%}

%union  
{
  char* str;
  int num;
}

// %define parse.trace
// %debug
%define parse.error verbose
%token <str> TK_IDENT 
%token <str> TK_INT 
%token <str> TK_REAL 
%token <str> TK_STRING  
%token <str> TK_POSINT
%token <str> KW_IF  
%token <str> KW_ELSE  
%token <str> KW_STRING 
%token  <str> KW_NUMBER 
%token  <str> KW_FALSE 
%token  <str> KW_FOR 
%token <str> KW_NOT 
%token KW_START 
%token <str> KW_BOOLEAN 
%token <str> KW_VAR 
%token  <str> KW_WHILE 
%token <str> KW_AND 
%token <str> KW_CONST
%token  <str> KW_FUNCTION 
%token <str> KW_OR 
%token  <str> KW_VOID 
%token  <str> KW_BREAK 
%token  <str> KW_RETURN 
%token  <str> KW_TRUE 
%token  <str> KW_CONTINUE 
%token  <str> KW_NULL 
%token <str> TK_POWER
%token <str> TK_EQUAL 
%token <str> TK_DIFF 
%token <str> TK_LESSOR 

%type <str> expr //%type---> mh termatiko 
%type <str> assign 
%type <str> comparesign
%type <str> elseif
%type <str> iforloop
%type <str> ifs
%type <str> elses
%type <str> whiles
%type <str> statements
%type <str> statement
%type <str> statements1
%type <str> fors
%type <str> data_types
%type <str> variable_decl
%type <str> id
%type <str> id1
%type <str> id2
%type <str> const_declaration
%type <str> const_id
%type <str> const_id1
%type <str> array
%type <str> function
%type <str> func_parameters
%type <str> func_parameters1
%type <str> func_parameter_id
%type <str> func_return_type
%type <str> func_body
%type <str> func_return
%type <str> func_input
%type <str> func_start
%type <str> body
%type <str> getout



%left KW_OR
%left KW_AND
%left TK_EQUAL TK_DIFF '<' TK_LESSOR
%left '-' '+'
%left TK_POWER
%left '*' '/' '%'
%left '(' ')' '[' ']'
%left KW_NOT

%start program

%%


program:body
{ 
  if (yyerror_count == 0) {  // dld an den vrhka suntaktika la8oi
    puts(c_prologue);
    printf("Expression evaluates to: %s\n", $1); //ektupose to expression pou vrhkes
  }  
}
;


comparesign:
 TK_DIFF        {$$ = template("%s","!=");}
| '<'           {$$ = template("%s","<");}
| TK_LESSOR     {$$ = template("%s","<=");}
| TK_EQUAL      {$$ = template("%s","==");} 
;

assign: 
TK_IDENT '=' expr ';'             { $$ = template("%s = %s;\n",$1,$3); }
|TK_IDENT '=' expr ';' assign      { $$ = template("%s = %s;\n %s",$1,$3,$5); }
|expr '=' TK_IDENT  ';'           { $$ = template("%s = %s;\n",$1,$3); }
|expr '=' TK_IDENT ';' assign      { $$ = template("%s = %s;\n %s",$1,$3,$5); }	                            
;
	 
expr:
  TK_INT                {$$ = template("%s",$1);}
| TK_REAL               {$$ = template("%s",$1);}
| TK_IDENT              {$$ = template("%s",$1);}
| TK_STRING             {$$ = template("%s",$1);}
| KW_TRUE               {$$ = template("true");}
| KW_FALSE              {$$ = template("false",$1);}    
| '(' expr ')'          { $$ = template("(%s)",$2);} //print shmasiologikh timh expr
| expr ':' expr         { $$ = template("%s : %s",$1,$3);}
| expr '+' expr         { $$ = template("%s + %s",$1,$3);}
| expr '-' expr         { $$ = template("%s - %s",$1,$3);}
|      '-' expr         { $$ = template("- %s",$2);}
| expr '*' expr         { $$ = template("%s * %s",$1,$3);}
| expr '/' expr         { $$ = template("%s / %s",$1,$3);}
| expr '%' expr         { $$ = template("%s % %s",$1,$3);}
| expr '=' expr         { $$ = template("%s = %s",$1,$3);}
| expr TK_POWER expr    { $$ = template("%s ^ %s",$1,$3);}
| expr KW_AND expr      { $$ = template("%s and %s",$1,$3);}
| expr KW_OR expr       { $$ = template("%s or %s",$1,$3);}
| KW_NOT expr           { $$ = template("not %s",$2);}
| TK_IDENT'['expr']'    { $$ = template("%s[%s]",$1,$3);}
|expr comparesign expr  { $$ = template("%s %s %s",$1,$2,$3);}
|TK_IDENT'['TK_INT']'   {$$ = template("%s[%s]",$1,$3);}  //array call
|TK_IDENT'('func_input ')' {$$ = template("%s(%s)", $1, $3);} //func call 
//| iforloop 
;
statements:
 %empty                              {$$ = template("");}              
|expr ';' statements                 {$$ = template("%s;\n %s",$1,$3);} 
|getout                              {$$ = template("%s",$1);} 
|ifs   statements                    {$$ = template("%s\n %s",$1,$2);}  
|whiles  statements                  {$$ = template("%s\n %s",$1,$2);} 
|fors    statements                  {$$ = template("%s\n %s",$1,$2);}  
;

statement:     //xoris thn epigh gia polla expr afou auta 8eloun{}        
 expr ';'                       {$$ = template("%s;\n",$1);} 
|getout                                  {$$ = template("%s",$1);} 
|ifs                          {$$ = template("%s",$1);}  
|whiles                          {$$ = template("%s",$1);}  
|fors                          {$$ = template("%s",$1);}  
;

statements1:
 %empty                        {$$ = template("");}              
|expr ';'                      {$$ = template("%s;\n ",$1);} 
|getout                        {$$ = template("%s",$1);} 
|whiles                        {$$ = template("%s %s",$1);}  
|fors                          {$$ = template("%s",$1);}  
;

iforloop:
 ifs                                {$$ = template("%s",$1);} 
|whiles                          {$$ = template("%s",$1);}  
|fors                          {$$ = template("%s",$1);}  
|elseif                                 {$$ = template("%s",$1);} 
|elses                                 {$$ = template("%s",$1);}                                    
;

ifs:     
 KW_IF '(' expr ')' statement  {$$ = template("if(%s)\n{%s};\n",$3,$5);} 
|KW_IF '(' expr ')' '{' statements'}' ';' {$$ = template("if(%s)\n{%s};\n",$3,$6);} 
;

elseif:
 KW_ELSE ifs      {$$ = template("\nelse %s",$2);} 
;

elses:
  KW_ELSE statements1                        {$$ = template("else\n{%s};\n",$2);} 
|KW_ELSE '{'statements '}'';'                {$$ = template("else\n{%s};\n",$3);} 	
|KW_ELSE '(' expr ')' '{' statements'}'';'   {$$ = template("else(%s)\n{%s};\n",$3,$6);} 
; 

whiles:
 KW_WHILE '('expr')' statement       {$$ = template("\nwhile(%s)\n{%s};\n",$3,$5);} 
|KW_WHILE '('expr')' '{'statements'}' ';'{$$ = template("\nwhile(%s)\n{%s};\n",$3,$6);} 
;

fors:
KW_FOR '('assign ';' expr ';'assign')'  statement          {$$ = template("for ( %s ; %s ; %s)\n {%s};\n",$3,$5,$7,$9);}
|KW_FOR '('assign ';' expr ';'assign')'  '{'statements '}' ';'        {$$ = template("for ( %s ; %s ; %s)\n {%s};\n",$3,$5,$7,$10);}
;

getout:
  KW_RETURN     ';'               {$$ = template("return;");}               
| KW_RETURN expr     ';'            {$$ = template("return %s;",$2);} 
| KW_CONTINUE         ';'             {$$ = template("continue;");}           
| KW_BREAK           ';'              {$$ = template("break;");}
;


data_types:
 KW_NUMBER        {$$ = template("%s","double");}
|KW_STRING        {$$ = template("%s","char*");}
|KW_BOOLEAN       {$$ = template("%s","int");}
|KW_VOID          {$$ = template("%s","void");}
;

array:
 TK_IDENT'['TK_INT']' {$$ = template(" %s[%s]",$1,$3);} 
;

variable_decl:
 KW_VAR id id1':' data_types ';' {$$ = template("%s %s %s;\n",$5,$2,$3);} //uses id,id1,id2,data_types,array
;

id: //oste na mpei sigoura array,metavlhth h metavlhth=kati 
 array                       {$$ = template("%s",$1);}      
|TK_IDENT                    {$$ = template("%s",$1);}         
|TK_IDENT '=' id2      {$$ = template("%s = %s",$1,$3);}
;
 
id1: //oste an 8elei na valei polles metavlhtes/arrays
 %empty                   {$$ = template("");}
|id1 ',' id                { $$ = template("%s,%s",$1,$3 );}
;

id2: //ti mporei na mpei sta variables
  TK_INT     {$$ = template("%s",$1);}
|TK_STRING   {$$ = template("%s",$1);} 
|KW_TRUE     {$$ = template("%s","true");}
|KW_FALSE    {$$ = template("%s","false");}
|TK_REAL     {$$ = template("%s",$1);}
;

const_declaration:
 KW_CONST const_id const_id1':' data_types ';' {$$ = template("const %s %s %s;\n",$5,$2,$3);} //uses const_id,const_id1,id2,data_types
;

const_id:  //opos kai gia ta variable_decl alla xoris thn "sketh" morfh
TK_IDENT '=' id2      {$$ = template("%s = %s",$1,$3);}
;

const_id1: //oste an 8elei na valei polles metavlhtes
 %empty                      {$$ = template("");}                            
|const_id1 ',' const_id                { $$ = template("%s,%s",$1,$3 );}
;

function:
KW_FUNCTION TK_IDENT '('func_parameters func_parameters1')' ':' func_return_type '{'func_body '}' {$$ = template("\n%s %s(%s%s) {\n%s}",$8,$2,$4,$5,$10);} //pos mporo na grapso expression se diaforetikes grammes?
;

func_parameters:
 %empty                                  {$$ = template("");}
|func_parameter_id':' data_types         {$$ = template("%s %s",$3,$1);}
;

func_parameters1:
 %empty                                  {$$ = template("");}
|','func_parameter_id':' data_types      {$$ = template(",%s %s",$4,$2);}
;

func_parameter_id:
 TK_IDENT                            {$$ = template("%s",$1);}
|TK_IDENT'['']'                      {$$ = template("%s[]",$1);}
;

func_return_type:
	%empty                {$$ = template("");}
|data_types            {$$ = template("%s",$1);}
|'['']'data_types      {$$ = template("%s",$3);} 
;

func_body:
 variable_decl func_body           {$$ = template("%s%s", $1, $2);}
|const_declaration func_body       {$$ = template("%s%s", $1, $2);}
|expr ';' func_body                    {$$ = template("%s;%s", $1, $3);}
|assign func_body                    {$$ = template("%s;%s", $1, $2);}
|iforloop func_body                {$$ = template("%s%s", $1, $2);}
|func_return                       {$$ = template("%s",$1);}
;

func_return:
 %empty                {$$ = template("");}
| KW_RETURN';'            {$$ = template("return ;");}
|KW_RETURN expr ';'      {$$ = template("return %s;",$2);}

func_input:
    %empty                {$$ = template("");}
    |expr ',' func_input  {$$ = template("%s , %s", $1, $3);}
    |expr                 {$$ = template("%s",$1);}
    ;

func_start:
KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{'func_body '}' {$$ = template("void main() {\n%s}\n", $8);}
;

body:
   %empty                  {$$ = template("\n");}
   |body const_declaration {$$ = template("%s%s",$1,$2);}
   |body variable_decl     {$$ = template("%s%s", $1, $2);}
   |body function          {$$ = template("%s%s", $1, $2);}
   |body func_start        {$$ = template("%s%s", $1, $2);}
   |body ';'               {$$ = template("%s;\n", $1);}
   |body iforloop          {$$ = template("%s%s", $1, $2);}
   |body expr              {$$ = template("%s%s", $1, $2);}
   ;
   
%%
int main () {
  if ( yyparse() == 0 ) //dld an den brhka suntaktiko la8os,yyparse kalei yylex
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}
