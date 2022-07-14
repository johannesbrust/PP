%-------------------------- example_2 ------------------------------------%
%
% Script to test a "Polynomial Pools (PP)" design and
% the COMP (Combinatorial orthogonal matching pursuit) algorithms
% to decode a set of pooled samples (e.g., corresponding to a COVID test)
%
% This problem is large with N > 100 000. A design based on
% pool sizes of 49^2 = 2401 (prime power) can be used to correctly 
% identify up to floor(49/2) = 24 positives
%
% In this example 10 positives are identified
%
%-------------------------------------------------------------------------%
% 07/13/22, J.B., Preparation for release

clc;
clear;

% Adding paths to Algorithm and test matrix
addpath('../ALGS');
addpath('../AUXILIARY');

% Add the path to the functions for the finite field 
external_ff_path = '../EXTERNAL/gf/gf';
java_path_setup_SCRIPT;

% Call PP
pars.print=1;
p = 7;          % Prime number
n = 2;          % Prime power exponent
q = p^n;        % Prime power
d = 3;          % Dimension
N = q^d;        % Samples
m = q^(d-1);    % Pool size
k = 10;         % Number positives (over-estimate positives)
[X,Y,dm]=PP( p, n, d, k, pars);

M = sparse(X,Y,1,dm(1),dm(2));

% Set defectives, 1,10001,20001,...,90001
x = zeros(N,1);
x(1:10000:100000) = 1;

y = (sum(M(:,(x==1)),2)>0); %.*ones(t2,1);

% Call decoding algorithm
pars2.print = 1;
pars2.d = sum(x);

[x_c,out2] = COMP_PT((M>0),y,pars2);

err = norm(x-x_c);
