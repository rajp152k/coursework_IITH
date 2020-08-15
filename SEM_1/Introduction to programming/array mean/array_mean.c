#include <stdio.h>
#include <stdlib.h>

float mean(float* a,int size);

int main()
{
  int size;
  float *a;

  printf("enter the size of the array being input  ");
  scanf("%d",&size);

  a = (float*)calloc(size,sizeof(float));

  int i;
  for(i=0;i<size;i++)
  {
  printf("enter value of a[%d]  ",i);
  scanf("%f",&a[i]);
  }

  printf("\n");

  printf("The mean is %f\n",mean(a,size));

  free(a);
  return 0;

}

float mean(float* a,int size)
{
  float sum = 0;
  int i;
  for(i=0;i<size;i++)
  {
    sum += a[i];
  }

  return (sum/size);
}
