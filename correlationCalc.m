%����pos1�㴦signal1��pos2��signal2�Ļ����,���ػ�����������Ǹ���ķ�ֵ��ʱ��
function [maxCor,TimeLag]=correlationCalc(signal1,signal2,timeInterval) 
% %   gpu���ٰ汾(ò��û�м��ٺܶ�)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);


    [corMag,seriesNum]=xcorr(signal1,signal2,'coeff');
%     plot(seriesNum,corMag);


    
    [maxCor,TimeLag] = max(corMag);%����ֵ,
    TimeLag = seriesNum(TimeLag)*timeInterval; %�õ���ǰ��ʱ��
    
end
    
    

