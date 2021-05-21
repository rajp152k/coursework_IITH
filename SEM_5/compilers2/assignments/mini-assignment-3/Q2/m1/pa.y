%{
#include <stdio.h>
#include <math.h>
void yyerror(char* s);

int fraction=0;
float ans;
%}

%token ONE ZERO POINT


%%

start:	 	
	 binary POINT fractional{
	 			ans = ($3*1.0) / (2<<fraction)	;
	 			ans += $1; 
				printf(" --> base_10 -->\n %f\n",ans);

				}
	| binary{
				printf(" --> base_10 -->\n %d\n",$1);
				}

binary: 	binary digit 	{$$ = $1*2 + $2;}
	  		| digit 		{$$ = $1;}
			;

fractional:	fractional digit {fraction++;$$ = $1*2 + $2;}
			| digit  	   {$$ = $1;}
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
