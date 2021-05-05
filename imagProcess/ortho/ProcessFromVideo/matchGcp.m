function matchGcp(gcpInfo_UV_path,gcpInfo_world_path,intrinsic_path,savePath,mode)
%calcRotateMatrix 根据第一帧的控制点外参，采用的是非线性拟合的方式，
%实际上可以通过solvePnP问题来解决
% mode = 1,nlinfit
% mode = 2,solvePnP
               


    
    %载入gcpInfo_UV和gcpInfo_World数据
    
    tmp1 = load(gcpInfo_UV_path);
    gcp = tmp1.gcp;
    
    tmp2 = load(gcpInfo_world_path);
    gcpInfo_world = tmp2.gcpInfo_world;
    
    clear tmp1;
    clear tmp2;
    
    tmp3 = load(intrinsic_path);
    intrinsics = tmp3.intrinsics;
    iopath = intrinsic_path;
    
    gcpUvdPath = gcpInfo_UV_path;
    gcpXyzPath = gcpInfo_world_path;
    
    saveName = 'RotateInfo'; %存放的是外参和内参信息，统一称为旋转信息
    
%     if nargin < 5
%         %默认为CRIN非线性拟合nlinfit计算外参
%         mode = 1;
%     end
    
    gcpsUsed = []; % 函数默认使用全部的gcp
    for i = 1 : size(gcpInfo_world,1)  %默认全部使用
        gcpsUsed = cat(2,gcpsUsed,i);
    end
    
    
    gcpCoord = '现实坐标系：x轴垂直于岸，y轴平行于岸 ';
    
%     extrinsicsInitialGuess= [20 20 100 deg2rad(45) deg2rad(0) deg2rad(0)]; % [ x y z azimuth tilt swing]

    extrinsicsInitialGuess= [-153.4459  -56.7809  -100 deg2rad(-110) deg2rad(-110) deg2rad(0)];
    
