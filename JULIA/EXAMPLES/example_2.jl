# -------------------------- example_2 ------------------------------------#
#
#  Script to test a "Polynomial Pools (PP)" design and
#  the COMP (Combinatorial orthogonal matching pursuit) algorithms
#  to decode a set of pooled samples (e.g., corresponding to a COVID test)
#
#  This problem is large with N > 100 000. A design based on
#  pool sizes of 49^2 = 2401 (prime power) can be used to correctly 
#  identify up to floor(49/2) = 24 positives
#
#  In this example 10 positives are identified
#
# -------------------------------------------------------------------------#


# include Algorithm and Test matrix
include("../ALGS/PP.jl")
include("../ALGS/COMP_PT.jl")



# Call PP
p = 7;          # Prime number
n = 2;          # Prime power exponent
q = p^n;        # Prime power
d = 3;          # Dimension
N = q^d;        # Samples
m = q^(d-1);    # Pool size
k = 10;         # Number positives (over-estimate positives)
M=PP( q, d, k )



# % Set defectives, 1,10001,20001,...,90001
x = zeros(Int,N)
x[1:10000:100000] .= 1


# Observed test outcomes
y = sum(M[:,x.==1], dims=2).>0


# Call decoding algorithm
pars = (print=1, def=sum(x))

# [x_c,out2] = COMP_PT((M>0),y,pars2);
(x_c,out) = COMP_PT(M,y,pars);

# Compare decoded value
err = norm(x-x_c);