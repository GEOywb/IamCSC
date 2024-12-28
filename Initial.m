function [X,W1,W2,K1,K2,E1,E2,Y1,Y2,Z]=Initial(HSI,X1,X2,d)
X=zeros(d,size(HSI,1)*size(HSI,2));
K1=rand(d,size(X1,1));
K2=rand(d,size(X2,1));
W1=rand(size(HSI,1)*size(HSI,2),size(HSI,1)*size(HSI,2));
W2=rand(size(HSI,1)*size(HSI,2),size(HSI,1)*size(HSI,2));
% Z=pdist(X1');
% W1=squareform(Z);
% Z=pdist(X2');
% W2=squareform(Z);
Z=(W1+W2)/2;
E1=W1-Z;
E2=W2-Z;
Y1=eye(size(X,2));
Y2=eye(size(X,2));