function phi = RBF(s, rho)
c = 1:1:6;
beta = 1/(rho^2);
phi = zeros(length(c),1);
for i = c
    phi(i) = exp(-beta*(s-c(i))^2);
end
%u = p./sum(p);
phi = phi./sum(phi);
end