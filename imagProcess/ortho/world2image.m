%�ú�������������������������ת��
function imageCor = world2image(cameraMatrix,Re_c,T,worldCor)
    M = Re_c*worldCor;%��һ��Ϊ�˶��ڶ��worldCor���������꣩��������ת��
    Mdim = size(M,2);
    T_remat=repmat(T,1,Mdim);
    temp = cameraMatrix.mat*(M+T_remat);
%     imageCor(1,1) = floor(temp(1)/temp(3));
%     imageCor(2,1) = floor(temp(2)/temp(3));
    imageCor(1,:) = floor(temp(1,:)./temp(3,:));
    imageCor(2,:) = floor(temp(2,:)./temp(3,:));
end

