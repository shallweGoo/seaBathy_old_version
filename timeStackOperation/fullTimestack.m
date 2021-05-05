%�ó���Ϊ�˵õ�����Ŀ��ͼ��ÿһ�е�ʱ���ջͼ
%����ͼ��Ϊ361*271��һ����1000��ͼ����ô���Եõ�271��ʱ�����е�ͼ(TimeStack)
% clc
% 

function fullTimestack(fileInfo)
    % fileInfo.file_path="F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ3\";
    % addpath(fileInfo.file_path);
    % fileInfo.pic_name = string(ls(fileInfo.file_path));
    % fileInfo.pic_name = fileInfo.pic_name(3:end);
    % fileInfo.pic_num = size(fileInfo.pic_name,1);
    % src=imread(fileInfo.pic_name(1));
    % [picInfo.row,picInfo.col] = size(src);
    TimeStack.pic_num = fileInfo.org_imag.pic_col;
    TimeStack.timestack = cell(1,TimeStack.pic_num);

%ÿ��ͼƬ��ȡһ��
    for i = 1:fileInfo.org_imag.pic_num
        temp_pic = imread(fileInfo.org_imag.file_path+fileInfo.org_imag.pic_name(i));
        for j = 1:fileInfo.org_imag.pic_col
            TimeStack.timestack{j}(:,i) = temp_pic(:,j);
        end
    end

%��Ϊ.mat�ļ���Ҫ�Ǵ�ΪͼƬ��ʽ�ļ��ᱨ��
% for i = 1:TimeStack.pic_num
%     row_timestack = TimeStack.timestack{i};
%     save("..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ3��ش���\�任��ͼƬ3ʱ���ջ\"+"col"+num2str(i)+".mat","row_timestack");
% end

    target_dir = fileInfo.file_dir.dir_name+ fileInfo.file_dir.res_dir(1)+"\";
    for i = 1:TimeStack.pic_num
        row_timestack = TimeStack.timestack{i};
        save(target_dir+"col"+num2str(i)+".mat","row_timestack");
    end
end
    

    
    