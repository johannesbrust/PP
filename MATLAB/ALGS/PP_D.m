function [ XIDX, YIDX, SM ] = PP_D( gfp, p, n, d, k)
%PP_D_L: Polynomial Pools Dimension d. Algorithm to construct a
% pooling matrix design using a polynomial to define pools
%
% y = b^(d-1) x_d-1 + ... + b^1 x1 + a,
%
% where b, a and x1, ... , x_{d-1} are all elements of a Galois-field
% of order p^n.
%
% INPUTS:
%
% gfp: Galois field 
% p: Prime number 
% n: Prime power (pool size: m=p^n)
% d: Dimension (total sample size: N=m^d)
% k: Matrix is floor(k/(d-1)) disjunct on output
%
% OUTPUTS:
% XIDX: Nonzero indices in the rows of a pooling design
% YIDX: Nonzero indices in the columns of a pooling design
% SM: Dimensions of the pooling matrix, SM(1)=rows, SM(2)=cols, SM(3)=nnz
%--------------------------------------------------------------------------
% 04/26/22, J.B., Initial implementation
% 05/20/22, J.B., Preparation for release
% 06/08/22, J.B., Improvement by computing indices without
%                       indexing multidimensional arrays
% 06/29/22, J.B., Testing the singular layer

dm1 = d-1;

pnum = 0;
if(isprime(p^n))
    pnum=1;
end

% Variables to setup lines
v = 0:(p^n-1);
lv = length(v);

% Generate slopes and x combinations
xv = unique(nchoosek(repmat(v,1,dm1),dm1),'rows');

% Number of unique combinations (length)
lx = size(xv,1);
lxv = lx*lv;

% Defining quantities for sparse representation
% Depends on the dimension

% Degree to which matrix is k-disjunct
k1 = k + 1;

% Vectorized containers
XV = repmat(xv,lv,1);
OV = ones(dm1,1);

% Polynomial in x values 
% (x_{d-1})^(d-1) + ... + x1^1
XVP = XV*(((p^n)*OV).^((dm1:-1:1)'));

BV = reshape(repmat(v,lx,1),lxv,1);
SV = (0:lv^d-1)';

% X and Y indices
XIDX = zeros(lxv*k1,1); 
YIDX = zeros(lxv*k1,1); 

IDXlv2 = 0:lxv-1;

if p^n == k; eidx = k-1; else eidx = k; end;

for i=0:eidx % lx
    
    % Sparse computations. Defined on vectors
        
    if pnum==0
        
        % Computing polynomial pools using the 
        % Galois-Field
        AV0 = v(i+1).*OV;
        AV = AV0;
        for j=2:dm1
            AV(j:dm1)= gfp.dmult(AV(j:dm1),AV0(j:dm1));
        end
        
        AXV = gfp.mult(XV,AV);
                
        YV = gfp.add(AXV,BV);
        
    else
        
        % Polynomial pools using modulus arithmetic and
        % prime numbers
        AV0 = v(i+1).*OV;
        AV = AV0;
        for j=2:dm1
            AV(j:dm1)= mod(AV(j:dm1).*AV0(j:dm1),p);
        end
        
        AXV = mod(XV*AV,p);
                
        YV = mod(AXV+BV,p);
        
    end
        
    % x values   
    XIDX(i*lxv + IDXlv2 + 1) = i*lv + BV + 1;
    
    % y values
    YIDX(i*lxv + IDXlv2 + 1) = int32(XVP) + int32(YV) + 1;
    
end

% Singular layer (infty slope)
if d==2 && k == p^n
    
    XIDX(k*lv*lv + IDXlv2 + 1) = k*lv + BV + 1;
       
    YIDX(k*lv*lv + IDXlv2 + 1) = SV(:) + 1;
    
elseif d~=2 && k == p^n
    
    XIDX(k*lxv + IDXlv2 + 1) = k*lv + BV + 1;
    
    YIDX(k*lxv + IDXlv2 + 1) = SV(:) + 1;
        
end
    
SM = zeros(1,3);
SM(1) = k1*lv;
SM(2) = lv^d;
SM(3) = lxv*k1;

% Construct a sparse matrix
%M = sparse(XIDX,YIDX,1,SM(1),SM(2));

end

