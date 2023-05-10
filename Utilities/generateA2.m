function A = generateA2(n0vec,P)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This function creates the adjacency matrix of a graph drawn from the
% non-symmetric Stochastic Block Model SSBM(n,P). Here P is a symmetric
% k-by-k matrix such that P_{ij} is the probability of an edge between C_i
% and C_j. Community sizes are given by n0vec


k = length(n0vec);
n = sum(n0vec);
A = sparse(n,n);
StartingPoints = cumsum(n0vec);

for i = 1:k
    if i == 1
        iStart = 1;
    else
        iStart = StartingPoints(i-1)+1;
    end
    iEnd = StartingPoints(i);
    for j = i:k
        if j==i
            tempBlock = randsym(n0vec(i),P(i,i));
        else
            tempBlock = +(sprand(n0vec(i),n0vec(j),P(i,j)) > 0);
        end
        if j == 1
            jStart = 1;
        else
            jStart = StartingPoints(j-1) + 1;
        end
        jEnd = StartingPoints(j);
        A(iStart:iEnd,jStart:jEnd) = tempBlock;
        if j~= i
            A(jStart:jEnd,iStart:iEnd) = tempBlock';
        end
    end
end
        
end