%�ú������ڶ�ͼ���е�һ��ʱ���������ݽ���������е����
%�õ�ÿһ������Ӧ�ĺ�ˮ���
function [f,c] = corForFandC(picInfo,currentCol,cpsdVar)
    %һ����Χ���밶����ô����ʱ��Ͳ������ˣ���Ϊͼ�����а�������������ø��ռ�ֱ������
    % ���ֱ���Ϊ0.5mʱ���ò���������Ϊ40��20m��
    
    
    aRange = 40;
    
    
    %temp_����Ϊ�˽�ʡ��parfor��ϵͳ�Ŀ���
    temp_data = picInfo.afterFilter;
    temp_timeInterval = picInfo.timeInterval;
    
    f = nan(picInfo.row,1);
    c = nan(picInfo.row,1);
    
%     debug_cor = nan(picInfo.row,1);
    
    % ���û���ع��Ƶľ������ƣ�Ŀǰ�������20��֮�⣨10m��֮��������ϵ������ѡȡ
    % �ò�����������ռ�ֱ����йأ�����ʱ��10mΪ��׼
    ov_range = 10; % ��Ҫ���ӵľ��룬��λΪ��(m)
    ov_range = round(ov_range/picInfo.pixel2Distance);
    dst_itv = 4;%ÿ������������һ�λ���ؼ���
    
    for i = picInfo.row:-1:aRange %�ӵ����һ�п�ʼ��ǰ����

%     for i = aRange:picInfo.row %�ӵ�һ�п�ʼ������

        ref = temp_data{i,currentCol};
%         maxCorVal = nan(1,i-1);%��¼ÿ����Ͳο���(Ҳ������һ����)��������ֵ
%         timeLag = nan(1,i-1);%��¼ÿ����Ͳο���������ֵ����Ӧ��ʱ��
        
        %���㻥���
%         cor_cof = nan(1,i-1); % ������¼�����źŵ����ϵ��
        
%         parfor j = 1:i-1
%             target = temp_data{j,currentCol};
%             cor_cof(j) = corr(ref',target','type','Pearson');
%             [~,timeLag(j)]= correlationCalc(ref,target,temp_timeInterval); %�õ�ÿ�����ֵ������Ӧ��ʱ��
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  �޸������Ǹ����м���ṹ(parfor)�汾 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        target = cell2mat(temp_data(1:i-1,currentCol)); 
        cor_cof = corr(ref',target','type','Pearson'); %��ȡ�����ϵ��
        cor_cof_begin = round(length(cor_cof)*0.6);
        cor_cof_end = length(cor_cof) - ov_range;
        while(cor_cof_begin>ov_range && cor_cof_begin>cor_cof_end  )
           cor_cof_begin = cor_cof_begin-5;
        end
        [~,mostSim] = max(cor_cof(cor_cof_begin:cor_cof_end));  % ѡȡcor_cof�����Ƶľ���
        
        mostSim = mostSim+round(length(cor_cof)*0.6)-1;
        
%         debug_cor(i) = i-mostSim+1;
        
        %����ʱ�ͻ���Ҫ�����һ��ѭ����xcorr��֧�ֶ��м���
        %����ÿ��2m������һ�ι���
%         dst_itv = 4;%�������ص�,����ǰ��ı�������
        t_lag_idx = mostSim:dst_itv:i-1; %��������
        timeLag = nan(1,size(t_lag_idx,2));
        
%         ��������汾��ÿ���㶼���м���Ļ�����)        
%         parfor j =  mostSim:i-1
%             [~,timeLag(j)]= correlationCalc(ref,target(j,:),temp_timeInterval);
%         end
        sup_count = 1;
        for j = t_lag_idx
            [~,timeLag(sup_count)]= correlationCalc(ref,target(j,:),temp_timeInterval);
            sup_count = sup_count+1;
        end
          
%%%%%%%%%%%%%%%%%%%
        
        
        
        
        

        
%         [~,mostSim] = max(cor_cof(1:end-ov_range));
        
        
        
        
        %�����ٶȹ��Ƶ�ɢ��
        
%         shoreDistance = zeros(1,i-mostSim+1);
%         time_lag = zeros(1,i-mostSim+1); 
%         time_lag(2:end) = timeLag(end:-1:mostSim); %����Ĺ�ϵ��Ҫ�ú�����һ��
        



%         shoreDistance = [0,(1:i-mostSim)*picInfo.pixel2Distance]; %���ھ���Ĺ���
%         timeLag = [0,flip(abs(timeLag(1,mostSim:i-1)))]; %ʱ�ͼ���
      
        
        timeLag = flip(abs(timeLag)); %ʱ�ͼ���
        
        for idx = 2:size(timeLag,2)      %�����źŵ�����ԭ��ʱ�䲢����չ�ֵ����Ĺ��ɣ���������䣬���Դ�ʱ��Ҫɸѡʱ���ź�
             if timeLag(idx)<timeLag(idx-1) || timeLag(idx)>timeLag(idx-1)+5
                    break;
             end
        end
        
        timeLag = [0,timeLag(1:idx-1)];
        
        shoreDistance = [0,(1:idx-1)*picInfo.pixel2Distance*dst_itv]; %���ھ���Ĺ���

        midPoint = round((i+mostSim)/2); %�е㴦������
        
        
        linearCurve = polyfit(timeLag,shoreDistance,1); % ��Ͻ����е㴦�ٶȵļ��㣨��ѡȡ�������ص��ź�֮������ѡȡ��Χ��
        %         linearCurve = polyfit(abs(time_lag),shoreDistance,1); % ��Ͻ����е㴦�ٶȵļ���
        
        
%%%%%%%%%%%%%%%%%%%%%%%%debug���
%         figure(3);
%         plot(timeLag,shoreDistance,'r*');
%         hold on;
%         tmp_y = polyval(linearCurve,timeLag);
%         plot(timeLag,tmp_y,'b');
%         figure(1);
%         plot(maxCorVal,'b');
        figure(2);
        plot(cor_cof,'r');
        
        % ȡƽ��ֵ����
        if(isnan(c(midPoint)))
            c(midPoint) = linearCurve(1);
        else
            c(midPoint) = (linearCurve(1)+c(midPoint))/2;
        end
        
        
        % ȡƽ��ֵ����
        if(isnan(f(midPoint)))
            f(midPoint) = ForMidPoint_f(ref,temp_data{mostSim,currentCol},cpsdVar);% ����f_ref,�����е��Ƶ��
        else
            temp_f = ForMidPoint_f(ref,temp_data{mostSim,currentCol},cpsdVar);
            f(midPoint) = (temp_f+f(midPoint))/2;
        end
        

        
    end

end
