# PP
**Polynomial Pools**

Matlab and Julia implementations from

"Effective Matrix Designs for COVID-19 Group Testing", D. Brust and J.J. Brust (2022)

Content:
  * MATLAB/
    * ALGS/
    * AUXILIARY/
    * EXAMPLES/
    * EXTERNAL/
  * JULIA/  

Notes: The Matlab codes use external functions from `[1]` for computations in finite fields.
The Julia code uses `[2]` for respective calculations.
    
## Example(s)

### Matlab
You can run a relatively small Matlab example from within MATLAB/EXAMPLES/

```
>> example_1

----------- PP Algorithm ----------- 
Problem Size 
Samples (N):                   64 
Pool size (m):                 16 
Dimension (d):                 3 
Characteristic (k):            2 
Expected tests:                20 
OUTPUT(S):############## 
Time (constr):        1.458367e-01 


----------- COMP Algorithm ----------- 
Problem Size 
Tests:                 20 
Samples:               64 
Input Expct. Positive: 2 
OUTPUTS:################ 
Time (search):         4.176795e-03 
Positive items:        2 
######################## 
Identified Indices:    2 
Identified Indices:    13 
```

A larger example is given by ``>> example_2``

### Julia
Likewise, you can run a Julia code

```
In[85]: runfile('example_3.py')

********* Linear Systems Solver ********************  
*         Alg: PLSS (Python 3.9)                      
*         Size: m = 10, n = 10                        
*         tol = 0.00000100                                 
*         Maxit = 500                                  
****************************************************  

Iter 	 norm(Res) 	 norm(pk)    
0 	 1.4468e+02 	 1.2560e+01   
1 	 9.0747e+01 	 8.7137e+00  
2 	 5.9964e+01 	 6.8153e+00  
3 	 4.1940e+01 	 5.5617e+00  
4 	 2.9450e+01 	 4.7588e+00  
5 	 2.0575e+01 	 4.0649e+00  
6 	 1.3862e+01 	 3.5855e+00  
7 	 8.8485e+00 	 3.1817e+00  
8 	 4.7557e+00 	 2.7828e+00  
9 	 1.5912e+00 	 2.0086e+00  
10 	 8.3808e-05 	 5.2023e-06  

********* Summary **********************************  
*         Conv: 1                                    
*         Time (s): 0.00                             
*         norm(Res) = 0.0000                           
*         Iter = 12                                   
*         Num. mult. = 25                             
**************************************************** 
```

## Cite
You can cite this work as (bibtex)

```
@TechReport{pp22,
  author      = {David Brust and Johannes J. Brust},
  title       = {Effective Matrix Designs for COVID-19 Group Testing},
  institution = {Mathematics Department, University of California, San Diego, CA},
  type        = {Technical Report},
  year        = {2022},
  url         = {TBD}
}
```

## Reference codes
[1] S. Cheng, A toolbox for simple finite field operations. https://www.mathworks.com/matlabcentral/fileexchange/32872-a-toolbox-for-simple-finite-field-operation, July 7, 2022.

[2] T. Kluck, GaloisFields.jl - finite fields for Julia. https://github.com/tkluck/GaloisFields.jl, July 7, 2022
