function [mat_fs,ps] = fft2Analysis(mat)
%FFT2ANALYSIS ����2ά�����fft���������Ƴ�Ƶ��ͼ�͹�����ͼ
%   �˴���ʾ��ϸ˵��
    F=fft2(mat);
    Fs=fftshift(F);      %��Ƶ��ͼ����Ƶ�ʳɷ��ƶ���Ƶ��ͼ����
    mat_fs=log(abs(Fs)+1);    %ȡģ����������
%     subplot(2,1,1);imshow(mat_fs,[]);title('����Ҷ�任Ƶ��ͼ');
    ps=log(abs(Fs).^2+1);   %������
%     subplot(2,1,2);imshow(ps,[]),title('������');
end

