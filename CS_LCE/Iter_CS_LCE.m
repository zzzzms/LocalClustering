function Clusters = Iter_CS_LCE(A,Gamma,n0vec,epsilon,t,reject,Assign_All)

% ================================================================= %
% This programs implements CS-LCE iteratively. 

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================

% ========= Initialization ================= %
Aold = A;
n = size(A,1); % number of vertices
N = n; 
k = length(n0vec); %number of clusters
Clusters = cell(k,1);
Remaining = cell(k,1);
OmegaCell = cell(k,1);

% ============ Now iteratively find the clusters ============ %
for a=1:k-1
    
    Dinv = spdiags(1./sum(A,2),0,n,n);
    DinvA = Dinv*A;
    L = speye(n,n) - DinvA;
    Omega = RandomWalkThresh(A,Gamma{a},n0vec(a),epsilon,t);
    OmegaCell{a} = Omega;
    [C,~] = CS_LCE(L,Gamma{a},Omega,n0vec(a),reject);
    Remaining{a} = setdiff(1:n,C);
    if a ~=1
        for b = a-1:-1:1 
            Remtemp = Remaining{b};
            Ctemp = Remtemp(C);
            C = Ctemp;
        end
    end
    Clusters{a} = C;
    % also need to readjust the indices of the labeled sets Gamma_b
    for b = a+1:k-1
        Gamtemp = find(ismember(Remaining{a},Gamma{b}));
        Gamma{b} = Gamtemp';
    end
    A = A(Remaining{a},Remaining{a});
    clear Dinv DinvA L C
    n = size(A,1);
end

% ================= Extract the final cluster ====================== %
Dinv = spdiags(1./sum(Aold,2),0,N,N);
DinvA = Dinv*Aold;
L = speye(N,N) - DinvA;
Omega = setdiff(1:N,Cell2Vec(Clusters(1:k-1)));
[C,~] = CS_LCE(L,Gamma{k},Omega,n0vec(k),reject);
C = setdiff(C,Cell2Vec(Clusters(1:k-1)));  % remove any previously classified vertices that may have snuck back in 
Clusters{k} = C;

% ================ Do a final sweep and classify the leftovers ========== %
if Assign_All == 1
    [ClustersFinal,~,~] = CleanUp2(Aold,Clusters);
    Clusters = ClustersFinal;
end

end