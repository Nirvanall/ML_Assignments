function [w] = kmm(X,Z)
% Estimate weights using Kernel Mean Matching
% Paper: Huang, Smola, Gretton, Borgwardt, Schoelkopf (2006)
% Correcting Sample Selection Bias by Unlabeled Data
%
% Input:
%       X       = source data (n x 1)
%       Z       = target data (m x 1)
% Output:
%       w       = weights (n x 1)
%
% Author: Wouter Kouw
% Last update: 28-03-2017

% Sizes
n = size(X,1);
m = size(Z,1);

% Optimization options
options = optimoptions('quadprog', 'Display', 'final', ...
    'StepTolerance', 1e-5, ...
    'maxIterations', 1e2);

%%%%%%%%%%%%%%%%%%%%%%%
%%%% Add your code here
Kxx = zeros(n,n);
for i=1:n
    Kxx(:,i) = exp(-0.5*(X-X(i)).^2);
end

Kxz = zeros(n,1);
for i=1:n
    Kxz(i,1) = sum(exp(-0.5*(X(i)-Z).^2));
end  

I = eye(n);
lambda = 1;

H = 2/n^2 * (Kxx + lambda*I);
f = -2/(n*m) * Kxz;

A = [ones(1,n); -1*ones(1,n)];
b = [n*0.000001+n; n*0.000001-n];
lb = zeros(n,1);

w = quadprog(H, f, A, b, [], [], lb, [], [], options);
       
end
