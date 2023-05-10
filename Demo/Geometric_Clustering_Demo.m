% ================================================================= %
% This demo shows the performance of CS-LCE on Geometric Data.

% ========================= Acknowledgement =============================
% It is modified based on Daniel Mckenzie's original code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

clear, clc, close all, format compact

addpath(genpath('../CS_LCE'))
addpath(genpath('../Utilities'))


% =========================== Parameters ========================= %
colours = ['r', 'b','g','k', 'm', 'c', 'y',];
n01 = 1200; n0 = 500; 
noise_level = 0.15; k=3; ambient_dim = 100;  
Iter = 10;
% Data set is embedded into R^ambient_dim with Gaussian noise. All pictures
% plotted are of two dimensional projections. Set ambient_dim higher to
% make problem more challenging.

case_number = 3; %1 = Lines, 2 = Circles, 3 = Moons

if case_number == 1
    % == Lines
    ysep = 1; len = 6;
    [Points2D,Points] = Generate3Lines(ysep,len,n01,noise_level,ambient_dim);
    N = k*n01;
elseif case_number == 2
    % == Circles
     r1 = 1;
     r2 = 2.4;
     r3 = 3.8;
     n1 = ceil(n0);
     n2 = ceil(n0*r2);
     n3 = ceil(n0*r3);
     N = n1+n2+n3;
     [Points2D,Points] = Generate3Circles(r1,r2,r3,n1,n2,n3,noise_level,ambient_dim);
elseif case_number == 3
    % == Moons
    r1 = 1;
    r2 = 1;
    r3 = 1.5;
    [Points2D,Points] = Generate3Moons(r1,r2,r3,n01,noise_level,ambient_dim);
    N = k*n01;
end

% ==================== Permute and Extract Ground Truth ================ %
perm = randperm(N);
[~,permInv] = sort(perm);
Data = Points(perm,:);
Points2D = Points2D(perm,:);

TrueClusters = cell(k,1);
n0vec = zeros(k,1);
if case_number == 1 || case_number == 3
    for a = 1:k
        TrueClusters{a} = permInv((a-1)*n01+1:a*n01);
    end
else
 % == Circles
 TrueClusters{1} = permInv(1:n1);
 TrueClusters{2} = permInv(n1+1:n1+n2);
 TrueClusters{3} = permInv(n1+n2+1:N);
end

for a = 1:k
    n0vec(a) = length(TrueClusters{a});
end

Accuracy_LCE_mat = zeros(k,Iter);
Precision_LCE_mat = zeros(k,Iter);
Recall_LCE_mat = zeros(k,Iter);


% === Extract Seed vertices
Gamma = cell(k,1);
num_seeds = 10; %number of seeds per cluster


epsilon_LCE = 0.6;    
reject_LCE = 0.1;     
Assign_All = 1;

for j= 1:Iter
    for a = 1:k
        Gamma{a} = datasample(TrueClusters{a},num_seeds,'Replace',false); %seed vertices
    end

    % ======= Compute l-Nearest Neighbors adjacency matrix ============== %
    A = CreateKNN_Mult_from_Data(Data,25,20);

    % ====================== Run CS-LCE ================================= %
    tic
    Clusters_LCE = Iter_CS_LCE(A,Gamma,n0vec,epsilon_LCE,3,reject_LCE,Assign_All);
    time = toc;
    
    for i=1:k
        Precision_LCE_mat(i,j) = length(intersect(Clusters_LCE{i},TrueClusters{i}))/length(Clusters_LCE{i});
        Recall_LCE_mat(i,j) = length(intersect(Clusters_LCE{i},TrueClusters{i}))/length(TrueClusters{i});
        Accuracy_LCE_mat(i,j) = length(intersect(Clusters_LCE{i},TrueClusters{i}))/length(TrueClusters{i});
       
    end
end

figure, 
plot(Points2D(:,1),Points2D(:,2), 'co'); hold on
plot(Points2D(Gamma{1},1),Points2D(Gamma{1},2),'ko'); hold on
plot(Points2D(Gamma{2},1),Points2D(Gamma{2},2),'ko'); hold on
plot(Points2D(Gamma{3},1),Points2D(Gamma{3},2),'ko');
title('Seeds for Each of the Clusters','FontSize',14)


figure, hold on
for a = 1:k
    CurrClust = Clusters_LCE{a};
    plot(Points2D(CurrClust,1),Points2D(CurrClust,2),strcat(colours(a),'o'));
end
title('Results using CS-LCE','FontSize',14)


% ==================== Determine Error ============================== %
Precision_LCE = mean(Precision_LCE_mat,'all');
Recall_LCE = mean(Recall_LCE_mat,'all');
F1_LCE = 2*Precision_LCE.*Recall_LCE./(Precision_LCE+Recall_LCE);
Accuracy_LCE = mean(Accuracy_LCE_mat,'all');

LCE = [Precision_LCE,Recall_LCE, F1_LCE, Accuracy_LCE]
Std = [std(mean(Accuracy_LCE_mat,1))]