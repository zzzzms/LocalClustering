function [Points2D,Points] = Generate3Lines(ysep,length,n0,noise_level,ambient_dim)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This function generates the `Three Lines' data set consisting of three
% parallel lines of the same length, a distance of y_sep apart, embedded
% into R^{ambient_dim} with some Gaussian noise.
%
% INPUTS
% ========================================================
% ysep .................... y-separation between adjacent lines
% length .................. length of each line
% n0 ...................... number of points, to be sampled at random, from
% each circle
% noise_level ............. variance of Gaussian noise to be added
%ambient_dim .............. Ambient dimension
% 
% OUTPUTS
% ========================================================
% Points2D ............... (3*n0)-by-2 MATRIX. Projection of data points to
% R^2
% Points ................. (3*n0)-by-100 MATRIX. Data points in R^100


% ================= y-coordinates of lines ================= %
y1 = 0;
y2 = ysep;
y3 = 2*ysep;

% ================= Create 2D data set ===================== %

X1 = length*rand(n0,1);
Y1 = zeros(n0,1);

X2 = length*rand(n0,1);
Y2 = y2*ones(n0,1);

X3 = length*rand(n0,1);
Y3 = y3*ones(n0,1);

Points2D = [X1,Y1;X2,Y2;X3,Y3];
%Noise2D = noise_level*randn(size(Points2D));
%Points2D = Points2D + Noise2D;

% ========== Embed in R^ambient_dim and add the noise ============== %
Points = zeros(3*n0,ambient_dim);
Points(:,1:2) = Points2D;
Noise = noise_level*randn(size(Points));
Points = Points + Noise;
Points2D = Points(:,1:2);

end

