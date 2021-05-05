function [image_result] =bpfilter(image_orign,D0,w) %��ֹƵ�ʣ�����

%��ͨͨ�˲���

% D0Ϊ����Ƶ�ʵģ��൱�������ڸ���Ҷ��ͼ�İ뾶ֵ��

if (ndims(image_orign) == 3)

%�ж϶����ͼƬ�Ƿ�Ϊ�Ҷ�ͼ�����������ת��Ϊ�Ҷ�ͼ���������������

image_2zhi = rgb2gray(image_orign);

else 

image_2zhi = image_orign;

end

image_fft = fft2(image_2zhi);%�ø���Ҷ�任��ͼ��ӿռ���ת��ΪƵ����

image_fftshift = fftshift(image_fft);

%����Ƶ�ʳɷ֣�����ԭ�㣩�任������ҶƵ��ͼ����

[width,high] = size(image_2zhi);

D = zeros(width,high);
    
%����һ��width�У�high�����飬���ڱ�������ص㵽����Ҷ�任���ĵľ���

for i=1:width

    for j=1:high

        D(i,j) = sqrt((i-width/2)^2+(j-high/2)^2);

%���ص㣨i,j��������Ҷ�任���ĵľ���

        H(i,j) = exp(-((D(i,j)^2-D0^2)^2)/((D(i,j)*w)^2));

%��˹��ͨ�˲�����

        image_fftshift(i,j)= H(i,j)*image_fftshift(i,j);

%���˲������������ص㱣�浽��Ӧ����

    end

end

image_result = ifftshift(image_fftshift);%��ԭ�㷴�任��ԭʼλ��

image_result = uint8(real(ifft2(image_result)));

%real��������ȡ������ʵ����

%uint8�������ڽ����ص���ֵת��Ϊ�޷���8λ������ifft����������Ҷ�任