function [ XIDX, YIDX, SM, out ] = PP( p, n, d, k, pars )
%PP "Polynomial Poolings" (for Pooling Tests)
%
% Supports affine and projective geometries and compressed constructions
% using prime powers
%   
% Algorithm for generating the indicies for a sparse pooling matrix M, 
% in which each of the 1:(p^(n))^d individual samples 
%
%   * is in at most k tests
%   * each test contains at most (p^n)^(d-1) different samples
%   * each pair of samples appears at most (d-1) times.
%
% NOTE: The pool size is a prime power m = p^n,
%   where p is prime and n > 0. For finite field computations 
%   this method uses an external function to construct finite fields
%
% The matrix is floor(k/(d-1)) disjunct and can exactly specify up to this
% number of defectives in a pooling algorithm.
%
% The sparse matrix can be formed (if so desired) by:
%
%   M = sparse(XIDX,YIDX,SM(1),SM(2));
%
% Pooling test problem:
%
%   M * x = y, (goal to recover x given known M and y)
%
% where [t,n]=size(M), t<n, M is a binary matrix with tests (rows)
% and samples (sometimes called items) in its columns.
%
% INPUTS:
% p: Prime number
% n: exponent 
% d: dimension (N = (p^n)^d)
% k: Characteristic up to how many positives to identify
% pars: Struct with optional parameters
%   pars.print: Flag to print infos
%   pars.geo = 1 (affine geometry)
%   pars.geo = 2 (projective geometry)
%
% OUTPUTS:
% XIDX: Nonzero indices in the rows of a pooling design
% YIDX: Nonzero indices in the columns of a pooling design
% SM: Dimensions of the pooling matrix, SM(1)=rows, SM(2)=cols, SM(3)=nnz
% out: Struct with output values
%   out.time: Computational time
%--------------------------------------------------------------------------
% 05/12/22, J.B., Preparation for release 

ctime = tic;

% Check inputs
if d<2
    error('Input error: Need 2 <= "dimension (d)" \n');
end
% Check inputs
if isprime(p)==0
    error('Input error: Need prime number p \n');
end
% Check inputs
if floor((p^n)/(d-1))<k || k < 1
    error('Input error: Need 1 <= k <= "floor(q/(d-1))" \n');
end

% Retrieve optional parameter values
if isfield(pars,'print')
    printInfo = pars.print;
else
    printInfo = 0;
end
if isfield(pars,'geo')
    geo = pars.geo;
else
    geo = 1;
end

kk = k*(d-1);
dm1 = d-1;
if printInfo == 1

    m = (p^n)^(dm1);
    fprintf('\n----------- PP Algorithm ----------- \n'); % 41 chars    
    fprintf('Problem Size \n');
    fprintf('Samples (N):                   %i \n',m*(p^n));
    fprintf('Pool size (m):                 %i \n',m);
    fprintf('Dimension (d):                 %i \n',d);
    fprintf('Characteristic (k):            %i \n',k);
    fprintf('Expected tests:                %i \n',p^n*(dm1*k+1));
    
end

% Invoke a "Galois field".
% Constructing of pools is done along lines in the field
gfp=gf(p,n);

% Construct the indices for the sparse matrices depending on the
% dimension
if d == 2
    [ XIDX, YIDX, SM ] = PP_D2( gfp, p, n, kk, geo );
else    
    [ XIDX, YIDX, SM ] = PP_D( gfp, p, n, d, kk );         
end

% The matrix can be constructed like
% M = sparse(XIDX,YIDX,1,SM(1),SM(2));

out.time = toc(ctime);

if printInfo == 1
    
    fprintf('OUTPUT(S):############## \n');
    fprintf('Time (constr):        %i \n',out.time);    
    fprintf('\n');
end
