# PP
**Polynomial Pools**

Matlab and Julia implementations from

"Effective Matrix Designs for COVID-19 Group Testing", D. Brust and J.J. Brust (2022),
[[Article](https://www.medrxiv.org/content/10.1101/2022.08.23.22279137v1 "Technical Report")]

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
Likewise, in the Julia REPL, navigate to the JULIA/EXAMPLES folder. 
Run the following from within the folder (tested with Julia 1.6.5):

```
julia> include("../AUXILIARY/setup.jl"); # setup the dependencies

```

Run examples equivalent to MATLAB:

```
julia> include("example_1.jl");

----------- COMP Algorithm ----------- 

Problem Size
Tests:                 20
Samples:               64
Input Expct. Positive: 2 

OUTPUTS:################
Time (search):         5.6223e-5
Positive items:        2
########################
Identified Indices:    [2, 13]

```

## Cite
If this work is useful to you, you can cite this work as (bibtex)

```
@article{brustB23,
  title={Effective matrix designs for COVID-19 group testing},
  author={Brust, David and Brust, Johannes J},
  journal={BMC bioinformatics},
  volume={24},
  number={1},
  pages={26},
  year={2023},
  publisher={Springer}
}
```

## Reference codes
[1] S. Cheng, A toolbox for simple finite field operations. https://www.mathworks.com/matlabcentral/fileexchange/32872-a-toolbox-for-simple-finite-field-operation, July 7, 2022.

[2] T. Kluck, GaloisFields.jl - finite fields for Julia. https://github.com/tkluck/GaloisFields.jl, July 7, 2022
