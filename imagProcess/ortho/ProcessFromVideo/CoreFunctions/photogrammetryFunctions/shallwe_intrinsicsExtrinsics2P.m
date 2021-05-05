function [P, K, R, IC] = shallwe_intrinsicsExtrinsics2P(intrinsics, extrinsics)


%% Section 1: Format IO into K matrix
fx=intrinsics(5);
fy=intrinsics(6);
c0U=intrinsics(3);
c0V=intrinsics(4);


%�����Լ����ڲξ�����ж���
K = [fx 0 c0U;
    0 fy c0V;
    0  0 1];



%% Section 2: Format EO into Rotation Matrix R

% �����Լ�����ת����
roll= extrinsics(4);
pitch=extrinsics(5);
yaw=extrinsics(6);
[R] = shallwe_angles2R(roll,pitch,yaw);

%���һ�ּ�����ת����ķ�ʽ









%% Section 3: Format EO into Translation Matrix
x=extrinsics(1);
y=extrinsics(2);
z=extrinsics(3);

IC = [eye(3) [-x -y -z]'];





%% Section 4: Combine K, Rotation, and Translation Matrix into P
P = K*R*IC;
P = P/P(3,4); %��Ӧ�Ծ��������3��4�е��Ǹ�Ԫ�ؽ��й�һ��
end
