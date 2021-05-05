%计算pos1点处signal1和pos2处signal2的互相关,返回互相相关最大的那个点的幅值和时间
function [maxCor,TimeLag]=correlationCalc(signal1,signal2,timeInterval) 
% %   gpu加速版本(貌似没有加速很多)
%     [corMag_gpu,seriesNum]=xcorr(gpuArray(signal1),gpuArray(signal2),'coeff');
% %     plot(seriesNum,corMag_gpu); 
%     corMag = gather(corMag_gpu);


    [corMag,seriesNum]=xcorr(signal1,signal2,'coeff');
%     plot(seriesNum,corMag);


    
    [maxCor,TimeLag] = max(corMag);%最大的值,
    TimeLag = seriesNum(TimeLag)*timeInterval; %得到当前的时间
    
end
    
    

