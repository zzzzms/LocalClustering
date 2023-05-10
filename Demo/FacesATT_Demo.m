% ================================================================= %
% This demo shows the performance of CS-LCE on ATT Human Face Images.
% ================================================================= %


clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))
addpath(genpath('../Datasets'))

load('FacesATT.mat');

% ============== Define all vectors of interest =========== %

k = 10;  %number of clusters
Iter = 100; %number of iterations

Accuracy_LCE_mat = zeros(k,Iter);
Precision_LCE_mat = zeros(k,Iter);
Recall_LCE_mat = zeros(k,Iter);


% =============== Parameters ============== %
epsilon_LCE = 0.8;
reject_LCE = 0.1;


sample_frac = 0.1;  %change here to modify the percentage of seed vertices

%rand=randperm(100);
%L=L(rand,:);
%A=A(rand,rand);
%y=y(rand);

% =========== Find the ground truth clusters ======== %
TrueClusters = cell(k,1);
n0vec = zeros(k,1);
for a = 1:k
    Ctemp = find(y == a);
    TrueClusters{a} = Ctemp;
    n0vec(a) = length(Ctemp);   
end

for j=1:Iter
    for i=1:k
        TrueCluster = TrueClusters{i};
        n0 = length(TrueCluster); 
        n0_equal = 10;
        

        % ================ Draw Seed vertices =============== %
        Gamma = datasample(TrueCluster,ceil(sample_frac*n0_equal),'Replace',false);

        % ================= Run CS-LCE ================= %
        Cluster_LCE = main_CS_LCE(A,Gamma,n0_equal,epsilon_LCE,3,reject_LCE);
        
        
        Precision_LCE_mat(i,j) = length(intersect(Cluster_LCE,TrueCluster))/length(Cluster_LCE);
        Recall_LCE_mat(i,j) = length(intersect(Cluster_LCE,TrueCluster))/n0;
        Accuracy_LCE_mat(i,j) = length(intersect(Cluster_LCE,TrueCluster))/length(TrueCluster);
        
    end
end


% ==================== Determine Error ============================== %
Precision_LCE = mean(Precision_LCE_mat,'all');
Recall_LCE = mean(Recall_LCE_mat,'all');
F1_LCE = 2*Precision_LCE.*Recall_LCE./(Precision_LCE+Recall_LCE);
Accuracy_LCE = mean(Accuracy_LCE_mat,'all');

CS_LCE = [Precision_LCE,Recall_LCE, F1_LCE, Accuracy_LCE]
Std = [std(mean(Accuracy_LCE_mat,1))]