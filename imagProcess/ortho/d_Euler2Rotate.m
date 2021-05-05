function Rotate = d_Euler2Rotate(yaw,pitch,roll) %�÷�ʽΪ��̬ŷ������ת,��ת����ͬ,��xyz��ת,��ʱΪ������˵Ľ��
   %�õ������ҳ˾��󣬶�Ӧ�б任
   %Ӧ����һ��
   yaw = yaw*pi/180;
   pitch = pitch*pi/180;
   roll = roll*pi/180;
   Rx = [1 0 0;
         0 cos(roll) -sin(roll);
         0 sin(roll) cos(roll)];%��x����ת��Ϊ������
   Ry = [cos(pitch) 0 sin(pitch);
         0 1 0;
         -sin(pitch) 0 cos(pitch)];%��y����ת��Ϊ����
   Rz = [cos(yaw) -sin(yaw) 0;
         sin(yaw) cos(yaw) 0;
         0 0 1];
   Rotate = Rz*Ry*Rx;
   
end