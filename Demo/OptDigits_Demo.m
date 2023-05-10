% ================================================================= %
% This demo shows the performance of CS-LCE on OptDigits Data.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================

clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))
addpath(genpath('../Datasets'))

load('OptDigits_KNN_Mult_K=15.mat')

% =============== Parameters ============== %
epsilon_LCE = 0.8;   
reject_LCE = 0.1;

num_trials = 10;
num_sizes = 5;
k = 10;  %number of clusters
n = size(A,1);

% =========== Find the ground truth clusters ======== %
TrueClusters = cell(k,1);
n0vec = zeros(k,1);
for a = 1:k
    Ctemp = find(y== a-1);
    TrueClusters{a} = Ctemp;
    n0vec(a) = length(Ctemp);
    
end


% ============== Define all vectors of interest =========== %
time_LCE_mat = zeros(k,num_sizes);
Jaccard_LCE_mat = zeros(k, num_sizes);

for m = 1:num_trials
    for j = 1:num_sizes
        sample_frac = 0.005*j;
        for i=1:k
            TrueCluster = TrueClusters{i};
            n0 = length(TrueCluster);
            n0_test = 560;

            % ================ Draw Seed set =============== %
            Gamma = datasample(TrueCluster,ceil(sample_frac*n0),'Replace',false);
        
            tic
            Cluster_LCE = main_CS_LCE(A,Gamma,n0,epsilon_LCE,3,reject_LCE);
            time_LCE_mat(i,j) = time_LCE_mat(i,j) + toc;
            Jaccard_LCE_mat(i,j) = Jaccard_LCE_mat(i,j) + Jaccard_Score(TrueCluster,Cluster_LCE)
        
        end
    end
end

time_LCE_mat = time_LCE_mat/num_trials;
Jaccard_LCE_mat = Jaccard_LCE_mat/num_trials;

figure,
plot(0.5*[1:5],mean(Jaccard_LCE_mat),'LineWidth',3)
xlabel('Percentage of vertices used as seeds','FontSize',14)
ylabel('Average Jaccard Score','FontSize',14)
legend({'CS-LCE'},'FontSize',14)

figure,
plot(0.5*[1:5],log(mean(time_LCE_mat)),'LineWidth',3)
xlabel('Percentage of vertices used as seeds','FontSize',14)
ylabel('Logarithm of Average Time in seconds','FontSize',14)
legend({'CS-LCE'},'FontSize',14)
