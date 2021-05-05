%�ú������ڵõ�����ʱ���ջ��0sʱ���ͺ�ʱ,fixed_time�ĵ�λΪ��,afterFilterȡ��ԭͼ����100��1100��ͼƬ
function [TimeStack1,TimeStack2] = getTimeStack(picInfo,col,fixed_time)
    if mod(fixed_time,picInfo.timeInterval) ~= 0
        error("you need to reselect fixed_time in interval time's integer multiple");
    end
    pixelInfo = picInfo.afterFilter(:,col);%��Ҫ�õ���һ�еĶ�ջ
    temp = zeros(picInfo.row,size(picInfo.afterFilter{1,1},2));
    %�õ��˸������е�ʱ������
    for i = 1:picInfo.row
        temp(i,:) = pixelInfo{i,:};
    end
    TimeStack1 = temp(:,1:end-fixed_time/picInfo.timeInterval);
    TimeStack2 = temp(:,fixed_time/picInfo.timeInterval+1:end);
end

