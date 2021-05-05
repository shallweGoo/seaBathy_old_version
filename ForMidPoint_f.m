%sampleFreΪ����Ƶ��,��ʵ�źŲ��ÿ���ʱ�䣬ֻ����һ��һ����ķ�ֵ�Ϳ��ԣ�Ĭ��ʹ�ú�����
function f_rep = ForMidPoint_f(signal1,signal2,cpsdVar) 
    %����Ƶ��Ϊ��Ϊ���ã�Ŀǰ����֪����Ϊʲô����ʵ����Ƶ��Ϊ2hz����1s��2֡
%     [Cxy,~] = mscohere(signal1,signal2,hamming(100),50,[],sampleFre);%�漰����봰������ص�֪ʶ����ʱ��֪����
%     
%     [Pxy,F] = cpsd(signal1,signal2,hamming(cpsdVar.windowLen),cpsdVar.winOverLap,cpsdVar.f,cpsdVar.Fs);
    [Pxy,F] = cpsd(signal1,signal2,[],[],[],cpsdVar.Fs);
%     Pxy(Cxy<0.1) =0;
    mag = abs(Pxy);
%     plot(F,mag);
    
    lp = 0;
    rp = 0;
    for i = 1:size(F)
        if(F(i)>=cpsdVar.waveLow)
            lp = i;
            break;
        end
    end
    for i = lp:size(F)
       if(F(i)>=cpsdVar.waveHigh)
            rp = i;
            break;
       end
    end
    validMag = mag(lp:rp,1);
    validF = F(lp:rp,1);
    f_rep = validMag'*validF/sum(validMag);
end