img=imread('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ\uasDemo_1603582140501.jpg');

subplot(2,3,1);imshow(img);title('ԭͼ');
% f=rgb2gray(img);
f = img;
F=fft2(f);
F1=log(abs(F)+1);   %ȡģ����������
subplot(2,3,2);imshow(F1,[]);title('����Ҷ�任Ƶ��ͼ');
Fs=fftshift(F);      %��Ƶ��ͼ����Ƶ�ʳɷ��ƶ���Ƶ��ͼ����
S=log(abs(Fs)+1);    %ȡģ����������
subplot(2,3,3);imshow(S,[]);title('Ƶ�ƺ��Ƶ��ͼ');
fr=real(ifft2(ifftshift(Fs)));  %Ƶ���򷴱任���ռ��򣬲�ȡʵ��
% ret=im2uint8(mat2gray(fr));    %����ͼ������
ret=im2uint8(mat2gray(fr)); 
subplot(2,3,4);imshow(ret),title('�渵��Ҷ�任');
F2=log(abs(Fs).^2+1);   %������
subplot(2,3,5);imshow(F2,[]),title('������');