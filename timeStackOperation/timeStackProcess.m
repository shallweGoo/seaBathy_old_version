%统一timeStack的流程
%
clear 
clc
%% 在指定路径创建文件夹
dir_ind = 15;
dir_ind = num2str(dir_ind);
fileInfo.file_dir.dir_name = "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片"+dir_ind+"相关处理\";
fileInfo.file_dir.res_dir = ["变换后图片"+dir_ind+"时间堆栈","变换后图片"+dir_ind+"带通滤波","变换后图片"+dir_ind+"数据截断","最终元胞数据","最终结果"];


for i = 1:length(fileInfo.file_dir.res_dir)
    if ~exist(fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(i),'dir')
         mkdir(fileInfo.file_dir.dir_name,fileInfo.file_dir.res_dir(i));
    end
end


% 建立fullTimeStack,所需要的信息
fileInfo.org_imag.file_path = "F:\workSpace\matlabWork\dispersion\selectPic\afterPer\双月湾第二组变换后\变换后图片"+dir_ind+"\";
fileInfo.org_imag.pic_name = string(ls(fileInfo.org_imag.file_path));
fileInfo.org_imag.pic_name = fileInfo.org_imag.pic_name(3:end);
fileInfo.org_imag.pic_num = length(fileInfo.org_imag.pic_name);
tmp=imread(fileInfo.org_imag.file_path+fileInfo.org_imag.pic_name(1));
[fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col] = size(tmp);

%% 调用fullTimeStack.m
fullTimestack(fileInfo);

%% 建立bpFilterForTimeStack所需要的信息
fileInfo.time_stack.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(1)+"\";
fileInfo.time_stack.file_name = string(ls(fileInfo.time_stack.file_path));
fileInfo.time_stack.file_name = fileInfo.time_stack.file_name(3:end);
fileInfo.time_stack.file_num = length(fileInfo.time_stack.file_name);





% bp_filter信息
fs = 2;
fileInfo.bp_filter.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(2)+"\";
fileInfo.bp_filter.used_filter = load(['F:/workSpace/matlabWork/dispersion/filter_mat/bpfilter0.05_0.5Fs' num2str(fs) '.mat']); %注意修改对应的滤波器
fileInfo.bp_filter.file_name = string(ls(fileInfo.bp_filter.file_path));
fileInfo.bp_filter.file_name = fileInfo.bp_filter.file_name(3:end);
fileInfo.bp_filter.file_num = length(fileInfo.bp_filter.file_name);

%partition信息
fileInfo.partition.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(3)+"\";
fileInfo.partition.file_name = string(ls(fileInfo.partition.file_path));
fileInfo.partition.file_name = fileInfo.partition.file_name(3:end);
fileInfo.partition.file_num = length(fileInfo.partition.file_name);
fileInfo.partition.begin = 100;
fileInfo.partition.end = 1100;



%% 调用bpFilterForTimeStack.m  与getPartOfData.m合并版本 （可采用单独的getPartOfData.m版本进行截取信号）
bpFilterForTimeStack(fileInfo); %在里面加入了截取信号的部分




%% 组成一个元胞数组
fileInfo.create_cell.file_path = fileInfo.file_dir.dir_name+fileInfo.file_dir.res_dir(4)+"\";
fileInfo.create_cell.file_name = string(ls(fileInfo.create_cell.file_path));
fileInfo.create_cell.file_name = fileInfo.create_cell.file_name(3:end);
fileInfo.create_cell.file_num =  length(fileInfo.create_cell.file_name);

%% 调用getSignalFromTimeStack.m
getSignalFromTimeStack(fileInfo);


