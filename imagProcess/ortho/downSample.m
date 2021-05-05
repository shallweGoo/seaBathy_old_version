%�ú����Ĺ����Ƕ����������ϵĵ���ԭͼ�н����²���
%��֤��ÿ�����ص�֮��ľ�������ͬ��
%�������Ϊ�簶�����귶ΧcrossShoreRange�Լ��ذ������귶ΧlongShoreRange�����귶Χ�Լ�ѡ��,����Ҳ���Լ�ѡ����,
function downSampleImage= downSample(src,crossShoreRange,longShoreRange,crossShoreInterval,longShoreInterval,cameraMatrix,Re_c,T)
    crossPoint = crossShoreRange(1):crossShoreInterval:crossShoreRange(2);
    longPoint = longShoreRange(1):longShoreInterval:longShoreRange(2);
    downSampleImage = zeros(size(crossPoint,2),size(longPoint,2));
    wc = 1;
    for i = longShoreRange(1):longShoreInterval:longShoreRange(2)
        hc = 1;
        for j = crossShoreRange(1):crossShoreInterval:crossShoreRange(2)
            samplePointWorldCor = world2image(cameraMatrix,Re_c,T,[j;i;0]);
            if(samplePointWorldCor(1)>size(src,2) || samplePointWorldCor(1)<1 || samplePointWorldCor(2)>size(src,1) || samplePointWorldCor(2)<1)
            pixelValue = 0;
         else
            pixelValue = src(samplePointWorldCor(2),samplePointWorldCor(1));
            end
            downSampleImage(hc,wc) = pixelValue; 
            hc = hc+1;
        end
        wc = wc+1;
    end    
    downSampleImage = uint8(downSampleImage);
end

