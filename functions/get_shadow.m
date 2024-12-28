function [ori,shadow,www] = get_shadow(data)
%img = data(:,:,[40 23 12]);%MUUFL
img = data;%(:,:,[25 14 6]);%Houston2018   18-25   8-14   4-6




%img = data(:,:,[23 14 6]);%Houston2018   18-25   8-14   4-6
ori = img;
%img = data(:,:,[59 40 23]);%houston2013   R: 625–740 μm, G: 492–577 μm, B: 440–475 μm

% for kk=1:3
%     img(:,:,kk)=(img(:,:,kk)-min(min(img(:,:,kk))))/(max(max(img(:,:,kk)))-min(min(img(:,:,kk))))*255;
% end

%img=(img-min(min(min(img))))/(max(max(max(img)))-min(min(min(img))))*255;


hsi = rgb2hsi(img);
% figure;imshow(hsi);
re_img = (hsi(:,:,1) + 1) ./ (hsi(:,:,3) + 1);
re_img=mat2gray(re_img);
% figure;imshow(re_img,[]);

level = graythresh(re_img) + 0.1; % 黑色多了：要变大
re_img(re_img>=level) = 1;
re_img(re_img<level) = 0;
re_img = 1 - re_img; % 阴影图像
www=re_img;
%% 清理孤立的像素点
re_img = 1 - re_img;
re_img = bwmorph(re_img,'spur',1);%去毛刺

re_img = bwmorph(re_img,'hbreak',1);%断连通

re_img = bwareaopen(re_img,35); % 去除小面积区域
re_img = 1- re_img;

re_img = bwareaopen(re_img,10); % 填充
re_img = double(re_img);
shadow = re_img;