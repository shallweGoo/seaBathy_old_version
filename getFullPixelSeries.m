clear;
% ��Ҫ�޸ĵĲ���
% ��Ӧ������ picInfo.idx



%% �Ƚ���ͼƬ������Ϣ��¼��
%  picInfo.file_path =  "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ1\";% ͼ���ļ���·��
%  ��Ӧ������
 picInfo.idx = 14;
 picInfo.idx = num2str(picInfo.idx);
 
 picInfo.file_path =  "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ"+picInfo.idx+"\";% ͼ���ļ���·��
 
 picInfo.allPic = string(ls(picInfo.file_path));%ֱ�Ӱ������е��ļ���
 picInfo.allPic = picInfo.allPic(3:end);
 
 picInfo.picnum = size(picInfo.allPic,1);%ͳ��������Ƭ������
 
 src=imread(picInfo.file_path+picInfo.allPic(1));
 [picInfo.row,picInfo.col] = size(src);
 clear src;
 
 
 
cpsdVar.windowLen = round(picInfo.picnum/4);
cpsdVar.winOverLap = round(cpsdVar.windowLen * 0.8);
cpsdVar.f = 400;%����Ϊf/2

world.crossShoreRange = 180;
world.longShoreRange = 135;

% if picInfo.idx == '1' || picInfo.idx == '9'
%     %����Ƶ�ʹ�������Ҫ�Ľṹ��
%     cpsdVar.Fs = 2;%����Ƶ�ʣ���λhz
%     picInfo.timeInterval = 1/cpsdVar.Fs; %��λs 
%     picInfo.pixel2Distance = 0.5; %��λ��
% elseif picInfo.idx == '2'
%     cpsdVar.Fs = 6;%����Ƶ�ʣ���λhz
%     picInfo.timeInterval = 1/cpsdVar.Fs; %��λs 
%     picInfo.pixel2Distance = 0.2; %��λ��
% else
%     cpsdVar.Fs = 6;%����Ƶ�ʣ���λhz
%     picInfo.timeInterval = 1/cpsdVar.Fs; %��λs 
%     picInfo.pixel2Distance = 0.5; %��λ��
%     if picInfo.idx == '4'
%         world.crossShoreRange = 180;
%         world.longShoreRange = 100;
%     elseif picInfo.idx == '5'|| picInfo.idx == '6'
%         world.crossShoreRange = 215;
%         world.longShoreRange = 115;
%     end
% end
 
 
% Ƶ��ѡ�������Ӱ��ܴ�
cpsdVar.waveLow  = 0.05;
cpsdVar.waveHigh = 0.2;


%��ͼ��������������Ϣ��֮ǰ�õķ�Χ
%     world.crossShoreRange = 200;
%     world.longShoreRange = 90;
    
    
    
    %�������ͬ��ȡֵ��Χ����ȷΪ��
    
    
    % �����ε����ݷ�Χ
    cpsdVar.Fs = 2;%����Ƶ�ʣ���λhz
    picInfo.timeInterval = 1/cpsdVar.Fs; %��λs 
    picInfo.pixel2Distance = 0.5; %��λ��
    
    
    world.crossShoreRange = 200;
    world.longShoreRange = 100;
%     
%     
%     
    world.x = 0:picInfo.pixel2Distance:world.longShoreRange;
    world.y = 0:picInfo.pixel2Distance:world.crossShoreRange;

%% ֱ�Ӷ��洢�õ�����
% ֮ǰ�汾��������Դ
% data = load("./someRes/afterFilter1_1000.mat");
% picInfo.afterFilter = data.afterFilter;


% ��timeStackϵ�л�ȡ��������Դ
% load("./timeStackOperation/data_cell_normalized.mat");
load("F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ"+picInfo.idx+"��ش���\����Ԫ������\data_cell_det&nor.mat");
picInfo.afterFilter = usefulData;



% �ò��˲��汾��timeStackϵ�л�ȡ��������Դ 600���� 300s(400-1000)
% data = load("./timeStackOperation/data_cell_detrend_normalized3.mat");
% picInfo.afterFilter = data.usefulData;

    

   
clear data;
clear usefulData;



%% main ��ȡÿ�����ص��ʱ������

% Time = zeros(1,picInfo.picnum);
% for i = 1:picInfo.picnum
%     Time(i)=i*picInfo.timeInterval;
% end



%% ͼƬԤ������ͨ�˲���������������Ƕ�ÿ�����ص��ʱ�����н����˲���,���������˽���ֱ��load
% PixelSeries = readData(picInfo);
% afterFilter = cell(picInfo.row,picInfo.col);
% load('testLp2_0.5_0.6.mat');
% % load('bpFilter0.05_0.5Fs2.mat');
% filter_len = size(test,2);
% for i = 1 : picInfo.col
%     for j = 1 : picInfo.row
%     beforeFilterData = createSignal(PixelSeries,j,i);
%     beforeFilterData = [beforeFilterData,zeros(1,filter_len)];
%     afterFilter{j,i} = filter(test,1,beforeFilterData); 
%     afterFilter{j,i} = afterFilter{j,i}(filter_len/2+1:picInfo.picnum+filter_len/2);
%     afterFilter{j,i} = detrend(afterFilter{j,i}./255);
%     afterFilter{j,i} = afterFilter{j,i}(1:1000); %����ȡ1000�����ǱȽϺõ�
%     end
% end
% picInfo.afterFilter = afterFilter;



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

%% ɾһЩ��ʱ����
%     clear src;
%     clear data;
