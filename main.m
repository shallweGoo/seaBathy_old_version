%�ú���Ϊ��ȷ��ݵ�������
dbstop if all error  % �������


% addpath('./filter/'); 
% addpath('./selectPic/');
% addpath('./imagProcess/');
addpath('./timeStackOperation/')
%% �Ƚ���ͼƬ������Ϣ��¼��
%  picInfo.file_path =  "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ\";% ͼ���ļ���·��
% 
%  picInfo.allPic = string(ls(picInfo.file_path));%ֱ�Ӱ������е��ļ���
%  picInfo.allPic = picInfo.allPic(3:end);
%  
%  picInfo.picnum = round(size(picInfo.allPic,1));%ͳ��������Ƭ������
%  
%  src=imread(picInfo.file_path+picInfo.allPic(1));
%  [picInfo.row,picInfo.col] = size(src);
%  
%  picInfo.timeInterval = 0.5; %��λs 
%  picInfo.pixel2Distance = 0.5; %��λ��
%  
% %����Ƶ�ʹ�������Ҫ�Ľṹ��
% cpsdVar.windowLen = round(picInfo.picnum/4);
% cpsdVar.winOverLap = round(cpsdVar.windowLen * 0.8);
% cpsdVar.f = 400;%����Ϊf/2
% cpsdVar.Fs = 2;%����Ƶ�ʣ���λhz
% cpsdVar.waveLow  = 0.05; % swell��Ƶ�ʷ�Χ
% cpsdVar.waveHigh = 0.2;  % 

%% main ��ȡÿ�����ص��ʱ������

% Time = zeros(1,picInfo.picnum);
% for i = 1:picInfo.picnum
%     Time(i)=i*picInfo.timeInterval;
% end

%����ȥ���������ƹ�һ��������
% data = load('DetrendAndNormalize.mat');
% DetrendAndNormalize = data.DetrendAndNormalize;


%% ͼƬԤ������ͨ�˲���������������Ƕ�ÿ�����ص��ʱ�����н����˲���,���������˽���ֱ��load
% PixelSeries = readData(picInfo);
% afterFilter = cell(picInfo.row,picInfo.col);
% myFilter = load('testLp2_0.5_0.6.mat');
% for i = 1 : picInfo.col
%     for j = 1 : picInfo.row
%     beforeFilterData = createSignal(PixelSeries,j,i);
%     beforeFilterData = [beforeFilterData,zeros(1,101)];
%     afterFilter{j,i} = filter(myFilter.test,1,beforeFilterData); 
%     afterFilter{j,i} = afterFilter{j,i}(52:picInfo.picnum+51);
%     afterFilter{j,i} = detrend(afterFilter{j,i}/255); %�ȹ�һ����ȥ������
%     afterFilter{j,i} = afterFilter{j,i}(1:1000); %����ȡ1000�����ǱȽϺõ�
%     end
% end

% data = load("afterFilter.mat");
% picInfo.afterFilter = data.afterFilter;

%% ��һ�γ��������getFullPixelSeries�У���main��ֱ��load��DetrendAndNormalize.mat������
% % ���˲�ֱ�Ӽ���
% % û���˲���Ԫ��
% DetrendAndNormalize = cell(height,width);
% PixelSeries = readData(file_path,allPic,picnum,height,width);  %��ȡʱ�����еĺ������ܴ��ڿ��ԸĽ��ĵط����������������м���
% for i = 1 : width
%     for j = 1 : height
%     DetrendAndNormalize{j,i} = createSignal(PixelSeries,j,i);
%     DetrendAndNormalize{j,i} = detrend(DetrendAndNormalize{j,i})/255;
%     end
% end


% data = load("afterFilter1_1000.mat");
% picInfo.afterFilter = data.afterFilter;

%% ���й���
range = zeros(picInfo.row,picInfo.col);
point.speed = zeros(picInfo.row,picInfo.col);
point.f = zeros(picInfo.row,picInfo.col);

%  ���밶��Զ�����ص���й���,˳�������ȷ���
seaDepth = NaN(picInfo.row,picInfo.col);
fixed_time = 3;

%����ʹ�õķ���
%1Ϊ�е�ȡ�ٶȷ�
%2Ϊ�̶�ʱ��Ϊ3s,��fixed_time = 3ʱ����Ϊ�ĵ�;
mode = 1;


