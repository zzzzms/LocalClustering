function [Points2D,Points] = Generate3Circles(r1,r2,r3,n1,n2,n3,noise_level,ambient_dim)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This function generates the `Three Circles' data set consisting of three
% concentric circles embedded into R^ambient_dim with a bit of Gaussian noise.
%
% INPUTS
% ========================================================
% r1,r2,r3 ................ Radii of the three circles
% n1,n2,n3 ................ Number of points on each circle
% noise_level ............. variance of Gaussian noise to be added
% ambient_dim ............. Dimension of ambient Euclidean space
% 
% OUTPUTS
% ========================================================
% Points2D ............... (3*n0)-by-2 MATRIX. Projection of data points to
% R^2
% Points ................. (3*n0)-by-100 MATRIX. Data points in R^100
% N ...................... Total number of points (= n1+n2+n3)

% ================= Create 2D data set ===================== %
theta1 = rand(n1,1)*2*pi;
theta2 = rand(n2,1)*2*pi;
theta3 = rand(n3,1)*2*pi;

X1 = r1.*cos(theta1);
Y1 = r1.*sin(theta1);

X2 = r2.*cos(theta2);
Y2 = r2.*sin(theta2);

X3 = r3.*cos(theta3);
Y3 = r3.*sin(theta3);

Points2D = [X1,Y1;X2,Y2;X3,Y3];
Noise2D = noise_level*randn(size(Points2D));
Points2D = Points2D + Noise2D;

N = n1+n2+n3;

% ========== Embed in R^ambient_dim and add the noise ============== %
Points = zeros(N,ambient_dim);
Points(:,1:2) = Points2D;
Noise = noise_level*randn(size(Points));
Points = Points + Noise;
Points2D = Points(:,1:2);

end

