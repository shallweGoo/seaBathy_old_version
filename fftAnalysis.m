%�ú������ڶ��źŽ���fft����,ֻ���ڹ۲�Ƶ��ͼ
% ������ͼ����
function fft_M = fftAnalysis(signal,Fs)
    fft_total = fft(signal);
    fft_M = abs(fft_total);
    N = length(fft_total);
    frequence = (0:N/2-1)*Fs/N;
    fft_M = fft_M/N;
    fft_M(2:end) = 2*fft_M(2:end);
    
    plot(frequence,fft_M(1:length(frequence)));
end

