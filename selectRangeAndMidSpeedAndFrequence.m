%���ڲ�������������֪�ģ���ô��Ҫѡȡһ����Χ��ѡȡ��ԭ����������źź���һ���źŻ���ص�ֵ���
%��ò���֮������ٶȺ�Ƶ�ʵĹ���
%��Ҫ�Ľ�!
function [range,speed,f] = selectRangeAndMidSpeedAndFrequence(picInfo,posReference,cpsdVar)%posRefΪ�ο���,����λ��ѡȡĿ��㣬λ����Ϣʵ���ϰ�����x��y��Ϣ��xΪlongShore����,yΪcrossShore����
%% �ð汾���ǹ̶�������40m����ÿ��5�׽��з���   
    %Ԥ�����ڴ�
    %Ҫ���㼸�����ص�ͷ��伸���ڴ�
    
    PixelNum = 8;
    corVal = zeros(1,PixelNum+1);%���ڴ����s1���򰶴���ÿ�����ص�Ļ�������ֵ
    timeLag = zeros(1,PixelNum+1);%���ڴ���ʱ����Ϣ
    shoreDistance = zeros(1,PixelNum+1);%���ڴ��������Ϣ
    count = 2;
    
    pixelInterval = 5;  %ÿ�θ��������ص�
    if(posReference.y-PixelNum*pixelInterval>=1)
        for i = posReference.y-pixelInterval:-pixelInterval:posReference.y-PixelNum*pixelInterval %�м�ļ�����ڹ۲���������ص����һ��ͳ��(5m),4���㣬��Ӧ0.5s
            posTarget = getSignalAndSetInfo(picInfo,i,posReference.x);
            [corVal(count),timeLag(count)]=correlationCalc(posReference.signal,posTarget.signal,picInfo.timeInterval);
            count = count+1;
        end
    else 
        range = nan;
        speed = nan;
        f = nan;
        return;
    end

    %���д���Ƶ��f_ref�ļ���
    f = ForMidPoint_f(posReference.signal,posTarget.signal,cpsdVar);

    
%   ֱ��Ĭ�ϲ������м���
    range  = 0;
   
    shoreDistance(2:PixelNum+1) = (1:PixelNum)*picInfo.pixel2Distance*pixelInterval; %���ھ���Ĺ���
    plot(abs(timeLag),shoreDistance,'r.');
    speed = polyfit(abs(timeLag),shoreDistance,1); % ��Ͻ����е㴦�ٶȵļ��� abs()���Կ����ڻ���ؼ��㺯���м� 
 %% ����Ϊ���ķ���Ѱ�������صķ�Χ��Ȼ����й���
 
%         corVal = zeros(1,posReference.y - 1);%���ڴ����s1���򰶴���ÿ�����ص�Ļ�������ֵ
%         timeLag = zeros(1,posReference.y - 1);%���ڴ���ʱ����Ϣ
    


    %�������ĵķ���ѡ��������ֵ��Ϊ����,������õ�����ǿ�Ȳ�����������ֵ��Զ����õ��������һ���㣬����������������ֱ�ӿ���ȷ��������Ч��
    %�ֿ��Ǽ���̶�����������
    
%     for i = posReference.y-1:-10:1 
%         posTarget = getSignalAndSetInfo(picInfo.afterFilter,i,posReference.x);
%         %���������ȷ�Ļ�,covVal��������Ļ����ֵ
%         %timeLag���˻�������ֵ��Ӧ��ʱ��ʱ��
%         [corVal(posReference.y-posTarget.y),timeLag(posReference.y-posTarget.y)]=correlationCalc(posReference.signal,posTarget.signal,picInfo.timeInterval);
%     end

% %     �����ⲿ���ǰ���������ѡ��һ��������Χ���й��ƵĴ��룬�ֽ���ע��
%     
%     %���д���Ƶ��f_ref�ļ���
%     f = ForMidPoint_f(posReference.signal,posTarget.signal,cpsdVar);
%     [~,Position] = max(corVal);%��Positon����ο�λ�õľ���
%     range = posReference.y-Position;%��range��Ŀ������������
%     shoreDistance = (1:Position)*picInfo.pixel2Distance; %���ھ���Ĺ���
%     speed = polyfit(timeLag(1:Position),shoreDistance,1); % ��Ͻ����е㴦�ٶȵļ���  
    
   



end
    

%�����в���Ϊ100�����ص�~50m�����

