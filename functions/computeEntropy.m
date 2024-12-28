function entropy = computeEntropy(probDist)  
    % 确保概率分布是一个行向量  
    probDist = probDist(:);  
      
    % 避免零概率导致的数值问题  
    probDist(probDist == 0) = eps;  
      
    % 计算熵  
    entropy = -sum(probDist .* log2(probDist));  
end