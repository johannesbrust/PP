# -------------------------- example_1 ------------------------------------
#
#  Script to test "Polynomial Pools Sparse (PP SP)" and
#  the COMP (Combinatorial orthogonal matching pursuit) algorithms
#  to decode a set of pooled samples (e.g., corresponding to a COVID test)
#
#  In this example q=4, d=3, k=2 (i.e., order 4, dimension 3)
#  N:         q^d            = 64 
#  Pool size: q^(d-1)        = 16 
#  Tests:     q*(k*(d-1)+1)  = 20
#
#  Design for up to k=2 positive samples
#
# -------------------------------------------------------------------------


# include Algorithm and Test matrix
include("../ALGS/PP.jl")
include("../ALGS/COMP_PT.jl")


# Call PP
p = 2          # Prime number
n = 2          # Prime power exponent
q = p^n        # Prime power
d = 3          # Dimension
N = q^d        # Samples
m = q^(d-1)    # Pool size
k = 2          # Number positives
M=PP( q, d, k )


# Set positives, 2,13
x = zeros(Int,N)
x[2]=1
x[13]=1

# Observed test outcomes
y = sum(M[:,x.==1], dims=2).>0

# % Call decoding algorithm
pars = (print=1, def=sum(x))

(x_c,out) = COMP_PT(M,y,pars);
 
# Compare decoded value
err = norm(x-x_c);