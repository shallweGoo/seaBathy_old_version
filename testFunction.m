% clc
% close all;

Fs = 2;
N = 500;
n = 0:N-1;
t = n/Fs;
% noise = sin(2*pi*0.7*t);
% x = sin(2*pi*0.2*t)+10*rand(1,N);
% x =20*rand(1,N);
% y = sin(2*pi*1.2*t)+rand(1,N);%如果是周期函数，平移时间不会超过T/2，y晚于x
% y2 = rand(1,N);
% y = zeros(2,N);
% y(1,:) = y1;
% y(2,:) = y2; 
% 
% sum_xy = x;
% [m,n] = correlationCalc(x,y,1/Fs)

%% 这一段为测试平方相干性和功率谱
% [Cxy,F] = mscohere(x,y,hamming(100),80,100,Fs);
% subplot(2,1,1);
% plot(F,Cxy)
% title('Magnitude-Squared Coherence')
% xlabel('Frequency (Hz)')
% grid

% [Pxy,F] = cpsd(x,x,hamming(100),80,100,Fs);
% % [Pxy,F] = cpsd(x,x,[],[],[],Fs);
% %     Pxy(Cxy<0.1) =0;
% mag = abs(Pxy);
% plot(F,mag);


%% 这一段是测试去直流分量，查看数据效果，分别用了三种去直流方法继续测试，并在频谱图和功率谱上画出

   cr = 300; %choose row 即选定的行


   row = double(row_timestack);
   x = row(cr,:);

   Fs = 2;
   x1 = clrDc(x,1);
   x2 = clrDc(x,2);
   x3 = clrDc(x,3);
   
%    fftAnalysis(x1,Fs);
%    fftAnalysis(x2,Fs);
%    fftAnalysis(x3,Fs);
   
   figure(1);
%    plot(x1,'r');
%    hold on;
%    plot(x2,'g');
%    hold on;
%    plot(x3,'b');
   plot(afterFilt(cr,:),'b');
   hold on;
   plot(x,'k');
   
    [Pxy,F] = cpsd(x,x,[],[],[],Fs);
    mag = abs(Pxy);
    
    [Pxy1,F1] = cpsd(x1,x1,[],[],[],Fs);
    mag1 = abs(Pxy1);
    
    [Pxy2,F2] = cpsd(x2,x2,[],[],[],Fs);
    mag2 = abs(Pxy2);

    [Pxy3,F3] = cpsd(x3,x3,[],[],[],Fs);
    mag3 = abs(Pxy3);
    
    
    [Pxy4,F4] = cpsd(afterFilt(cr,:),afterFilt(cr,:),[],[],[],Fs);
    mag4 = abs(Pxy4);
    figure(2);
    
    plot(F1,mag1,'r')
    hold on;
    plot(F2,mag2,'g');
    hold on;
    plot(F3,mag3,'b');
    hold on;
%     plot(F, mag, 'k');
%     hold on;
    plot(F4, mag4, 'y');
    
%%    
% 求互相关计算

% [a,timelag]=correlationCalc(x,y,1/Fs);%y晚于x，则此时时滞为负
% timelag

% figure(1);
% plot(timelag,a);






% 
% figure(2);
% plot(t,x,'b',t,y,'r');


%fft
% s1 = afterFilt(300,100:1000);
% s2 = picInfo.afterFilter{300,200};
% figure(1);
% s1_fft = fftAnalysis(s1,Fs);
% figure(2);
% s2_fft = fftAnalysis(s2,Fs);


%filter
% myFilter = load('bpFilter0.05_0.5Fs2.mat');

% myFilter = load(".\filter_mat\0.05_0.5_fs4_bp2.mat");
% 
% sum_xy1 = [sum_xy,zeros(1,length(myFilter.bpfilter))];
% after_xy = filter(myFilter.bpfilter,1,sum_xy1);
% % after_xy = filter(myFilter.test,1,sum_xy);
% % figure,plot(t,x,'b',t,sum_xy,'r',t,after_xy(length(myFilter.bpfilter)/2+1:N+length(myFilter.bpfilter)/2),'black');
% after_xy = after_xy(floor(length(myFilter.bpfilter)/2)+1:N+floor(length(myFilter.bpfilter)/2));
% figure(1),plot(t,x,'b',t,after_xy,'black');


%

% row_timestack = double(row_timestack);
% testSignal = row_timestack(300,:);
 [Pxy,F] = cpsd(testSignal,testSignal,[],[],[],Fs);
%     Pxy(Cxy<0.1) =0;
mag = abs(Pxy);
figure;
plot(F,mag);


% ForMidPoint_f(after_xy,after_xy,cpsdVar)
%% 测试滤波之后还原的信号时滞是否跟之前相同
% test_signal1 = x + noise;
% test_signal1 = [test_signal1,zeros(1,101)];
% test_signal1 = filter(myFilter.test,1,test_signal1);
% test_signal1 = test_signal1(52:N+51);
% % test_signal1 = detrend(double(test_signal1)/255);
% 
%     
% test_signal2 = y + noise;
% test_signal2 = [test_signal2,zeros(1,101)];
% test_signal2 = filter(myFilter.test,1,test_signal2);  
% test_signal2 = test_signal2(52:N+51);
% % test_signal2 = detrend(double(test_signal2)/255);
% 
% 
% [~,timelag1] = correlationCalc(test_signal1,test_signal2,1/Fs)

