%
% Test example for class gf
%
% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

clear;

java_path_setup; % please run this to setup java path
% create gf class of 3^2
fprintf('%% Create GF(3^2):\ngf9=gf(3,2);\n');
gf9=gf(3,2); 

%%%%
% Eg. 1
a=[2 1;1 0]

% compute rank
fprintf('\n%% Compute Rank:\ngf9.rank(a)\n');
% fprintf('Rank of a = %d\n',gf9.rank(a)); % return rank
gf9.rank(a)

% compute inverse
fprintf('\n%% Compute a inverse:\ninva = gf9.inv(a)\n')
inva = gf9.inv(a)

% Check inverse
fprintf('\n%% Check inverse (a * inva):\na_times_ainva=gf9.mult(a,inva)\n');
a_times_ainva=gf9.mult(a,inva)

% matrix divide
fprintf('\n%% Compute a / a:\ngf9.div(a,a)\n');
gf9.div(a,a)

%%%%%
% Eg. 2
fprintf('\n%% More examples:\n');
b=[1 2 1;1 0 1]
c=[1 1 2;2 1 1]

% compute summation
fprintf('\n%% Compute b + c:\ngf9.add(b,c)\n');
gf9.add(b,c)

% compute subtraction
fprintf('\n%% Compute b - c:\ngf9.sub(b,c)\n');
gf9.sub(b,c)

% compute dot multiplication
fprintf('\n%% Compute b .* c:\ngf9.dmult(b,c)\n');
gf9.dmult(b,c)

% compute dot division
fprintf('\n%% Compute b ./ c:\ngf9.ddiv(b,c)\n');
gf9.ddiv(b,c)

%%%%%
% Eg. 3
fprintf('\n%% Yet more examples:\n');
a=[1 2 1 1];
b=[1 3 1];

% compute convolution of two polynomials
fprintf('\n%% Polynomial x^3 + 2 x^2 + x + 1 is represented by\n');
disp(a);

fprintf('\n%% Polynomial x^2 + 3 x + 1 is represented by\n');
disp(b);

fprintf('\n%% Polynomial a times polynomial b:\ngf9.conv(a,b)\n');
gf9.conv(a,b)

fprintf('\n%% Polynomial a divided by polynomial b:\n[q,rem]=gf9.deconv(a,b)\n');
[q,rem]=gf9.deconv(a,b);

fprintf('\n%% Quotient:\n');
disp(q);

fprintf('\n%% Remainder:\n');
disp(rem);

fprintf('\n%% Check:\ngf9.sub(a,gf9.conv(q,b)) %% should be equal to rem');
gf9.sub(a,gf9.conv(q,b))



%%%%
% Eg. 4
% output the primitive polynomial
fprintf('\n%% More information on GF:\n');
fprintf('\n%% Output primitive polynomial:\ngf9.return_primitive_polynomial %% x^2 +1\n');
gf9.return_primitive_polynomial % x^2 + 1

% show polynomial representation
fprintf('\n%% Show polynomial representations of symbol 2:\ngf9.return_poly_representation(5) %% x + 2\n');
gf9.return_poly_representation(5) % x + 2


