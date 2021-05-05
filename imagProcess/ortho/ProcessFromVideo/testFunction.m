addpath(genpath('./CoreFunctions'));
% 
% 
% savePath = './';
% gcp_path = './gcpFullyInfo.mat';
% rotateInfo_path = './RotateInfo_firstFrame.mat';
% roi_x = [-10,250];
% roi_y= [-10,150];
% ps = 2;
% chooseRoi(gcp_path,rotateInfo_path,roi_x,roi_y,ps,savePath);

%%
savePath = './';
roi_path = './GRID_roiInfo.mat';
rotateInfo_path = './extrinsicFullyInfo.mat';
unsolvedPic_path = 'F:/workSpace/matlabWork/imgResult/downSample/';


%��input���и�ֵ
inputData.localFlag = 1;
inputData.roi_x = [20,200];
inputData.roi_y = [0,80];
inputData.dx = 0.5;
inputData.dy = 0.5;

inputData.x_dx = 0.5;
inputData.x_oy = 0;
inputData.x_rag = [0,200];

inputData.y_dy = 0.5;
inputData.y_ox = 50;
inputData.y_rag = [0,90];




getPixelImage(roi_path,rotateInfo_path,unsolvedPic_path,savePath,inputData);
%
%%
savePath = 'F:/workSpace/matlabWork/imgResult/orthImg/';
pixelInst_path = './pixelImg.mat';
rotImg(pixelInst_path,savePath);
