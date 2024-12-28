%{
Copyright (c) 2015, Tom Mertens
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}

%
% Implementation of Exposure Fusion
%
% written by Tom Mertens, Hasselt University, August 2007
% e-mail: tom.mertens@gmail.com
%
% This work is described in
%   "Exposure Fusion"
%   Tom Mertens, Jan Kautz and Frank Van Reeth
%   In Proceedings of Pacific Graphics 2007
%
%
% Usage:
%   result = exposure_fusion(I,m);
%   Arguments:
%     'I': represents a stack of N color images (at double
%       precision). Dimensions are (height x width x 3 x N).
%     'm': 3-tuple that controls the per-pixel measures. The elements 
%     control contrast, saturation and well-exposedness, respectively.


% 'I':��ʾN����ɫͼ��Ķ�ջ(˫����)���ߴ�Ϊ(�ߡ���� 3 �� N)��
% 'm':���������ض�����3Ԫ�顣��ЩԪ�طֱ���ƶԱȶȡ����ͶȺ������ع⡣
%
% Example:
%   'figure; imshow(exposure_fusion(I, [0 0 1]);'
%   This displays the fusion of the images in 'I' using only the well-exposedness
%   measure
%

function R = exposure_fusion4(img,m)
[r,c,K]=size(img{1});
R = zeros(r,c,K);
N=length(img);  %N��ʾ��ɫͼ�������
I = zeros(r,c,1,N);
for band = 1:K
    for i=1:N
        I(:,:,:,i)=img{i}(:,:,band);
    end
    r = size(I,1);
    c = size(I,2);
    N = size(I,4);
    
    W = ones(r,c,N);
    
    %compute the measures and combines them into a weight map
    %�������ֵ�������Ǻϲ���Ȩ��ͼ
    wexp_parm = m(3);
    
    if (wexp_parm > 0)
        W = W .*well_exposedness(I).^wexp_parm;
    end
    
    %normalize weights: make sure that weights sum to one for each pixel
    %��׼��Ȩ��:ȷ��ÿ�����ص�Ȩ��֮��Ϊ1
    W = W + 1e-12; %avoids division by zero���ⱻ���
    W = W./repmat(sum(W,3),[1 1 N]);
    
    % create empty pyramid�����յĽ�����
    pyr = gaussian_pyramid(zeros(r,c,1));
    nlev = length(pyr);

    % multiresolution blending��ֱ��ʻ��
    for i = 1:N
        % construct pyramid from each input image��ÿ������ͼ�񹹽�������
        pyrW = gaussian_pyramid(W(:,:,i));
        pyrI = laplacian_pyramid(img{i}(:,:,band));%I(:,:,:,i) img{i}(:,:,[120 72 36])
        
        % blend
        for l = 1:nlev
            w = pyrW{l};
            pyr{l} = pyr{l} + w.*pyrI{l};
        end
    end
 
    % reconstruct�ؽ�
    R(:,:,band)= reconstruct_laplacian_pyramid(pyr);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% well-exposedness measure
function C = well_exposedness(I)
sig = .2;
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    C(:,:,i) = exp(-.5*(I(:,:,1,i) - .5).^2/sig.^2);
end


