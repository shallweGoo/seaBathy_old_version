%% �ó���Ϊ��ʱ���źŽ����˲��ĳ���

% myBpFilter = load('testLp2_0.5_0.6.mat');
afterPic = zeros(height,width);
for i = 1:height
    for j = 1:width
        afterPic(i,j) = afterFilter{i,j}(1);
    end
end
afterPic = uint8(afterPic);
% imwrite(afterPic,"./afterPic1.jpg");

%% ��ͨ�˲��ķ���
contrastPic=imread(strcat(file_path,'1.jpg'));
img_f=fftshift(fft2(double(contrastPic)));  %����Ҷ�任�õ�Ƶ��
d0=50;
height_mid=fix(height/2);  %�ǲ��ǿ���������ȡ����ʽ��
width_mid=fix(width/2);  
img_lpf=zeros(height,width);
h = zeros(height,width);
for i=1:height
    for j=1:width
        d=sqrt((i-height_mid)^2+(j-width_mid)^2);   %�����ͨ�˲��������
        if d<=d0
            h(i,j)=1;
        else
            h(i,j)=0;
        end
        img_lpf(i,j)=h(i,j)*img_f(i,j);  
    end
end
img_lpf=ifftshift(img_lpf);    %������Ҷ�任
img_lpf=uint8(real(ifft2(img_lpf)));  %ȡʵ������
%%
figure(1);
imshow(afterPic);
% contrastPic=imread(strcat(file_path,'1.jpg'));
figure(2);
imshow(contrastPic);

figure(3)
imshow(img_lpf);
%%
file_path =  'F:\workSpace\matlabWork\dispersion\selectPic\4hzSample\';% ͼ���ļ���·��
contrastPic=imread(strcat(file_path,'1.jpg'));
afterPic = imread(".\afterPic1.jpg");
figure(4);
plot(contrastPic(:,1),'r');
hold on;
plot(afterPic(:,1),'b');
hold on;
cvFilter = imread('C:/Users/49425/Desktop/GsFilter1.jpg');
plot(cvFilter(:,1),'black');

% plot(img_lpf(:,1),'black')