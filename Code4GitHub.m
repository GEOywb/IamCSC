clc
clear
addpath('functions');
addpath('SSC-using-ADMM-master');
load Subscene.mat
real_label=Label;
X1=reshape(HSI,size(HSI,1)*size(HSI,2),size(HSI,3));
X2=reshape(LiDAR,size(LiDAR,1)*size(LiDAR,2),size(LiDAR,3));
X1=double(X1');
X2=double(X2');
X1=mat2gray(X1);
X2=mat2gray(X2);
d=40;
b=size(X1,1);
sigma=3;
delta=1;
alpha1=1;
alpha2=1;
beta=0.5;
lambda=0.1;
lr=10^(-5);
[X,W1,W2,K1,K2,E1,E2,Y1,Y2,Z]=Initial(HSI,X1,X2,d);
for i=1:200000
    [X,W1,W2,K1,K2,E1,E2,Y1,Y2,Z,lr]=IamCSC4GitHub(HSI,LiDAR,X1,X2,d,b,sigma,delta,alpha1,alpha2,beta,lambda,lr,1,1,X,W1,W2,K1,K2,E1,E2,Y1,Y2,Z);
    real_label_zhankai=reshape(real_label,size(real_label,1)*size(real_label,2),1);
    real_label_no0=real_label_zhankai(real_label_zhankai~=0);
    Z_no0=(Z+Z')/2;
    Z_no0(real_label_zhankai==0,:)=[];
    Z_no0(:,real_label_zhankai==0)=[];
    Z_no0=(Z_no0-min(min(Z_no0)))/(max(max(Z_no0))-min(min(Z_no0)));
    extend_label_no0=spectral(Z_no0,1,size(unique(real_label_no0),1));
    extend_label_no0_ = bestMap(real_label_no0,extend_label_no0);
    extend_label_=zeros(size(real_label_zhankai));
    extend_label_(real_label_zhankai~=0)=extend_label_no0_;
end