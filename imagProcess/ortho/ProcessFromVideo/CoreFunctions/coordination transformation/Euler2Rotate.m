%���Ҫ�����C1->C2�������ת�������ʱ����ĽǶ�Ӧ����C2->C1��ŷ���ǣ��������������ֶ�����������
%Ҳ��������C1->C2�������ת�ǣ���ʱҪ�õ�C1->C2����ת������Ҫ��õĽ��ת�á�
function Rotate = Euler2Rotate(yaw,pitch,roll) %�÷�ʽΪ��̬ŷ������ת 
   yaw = yaw*pi/180;
   pitch = pitch*pi/180;
   roll = roll*pi/180;
   Rx = [1 0 0;
         0 cos(roll) sin(roll);
         0 -sin(roll) cos(roll)];%��x����ת��Ϊ������
   Ry = [cos(pitch) 0 -sin(pitch);
         0 1 0;
         sin(pitch) 0 cos(pitch)];%��y����ת��Ϊ����
   Rz = [cos(yaw) sin(yaw) 0;
         -sin(yaw) cos(yaw) 0;
         0 0 1];
   Rotate = Rz'*Ry'*Rx';
end
