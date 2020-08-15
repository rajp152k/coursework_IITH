#include <stdio.h>
#include <stdlib.h>

int partitioner(float* a,int l,int r)
{
  float t;
  int i = l-1;
  int j;
  for(j=l;j<r;j++)
  {
    if(a[j]<=a[r])
    {
      i++;
      t = a[i];
      a[i] = a[j];
      a[j] = t;
    }
  }
  t = a[i+1];
  a[i+1] = a[r];
  a[r] = t;

  return (i+1);
}


void q_sort(float* a,int l,int r)
{
  if(l<r)
  {
  int m = partitioner(a,l,r);

  q_sort(a,l,m-1);
  q_sort(a,m+1,r);
  }
}

int main()
{
  int size;
  printf("\nenter the size of the array    ");
  scanf("%d",&size);

  float* a;
  a = (float*)calloc(size,sizeof(float));

  int i;
  for(i=0;i<size;i++)
  {
    printf("enter a[%d]   ",i);
    scanf("%f",&a[i]);
  }
  printf("\n");

  q_sort(a,0,(size-1));

  for(i=0;i<size;i++)
  {
    printf("a[%d] = %f \n",i,a[i]);
  }
  printf("\n");

  return 0;
}
