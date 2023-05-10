function Cluster = main_CS_LCE(A,Gamma,n0,epsilon,t,reject)

% ================================================================= %
% This program implements Algorithm CS-LCE. 

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================


% ========= Initialization ================= %
n = size(A,1); % number of vertices
degvec = sum(A,2);
Dinv = spdiags(1./degvec,0,n,n);
DinvA = Dinv*A;
L = speye(n,n) - DinvA;

% ============ Call the subroutines ============= %

Omega = RandomWalkThresh(A,Gamma,n0,epsilon,t);
[Cluster,~] = CS_LCE(L,Gamma,Omega,n0,reject);
end