%%

% 
% [max,timelag2] = correlationCalc(x,y,1/Fs)
% c = 5.6;
% g = 9.8;
% f = 0.2;
% (c/2/pi/f)*atanh(2*pi*c*f/g)




%%
  tmp = imread("F:/workSpace/matlabWork/imgResult/orthImg/finalOrth_1603524600000.jpg");
  tmp = insertShape(tmp,'Line',[20 1 20 401],'LineWidth',1,'Color','r');
  tmp = insertShape(tmp,'Line',[120 1 120 401],'LineWidth',1,'Color','r');
  imshow(tmp);
  
%%
  fixedtime = seaDepth(:,500);%分辨率为0.2m设为200
  fixedtime = fixedtime(400:end); %分辨率为0.2m时设为180
  t_cor = interpolation.seaDepth(:,500);
  t_cor = t_cor(400:end); %分辨率为0.2m时设为180
  plot(fixedtime,'r');
  hold on;
  plot(t_cor,'b');
%%
  load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片2相关处理\最终结果\fixedTime3s_det&nor(100_1500)_psd(0.05_0.2).mat')
  fixedtime_20cm_tmp = seaDepth(:,500);
  fixedtime_20cm_tmp = fixedtime_20cm_tmp(450:end);
  load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片2相关处理\最终结果\t_cor_det&nor(100_1500)_psd(0.05_0.2).mat')
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
        interpolation.total_x(interpolation.insert_x) =[];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
   t_cor_20cm_tmp = interpolation.seaDepth(:,500);
   t_cor_20cm_tmp = t_cor_20cm_tmp(450:end);
   
   
   %%%% 分辨率不同时需要转换
   fixedtime_20cm_tmp_len = length(fixedtime_20cm_tmp);
   idx = 1;
   fixedtime_20cm = zeros(1,length(1:5:fixedtime_20cm_tmp_len));
   for i = 1:5:fixedtime_20cm_tmp_len
      fixedtime_20cm(idx) = fixedtime_20cm_tmp(i);
      idx=idx+1;
   end
   
   
   t_cor_20cm_tmp_len = length(t_cor_20cm_tmp);
   idx = 1;
   t_cor_20cm = zeros(1,length(1:5:t_cor_20cm_tmp_len));
   for i = 1:5:t_cor_20cm_tmp_len
      t_cor_20cm(idx) = t_cor_20cm_tmp(i);
      idx=idx+1;
   end
   
   
   %%%%%%
   %%
   load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片3相关处理\最终结果\fixedTime3s_det&nor(100_1500)_psd(0.05_0.2).mat')
   fixedtime_50cm_tmp = seaDepth(:,200);
   fixedtime_50cm_tmp = fixedtime_50cm_tmp(180:end);
   load('F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片3相关处理\最终结果\t_cor_det&nor(100_1500)_psd(0.05_0.2).mat');
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
        interpolation.total_x(interpolation.insert_x) =[];
        interpolation.now_y(interpolation.insert_x) = [];
        interpolation.insert_y = interp1(interpolation.total_x,interpolation.now_y,interpolation.insert_x,'nearest');
        interpolation.temp(interpolation.insert_x) = interpolation.insert_y;
        interpolation.seaDepth(:,i) = interpolation.temp;
    end
   t_cor_50cm_tmp = interpolation.seaDepth(:,200);
   t_cor_50cm_tmp = t_cor_50cm_tmp(180:end);
   
   
   
   %%% 分辨率不同时需要转换
   fixedtime_50cm_tmp_len = length(fixedtime_50cm_tmp);
   idx = 1;
   fixedtime_50cm = zeros(1,length(1:2:fixedtime_50cm_tmp_len));
   for i = 1:2:fixedtime_50cm_tmp_len
      fixedtime_50cm(idx) = fixedtime_50cm_tmp(i);
      idx=idx+1;
   end
   
   
   t_cor_50cm_tmp_len = length(t_cor_50cm_tmp);
   idx = 1;
   t_cor_50cm = zeros(1,length(1:2:t_cor_50cm_tmp_len));
   for i = 1:2:t_cor_50cm_tmp_len
      t_cor_50cm(idx) = t_cor_50cm_tmp(i);
      idx=idx+1;
   end
   
   %%
   
   
   
   
   
   figure(1);
   plot(t_cor_20cm,'k');
   hold on;
   plot(t_cor_50cm,'g');
   legend("t\_cor\_20cm","t\_cor\_50cm");
   figure(2);
   plot(fixedtime_20cm,'k');
   hold on;
   plot(fixedtime_50cm,'g');
   legend("fixedtime\_20cm","fixedtime\_50cm");
   
   
   
   
   
   