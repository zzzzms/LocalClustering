% ================================================================= %
% This demo shows the performance of CS-LCE on SSBM with same sized clusters.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% Zhaiming Shen. April 2023
% =======================================================================

clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))

% ============== Parameters ================= %
a = 5;
b = 1;
num_sizes = 5;                      % Number of different cluster sizes
num_trials = 10;                     % Number of trials to run for each size
Cluster_sizes = 200*[1:num_sizes];  % Vector of cluster sizes


% ============ Parameters ========== %
epsilon_LCE = 0.8;   
reject_LCE = 0.1;

% ============== Define all matrices of interest =========== %
time_LCE_mat = zeros(num_trials,num_sizes);
Jaccard_LCE_mat = zeros(num_trials,num_sizes);

for j = 1:num_sizes
    n1 = Cluster_sizes(j);
    n0vec = n1*[1,1,1];
    n = sum(n0vec);
%     p_prime = ((log(n))^2)/2;
%     q = 5*log(n)/n;
%     P_diag = p_prime./n0vec - q;
%     P = q*ones(4,4) + diag(P_diag);

%     P = [a*log(n)/n,b*log(n)/n,b*log(n)/n,b*log(n)/n;
%         b*log(n)/n,a*log(n)/n,b*log(n)/n,b*log(n)/n;
%         b*log(n)/n,b*log(n)/n,a*log(n)/n,b*log(n)/n;
%         b*log(n)/n,b*log(n)/n,b*log(n)/n,a*log(n)/n;];
    
    P = [a*log(n)/n,b*log(n)/n,b*log(n)/n;
        b*log(n)/n,a*log(n)/n,b*log(n)/n;
        b*log(n)/n,b*log(n)/n,a*log(n)/n;];
    
    for i = 1:num_trials
        A = generateA2(n0vec,P);
        Im1 = mat2gray(full(A));
        %perm = 1:n;
        perm = randperm(n);
        A = A(perm,perm);
        
        % =============== Find ground truth Cluster ================ %
        [~,permInv] = sort(perm);
        TrueCluster = permInv(1:n1);
        
        % ============== ExtractSeed vertices ================ %
        Gamma = datasample(TrueCluster,5,'Replace',false);
        
        % ========== Find Cluster with CS-LCE =========== %
        tic
        Cluster_LCE = main_CS_LCE(A,Gamma,n1,epsilon_LCE,3,reject_LCE);
        time_LCE_mat(i,j) = toc;
        Jaccard_LCE_mat(i,j) = Jaccard_Score(TrueCluster,Cluster_LCE)
        
    end
end

% ======= Plot all for comparison ======== %
figure,
plot(200*[1:num_sizes],mean(Jaccard_LCE_mat,1),'LineWidth',3)
legend({'CS-LCE'},'FontSize',14)
ylabel('Jaccard Index')
xlabel('Size of Target Cluster')
set(gca, 'FontSize',14)

% ======= Plot all for times comparison ======== %
figure,
plot(200*[1:num_sizes],log(mean(time_LCE_mat,1)),'LineWidth',3)
legend({'CS-LCE'},'FontSize',14)
ylabel('logarithm of run time')
xlabel('Size of Target Cluster')
set(gca, 'FontSize',14)
