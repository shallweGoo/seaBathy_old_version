function res = testfixedTimeForCor(timeStack_org,timeStack_fixedTime,i)
% �ó���ΪfixedTimeForCor�Ĳ��԰棬����ѡ��һ��timeStack���м��㣬i�����ڵ�λ��
%     noNeedDistance = 50; %�����������ֵ�Ͳ���ǰ����ˣ�ʵ���Ͼ����ǰ��ϵĵ�Ҳ���л���أ��Ҳ�֪�����������
    PredictRange = 200; %��PredictRange����֮��Ԥ�⻥������ֵ
    row = size(timeStack_org,1);
    cor_val = NaN(1,PredictRange);
    res = NaN(row,PredictRange);
        for j = i:-1:i-PredictRange+1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�
%         for j = i:-1:1 %�ӱ���ʼ������ؿ�ʼ�������Ƴ̶�  
            cor_val(i-j+1) = corr(timeStack_org(i,:)',timeStack_fixedTime(j,:)','type','Pearson'); %������źż��㻥���
        end
            plot(cor_val);
            res(i,:) = cor_val;
end
