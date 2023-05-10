function A = generateA(n,n0,p,q)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This script generates the adjacency matrix of a graph G drawn from the 
% Stochastic Block Model G(n,k,p,q). where k = floor(n/n0)

k = floor(n/n0);
A = sparse(n,n);
A(1:n0,1:n0) = randsym(n0,p);
B = +(sprand(n0,n-n0,q)>0);
dEps = zeros(n,1);
dEps(1:n0) = sum(B,2);
A(1:n0, n0+1:end) = B;
A(n0+1:end,1:n0) = B'; 

for i = 2:k-1
    Start = (i-1)*n0+1;
    Finish = i*n0;
    A(Start:Finish,Start:Finish) = randsym(n0,p);
    B = +(sprand(n0,n - Finish,q)>0); % The 'noise matrix'
    A(Start:Finish,Finish+1:end) = B;
    A(Finish+1:end,Start:Finish) = B';
    dEps(Start:Finish) = sum(A(Start:Finish,:),2) - sum(A(Start:Finish,Start:Finish),2);
end

% And the final cluster, which may be smaller.
nfinal = n - (k-1)*n0;
A(n-nfinal +1:end, n-nfinal +1:end) = randsym(nfinal,p);
end