
clear ;
img = imread("foam_area.jpg");
[height,width] = size(img);


% 
D0 = 10;
H = gaussfilter(width,height,D0);
% H = elliptic_lp_filter(height,width,60,20,20,3);

mesh(1:height,1:width,H);

[H_fs,H_ps]=fft2Analysis(H);

figure(1);
subplot(2,1,1);imshow(H_fs,[]);title('����Ҷ�任Ƶ��ͼ');
subplot(2,1,2);imshow(H_ps,[]),title('������');

aft_img = imagFiltUseDiffFilter(img,H);

[aft_img_fs,~]=fft2Analysis(aft_img);
[img_fs,~] = fft2Analysis(img);


figure(2);
subplot(2,1,1);imshow(img_fs,[]),title('ԭͼ����Ҷ�任Ƶ��ͼ');
subplot(2,1,2);imshow(aft_img_fs,[]);title('�任��ͼƬ����Ҷ�任Ƶ��ͼ');


figure(3);
subplot(2,1,1);imshow(img);title('ԭͼ');
subplot(2,1,2);imshow(aft_img),title('�˲����ͼ');