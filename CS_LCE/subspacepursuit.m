function Sest = subspacepursuit(Phi,u,K,tol,maxiterations)

% ================================================================= %
% This program implements the subspace pursuit algorithm. 

% ========================= Acknowledgement =============================
% I would like to thank Dr. Daniel Mckenzie for his kindness of sharing 
% his code. 
% 
% Zhaiming Shen. April 2023
% =======================================================================

% Initialization
Sest = zeros(size(Phi,2),1);
utrue = Sest;
v = u;
prevresen = norm(v);
t = 1;
numericalprecision = 1e-12;
T2 = [];
while (t <= maxiterations) && (norm(v)/norm(u) > tol)
  y = abs(Phi'*v);
 % y = abs(Phi')*abs(v);
  [vals,~] = sort(y,'descend');
  Omega = find(y >= vals(K) & y > numericalprecision);
  K = length(Omega);
  if K == 0
      Sest = zeros(size(Phi,2),1);
      return
  end 
  T = union(Omega,T2);
  phit = Phi(:,T);
  [bb, ~] = lsqr(phit,u,[],10);  
  b = abs(bb);
  [vals,~] = sort(b,'descend');
  Sest = zeros(length(utrue),1);
  Sest(T(b >= vals(K) & b > numericalprecision)) = b(b >= vals(K) & b > numericalprecision);
  [~,z] = sort(Sest,'descend');
  Told = T2;
  T2 = z(1:K);
  phit = Phi(:,T2);
  [b,~] = lsqr(phit,u,[],10);
  Sest = zeros(length(utrue),1);
  Sest(T2) = b;
  v = u - Phi(:,T2)*b;
  newresen = norm(v);
  if newresen > prevresen
    T2 = Told;
    phit = Phi(:,T2);
    [b,~] = lsqr(phit,u,[],10);
    Sest = zeros(length(utrue),1);
    Sest(T2) = b;
    break;
  end
  prevresen = newresen;
  t = t+1;
end