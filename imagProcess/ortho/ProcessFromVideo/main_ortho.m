
% �ú���Ϊ��һ����Ƶ��ʼ��ֱ��һ������ͼ�����������
% ����·�����鶼ʹ�þ���·����
addpath(genpath('F:/workSpace/matlabWork/seaBathymetry/imagProcess/ortho/ProcessFromVideo/CoreFunctions/'))
mat_savePath = 'F:/workSpace/matlabWork/imgResult/resMat/';
ds_image_savePath =  'F:/workSpace/matlabWork/imgResult/downSample/';
fs = 2;


%% step1 downSampleFromVideo
% ��һ��������Ƶ��ʼ�²���
% ����ԭ��Ϊfunction downSampleFromVideo(videoPath,savePath,fs,videoRange)
% ���������
% videoPath �� ��Ƶ�ľ���·��
% savePath �� ��Ž��ͼƬ�ľ���·��
% fs �� ����Ƶ��
% videoRange �� Ϊһ��1*2���飬videoRange(1)Ϊ��ȡ��Ƶ�Ŀ�ʼʱ�䣬videoRange(2)Ϊ��Ƶ����ʱ�䣬��λΪ��

% step1.videoPath = 'E:/����ԭʼ����/2020��10�»�������/_10.24_˫����/�ڶ���/DJI_0150.MOV';

disp('----------step1 start--------------- ');
% step1.videoPath = 'E:/����ԭʼ����/2021.01.21˫����/2021_01_22��/DJI_0189.MOV';
% step1.videoPath = 'E:/����ԭʼ����/2021.01.12˫����/��Ƶ����/��һ��/DJI_0178.MOV';
step1.videoPath = 'E:/����ԭʼ����/2020��10�»�������/_10.24_˫����/�ڶ���/DJI_0150.MOV';
step1.savePath = ds_image_savePath;
step1.fs = fs;
step1.videoRange = [100,400]; %5���ӵĽ�ȡʱ��
downSampleFromVideo(step1);

disp('----------step1 finish--------------- ');

%% step2 getGcpInfo_UV & getGcpInfo_World

% �ڶ�������ȡgcpInfo�������������������
% 2.getGcpInfo_World����ԭ�ͣ�gcpInfo_world = getGcpInfo_World(gcp_llh,o_llh,euler_ned2new,savePath)
% ���������
% gcp_llh �� gcp�ľ�γ�ߣ�gps�ó�
% o_llh �� local����ϵԭ��ľ�γ�ߣ�gps�ó�
% euler_ned2new �� ned����ϵתlocal����ϵ��ŷ���ǣ�һ��ֻ��ƫ���й� 1*3����,��Ӧyaw,pitch,roll
% savePath �� �������ľ���·��

disp('----------step2 start--------------- ');


step2.world.gcp_llh = [
        [22.5948224,114.8764800,7.41-5.09];
        [22.5952560,114.8767744,7.53-5.09];
        [22.5956768,114.8767360,5.09-5.09];
        [22.5958368,114.8764544,5.14-5.09];
        [22.5960064,114.8761216,5.11-5.09];
];
step2.world.o_llh = [22.5956768,114.8767360,5.09-5.09];
step2.world.euler_ned2new = [-148.5,0,0];
step2.world.savePath = mat_savePath;

getGcpInfo_World(step2.world.gcp_llh,step2.world.o_llh,step2.world.euler_ned2new,step2.world.savePath);


% 1.getGcpInfo_UV����ԭ��Ϊ��function gcpInfo =  getGcpInfo_UV(imagePath,gcpSavePath,fs,mode)
%   �������Ϊ��
%   imagePath �� ��һ֡ͼƬ�ľ���·��
%   gcpSavePath �� ����gcp
%   fs �� ����Ƶ��
%   mode �� ģʽ1����ȡgcp�ں����ڶ������Ϣ��ģʽ2����ȡ����֮ǰ����Ϣ֮�⣬�������gcpģ��




ff_name = string(ls(ds_image_savePath));
ff_name = ff_name(3);%Ϊ��һ֡��ͼƬ����
ff_name = char(ff_name);
step2.UV.imagePath = [ds_image_savePath ff_name];
step2.UV.gcpSavePath = mat_savePath;
step2.UV.fs = fs;       
getGcpInfo_UV(step2,2);

