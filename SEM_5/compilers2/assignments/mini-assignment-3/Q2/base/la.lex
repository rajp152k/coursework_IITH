%{
#include <stdio.h>
#include "y.tab.h"

int yylval;
%}

%%

1		{
			yylval = 1;
			return ONE;
		};
0		{ 	
			yylval = 0;
			return ZERO;
		};

\n 		return 0;

%%

int yywrap(){
return 1;
}
