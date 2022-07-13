function [ x, out ] = COMP_PT( M, y, pars )
%COMP_PT Combinatorial Orthogonal Matching Pursuit (w/o noise)
%   
% Algorithm for pooling tests (e.g., mixed COVID samples) with
% problem representation:
%
%   M * x = y, (goal to recover x given known M and y)
%
% where [t,n]=size(M), t<n, M is a binary matrix with tests (rows)
% and patients (sometimes called items) in its columns.
%
% INPUTS:
% M: Matrix (t x n)
% y: Measured outcomes (t x 1)
% pars: Struct with optional parameters
%   pars.print: Flag to print infos
%   pars.d: Number of defectives
%
% OUTPUTS:
% x: Computed solution
% out: Struct with output values
%   out.time: Computational time
%   out.d_final: Computed defectives
%--------------------------------------------------------------------------
% 03/17/21, J.B., Initial implementation

ctime = tic;

% Problem data
[t,n] = size(M);

% Retrieve optional parameter values
if isfield(pars,'print')
    printInfo = pars.print;
else
    printInfo = 0;
end
if isfield(pars,'d')
    d = pars.d;
else
    d = -1;
end

if printInfo == 1

    fprintf('\n----------- COMP Algorithm ----------- \n'); % 41 chars    
    fprintf('Problem Size \n');
    fprintf('Tests:                 %i \n',t);
    fprintf('Samples:               %i \n',n);
    fprintf('Input Expct. Positive: %i \n',d);
    
end

x = zeros(n,1);
% Algorithm (column-wise)
for i=1:n
    if sum(M(:,i)) > 0
        x(i) = (sum(M(:,i)) == sum(1 == y(M(:,i))));
    end
    %x(i) = (sum(M(:,i)) == sum(y(M(:,i))));
end

out.d_final = sum(x);
out.time = toc(ctime);

if printInfo == 1
    
    fprintf('OUTPUTS:################ \n');
    fprintf('Time (search):         %i \n',out.time);
    fprintf('Positive items:        %i \n',out.d_final);
    fprintf('######################## \n');
    fprintf('Identified Indices:    %i \n',find(x));
    fprintf('\n');
end
