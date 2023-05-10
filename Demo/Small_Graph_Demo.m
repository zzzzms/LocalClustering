% ================================================================= %
% This demo shows the performance of CS-LCE on a small SSBM graph.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================

clear, clc, close all, warning off, format compact

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))

% ============== Generating adjacency matrix of graph ============== %
n = 400;          % Set the number of vertices of the graph
k = 4;            % number of clusters
n0 = ceil(n/k);   % size of each cluster (equally sized)
p = 0.1;          % in-cluster connection probability
q = 0.01;         % between cluster connection probability
A = generateA(n,n0,p,q);
%A = A^2.*A;

% uncomment below if you wish to visualize the adjacency matrix
Im1 = mat2gray(full(A));
imshow(imcomplement(Im1));
title('The ground truth adjacency matrix')



% ================= Parameters ===================
epsilon_LCE = 0.8;    
reject_LCE = 0.1;

Iter = 1; % number of iteration

Cluster_LCE = cell(Iter,1);
Accuracy_LCE = zeros(1,Iter);

Time_LCE = 0;

% ================ Randomly permute the adjacency matrix =============== %
perm = sort(randperm(n));
%perm = randperm(n);
A = A(perm,perm);
[~,permInv] = sort(perm);
TrueCluster = permInv(1:n0);   % the ground truth first cluster, after permutation.

for i = 1:Iter
    % ========================== Draw seed vertices =================== %
    Gamma = datasample(TrueCluster,1,'Replace',false); % seed vertices
    
    % ========= Visualize the graph with seed vertices highlighted ======== %
    G = graph(A);
    figure
    H = plot(G,'Layout','force','MarkerSize',4);
    highlight(H,Gamma,'NodeColor','r','MarkerSize',8);
    title('Graph with seed vertices highlighted','FontSize',14)

    % ====================== Run CS-LCE ================================= %
    tic
    Cluster_LCE{i} = main_CS_LCE(A,Gamma,n0,epsilon_LCE,3,reject_LCE);
    Time_LCE = Time_LCE + toc;
   
    length(Cluster_LCE{i})
    
    
    % ================= Assess Accuracy ===================== %
    Accuracy_LCE(i) = 100*length(intersect(Cluster_LCE{i},TrueCluster))/length(TrueCluster);
   
end

Time_LCE = Time_LCE/Iter;
disp(['Found Cluster 1 by CS-LCE with an accuracy of ',num2str(mean(Accuracy_LCE)),'%', ' with average time ', num2str(Time_LCE), ' seconds'])


% ===============  Replot graph =========================== %
figure
H1 = plot(G,'Layout','force','MarkerSize',4);
highlight(H1,Cluster_LCE{Iter},'NodeColor','r','MarkerSize',4);
highlight(H1,Gamma,'NodeColor','r','MarkerSize',8);
title('Cluster Found by CS-LCE.')
