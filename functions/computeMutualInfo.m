function mi = computeMutualInfo(labels1, labels2)  
    % ת����ǩΪΨһ����������  
    [~, ~, idx1] = unique(labels1);  
    [~, ~, idx2] = unique(labels2);  
    labels1 = idx1;  
    labels2 = idx2;  
      
    % �������Ϸֲ�  
    jointDist = accumarray([labels1, labels2], 1, [max(labels1), max(labels2)], @sum);  
    jointDist(jointDist == 0) = eps; % ���������  
      
    % �����Ե�ֲ�  
    marginalDist1 = sum(jointDist, 2);  
    marginalDist2 = sum(jointDist, 1);  
      
    % ���㻥��Ϣ  
    pxy = jointDist ./ sum(jointDist(:));  
    px = marginalDist1 ./ sum(marginalDist1);  
    py = marginalDist2 ./ sum(marginalDist2);  
    mi = sum(sum(pxy .* log2(pxy ./ (px' * py))));  
end