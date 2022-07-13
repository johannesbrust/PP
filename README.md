# PT
**Algorithms for COVID-19 Pooling Tests (PT)**

MATLAB implementations of algorithms from the article

"COVID-19 Pooling Matrix Designs", J.J. Brust (2021), IMAGE (TBD)

Content:
  * ALGS/
    - SDD_PT.m (Shifted-Diagonal-Design (SDD): {Algorithm to construct pooling matrix M})
    - SCOMP_PT.m (Sequential Combinatorial Orthogonal Matching Pursuit (SCOMP): {Decoding Algorithm})
    - DD_PT.m (Definite Defectives (DD): {Decoding Algorithm}
    - COMP_PT.m (Combinatorial Orthogonal Matching Pursuit (COMP): {Decoding Algorithm})
  * TESTS/
    - test_Pooling.m (Example pooling test with m=24, k=7 using SDD and COMP)
    - test_SDD.m (Small test for correctness of SDD)
    - test_COMP_PT_1.m (Test of COMP on an example matrix from Wikipedia)

## Example
You can run an example test from within the /TESTS folder. On
the MATLAB command prompt:

`> test_Pooling`

```
----------- SDD Algorithm ----------- 
Problem Size 
Pools (m):                     24 
Multiplicity (k):              7 
Expected tests (m*k):          168 
OUTPUT(S):############## 
Time (constr):        3.744661e-03 


----------- COMP Algorithm ----------- 
Problem Size 
Tests:                 168 
Patients:              576 
Input Expct. Positive: 5 
OUTPUTS:################ 
Time (search):         5.778742e-03 
Positive items:        5 
######################## 
Identified Indices:    2 
Identified Indices:    3 
Identified Indices:    13 
Identified Indices:    75 
Identified Indices:    381
