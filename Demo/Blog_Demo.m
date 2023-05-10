% ================================================================= %
% This demo shows the performance of CS-LCE on political blog network.
% ================================================================= %


clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))
addpath(genpath('../Datasets'))

load('polblogs.mat');

% ================ Randomly permute the adjacency matrix =============== %
A=polblogsAdjMat;
[~,n]=size(A);
perm = randperm(n);
A = A(perm,perm);
[~,permInv] = sort(perm);
TrueCluster = permInv(1:586);   % the ground truth first cluster, after permutation.

% ========================== Draw seed vertices =================== %
Gamma = datasample(TrueCluster,1,'Replace',false); % seed vertices

% =============== Parameters ============== %
epsilon_LCE = 0.8;    
reject_LCE = 0.1;    

% ====================== Run CS-LCE ================================= %
tic
Cluster_LCE = main_CS_LCE(A,Gamma,586,epsilon_LCE,3,reject_LCE);
toc


% ================= Assess Accuracy ===================== %
accuracy_LCE = 100*length(intersect(Cluster_LCE,TrueCluster))/length(TrueCluster);
accuracy_LCE = 100*(1-(length(Cluster_LCE)-586*accuracy_LCE/100)*2/1224);

disp(['Found Cluster 1 by newIdea with an accuracy of ',num2str(accuracy_LCE),'%'])

misclassified_LCE = length(Cluster_LCE)-length(intersect(Cluster_LCE,TrueCluster))

