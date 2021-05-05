function signal = clrDc(signal,mode)
    if nargin<2
        mode = 2;
    end
    %Ŀǰ�����ַ���ȥ��ֱ������
    %1.detrend ȥ����ѵ�����������Ʋ��Է���
    %2.�źż�ȥ��ֵ
    %3.��Ƶ������f=0Hz�ķ���Ϊ0
    
    switch mode
        case 1
            signal = detrend(signal);
            
        case 2
            signal = signal - mean(signal);
            
        case 3
            %�Ƚ��� fft�任
            fft_total = fft(signal);
            fft_total(1) = 0;
            signal = ifft(fft_total);
    end
    
end

