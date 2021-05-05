%��̬ŷ���Ƕ��壬�õ���ǰ�������ŷ���ǣ�Ҫ�õ�c1->c2��ŷ���ǣ�����Ӧ��Ϊc2->c1����ת����
% �÷�ʽΪz-x-y˳���ŷ���ǣ��ҳ˾���
function eulerAngle = Rotate2Euler(Rotate)
    yaw = atan(Rotate(2,1)/Rotate(1,1))*180/pi; %ƫ��������ԭ��ŷ���ǵĶ���
    pitch = asin(-Rotate(3,1))*180/pi;
    roll = atan(Rotate(3,2)/Rotate(3,3))*180/pi;
    eulerAngle(1) = yaw;
    eulerAngle(2) = pitch;
    eulerAngle(3) = roll;
end

