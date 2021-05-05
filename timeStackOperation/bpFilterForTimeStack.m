%�ýű�Ϊʱ���ջ���ݽ��д�ͨ�˲�
%�洢ÿһ�е�ʱ���ջ���겨֮����ź�


function bpFilterForTimeStack(fileInfo)
%     clear;
%     clc;
%     fileInfo.file_path = "..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\�任��ͼƬ2ʱ���ջ\";
%     addpath(fileInfo.file_path);
%     fileInfo.file_name = string(ls(fileInfo.file_path));
%     fileInfo.file_name = fileInfo.file_name(3:end);
%     fileInfo.file_num = size(fileInfo.file_name,1);
%     src = load(fileInfo.file_path+fileInfo.file_name(1));
%     [timeStack.row,timeStack.col] = size(src.row_timestack);

    filter_len = length(fileInfo.bp_filter.used_filter.bpfilter);
    bpfilter = fileInfo.bp_filter.used_filter.bpfilter;
    afterFilt = zeros(fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_num);
    filter_half =  floor(filter_len/2);
    f_start = filter_half+1;
    % ��ÿһ��ʱ���ջ���ݽ���0.05-0.5hz���˲�,ע��������˲���ʱ��ѡ��Ĳ���Ƶ��
    target_dir_filter = fileInfo.bp_filter.file_path;
    target_dir_part = fileInfo.partition.file_path;
    
    for i = 1:fileInfo.time_stack.file_num
        row_data = load(fileInfo.time_stack.file_path+"col"+num2str(i)+".mat"); %ԭʼ����
        det_data = detrend(double(row_data.row_timestack)')';% ȥ�����ƻ�(ʦ��˵��������ȥ��ֱ������)�������Թ�Ȼ���ԣ�ֵ��ѧϰ
        for j = 1:fileInfo.org_imag.pic_row
            temp = [det_data(j,:),zeros(1,filter_len)]; %�˲�����
            temp = filter(bpfilter,1,temp); 
            afterFilt(j,:) = temp(f_start:fileInfo.org_imag.pic_num+filter_half);
        end
        part = afterFilt(:,fileInfo.partition.begin:fileInfo.partition.end);
        save(target_dir_filter+"col"+num2str(i)+".mat","afterFilt");
        save(target_dir_part+"col"+num2str(i)+".mat","part");
    end
end

