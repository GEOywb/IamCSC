%按列归一化，任意归一化范围
function [Array_dst]=normalize(Array_src,ymin,ymax)
[l,r]=size(Array_src);
Bound=[];
for i=1:r
    Bound(1,i)=min(Array_src(:,i));
    Bound(2,i)=max(Array_src(:,i));
    if abs(Bound(1,i)-Bound(2,i))<0.000000001
        Bound(1,i)=0;
        Bound(2,i)=1;
    end
end
 
[m,n]=size(Array_src);
for i=1:m
    Array_dst(i,:)=ymin + (Array_src(i,:)-Bound(1,:))./(Bound(2,:)-Bound(1,:)).*( ymax - ymin );
end