%-------------------------- example_1 ------------------------------------%
%
% Script to test "Polynomial Pools Sparse (PP SP)" and
% the COMP (Combinatorial orthogonal matching pursuit) algorithms
% to decode a set of pooled samples (e.g., corresponding to a COVID test)
%
% In this example q=4, d=3, k=2 (i.e., order 4, dimension 3)
% N:         q^d            = 64 
% Pool size: q^(d-1)        = 16 
% Tests:     q*(k*(d-1)+1)  = 20
% 
% Design for up to k=2 positive samples
%
%-------------------------------------------------------------------------%
% 07/13/22, J.B., Preparation for release

clc;
clear;

% Adding paths to Algorithm and test matrix
addpath('../ALGS');
addpath('../AUXILIARY');

external_ff_path = '../EXTERNAL/gf/gf';
java_path_setup_SCRIPT;

% Call PP
pars.print=1;
p = 2;          % Prime number
n = 2;          % Prime power exponent
q = p^n;        % Prime power
d = 3;          % Dimension
N = q^d;        % Samples
m = q^(d-1);    % Pool size
k = 2;          % Number positives
[X,Y,dm]=PP( p, n, d, k, pars);

M = sparse(X,Y,1,dm(1),dm(2));

% Set positives, 2,13
x = zeros(N,1);
x(2)=1;
x(13)=1;

% Observed test outcomes
y = (sum(M(:,(x==1)),2)>0);

% Call decoding algorithm
pars2.print = 1;
pars2.d = sum(x);

[x_c,out2] = COMP_PT((M>0),y,pars2);
 
% Compare decoded value
err = norm(x-x_c);