% �̶�����
% for i = 1:picInfo.col %����������
%     t1 = cputime;
%     for j = picInfo.row:-1:1 %���밶��Զ�ĵط����򰶷�����й���
%         posReference = getSignalAndSetInfo(picInfo,j,i);
% %         [range,speedTemp,f_Temp] = selectRangeAndMidSpeedAndFrequence(DetrendAndNormalize,posReference,timeInterval,pixel2Distance,cpsdVar);
%         [~,speedTemp,f_Temp] = selectRangeAndMidSpeedAndFrequence(picInfo,posReference,cpsdVar);
%         mid = j - 20;%�������Ϊ�̶��������ã����ǲ�������ػ�û�н��
%         %         mid = round((j+range)/2);
%         if mid >= 1
%             point.speed(mid,i) = speedTemp(1);
%             point.f(mid,i) = f_Temp;
%             seaDepth(mid,i) = dispersionCalc(f_Temp,speedTemp(1));
%         else
%             break;
%         end
%     end
%     runtime = cputime-t1;
% end




% �Ի���ؽ��м��㣨�Ľ��棬����ÿ����һ�����ݼӿ������ٶȣ���Ŀǰʧ����
% ����һ�����������ÿһ�е�����ֵ
if mode == 1
    for i = 1:picInfo.col
    %     t1 = cputime;
        [point.f(:,i),point.speed(:,i)] = corForFandC(picInfo,i,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    %     run_time = cputime-t1;
    end
    
% ���ù̶�ʱ��ķ�ʽ�����й����ٶȵĹ���
% ÿһ�н��з�Χ����

% �ֱ��ʸ���Ҫ�ǵøò���
elseif mode == 2
    for i = 1:picInfo.col                  
        [TimeStack1,TimeStack2] = getTimeStack(picInfo,i,fixed_time);
        res = fixedTimeForCor(TimeStack1,TimeStack2); 
        [~,idx] = max(res,[],2); %����ÿ�е����ϵ��
        idx(1:49) = nan;  %ֱ������1��49Ϊ�����Ƶķ�Χ
        point.speed(:,i) = idx*picInfo.pixel2Distance/fixed_time;
%         point.f(:,i) = fixedTimeCorForF(idx,i,picInfo,cpsdVar);
        point.f(:,i) = fixedTimeCorForF_PS(i,picInfo,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    end
    % ��ƽ������Ĺ���
    
end
        


    
%% Ϊ�̶�ʱ��Ľ����һ��ƽ������

%     mean_seaDepth = seaDepth;
%     for i = 1:picInfo.col
%         for j = 1:5:picInfo.row
%             if j+2 <= picInfo.row
%                 mean_seaDepth(j:j+5,i) = mean(seaDepth(j:j+2,i));
%             else
%                 mean_seaDepth(j:end,i) = mean(seaDepth(j:end,i));
%             end
%         end
%     end
%    
   
    

        
%% ����plot

    
    seaDepth(imag(seaDepth)~=0) = nan;
    
    figure;   
    plotBathy(world,seaDepth);
%     figure;
%     plotBathy(world,mean_seaDepth);
    
%% ���Խ������Բ�ֵ������ֵΪnan��,���е㷽������ʱ�ͻ���ֺܶ��

if mode == 1 
    %% 
    interpolation.seaDepth = seaDepth;
    for i = 1:picInfo.col
        interpolation.total_x = 1:picInfo.row;
        interpolation.now_y  = interpolation.seaDepth(:,i)';
        interpolation.temp = interpolation.now_y;
        interpolation.insert_x = find(isnan(interpolation.now_y));
        interpolation.terminate_x = find(~isnan(interpolation.now_y),1,'last');
        interpolation.first_x = find(~isnan(interpolation.now_y),1,'first');
        interpolation.insert_x_idx = find(interpolation.insert_x>=interpolation.first_x & interpolation.insert_x <= interpolation.terminate_x);
        interpolation.insert_x = interpolation.insert_x(interpolation.insert_x_idx);
        interpolation.total_x(interpolation.insert_x) = [];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
    figure;
    plotBathy(world,interpolation.seaDepth);
    
end
   





            
            









    

    
    
  
    
    