function targetF = fixedTimeCorForF_PS(currentCol,picInfo,cpsdVar)
%FIXEDTIMECORFORF_PS �ú���Ϊ�̶�ʱ�䷽��Ҫ���еĺ��˵�Ƶ�ʣ��Ͳ��ñ���Ĺ����׽���Ƶ�ʵ�
%���㣬����ȥѰ����һ��������
    targetF = nan(picInfo.row,1);
    for i = 1:picInfo.row
            orgSignal = picInfo.afterFilter{i,currentCol};
            targetF(i) = ForMidPoint_f(orgSignal,orgSignal,cpsdVar);
    end
end

