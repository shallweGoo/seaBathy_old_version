%�ú�����Ŀ����Ϊ���ڹ̶�һ��ʱ�䣬���㻥������ĵ�,
%�̶�ͼƬ��ÿһ�������㣨271�������Ű���ʱ���ջ��ÿ��������,ֱ�����㵽ͼƬ��ÿһ����

%timeStack�õ���ֻ��һ�е�ʱ���ջ������Ҫ�õ�����ͼƬ�ͻ���鷳
function res = fixedTimeForCor(timeStack_org,timeStack_fixedTime)
    noNeedDistance = 100; %�����������ֵ�Ͳ���ǰ����ˣ�ʵ���Ͼ����ǰ��ϵĵ�Ҳ���л���أ��Ҳ�֪�����������
    PredictRange = 80; %��PredictRange����֮��Ԥ�⻥������ֵ
    row = size(timeStack_org,1);
    cor_val =NaN(1,PredictRange);
    res = NaN(row,PredictRange);
    for i = row:-1:noNeedDistance
        for j = i:-1:i-PredictRange+1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�
%         for j = i:-1:1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�  
            cor_val(i-j+1) = corr(timeStack_org(i,:)',timeStack_fixedTime(j,:)','type','Pearson'); %������źż��㻥���
        end
%             plot(cor_val);
            res(i,:) = cor_val;
    end

end