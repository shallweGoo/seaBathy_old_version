function imag = imagFiltUseDiffFilter(imag_org,filter)
%ʹ�ò�ͬ�˲������˲�����
    if (ndims(imag_org) == 3)
        image_2zhi = rgb2gray(imag_org);
    else 
        image_2zhi = imag_org;
    end
    image_fft = fft2(image_2zhi);%�ø���Ҷ�任��ͼ��ӿռ���ת��ΪƵ����
    image_fftshift = fftshift(image_fft); %����Ƶ�ʳɷ֣�����ԭ�㣩�任������ҶƵ��ͼ����

    [height,width] = size(image_2zhi);
    for i = 1:width
        for j =1:height
            image_fftshift(j,i)= filter(i,j)*image_fftshift(j,i);
        end
    end
    
    imag = ifftshift(image_fftshift);%��ԭ�㷴�任��ԭʼλ��
    imag = uint8(real(ifft2(imag)));

end

