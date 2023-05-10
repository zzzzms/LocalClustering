% ================================================================= %
% This demo shows the performance of CS-LCE on MNIST Data.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================

clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))
addpath(genpath('../Datasets'))

load('MNIST_KNN_Mult_K=15_r=10.mat');


% ============ Parameters ============= %
epsilon_LCE = 0.8;
reject_LCE = 0.1;

num_trials = 10;
num_sizes = 5;
k = 10;  %number of clusters

% =========== Find the ground truth clusters ======== %
TrueClusters = cell(k,1);
n0vec = zeros(k,1);
for a = 1:k
    Ctemp = find(y== a-1);
    TrueClusters{a} = Ctemp;
    n0vec(a) = length(Ctemp);
    
end


% ============== Define all vectors of interest =========== %
time_LCE_mat = zeros(k,num_sizes,num_trials);
Cluster_LCE_mat = cell(k,num_sizes,num_trials);
InterLength_LCE_mat = zeros(k,num_sizes,num_trials);
Precision_LCE_mat=zeros(k,num_sizes,num_trials);
Recall_LCE_mat=zeros(k,num_sizes,num_trials);
F1_LCE_mat=zeros(k,num_sizes,num_trials);

sample_frac = 0.0005;

for m = 1:num_trials
    for j = 1:num_sizes
        for i=1:k
            TrueCluster = TrueClusters{i};
            n0 = length(TrueCluster); 
            %%n0_equal = 7000;

            % ================ Draw Seed set =============== %
            Gamma = datasample(TrueClusters{i},ceil(sample_frac*j*n0),'Replace',false);

            
            tic
            Cluster_LCE_mat{i,j,m} = main_CS_LCE(A,Gamma,n0,epsilon_LCE,3,reject_LCE);
            time_LCE_mat(i,j,m) = time_LCE_mat(i,j,m) + toc;
        
     
        
            Precision_LCE_mat(i,j,m) = length(intersect(Cluster_LCE_mat{i,j,m},TrueClusters{i}))/length(Cluster_LCE_mat{i,j,m})
            Recall_LCE_mat(i,j,m) = length(intersect(Cluster_LCE_mat{i,j,m},TrueClusters{i}))/length(TrueClusters{i})
            F1_LCE_mat(i,j,m) = 2*Precision_LCE_mat(i,j,m)*Recall_LCE_mat(i,j,m)/(Precision_LCE_mat(i,j,m)+Recall_LCE_mat(i,j,m));
            InterLength_LCE_mat(i,j,m) = length(intersect(Cluster_LCE_mat{i,j,m},TrueClusters{i}));
           
            length(Cluster_LCE_mat{i,j,m})
            
        end
    end
end

% =================== Determine Error ====================== %
Precision_LCE = mean(Precision_LCE_mat,[1,3])
Recall_LCE = mean(Recall_LCE_mat,[1,3])
F1_LCE = mean(F1_LCE_mat,[1,3])

Accuracy_LCE = sum(InterLength_LCE_mat,[1,3])/(num_trials*70000)
Std_LCE = std(mean(Recall_LCE_mat,1),0,3)

Time_LCE = mean(time_LCE_mat,[1,3])
