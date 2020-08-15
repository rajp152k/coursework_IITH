#include <stdio.h>
#include <string.h>


int main()
{

  char s[100];
  printf("enter the string to be observed\n");
  fgets(s,100,stdin);

  int d = 1;
  int i = 0;
  while((i < (strlen(s)/2)) && (d == 1) )
  {
    if(s[i] != s[strlen(s)-i-2])
    {
      d = 0;
    }
    i++;
  }

  if(d == 0)
  {
    printf("it's not a palindrome -->    :-/ \n");
  }

  else
  {
    printf("it's a palindrome -->    :-)  \n");
  }

  return 0;
}
