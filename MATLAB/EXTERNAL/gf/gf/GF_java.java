package gf;

import java.lang.reflect.Array;

// This file is not intented to be used directly, it will be
// called by Matlab
//
// Written by Samuel Cheng (Sept 13, 2011)
//
// If you need to contact me, just google :)
//
// Java speed up for simple gf operation 
// Note that computation table is input from outside

public class GF_java {
  int gfat[][];
  int gfmt[][];
  int gfst[][];
  int gfdt[][];
  
  public GF_java(int[][] at, int [][]mt, int[][] st, int dt[][])
  {
	  gfat=at;
	  gfmt=mt;
	  gfst=st;
	  gfdt=dt;
  }
  
  
  public int [][] mat_dot(int [][]a, int [][]b)
  {
    int [][]x;
    assert(a.length==b.length);
    assert(a[0].length==b[0].length);
    x=new int[a.length][a[0].length];

    for (int i=0;i<a.length;i++)
    	for (int j=0;j<a[0].length;j++)
    		x[i][j]=gfmt[a[i][j]][b[i][j]];
    return x;
  }

  public int [][] mat_dotdiv(int [][]a, int [][]b)
  {
    int [][]x;
    assert(a.length==b.length);
    assert(a[0].length==b[0].length);
    x=new int[a.length][a[0].length];

    for (int i=0;i<a.length;i++)
    	for (int j=0;j<a[0].length;j++)
    		x[i][j]=gfdt[a[i][j]][b[i][j]];
    return x;
  }

  public int [][] mat_sub(int [][]a, int [][]b)
  {
    int [][]x;
    assert(a.length==b.length);
    assert(a[0].length==b[0].length);
    x=new int[a.length][a[0].length];

    for (int i=0;i<a.length;i++)
    	for (int j=0;j<a[0].length;j++)
    		x[i][j]=gfst[a[i][j]][b[i][j]];
    return x;
  }

  public int [][] mat_add(int [][]a, int [][]b)
  {
    int [][]x;
    assert(a.length==b.length);
    assert(a[0].length==b[0].length);
    x=new int[a.length][a[0].length];

    for (int i=0;i<a.length;i++)
    	for (int j=0;j<a[0].length;j++)
    		x[i][j]=gfat[a[i][j]][b[i][j]];
    return x;
  }
  
  public int rank(int [][]a)
  {
	  int [] rrank=new int [1];
	  diag(a,rrank);
	  return rrank[0];
  }
  
  public int [][] inverse (int [][]mat)
  {
	  
	  int [][] out=new int[mat.length][mat.length];
	  int [][] tmp;
	  if (mat.length!=mat[0].length)
		  return out; // do nothing
	  int [] r=new int[1];
	  tmp=diag(mat,r);
	  if (r[0] < mat.length)
		  return out; // do nothing
	  for (int i=0;i<mat.length;i++)
		  for (int j=0;j<mat.length;j++)
			  out[i][j]=tmp[i][j+mat[0].length];
//	  System.out.print(mat.length+" "+mat[0].length);
//	  out=tmp;
	  return out;
	  
  }
  
  public int[][] diag(int [][]b, int [] return_rank)
  {
	  int [][] a=new int[b.length][b[0].length+b.length];
	  for (int i=0;i<b.length;i++)
	  {
		  a[i][i+b[0].length]=1;
		  for (int j=0;j<b[0].length;j++)
			  a[i][j]=b[i][j];
	  }
	  
	  
	  for (int i=0;i<a.length;i++)
	  {
		  // rotate to row with non-zero pivot
		  // if not succeed, return rank
		  int pivot=a[i][i];
//		  System.out.print("pivot " + pivot);
		  if (pivot==0)
		  {
			  int k;
			  for (k=0;k<a.length && a[i][k]==0;k++);
			  if (k>=a.length) // search all already
			  {
				  return_rank[0]=i;
				  return a;
				  
			  }
			  else // (a[i][k]!=0)
			  {
//				  System.out.print("i:" + i + " k: " + k);
				  rotate_row(a,i,k);
				  pivot=a[i][i];
			  }
//			  else
//			  {
//				  return_rank[0]=i;
//				  return a;
//			  }
		  }
		  // divide whole row by pivot
		  for (int j=0;j<a[0].length;j++) 
		  {
			  a[i][j]=gfdt[a[i][j]][pivot];
		  }
		  // subtract all remaining matrix with scaled row
		  for (int i2=0;i2<i;i2++)
		  {
			  int s=a[i2][i];
			  for (int j=i;j<a[0].length;j++)
			  a[i2][j]=gfst[a[i2][j]][gfmt[s][a[i][j]]];
		  }
		  for (int i2=i+1;i2<a.length;i2++)
		  {
			  int s=a[i2][i];
			  for (int j=i;j<a[0].length;j++)
			  a[i2][j]=gfst[a[i2][j]][gfmt[s][a[i][j]]];
		  }
	  }
	  return_rank[0]=a.length;
	  return a;
  }
  
  public void rotate_row(int[][] a, int i, int k) {
	  int []b=new int[a[0].length];
	  for (int j=0;j<a[0].length;j++)
		  b[j]=a[i][j];
	  for (int j=0;j<a[0].length;j++)
		  a[i][j]=a[k][j];
	  for (int j=0;j<a[0].length;j++)
		  a[k][j]=b[j];
}


public int [][] mat_mult(int [][]a, int[][]b)
  {
    assert(a[0].length==b.length);
    int [][] x;
    x=new int[a.length][b[0].length];
    
    for (int i=0;i<a.length;i++)
    	for (int j=0;j<b[0].length;j++)
    	{
    		int sum=0;
    		for (int k=0;k<a[0].length;k++)
    		{
    			int id1=a[i][k];
    			int id2=b[k][j];
//    			System.out.println("k="+k+": "+id1+" * "+id2);
    			int nid=gfmt[id1][id2];
    			sum=gfat[sum][nid];
    		}
    		x[i][j]=sum;
    	}		
    return x;
    
  }

	public int[] vec_conv(int []a, int []b)
	{
		int [] x;
		x=new int[a.length + b.length-1];
		
		for (int i=0;i<a.length;i++)
			for (int j=0;j<b.length;j++)
			{
				int nid=gfmt[a[i]][b[j]];
				x[i+j]=gfat[x[i+j]][nid];
			}
		return x;
	}
	
	public Object [] vec_deconv(int []b, int []a)
	{
		int [] rem = new int[a.length-1];
		Object [] obj = new Object[2];
		int [] q;
		if (b.length < a.length)
		{
			q=new int[1];
			q[0]=0;
			
			for (int i=0;i<b.length;i++)
				rem[rem.length-1-i]=b[b.length-1-i];

			obj[0]=q;
			obj[1]=rem;
			return obj;
		}
		q=new int[b.length-a.length+1];
		for (int i=0;i<b.length-a.length+1;i++)
		{
			q[i]=gfdt[b[i]][a[0]];
			for (int j=1;j<a.length;j++)
			{
				int tmp=gfmt[q[i]][a[j]];
				b[i+j]=gfst[b[i+j]][tmp];
			}
		}
		
		for (int i=0;i<rem.length;i++)
			rem[rem.length-1-i]=b[b.length-1-i];
		obj[0]=q;
		obj[1]=rem;
		return obj;
	}
	
}