%     extrinsicsInitialGuess = [-100 0 -100 deg2rad(45) deg2rad(90) deg2rad(0)];
    
    %  要去求解的参数
    
    extrinsicsKnownsFlag= [0 0 0 0 0 0];  % [ x y z azimuth tilt swing]
    
    
    
    % 整合一下数据，将数据都弄到gcp这个结构体中
    for k=1:size(gcpInfo_world,1)
    
        gcp(k).x=gcpInfo_world(k,1);
        gcp(k).y=gcpInfo_world(k,2);
        gcp(k).z=gcpInfo_world(k,3);
        gcp(k).WorldCoordSys = gcpCoord;
        
    end
    
    imagePath = gcp(1).imagePath; %设置图片路径
    
    
    % 展示修改之后的GCP信息
    disp(' ');
    disp('最终GCP信息（结构体）:');
    disp(gcp);
    
    %创建一些临时变量方便使用
    
    for k=1:length(gcp)
        gnum(k)=gcp(k).num;
    end
    [~,gcpInd] = ismember(gcpsUsed,gnum);
    
    x=[gcp(gcpInd).x];
    y=[gcp(gcpInd).y];
    z=[gcp(gcpInd).z];

    xyz = [x' y' z'];  %每个gcp在显示坐标系下的xyz: N x 3 矩阵代表N个gcp，列分别为x，y，z
    UVd = reshape([gcp(gcpInd).UVd],2,length(x))';  % N x 2 矩阵代表N个gcp, 列分别为U,V
    
    
    % 以上到创建临时变量全部都是为了防止顺序混乱，不过一般不会乱
    
    %用一个非线性优化去求解外参矩阵
    [extrinsics,extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,UVd,xyz);
%     extrinsicsInitialGuess= [20 20 100 deg2rad(45) deg2rad(0) deg2rad(0)]; % [ x y z azimuth tilt swing]

    extrinsicsInitialGuess= [-153.4459  -56.7809  -100 deg2rad(-110) deg2rad(-110) deg2rad(0)];
%     extrinsicsInitialGuess= [-100  0  -100 deg2rad(45) deg2rad(90) deg2rad(0)];
    
    
    % azimuth ：以世界坐标系的z轴为旋转轴，顺时针旋转提供正向角度。
    % tilt ：俯仰角，以摄像头水平方向为+90°，向上减少到0°，向下增加到180°。
    % swing ：滚动角，相机水平为0°，逆时针旋转提供正向的角度。
    
    
    
    % 展示xyz(相机在世界坐标系下的坐标)，和三个方位角信息，方位角定位的有点乱
    disp(' ')
    disp('Solved Extrinsics and NLinfit Error')
    disp( [' x = ' num2str(extrinsics(1)) ' +- ' num2str(extrinsicsError(1))])
    disp( [' y = ' num2str(extrinsics(2)) ' +- ' num2str(extrinsicsError(2))])
    disp( [' z = ' num2str(extrinsics(3)) ' +- ' num2str(extrinsicsError(3))])
    disp( [' azimuth = ' num2str(rad2deg(extrinsics(4))) ' +- ' num2str(rad2deg(extrinsicsError(4))) ' degrees'])
    disp( [' tilt = ' num2str(rad2deg(extrinsics(5))) ' +- ' num2str(rad2deg(extrinsicsError(5))) ' degrees'])
    disp( [' swing = ' num2str(rad2deg(extrinsics(6))) ' +- ' num2str(rad2deg(extrinsicsError(6))) ' degrees'])
    
    %% 借用gcp的坐标来查看校正效果


    % Format All GCP World and UVd coordinates into correctly sized matrices for
    % non-linear solver and transformation functions (xyzToDistUV).
    xCheck=[gcp(:).x];
    yCheck=[gcp(:).y];
    zCheck=[gcp(:).z];
    xyzCheck = [xCheck' yCheck' zCheck'];  % N x 3 matrix with rows= N gcps, columns= x,y,z

    % Transform xyz World Coordinates to Distorted Image Coordinates
    [UVdReproj ] = xyz2DistUV(intrinsics,extrinsics,xyzCheck);

    %  Reshape UVdCheck so easier to interpret
    UVdReproj = reshape(UVdReproj ,[],2);


    % Load Specified Image and Plot Clicked and Reprojected UV GCP Coordinates
    f1=figure;
    imshow(imagePath);
    hold on;

    for k=1:length(gcp)
        % 点击生成的gcp信息
        h1=plot(gcp(k).UVd(1),gcp(k).UVd(2),'ro','markersize',10,'linewidth',3);
        text(gcp(k).UVd(1)+30,gcp(k).UVd(2),num2str(gcp(k).num),'color','r','fontweight','bold','fontsize',15);

        % 经过校正的gcp信息
        h2=plot(UVdReproj(k,1),UVdReproj(k,2),'yo','markersize',10,'linewidth',3);
        text(UVdReproj(k,1)+30,UVdReproj(k,2),num2str(gcp(k).num),'color','y','fontweight','bold','fontsize',15);
    end
    
    legend([h1 h2],'点击生成的gcp','计算外参之后演算出的gcp');





    %% 误差分析部分
    for k=1:length(gcp)

        % 单目只有知道尺度因子Pz，也就是深度信息，才能得到2d->3d,不然就要已知一维的信息才能有解（x,y,z）
        [xyzReproj(k,:)] = distUV2XYZ(intrinsics,extrinsics,[gcp(k).UVd(1); gcp(k).UVd(2)],'z',gcp(k).z);

        %计算误差
        gcp(k).xReprojError=xyzCheck(k,1)-xyzReproj(k,1);
        gcp(k).yReprojError=xyzCheck(k,2)-xyzReproj(k,2);

    end

    rms=sqrt(nanmean((xyzCheck-xyzReproj).^2));

    % 展示结果的过程
    disp(' ');
    disp('Horizontal GCP Reprojection Error');
    disp( ('GCP Num / X Err /  YErr'));
    
    for k=1:length(gcp)
        disp( ([num2str(gcp(k).num) '/' num2str(gcp(k).xReprojError) '/' num2str(gcp(k).yReprojError) ]));
    end


    


    %% 存放结果

    % 原始数据的存放结构体信息
    initialCamSolutionMeta.iopath=iopath;
    initialCamSolutionMeta.gcpUvPath=gcpUvdPath;
    initialCamSolutionMeta.gcpXyzPath=gcpXyzPath;

    % 结果参数
    initialCamSolutionMeta.gcpsUsed=gcpsUsed;
    initialCamSolutionMeta.gcpRMSE=rms;
    initialCamSolutionMeta.gcps=gcp;
    initialCamSolutionMeta.extrinsicsInitialGuess=extrinsicsInitialGuess;
    initialCamSolutionMeta.extrinsicsKnownsFlag=extrinsicsKnownsFlag;
    initialCamSolutionMeta.extrinsicsUncert=extrinsicsError';
    initialCamSolutionMeta.imagePath=initialCamSolutionMeta.gcps(1).imagePath;

    % 坐标系统存放
    initialCamSolutionMeta.worldCoordSys=gcpCoord;



    % 存放内外参结果
    save([savePath saveName '_firstFrame' ],'initialCamSolutionMeta','extrinsics','intrinsics');

    %存放完整的gcp信息结构体
    save([savePath 'gcpFullyInfo'],'gcp');
    
    % 展示结果
    disp(' ');
    disp('Finished Solution');

    disp(initialCamSolutionMeta);
    
    
    
    
    %% 模式选择，后面再加进去
%     switch mode
%         case 1
%             
%         
%         
%         case 2
%         
%                     
%         
%         otherwise
%             error("happened confliction because of unsituable mode");
%             
%             
%     end
    



end

