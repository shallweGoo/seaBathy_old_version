%c0Ϊ�ϵ�ʱ�̵��������
%cΪ��������ʱ�̵��������
% Rc0c ���ϵ�ʱ��ת������ʱ�̵��������
% Rotate = Euler2Rotate(yaw,pitch,roll)
Rc0_c = Euler2Rotate(0,0,-90);
Rc0_c = Rc0_c';

%Rbc�ǻ���b����ϵ���ϵ��������ϵc����ת�����������ת��Ϊb->c�ĽǶ�
Rb_c = Euler2Rotate(90,0,90);
Rb_c = Rb_c';
%%
%P = Rc0_c*Rb_c*[1;0;0];
%%
%Rned_b 
Rned_b = Euler2Rotate(-5.1,5,-1.3);
Rned_b = Rned_b';

%Re_ned
Re_ned = Euler2Rotate(3,0,0);
Re_ned = Re_ned';

%total
Re_c = Rc0_c*Rb_c*Rned_b*Re_ned;

% [yaw,pitch,roll] = Rotate2Euler(Rc0c);
% Rcv_e_c
Rcv_e_c = [0.01768085450531172,0.9995008050096885,0.02618259286142196;
           -0.9995578333534292,0.01829587042830817, -0.02343925995139384;
           -0.02390659251671921, -0.02575658964722512,0.9993823457135835];
Rcalc_e_ned = Rned_b'*Rb_c'*Rc0_c'*Rcv_e_c;
[yaw,pitch,roll] = Rotate2Euler(Rcalc_e_ned);

%��cv�õ�����ת����
T = [  -9.298077026385412;  5.613361443645831;  50.62898101162759];
Zc = 50.0161;

%��������Ϊ���������굽��ά�����ת��2d->3d;
DjCamMat = [3073.8 0 2000;
            0 3067.1 1125;
            0 0 1]; 



imagePoint_your_know = [1995;498;1]; %�����������2d

wcPoint =  Re_c'* (Zc*inv(DjCamMat)*imagePoint_your_know - T)
cv_wcPoint =  Rcv_e_c'* (Zc*inv(DjCamMat)*imagePoint_your_know - T)

world_cor = [16;9;0];
pixel_cor = DjCamMat*(Re_c*world_cor+T);
pixel_cor(1) =pixel_cor(1)/pixel_cor(3);
pixel_cor(2) =pixel_cor(2)/pixel_cor(3);
pixel_cor(3) =1;

cv_pixel_cor = DjCamMat*(Rcv_e_c*world_cor+T);
cv_pixel_cor(1) =cv_pixel_cor(1)/cv_pixel_cor(3);
cv_pixel_cor(2) =cv_pixel_cor(2)/cv_pixel_cor(3);
cv_pixel_cor(3) = 1;

pixel_cor
cv_pixel_cor