clear ff_name;


disp('----------step2 finish--------------- ');


%% step3 matchGcp
% ������ ��ȡ��һ֡ͼƬ������Լ�����gcp���ݣ���UV���ݺ�World���ݽ�ϣ�
% ����ԭ�� matchGcp(gcpInfo_UV_path,gcpInfo_world_path,intrinsic_path,savePath,mode)
% ���������
% gcpInfo_UV_path��gcp_UV��Ϣmat��ʽ���ݵľ���·��
% gcpInfo_world_path��gcp_world��Ϣmat��ʽ���ݵľ���·��
% intrinsic_path��1*11�Ľṹ�壬����ڲ�
% savePath��gcpȫ����Ϣ���ϵĽṹ�����һ֡ͼƬ�����δ�ŵľ���·��

disp('----------step3 start--------------- ');

step3.gcpInfo_UV_path = [mat_savePath 'gcpInfo_firstFrame.mat'];
step3.gcpInfo_world_path = [mat_savePath 'gcpInfo_world.mat'];
step3.intrinsic_path = './neededData/intrinsicMat.mat';
step3.savePath = mat_savePath;

matchGcp(step3.gcpInfo_UV_path,step3.gcpInfo_world_path,step3.intrinsic_path,step3.savePath,1);

disp('----------step3 finish--------------- ');

%% step4 getScpInfo
% ���Ĳ�,��ȡScp����Ϣ
% ����ԭ��Ϊ getScpInfo(gcp_path,savePath,fs,brightFlag)
% ���������
% gcp_path �� ��step3���õ���gcp��ȫ����Ϣ��mat��ʽ���ݵľ���·��
% savePath �� ���յõ���scp��Ϣ�Ĵ��·��
% fs ������Ƶ��
% brightFlag����ɫӳ��ѡ���ѡΪ'bright'��'dark' �ֱ��Ӧ ��ɫΪ������ֵӳ�����ɫΪ������ֵӳ��


disp('----------step4 start--------------- ');
step4.gcp_path = [mat_savePath 'gcpFullyInfo.mat'];
step4.savePath = mat_savePath;
step4.fs = fs;
step4.brightFlag = 'bright'; 
getScpInfo(step4.gcp_path,step4.savePath,step4.fs,step4.brightFlag);

disp('----------step4 finish--------------- ');

%% step5 calcFollowedExtrinsic
% ���岽��������֪��Ϣ��scp��ģ�壩������֮��ÿ��ͼƬ�����
% ����ԭ�ͣ�calcFollowedExtrinsic(scp_path,gcp_path,rotateInfo_path,unsovledExtrinsic_pic_path,savePath,mode)
% ���������
% scp_path �� scp��Ϣ��mat��ʽ���ݾ���·��
% gcp_path �� gcp��Ϣ��mat��ʽ���ݾ���·��
% rotateInfo_path �� ��һ֡����ת��Ϣ��mat��ʽ���ݾ���·��
% unsovledExtrinsic_pic_path �� ���������ͼƬ�Ĵ�ž���·��
% savePath �� ȫ������ξ�����Լ������Ϣ�Ĵ�ž���·����Ϊ���·��
% mode ��ģʽ1Ϊ����scp��Ϣ��ģʽ2Ϊ����ģ����Ϣ


disp('----------step5 start--------------- ');
step5.scp_path =[mat_savePath 'scpInfo_firstFrame.mat'];
step5.gcp_path = [mat_savePath 'gcpFullyInfo.mat'];
step5.rotateInfo_path = [mat_savePath 'RotateInfo_firstFrame.mat'];
step5.unsovledExtrinsic_pic_path = ds_image_savePath;
step5.savePath = mat_savePath;
step5.mode = 1;

calcFollowedExtrinsic(step5.scp_path,step5.gcp_path,step5.rotateInfo_path,step5.unsovledExtrinsic_pic_path,step5.savePath,step5.mode);

disp('----------step5 finish--------------- ');

