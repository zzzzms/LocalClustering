function Omega = RandomWalkThresh(A,Gamma,n0_hat,epsilon,t)

% ================================================================= %
% This function implements the random walk threshold step in CS-LCE.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================


% =========================== Initialization ========================== %
n = size(A,1);
Dtemp = sum(A,2);
Dinv = spdiags(Dtemp.^(-1),0,n,n);
v0 = sparse(Gamma,1,Dtemp(Gamma),n,1);
P = A*Dinv;

% ===================== Random Walk and Threshold ===================== %
v = v0;
for i = 1:t
    v = P*v;
end

[w,IndsThresh] = sort(v,'descend');
FirstZero = find(w==0, 1, 'first');
if ~isempty(FirstZero) && FirstZero < ceil((1+epsilon)*(n0_hat))
    warning('the size of Omega is smaller than (1+delta) times the user specified cluster size. Try a larger value of k')
    T = FirstZero;
else
    T = ceil((1+epsilon)*(n0_hat));
end
Omega = union(IndsThresh(1:T),Gamma);

