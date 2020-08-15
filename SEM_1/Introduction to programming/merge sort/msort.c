#include <stdio.h>
#include <stdlib.h>
#include <float.h>

void m_sort(float* a,int l,int r);             //the recursively defined merge sort
void merge(float* a,int l, int m, int r);      //merges 2 sorted subarrays(combining stage)
                                               //a[l to m] and a[m+1 to r]
int main()
{
  int size;
  float *a;
  printf("enter the size of the array    ");
  scanf("%d",&size);
  printf("\n");

  a = (float*)calloc(size,sizeof(float));

  int i;
  for(i=0;i<size;i++)
  {
    printf("enter a[%d]   ",i);
    scanf("%f",&a[i]);
  }

  m_sort(a,0,size-1);

  printf("\n");

  for(i=0;i<size;i++)
  {
    printf("a[%d] = %f\n",i,a[i]);
  }

  free(a);
  return 0;
}


//by the divide-conquer-combine strategy... used recursively.
void m_sort(float* a,int l,int r)
{
  if(l==r)
  {
      return;
  }
  int m;
  m = (l+r)/2;  //dividing

  m_sort(a,l,m);     //conquering separately
  m_sort(a,m+1,r);   //conquering separately

  merge(a,l,m,r);    //combining
}

void merge(float* a,int l, int m, int r)
{
  int nl;
  int nr;
  nl = m-l+1;
  nr = r-m;

  float *left;
  float *right;
  left = (float*)calloc(nl+1,sizeof(float));
  right = (float*)calloc(nr+1,sizeof(float));

  int i;
  int k = 0;
  for(i=l;i<=m;i++)
  {
    left[k] = a[i];
    k++;
  }
  k=0;
  for(i=m+1;i<=r;i++)
  {
    right[k] = a[i];
    k++;
  }

  //placing a sentinel for ideal termination
  left[nl] = FLT_MAX;
  right[nr] = FLT_MAX;

  int p,q;
  p = 0;
  q = 0;

  for(i=l;i<=r;i++)
  {
    if(left[p]<right[q])
    {
      a[i] = left[p];
      p++;
    }
    else
    {
      a[i] = right[q];
      q++;
    }
  }

  free(left);
  free(right);
}
