%{
#include <stdio.h>
void yyerror(char* s);
%}

%token ONE ZERO

%%

start:	 	binary		{printf(" --> base_10 --> %d\n",$$);};

binary: 	binary digit 	{$$ = $1*2 + $2;}
	  		| digit 		{$$ = $1;}
			;

digit:		ONE 			{$$=$1;}
	 		|ZERO 			{$$=$1;}
			;
%%

int main(){
while(yyparse());
return 0;
}

void yyerror(char*s){
	fprintf(stdout,"error detected : %s",s);
	}
