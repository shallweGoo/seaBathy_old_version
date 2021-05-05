%rowΪ��ǰ���ڵ�����
%idxΪ�����������õ�ÿһ��Ļ�������ֵ���ڵĵ�
function targetF = fixedTimeCorForF(idx,currentCol,picInfo,cpsdVar)
    targetF = nan(picInfo.row,1);
    for i = 1:picInfo.row
        if( ~isnan(idx(i)))
            orgSignal = picInfo.afterFilter{i,currentCol};
            targetSignal = picInfo.afterFilter{i-idx(i)+1,currentCol}; 
            targetF(i) = ForMidPoint_f(orgSignal,targetSignal,cpsdVar);
        end
    end
       
end

