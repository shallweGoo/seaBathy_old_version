% �ú����������ݽضϣ��źſ�ʼ�ͽ�β�ĵط����ܴӲ����Ͽ�����̫�ã��������м�һ��

clc
clear;
%%  ѡ����й��ƣ�������Interval�ķ�Χ��������
fileInfo.file_path = "..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ3��ش���\�任��ͼƬ3��ͨ�˲�\";
addpath(fileInfo.file_path);
fileInfo.file_name = string(ls(fileInfo.file_path));
fileInfo.file_name = fileInfo.file_name(3:end);
fileInfo.file_num = size(fileInfo.file_name,1);

src = load(fileInfo.file_path+fileInfo.file_name(1));
[timeStack.row,timeStack.col] = size(src.afterFilt);
clear src;


%�ź������ѡ��
Interval = 100:900;
%

part = zeros(timeStack.row,Interval(end)-Interval(1)+1);


temp = fileInfo.file_path;
%% ��������û��detrend,Ȼ����нضϰ汾

for i = 1:fileInfo.file_num
        load(temp+"col"+num2str(i)+".mat"); %ԭʼ����
        row_data = afterFilt;
    parfor j = 1:timeStack.row
        part(j,:) = row_data(j,Interval);
    end
        save("..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\�任��ͼƬ3���ݽض�\���ݽض�1\col"+num2str(i)+".mat","part");
end



%% ����detrendȻ����нضϰ汾
% for i = 1:fileInfo.file_num
%     load(temp+"col"+num2str(i)+".mat"); %ԭʼ����
%     row_data = afterFilt;
%     row_data = detrend(row_data')';
%     parfor j = 1:timeStack.row
%         part(j,:) = row_data(j,Interval);
%     end
%         save("F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\���ݽض�5\col"+num2str(i)+".mat","part");
% end


