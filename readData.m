% ��ȡͼƬÿһ�е�ʱ�����У��ܹ���height*width��ʱ������,û����ʱ�䣬�ں������ֶ������������
%����˵����pathΪ·����picnumΪͼƬ��������
function PixeSeries=readData(picInfo)
    PixeSeries = zeros(picInfo.row,picInfo.col,picInfo.picnum);
    %��ά����
        for k = 1:picInfo.picnum
            pixelInfo = imread(strcat(picInfo.file_path,picInfo.allPic(k)));
%             for i = 1:height
               for j = 1:picInfo.col
                    PixeSeries(:,j,k)= pixelInfo(:,j);
               end
%            end
        end               
end

