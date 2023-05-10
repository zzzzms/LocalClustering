function A = randsym(n,p)

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% This function generates a random symmetric binary matrix with expected
% row sums np and zeros on the diagonal. 
% Use instead of sprandsym when p is close to 1.

AA = rand(n);
T = +(triu(AA,1)> 1-p);
A = T + T';
end
