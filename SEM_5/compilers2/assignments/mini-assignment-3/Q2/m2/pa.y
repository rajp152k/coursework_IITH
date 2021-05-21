%{
#include <stdio.h>
#include <math.h>
void yyerror(char* s);

%}
%token POINT
%token <int> ONE ZERO 

%type <int> start;
%type <int> binary;
%type <int> digit;
%type <float> fractional;
%%

start:	 	
	 binary POINT fractional{
	 			ans = $1 + $3/2;
				printf(" --> base_10 -->\n %f\n",ans);

				}
	| binary{
				printf(" --> base_10 -->\n %d\n",$1);
				}

binary: 	binary digit 	{$$ = $1 + $2*1.0/2;}
	  		| digit 		{$$ = $1;}
			;

fractional:	fractional digit {fraction  = ;$$ = $1*2 + $2;}
			| digit  	   	 {$$ = $1;}
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
