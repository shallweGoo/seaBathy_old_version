%ͳһtimeStack������
%
clear 
clc
%% ��ָ��·�������ļ���
dir_ind = 15;
dir_ind = num2str(dir_ind);
fileInfo.file_dir.dir_name = "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ"+dir_ind+"��ش���\";
fileInfo.file_dir.res_dir = ["�任��ͼƬ"+dir_ind+"ʱ���ջ","�任��ͼƬ"+dir_ind+"��ͨ�˲�","�任��ͼƬ"+dir_ind+"���ݽض�","����Ԫ������","���ս��"];


for i = 1:length(fileInfo.file_dir.res_dir)
    if ~exist(fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(i),'dir')
         mkdir(fileInfo.file_dir.dir_name,fileInfo.file_dir.res_dir(i));
    end
end


% ����fullTimeStack,����Ҫ����Ϣ
fileInfo.org_imag.file_path = "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ"+dir_ind+"\";
fileInfo.org_imag.pic_name = string(ls(fileInfo.org_imag.file_path));
fileInfo.org_imag.pic_name = fileInfo.org_imag.pic_name(3:end);
fileInfo.org_imag.pic_num = length(fileInfo.org_imag.pic_name);
tmp=imread(fileInfo.org_imag.file_path+fileInfo.org_imag.pic_name(1));
[fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col] = size(tmp);

%% ����fullTimeStack.m
fullTimestack(fileInfo);

%% ����bpFilterForTimeStack����Ҫ����Ϣ
fileInfo.time_stack.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(1)+"\";
fileInfo.time_stack.file_name = string(ls(fileInfo.time_stack.file_path));
fileInfo.time_stack.file_name = fileInfo.time_stack.file_name(3:end);
fileInfo.time_stack.file_num = length(fileInfo.time_stack.file_name);





% bp_filter��Ϣ
fs = 2;
fileInfo.bp_filter.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(2)+"\";
fileInfo.bp_filter.used_filter = load(['F:/workSpace/matlabWork/dispersion/filter_mat/bpfilter0.05_0.5Fs' num2str(fs) '.mat']); %ע���޸Ķ�Ӧ���˲���
fileInfo.bp_filter.file_name = string(ls(fileInfo.bp_filter.file_path));
fileInfo.bp_filter.file_name = fileInfo.bp_filter.file_name(3:end);
fileInfo.bp_filter.file_num = length(fileInfo.bp_filter.file_name);

%partition��Ϣ
fileInfo.partition.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(3)+"\";
fileInfo.partition.file_name = string(ls(fileInfo.partition.file_path));
fileInfo.partition.file_name = fileInfo.partition.file_name(3:end);
fileInfo.partition.file_num = length(fileInfo.partition.file_name);
fileInfo.partition.begin = 100;
fileInfo.partition.end = 1100;



%% ����bpFilterForTimeStack.m  ��getPartOfData.m�ϲ��汾 ���ɲ��õ�����getPartOfData.m�汾���н�ȡ�źţ�
bpFilterForTimeStack(fileInfo); %����������˽�ȡ�źŵĲ���




%% ���һ��Ԫ������
fileInfo.create_cell.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(4)+"\";
fileInfo.create_cell.file_name = string(ls(fileInfo.create_cell.file_path));
fileInfo.create_cell.file_name = fileInfo.create_cell.file_name(3:end);
fileInfo.create_cell.file_num =  length(fileInfo.create_cell.file_name);

%% ����getSignalFromTimeStack.m
getSignalFromTimeStack(fileInfo);


