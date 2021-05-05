%�ó���Ϊ͸�ӱ任��������
addpath('E:/Program Files (x86)/mexopencv-master');
addpath('E:/Program Files (x86)/mexopencv-master/opencv_contrib');
addpath('F:/workSpace/matlabWork/dispersion/imagProcess/ortho/coordination transformation')

%% gcp����ʵ�������꣨���Լ���������ϵ������������
gcp_llh =[[22.5948224,114.8764800,7.41];
[22.5952560,114.8767744,7.53];
[22.5956768,114.8767360,5.09];
[22.5958368,114.8764544,5.14];
[22.5960064,114.8761216,5.11]];

% o_llh = [22.5957696,114.8766464,5.23];
o_llh = [22.5956768,114.8767360,5.09];

objectPoints =gcpllh2NED(o_llh,gcp_llh);
objectPoints = objectPoints';
imagePoints = [[258,389];[287,725];[814,1015];[1286,866];[1696,710]];
% % �������������ڲΣ�4000*1250��
% cameraMatrix.mat = [3073.8 0 2000;
%                 0 3067.1 1125;
%                 0 0 1]; 
% cameraMatrix.dist =[0.0986746953968013,-0.249452801912667,0,0,0];

% �������������ڲΣ�1920*1080��
cameraMatrix.mat = [1585.04404476623,0,960;0,1586.39568988226,540;0,0,1];
cameraMatrix.dist = [0.157285324524228,-0.493792014006428,0,0,0];

picNum = 500;
file_path = ".\1.jpg";
save_path =".\";
save_name ="�ذ���簶�仯_Per";
%% ����Re_c
[Re_c, tvec] = gcpForCamExtrinsic(cameraMatrix,objectPoints,imagePoints);

% Rnew = eye(3); %���ݱ任���޸�
Rnew = Euler2Rotate(123,0,0);
Rnew = Rnew';

%% ���б任 ֱ�Ӽ�������ͼ�ı任�����õ�Ӧ�Ծ��󣩺�������û�б�Ҫ��������ͼ�Ĳ���
src = imread(file_path);
if ndims(src) == 3
    src = rgb2gray(src);
end
res = orthoRectification(cameraMatrix,src,Re_c,Rnew);
% imwrite(res,save_path+save_name+'.jpg');


%% ѭ�����������޸�
% for i = 1:picNum
%     src = rgb2gray(imread(file_path+num2str(i)+'.jpg'));
%     res = orthoRectification(cameraMatrix.mat,src,Re_c,Rnew);
%     imwrite(res,save_path+num2str(i)+'.jpg');
% end
    