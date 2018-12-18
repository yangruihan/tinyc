%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
#define YYSTYPE char *
%}

%token T_Int T_Void T_Return T_Print T_IntConstant
%token T_StringConstant T_Identifier

%left '+' '-'
%left '*' '/'
%right U_neg

%%

Program:
          /* empty */           { }
        | Program FuncDecl      { }
        ;

FuncDecl:
        RetType FuncName '(' Args ')' '{' VarDecls Stmts '}'
                               { printf("ENDFUNC\n\n"); }
        ;

RetType:
          T_Int         { }
        | T_Void        { }
        ;

FuncName:
          T_Identifier  { printf("FUNC @%s:\n", $1); }
        ;

Args:
          /* empty */   { }
        | _Args         { printf("\n\n"); }
        ;

_Args:
          T_Int T_Identifier                  { printf("arg %s", $2); }
        | _Args ',' T_Int T_Identifier        { printf(", %s", $4); }
        ;

VarDecls:
          /* empty */           { }
        | VarDecls VarDecl ';'  { printf("\n\n"); }
        ;

VarDecl:
          T_Int T_Identifier                  { printf("var %s", $2); }
        | VarDecl ',' T_Identifier            { printf(", %s", $3); }
        ;

Stmts:
          /* empty */   { }
        | Stmts Stmt    { }
        ;

Stmt:
          AssignStmt    { }
        | PrintStmt     { }
        | CallStmt      { }
        | ReturnStmt    { }
        ;

AssignStmt:
        T_Identifier '=' Expr ';'       { printf("pop %s\n\n", $1); }
        ;

PrintStmt:
        T_Print '(' T_StringConstant PActuals ')' ';'
                                        { printf("print %s\n\n", $3); }
        ;

PActuals:
          /* empty */           { }
        | PActuals ',' Expr     { }
        ;

CallStmt:
        CallExpr ';'            { printf("pop\n\n"); }
        ;

CallExpr:
        T_Identifier '(' Actuals ')'    { printf("$%s\n", $1); }
        ;

Actuals:
          /* empty */           { }
        | Expr PActuals         { }
        ;

ReturnStmt:
          T_Return Expr ';'     { printf("ret ~\n\n"); }
        | T_Return ';'          { printf("ret\n\n"); }
        ;

Expr:
          Expr '+' Expr         { printf("add\n"); }
        | Expr '-' Expr         { printf("sub\n"); }
        | Expr '*' Expr         { printf("mul\n"); }
        | Expr '/' Expr         { printf("div\n"); }
        | '-' Expr %prec U_neg  { printf("neg\n"); }
        | T_IntConstant         { printf("push %s\n", $1); }
        | T_Identifier          { printf("push %s\n", $1); }
        | CallExpr              { }
        | '(' Expr ')'          { }
        ;

%%

int main() {
    return yyparse();
}
