%{
#define YYSTYPE char *
#include "y.tab.h"
int cur_line = 1;
void yyerror(const char* msg);
void unrecognized_char(char c);
void unterminate_string();
#define _DUPTEXT { yylval = strdup(yytext); }
%}

WHITESPACE      ([ \t\r\a]+)
SINGLE_COMMENT1 ("//"[^\n]*)
SINGLE_COMMENT2 ("#"[^\n]*)
OPERATOR        ([-/+*%=,;!<>(){}])
INTEGER         ([0-9]+)
UNTERM_STRING   (\"[^\"\n]*)
STRING          (\"[^\"\n]*\")
IDENTIFIER      ([A-Za-z_][A-Za-z0-9_]*)

%%

{WHITESPACE}      { }
{SINGLE_COMMENT1} { }
{SINGLE_COMMENT2} { }

{OPERATOR}      { return yytext[0]; }
"int"           { return T_Int;     }
"void"          { return T_Void;    }
"return"        { return T_Return;  }
"print"         { return T_Print;   }

{INTEGER}       { _DUPTEXT; return T_IntConstant;    }
{STRING}        { _DUPTEXT; return T_StringConstant; }
{IDENTIFIER}    { _DUPTEXT; return T_Identifier;     }

\n              { cur_line ++; }

{UNTERM_STRING} { unterminate_string();         }
.               { unrecognized_char(yytext[0]); }

%%

int yywrap(void) {
    return 1;
}

void unrecognized_char(char c) {
     char buf[32] = "Unrecognized character: ?";
     buf[24] = c;
     yyerror(buf);
}

void unterminate_string() {
     yyerror("Unterminate string constant");
}

void yyerror(const char* msg) {
     printf("Error at line %d:\n\t%s\n", cur_line, msg);
     exit(-1);
}
