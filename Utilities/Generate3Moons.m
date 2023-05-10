function [Points2D,Points] = Generate3Moons(r1,r2,r3,n0,noise_level,ambient_dim)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This function generates the `Three Moons' data set consisting of two
% smaller semicircles and one larger semicircle, embedded in
% R^{ambient_dim}
%
% INPUTS
% ========================================================
% r1,r2 ................... radii of two smaller circles
% r3 ...................... radius of larger circle
% n0 ...................... number of points, to be sampled at random, from
% each circle
% noise_level ............. variance of Gaussian noise to be added
% ambient_dim ............. Ambient Dimension
% 
% OUTPUTS
% ========================================================
% Points2D ............... (3*n0)-by-2 MATRIX. Projection of data points to
% R^2
% Points ................. (3*n0)-by-100 MATRIX. Data points in
% R^ambient_dim

% =========== Define the centres of the circles =========== %
Centre1 = [0,0];
Centre2 = [3,0];
Centre3 = [1.5,0.4];

% =============== Generate the data in 2D ================= %
theta1 = rand(n0,1)*pi;
theta2 = rand(n0,1)*pi;
theta3 = pi + rand(n0,1)*pi;
X1 = r1.*cos(theta1);
Y1 = r1.*sin(theta1);
Moon1 = [X1,Y1] + Centre1;
X2 = r2.*cos(theta2);
Y2 = r2.*sin(theta2);
Moon2 = [X2,Y2] + Centre2;
X3 = r3.*cos(theta3);
Y3 = r3.*sin(theta3);
Moon3 = [X3,Y3] + Centre3;
Points2D = [Moon1;Moon2;Moon3];

% ========== Embed in R^ambient_dim and add the noise ============== %
Points = zeros(3*n0,ambient_dim);
Points(:,1:2) = Points2D;
Noise = noise_level*randn(size(Points));
Points = Points + Noise;
Points2D = Points(:,1:2);

end