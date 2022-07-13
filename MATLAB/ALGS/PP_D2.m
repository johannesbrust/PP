function [ XIDX, YIDX, SM ] = PP_D2(gfp, p, n, k, geo )
%PP_D2: Polynomial Pools Dimension d=2. Algorithm to construct a
% pooling matrix design using the special polynomial that reduces to
% a line:
%
% y = b x + a,
%
% where b, a and x are all elements of a Galois-field
% of order p^n. This method can be used to construct the incidence 
% matrix of a finite projective geometry or an affine plane
% (i.e., this method includes designs "PP_PG", which are the 
%   projective geometry)
%
% INPUTS:
%
% gfp: Galois field 
% p: Prime number 
% n: Prime power (pool size: m=p^n)
% d: Dimension (total sample size: N=m^d)
% k: Matrix is floor(k/(d-1)) disjunct on output
% geo: 1 (affine geometry), 2 (projective geometry)
%
% OUTPUTS:
% XIDX: Nonzero indices in the rows of a pooling design
% YIDX: Nonzero indices in the columns of a pooling design
% SM: Dimensions of the pooling matrix, SM(1)=rows, SM(2)=cols, SM(3)=nnz
%--------------------------------------------------------------------------
% 04/26/22, J.B., Initial implementation
% 05/20/22, J.B., Preparation for release
% 06/07/22, J.B., Further preparations

% Branch computations depending prime number type
pnum = 0;
if(n==1)
    pnum=1;
end

% Invoke a "Galois field".
% Constructing of pools is done along lines in the field
%gfp=gf(p,n);

% Variables to setup lines
% Initializing slopes
s = 0:(p^n-1);
ls = length(s);

% Defining quantities for sparse representation
k1  = k+1;

XV = repmat(s',ls,1);
OV = ones(length(XV),1);
BV = reshape(repmat(s,ls,1),ls*ls,1);
SV = (0:ls*ls-1)';

% Sparse indices for the affine geometry
XIDX_ = zeros(ls*ls*k1,1); 
YIDX_ = zeros(ls*ls*k1,1); 

% Sparse indices for the projective geometry
if k < ls
    psize = ls-k;
else
    psize = ls+1;
end
XIDX1 = zeros(ls*(ls+1)*k1+psize,1); 
YIDX1 = zeros(ls*(ls+1)*k1+psize,1);

IDXlv2 = 0:ls*ls-1;
IDXlv = 0:ls-1;

for i=0:k-1
    
    % Sparse computations. Defined on vectors

    AV = s(i+1).*OV;
    
    if pnum==0
        AXV = gfp.dmult(AV,XV);
        YV = gfp.add(AXV,BV);
    else
        AXV = mod(AV.*XV,p);
        YV = mod(AXV+BV,p);
    end
    
    % Affine plane
    XIDX_(i*ls*ls + IDXlv2 + 1) = i*ls + BV + 1;
    YIDX_(i*ls*ls + IDXlv2 + 1) = SV(sub2ind([ls,ls],XV+1,YV+1)) + 1;
    
    % Projective Geometry
    % Based on appending to an affine plane
    XIDX1(i*ls*ls + i*ls + IDXlv2 + 1) = XIDX_(i*ls*ls + IDXlv2 + 1);
    YIDX1(i*ls*ls + i*ls + IDXlv2 + 1) = YIDX_(i*ls*ls + IDXlv2 + 1);
    
    XIDX1(i*ls*ls + i*ls + ls*ls + IDXlv + 1) = i*ls + IDXlv + 1;
    YIDX1(i*ls*ls + i*ls + ls*ls + IDXlv + 1) = ls*ls + i  + 1;
    
end


% Singular layer (i.e., infty slopes)
XIDX_(ls*ls*k + IDXlv2 + 1) = ls*k + BV + 1;
YIDX_(ls*ls*k + IDXlv2 + 1) = SV(sub2ind([ls,ls],BV+1,XV+1)) + 1;

% Singular layer for projective geometry (i.e., infty slopes)
XIDX1(ls*ls*k + k*ls + IDXlv2 + 1) = XIDX_(k*ls*ls + IDXlv2 + 1);
YIDX1(ls*ls*k + k*ls + IDXlv2 + 1) = YIDX_(k*ls*ls + IDXlv2 + 1);

XIDX1(ls*ls*k + k*ls + ls*ls + IDXlv + 1) = k*ls + IDXlv + 1;
YIDX1(ls*ls*k + k*ls + ls*ls + IDXlv + 1) = ls*ls + k  + 1;
    

% Singelton "projective geometry" (this geometry is less regular,
% which is why the matrix is extended with an identity block
% to ensure identifying upto k positives
if k < ls
    XIDX1(ls*ls*k + k*ls + ls*ls + ls + (1:(ls - k))) = ls*(k) + ls + (1:(ls-k));
    YIDX1(ls*ls*k + k*ls + ls*ls + ls + (1:(ls - k))) = ls*ls + ((k+1+1):(ls+1));
    tsize = ls-k;
else
    XIDX1(ls*ls*k + k*ls + ls*ls + ls + (1:(ls + 1))) = ls*(k) + ls + 1;
    YIDX1(ls*ls*k + k*ls + ls*ls + ls + (1:(ls + 1))) = ls*ls + (1:(ls+ 1));
    tsize = 1;
end

% Sparse matrices
SM = zeros(1,3);
if geo == 1    
    % Affine geometry
    XIDX = XIDX_;
    YIDX = YIDX_;
    SM(1) = (k+1)*ls;
    SM(2) = ls*ls;
    SM(3) = (k+1)*ls*ls;    
else
    % Projective geometry
    XIDX = XIDX1;
    YIDX = YIDX1;
    SM(1) = (k+1)*ls+tsize;
    SM(2) = ls*ls+ls+1;
    SM(3) = (k+1)*(ls+1)*ls;
    if k >= ls; SM(3) = SM(3) + ls+1; else SM(3) = SM(3) + tsize; end;    
end


%M = sparse(XIDX,YIDX,1,SM(1),SM(2)); 