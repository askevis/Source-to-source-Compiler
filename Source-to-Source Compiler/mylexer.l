%{
  // #define TK_IDENT 258
  // #define TK_INT 259
  // #define TK_REAL 260
  // #define KW_IF 262  
  // #define KW_ELSE 263
  // #define KW_NUMBER 265
  // #define KW_FALSE 266
  // #define KW_FOR 267
  // #define KW_NOT 268
  // #define KW_START 269
  // #define KW_BOOLEAN 270
  // #define KW_VAR 271
  // #define KW_WHILE 272
  // #define KW_AND 273
  // #define KW_CONST 275
  // #define KW_FUNCTION 276
  // #define KW_OR 277
  // #define KW_VOID 278
  // #define KW_BREAK 279
  // #define KW_RETURN 28
  // #define KW_TRUE 281
  // #define KW_CONTINUE 282
  // #define KW_NULL 283
  // #define TK_POWER 284
  // #define TK_EQUAL 285
  // #define TK_DIFF 286
  // #define TK_LESSOR 287
  // #define TK_STRING 288
  // #define TK_POSINT 289
  
  #include <stdio.h>
  #include <string.h>
  #include "myparser4.tab.h"
  #include "cgen.h"

  int lineNum = 1;
%}


ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  [+-]?{DIGIT}{DIGIT}*
DECIMAL ([+-]?"."{NUMBER})|([+-]?{NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
CHARACTERS [a-zA-Z0-9\-+\*\/:_$!#@&~^()., ]|[\\n]|[\\t]|[\\r]|[\\\\]|[\\\']|[\\\"]
STRING  \"{CHARACTERS}*\"|\'{CHARACTERS}*\'
%x comment

%%

if               return KW_IF;
else		    return KW_ELSE;
number		 return KW_NUMBER;
false		   return KW_FALSE;
for	             return KW_FOR;
not		         return KW_NOT;
string           return KW_STRING; 
start		   return KW_START;
boolean	     return KW_BOOLEAN;
var		        return KW_VAR;
while		   return KW_WHILE;
const		  return KW_CONST;
function	return KW_FUNCTION;
or		          return KW_OR;
void		    return KW_VOID;
break		   return KW_BREAK;
return	      return KW_RETURN ;
true		    return KW_TRUE;
continue	return KW_CONTINUE;
null		    return KW_NULL;
and		         return KW_AND;

{ID}        { yylval.str = strdup(yytext); //printf("An identifier : (%s)\n ", yytext); return TK_IDENT; oti exei sto yytext to pernao sthn yylval pou einai global giati to yytext panografete
                return TK_IDENT; } 

{NUMBER}    { yylval.str = strdup(yytext); 
                return TK_INT; }  //return TK_INT;
			

{REAL}      { yylval.str = strdup(yytext); 
                return TK_REAL;  } // printf("A real: (%s) \n",yytext); return TK_REAL;
				
{STRING}      { yylval.str = strdup(yytext);
                 return TK_STRING;  }  
				


"+"         return '+';
"-"          return '-';
"*"          return '*';
"/"          return '/';
"%"          return '%';
"**"         return TK_POWER;
"=="         return TK_EQUAL;
"!="         return TK_DIFF;
"<"          return '<';
"<="         return TK_LESSOR;
"="          return '=';
";"           return ';';
"("           return '(';
")"           return ')';
","           return ',';
"["           return '[';
"]"           return ']';
"{"           return '{';
"}"           return '}';
":"           return ':';

"//"[^\n]*  printf("Line %d: line comment: %s\n", lineNum, yytext);/* eat line comments */
"/*"                    { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++lineNum;
<comment>"*"+"/"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }



[ \r\t]+		/* eat whitespace */
\n 					 ++lineNum;


<<EOF>> 	return EOF;
.           { yyerror("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); }//yyerror declared in cgen.h







