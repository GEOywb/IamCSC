% mat2tif
% ���߹���mat�ļ�������Ϊtif
%clc; clear; close all;

%% load the hyperspectral image
% path = './';
% dataset = 'IndiaP';
% 
% location = [path, dataset];
% load (location);
%load temp4.mat
img = double(image2_new);
% ��ȡ����ά����Ϣ
[row, col, bands] = size(img);

% double����תunit8
%img_8 = uint8(img(:,:,:)/10000*256);
% img_8 = uint8(img*256);
img_8 = img;
% ����Ϊtifͼ��
t = Tiff('image2_new.tif','w');
% Ӱ����Ϣ
tagstruct.ImageLength = size(img_8,1); 
tagstruct.ImageWidth = size(img_8,2);  

% ��ɫ�ռ���ͷ�ʽ
tagstruct.Photometric = 1;

% ÿ�����ص���ֵλ��������ת��Ϊunit8������Ϊ8λ
tagstruct.BitsPerSample = 64; % 
% ÿ�����صĲ��θ�����һ��ͼ��Ϊ1��3�����Ƕ���ң��Ӱ����ڶ���������Գ�������3
tagstruct.SamplesPerPixel = bands;
tagstruct.RowsPerStrip = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% ��ʾ����Ӱ������
tagstruct.Software = 'MATLAB'; 
% ��ʾ���������͵Ľ���
tagstruct.SampleFormat = 3;
% ����Tiff�����tag
t.setTag(tagstruct);

% ��׼����ͷ�ļ�����ʼд����
t.write(img_8);
% �ر�Ӱ��
t.close;