%% step6 chooseRoi
% ��������ѡ�����Ȥ������,��Ҫ�ǻ�ȡ�������local_xyz��Ϣ
% ����ԭ�� chooseRoi(gcpInfo_path,rotateInfo_path,roi_x,roi_y,pixel_resolution,savePath)
% ���������
% gcpInfo_path��gcp��Ϣ��mat��ʽ���ݾ���·��
% rotateInfo_path �� ��һ֡����ת��Ϣ��mat��ʽ���ݾ���·��
% roi_x,roi_y ������Ȥ�����x��y�᷶Χ����Ϊ1*2����
% pixel_resolution �� ÿ�����ص�����ľ���
% savePath �� ������Ϣ�Ĵ���·��

disp('-----------step6 start--------------- ');

step6.gcpInfo_path = [mat_savePath 'gcpFullyInfo.mat'];
step6.rotateInfo_path = [mat_savePath 'RotateInfo_firstFrame.mat'];
step6.roi_x = [0,200]; 
step6.roi_y = [0,100];
step6.pixel_resolution = 0.5;
step6.savePath = mat_savePath;

chooseRoi(step6.gcpInfo_path,step6.rotateInfo_path,step6.roi_x,step6.roi_y,step6.pixel_resolution,step6.savePath);


disp('-----------step6 finish--------------- ');

%% step7 getPixelImage
% ���߲�����ʽ��ȡ���ص�ͼƬ
% ����ԭ�ͣ�getPixelImage(roi_path,extrinsicFullyInfo_path,unsolvedPic_path,savePath,inputStruct)
% ���������
% roi_path �� roiϢ��mat��ʽ���ݾ���·��
% extrinsicFullyInfo_path ������ͼƬ��ε�mat��ʽ���ݵľ���·��
% unsolvedPic_path �� �����ͼƬ�Ĵ�ž���·��
% savePath �� ���·����������ص�ͼƬ

% inputStruct �� ����Ľṹ�壬Ӧ������roi_x,roi_y,dx,dy,x_dx,x_oy,x_rag,y_dy,y_ox,y_rag,localFlag
% localFlag = 0 Ϊ��������ϵ�� = 1 Ϊ��������ϵ
% roi_x,roi_y����Ҫ����ת����������local����ϵ������world����ϵ�ж�����,����Ҫ���ñ�־λlocalFlag
% dx,dy��Ϊroi_x,roi_y�����طֱ��ʣ���λΪm
% x_dx��Ϊ x_transect(Alongshore)�����ϵ����طֱ��ʣ���λΪm
% x_oy��Ϊx_transect����yֵ
% x_rag:x_transect�ķ�Χ��x�ķ�Χ
% y_dy,y_ox,y_rag ͬ�Ͻ���

disp('-----------step7 start--------------- ');

step7.roi_path = [mat_savePath 'GRID_roiInfo.mat'];
step7.extrinsicFullyInfo_path = [mat_savePath 'extrinsicFullyInfo.mat'];
step7.unsolvedPic_path = ds_image_savePath;
step7.savePath = mat_savePath;


step7.inputStruct.roi_x = [0,200];
step7.inputStruct.roi_y = [0,100];
step7.inputStruct.dx = 0.5;
step7.inputStruct.dy = 0.5;

step7.inputStruct.x_dx = 0.5;
step7.inputStruct.x_oy = 0;
step7.inputStruct.x_rag = [0,200];

step7.inputStruct.y_dy = 0.5;
step7.inputStruct.y_ox = 0;
step7.inputStruct.y_rag = [0,100];

getPixelImage(step7.roi_path,step7.extrinsicFullyInfo_path,step7.unsolvedPic_path,step7.savePath,step7.inputStruct);

disp('-----------step7 finish--------------- ');


%% step8 rotImg
% �ڰ˲�����תͼ��������˴������ϴ���
% ����ԭ�ͣ�rotImg(pixelInst_path,savePath)
% ������Ϣ��
% pixelInst_path �� ������Ϣ�Ľṹ�ľ���·��
% savePath �� ������Ϣ

disp('----------step8 start--------------- ');

step8.pixelInst_path = [mat_savePath 'pixelImg.mat'];
step8.savePath = 'F:/workSpace/matlabWork/imgResult/orthImg/';

rotImg(step8.pixelInst_path,step8.savePath);


disp('----------step8 finish--------------- ');
disp('----------ALL STEP FINISH!!--------------- ');

% ��ɣ�




            



