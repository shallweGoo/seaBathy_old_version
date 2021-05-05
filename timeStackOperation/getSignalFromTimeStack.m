function getSignalFromTimeStack(fileInfo,pattern)

% pattern ģʽ˵��
% pattern == 0 Ϊ3ά����汾
% pattern == 1 Ϊδ��һ��Ԫ���汾
% == 2,Ϊ��һ���汾


if nargin<2
    pattern = 2;
end

%�ӽ�ȡ���źŵ��ļ����л�ȡ����ͼƬ�ź�
% fileInfo.file_path = "..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2��ش���\�任��ͼƬ2���ݽض�\���ݽض�1\";
% % addpath(fileInfo.file_path);
% fileInfo.file_name = string(ls(fileInfo.file_path));
% fileInfo.file_name = fileInfo.file_name(3:end);
% fileInfo.file_num = size(fileInfo.file_name,1); 

% src = load(fileInfo.file_path+fileInfo.file_name(1));
% [timeStack.row,timeStack.col] = size(src.part);

% ͼƬ��СΪ361*271

% ��ԭ���ĳ���Ľ���������һ����ά����洢����,��֪���ܲ������Ч��
% usefulData = zeros(361,271,timeStack.col);


% Ԫ������汾
% org_path ="..\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2\";
% org_name = string(ls(org_path));
% org_name = org_name(3:end);
% org = imread(org_path+org_name(1));
usefulData = cell(fileInfo.org_imag.pic_row,fileInfo.org_imag.pic_col);

temp = fileInfo.partition.file_path; %���ٿ���
switch pattern 
    case 0
    % 3ά����汾���ݣ�֮����Ҫreshape
        for i = 1:fileInfo.time_stack.file_num
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
            usefulData{:,i} = mat_file.part;
        end
    case 1
    % Ԫ������汾����Ҫ˫ѭ�����������㣨���Ǹо�Ԫ������������ݽṹ����ʹ�ã� δ��һ��
    temp = fileInfo.file_path; %���ٿ���
        for i = 1:fileInfo.time_stack.file_num
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
            temp_mat = mat_file.part;
            for j= 1:size(temp_mat,1)
                usefulData{j,i} = temp_mat(j,:);
            end
        end
    case 2
    % Ԫ������汾��һ���汾����Ҫ˫ѭ�����������㣨���Ǹо�Ԫ������������ݽṹ����ʹ�ã�
        for i = 1:fileInfo.time_stack.file_num
            mat_file = load(temp+"col"+num2str(i)+".mat"); %���ݵ�mat��ʽ�ļ�
            temp_mat = mat_file.part;
            for j= 1:size(temp_mat,1)
               usefulData{j,i} = temp_mat(j,:)./max(abs(temp_mat(j,:)));
            end
        end
end

target_dir = fileInfo.create_cell.file_path;
save(target_dir+"data_cell_det&nor.mat","usefulData");

end