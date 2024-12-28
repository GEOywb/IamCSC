function mi = computeMutualInfo(labels1, labels2)  
    % 转换标签为唯一的整数索引  
    [~, ~, idx1] = unique(labels1);  
    [~, ~, idx2] = unique(labels2);  
    labels1 = idx1;  
    labels2 = idx2;  
      
    % 计算联合分布  
    jointDist = accumarray([labels1, labels2], 1, [max(labels1), max(labels2)], @sum);  
    jointDist(jointDist == 0) = eps; % 避免除以零  
      
    % 计算边缘分布  
    marginalDist1 = sum(jointDist, 2);  
    marginalDist2 = sum(jointDist, 1);  
      
    % 计算互信息  
    pxy = jointDist ./ sum(jointDist(:));  
    px = marginalDist1 ./ sum(marginalDist1);  
    py = marginalDist2 ./ sum(marginalDist2);  
    mi = sum(sum(pxy .* log2(pxy ./ (px' * py))));  
end