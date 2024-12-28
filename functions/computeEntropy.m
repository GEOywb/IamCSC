function entropy = computeEntropy(probDist)  
    % ȷ�����ʷֲ���һ��������  
    probDist = probDist(:);  
      
    % ��������ʵ��µ���ֵ����  
    probDist(probDist == 0) = eps;  
      
    % ������  
    entropy = -sum(probDist .* log2(probDist));  
end