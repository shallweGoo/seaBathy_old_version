%该函数为深度反演的主函数
dbstop if all error  % 方便调试


% addpath('./filter/'); 
% addpath('./selectPic/');
% addpath('./imagProcess/');
addpath('./timeStackOperation/')
%% 先进行图片基本信息的录入
%  picInfo.file_path =  "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片\";% 图像文件夹路径
% 
%  picInfo.allPic = string(ls(picInfo.file_path));%直接包括所有的文件名
%  picInfo.allPic = picInfo.allPic(3:end);
%  
%  picInfo.picnum = round(size(picInfo.allPic,1));%统计所有照片的数量
%  
%  src=imread(picInfo.file_path+picInfo.allPic(1));
%  [picInfo.row,picInfo.col] = size(src);
%  
%  picInfo.timeInterval = 0.5; %单位s 
%  picInfo.pixel2Distance = 0.5; %单位米
%  
% %进行频率估计所需要的结构体
% cpsdVar.windowLen = round(picInfo.picnum/4);
% cpsdVar.winOverLap = round(cpsdVar.windowLen * 0.8);
% cpsdVar.f = 400;%点数为f/2
% cpsdVar.Fs = 2;%采样频率，单位hz
% cpsdVar.waveLow  = 0.05; % swell的频率范围
% cpsdVar.waveHigh = 0.2;  % 

%% main 获取每个像素点的时间序列

% Time = zeros(1,picInfo.picnum);
% for i = 1:picInfo.picnum
%     Time(i)=i*picInfo.timeInterval;
% end

%载入去除线性趋势归一化的数据
% data = load('DetrendAndNormalize.mat');
% DetrendAndNormalize = data.DetrendAndNormalize;


%% 图片预处理（带通滤波）（在我理解来是对每个像素点的时间序列进行滤波）,保存下来了建议直接load
% PixelSeries = readData(picInfo);
% afterFilter = cell(picInfo.row,picInfo.col);
% myFilter = load('testLp2_0.5_0.6.mat');
% for i = 1 : picInfo.col
%     for j = 1 : picInfo.row
%     beforeFilterData = createSignal(PixelSeries,j,i);
%     beforeFilterData = [beforeFilterData,zeros(1,101)];
%     afterFilter{j,i} = filter(myFilter.test,1,beforeFilterData); 
%     afterFilter{j,i} = afterFilter{j,i}(52:picInfo.picnum+51);
%     afterFilter{j,i} = detrend(afterFilter{j,i}/255); %先归一化再去除趋势
%     afterFilter{j,i} = afterFilter{j,i}(1:1000); %发现取1000个点是比较好的
%     end
% end

% data = load("afterFilter.mat");
% picInfo.afterFilter = data.afterFilter;

%% 这一段程序放在了getFullPixelSeries中，在main里直接load（DetrendAndNormalize.mat）即可
% % 不滤波直接计算
% % 没有滤波的元胞
% DetrendAndNormalize = cell(height,width);
% PixelSeries = readData(file_path,allPic,picnum,height,width);  %读取时间序列的函数可能存在可以改进的地方，利用列向量整列计算
% for i = 1 : width
%     for j = 1 : height
%     DetrendAndNormalize{j,i} = createSignal(PixelSeries,j,i);
%     DetrendAndNormalize{j,i} = detrend(DetrendAndNormalize{j,i})/255;
%     end
% end


% data = load("afterFilter1_1000.mat");
% picInfo.afterFilter = data.afterFilter;

%% 进行估计
range = zeros(picInfo.row,picInfo.col);
point.speed = zeros(picInfo.row,picInfo.col);
point.f = zeros(picInfo.row,picInfo.col);

%  从离岸最远的像素点进行估计,顺便进行深度反演
seaDepth = NaN(picInfo.row,picInfo.col);
fixed_time = 3;

%设置使用的方法
%1为中点取速度法
%2为固定时间为3s,即fixed_time = 3时所成为的点;
mode = 1;


% 固定波长
% for i = 1:picInfo.col %按行来估计
%     t1 = cputime;
%     for j = picInfo.row:-1:1 %从离岸最远的地方向向岸方向进行估计
%         posReference = getSignalAndSetInfo(picInfo,j,i);
% %         [range,speedTemp,f_Temp] = selectRangeAndMidSpeedAndFrequence(DetrendAndNormalize,posReference,timeInterval,pixel2Distance,cpsdVar);
%         [~,speedTemp,f_Temp] = selectRangeAndMidSpeedAndFrequence(picInfo,posReference,cpsdVar);
%         mid = j - 20;%此条语句为固定波长所得，但是测出最大互相关还没有结果
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




% 对互相关进行计算（改进版，尝试每次用一列数据加快运算速度），目前失败了
% 利用一个数组来存放每一行的索引值
if mode == 1
    for i = 1:picInfo.col
    %     t1 = cputime;
        [point.f(:,i),point.speed(:,i)] = corForFandC(picInfo,i,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    %     run_time = cputime-t1;
    end
    
% 采用固定时间的方式来进行估计速度的估计
% 每一列进行范围估计

% 分辨率改了要记得该参数
elseif mode == 2
    for i = 1:picInfo.col                  
        [TimeStack1,TimeStack2] = getTimeStack(picInfo,i,fixed_time);
        res = fixedTimeForCor(TimeStack1,TimeStack2); 
        [~,idx] = max(res,[],2); %计算每行的相关系数
        idx(1:49) = nan;  %直接设置1：49为不估计的范围
        point.speed(:,i) = idx*picInfo.pixel2Distance/fixed_time;
%         point.f(:,i) = fixedTimeCorForF(idx,i,picInfo,cpsdVar);
        point.f(:,i) = fixedTimeCorForF_PS(i,picInfo,cpsdVar);
        seaDepth(:,i) = calDepth(point.speed(:,i),point.f(:,i));
        disp(['progress:' num2str(i/picInfo.col*100) '% completed']);
    end
    % 加平滑处理的过程
    
end
        


    
%% 为固定时间的结果加一个平均操作

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
   
    

        
%% 进行plot

    
    seaDepth(imag(seaDepth)~=0) = nan;
    
    figure;   
    plotBathy(world,seaDepth);
%     figure;
%     plotBathy(world,mean_seaDepth);
    
%% 可以进行线性插值，补上值为nan的,用中点方法计算时就会出现很多空

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
   





            
            









    

    
    
  
    
    