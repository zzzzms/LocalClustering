function [C,v] = CS_LCE(L,Gamma_a,Omega_a,n_a,reject)

% ================================================================= %
% This function finds the local cluster after the random walk threshold step.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================


Phi = L(:,Omega_a);
n = size(L,1);
yg = sum(Phi,2);
[~,I]=mink(abs(Phi')*abs(yg),floor(n_a/5));
Phi = L;
Phi(:,Omega_a(I)) = 0;
yg = sum(Phi,2);
g = length(Gamma_a);
sparsity = ceil(4*n_a/5);
if sparsity <= 0
    C = union(Omega_a,Gamma_a);
    v = zeros(n,1);
else
    v = subspacepursuit(Phi,yg,sparsity,1e-10,ceil(log(5*n)));
    Lambda_a = v > reject;
    G = [1:n];
    C = union(G(Lambda_a), Omega_a(I));
    C = union(C,Gamma_a);
end
end
