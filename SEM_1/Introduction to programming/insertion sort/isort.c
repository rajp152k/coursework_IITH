#include <stdio.h>
#include <stdlib.h>


void isort(float* arr,int size);

int main()
{
  int size;
  float *a;

  printf("enter the size of the array being input \n");
  scanf("%d",&size);

  a = (float*)calloc(size,sizeof(float));


  int i;
  for(i=0;i<size;i++)
  {
    printf("enter value of a[%d]  ",i);
    scanf("%f",&a[i]);
  }
  printf("\n");

  isort(a,size);

  printf("the sorted array is...\n");
  for(i=0;i<size;i++)
  {
    printf("a[%d] = %f\n",i,a[i]);
  }
free(a);
return 0;
}

void isort(float* arr,int size)
{
  int hold;//stores the value being inserted
  int j;
  for(j=1;j<size;j++)
  {
    hold = arr[j];
    int k;
    k = j-1;
    while((k>=0) && (arr[k]>hold))
    {
      arr[k+1] = arr[k];
      k=k-1;
    }
    arr[k+1] = hold;
  }
}
