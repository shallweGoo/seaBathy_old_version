function chooseRoi(gcpInfo_path,rotateInfo_path,roi_x,roi_y,pixel_resolution,savePath) 
%CHOOSEROI 在每一帧的图片上选择感兴趣的区域
%   roi_x为感兴趣的区域x轴的范围，形式应为[x1,x2];
%   roi_y为感兴趣的区域y轴的范围，形式应为[y1,y2];
%   在算世界坐标时已经进行了旋转，可能原点那些都不用重新指定了

    
    tmp1 = load(gcpInfo_path);
    gcp = tmp1.gcp;

    tmp2 = load(rotateInfo_path);
    extrinsics = tmp2.extrinsics;
    intrinsics = tmp2.intrinsics;
    %initialCamSolutionMeta = tmp3.initialCamSolutionMeta;

    clear tmp1;
    clear tmp2;

    localOrigin = [0,0]; %自定义坐标系原点（由于之前的世界坐标用的就是自定义坐标，故直接定义为0即可）
    localAngle =0; % Degrees +CCW from Original World X

    worldCoord = gcp(1).WorldCoordSys;
    imagePath{1} = gcp(1).imagePath;
    
    rotateInfoPath{1} = rotateInfo_path;
    
    saveName = 'roiInfo';
    % Enter if you would like to INPUT your grid in  rotated local
    % coordinates. 1=local coordinates, 0= world coordinates.
    % The function will still rectify both coordinate systems regardless
    % of localFlagInput value. LocalFlagInput only dictates
    % the coordinate system of the input and which direction the rotation
    % will occur. If localOrigin and localAngle =0; this value is irrelevant.

    localFlagInput=1;

    

    % Grid Specification. Enter the limits (ixlim, iylim) and resolution(idxdy)
    % of your rectified grid. Coordinate system entered will depend on
    % localFlagInput. Units should be consistent with world Coordinate system
    % (m vs ft, etc).


    % ixlim=[0 700];
    % iylim=[0 1000];
    % idxdy=2;


    ixlim = roi_x;
    iylim = roi_y;
    idxdy= pixel_resolution;

    teachingMode=1;

    % Elevation Specification. Enter the elevation you would like your grid
    % rectified as. Typically, CIRN specifies an constant elevation across the
    % entire XY grid consistent with the corresponding tidal level the world
    % coordinate system. For more accurate results a spatially variable
    % elevation grid should be entered if available. However, this code is not
    % designed for that. If you would like to enter a spatially variable
    % elevation, say from SFM along with tidal elevation, enter your grid as iZ
    % It is up to the user to make sure it is same size as iX and iY.Spatially
    % variable  Z values are more significant for run up calculations than for
    % surface current or bathymetric inversion calculations at a distance.
    % It can also affect image rectifications if concerned with topography
    % representation.

    % What does alter bathymetric inversion, surface current, and run-up
    % calculations is a temporally variable z elevation. So make sure the
    % elevation value corresponds to the correct tidal value in time and
    % location. For short UAS collects, we can assume the elevation is
    % relatively constant during the collect. However for fixed stations we
    % would need a variable z in time. This function is designed for
    % rectification of a single frame, so z is considered constant in time.
    % Value should be entered in the World Coordinate system and units.

    iz = 0; %选择区域时默认区域的z值为0（海平面）





    %% Section 4: Uncomment for Multi-Camera Demo
    % %  The Mult-Camera Demo will share the same grid parameters, but use
    % %  different images, extrinsics, and save in a different location.
    %
    % % Output Name
    % oname='fixedMultCamDemo_2mdxdy';
    % % OutPut Directory
    % odir='./X_FixedMultCamDemoData/rectificationGrids';
    %
    % % Image paths
    % % Each value in the CAM structure represents a different camera. It is up to
    % %  the user to ensure CAMERA IOEO and imagePaths match for the correct camera
    % %  as well as images are taken simultaneously.
    % imagePath{1}= './X_FixedMultCamDemoData/collectionData/c1/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c1.timex.jpg';
    % imagePath{2}= './X_FixedMultCamDemoData/collectionData/c2/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c2.timex.jpg';
    % imagePath{3}= './X_FixedMultCamDemoData/collectionData/c3/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c3.timex.jpg';
    % imagePath{4}= './X_FixedMultCamDemoData/collectionData/c4/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c4.timex.jpg';
    % imagePath{5}= './X_FixedMultCamDemoData/collectionData/c5/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c5.timex.jpg';
    % imagePath{6}= './X_FixedMultCamDemoData/collectionData/c6/1444314601.Thu.Oct.08_14_30_01.GMT.2015.argus02b.c6.timex.jpg';
    %
    % %  IOEO Solutions
    % %  Enter the filepath of the saved CIRN IOEO calibration results produced by
    % %  C_singleExtrinsicSolution. Note extrinsics for all K cameras should be
    % %  in same coordinate system.
    %
    % ioeopath{1}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C1_FixedMultiCamDemo.mat';
    % ioeopath{2}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C2_FixedMultiCamDemo.mat';
    % ioeopath{3}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C3_FixedMultiCamDemo.mat';
    % ioeopath{4}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C4_FixedMultiCamDemo.mat';
    % ioeopath{5}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C5_FixedMultiCamDemo.mat';
    % ioeopath{6}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C6_FixedMultiCamDemo.mat';
    %




    %% Section 5: Load Required Files for Rectification

    for k=1:length(imagePath)
        %Load Image
        I{k}=imread(imagePath{k});

        % Load Solution from C_singleExtrinsicSolution

        % Save IOEO into larger structure
        % Take First Solution (Can be altered if non-first frame imagery desired
        Extrinsics{k}=extrinsics(1,:);
        Intrinsics{k}=intrinsics;

    end

    % Rename IEEO to original EOIO name so names consistent
    extrinsics=Extrinsics;
    intrinsics=Intrinsics;


    %% Section 6: Load and Assign Extrinsics
    %  For accurate rectification, the grid and the extrinsics solution must be
    %  in the same coordinate system and units. The extrinsic output from
    %  C_singleGeometrySolution is in world coordinates. Thus, to rectify in
    %  local coordinates, we must rotate our world extrinsics to local
    %  extrinsics.

    for k=1:length(rotateInfoPath)
        %  World Extrinsics
        extrinsics{k}=extrinsics{k};

        %  Local Extrinsics
        localExtrinsics{k} = localTransformExtrinsics(localOrigin,localAngle,1,extrinsics{k});
    end



    %% Section 7: Generate Grids
    %  This function will rectify the specified image in both world and local
    %  (if specified) coordinates. The image rectification for each coordinate
    %  system requires an equidistant grid. This cannot be done by simply
    %  rotating one grid to another, the rotated resoltions will not be
    %  equidistant and the images stretched. Thus the entered limits need to
    %  rotated and new grids created. This is accomplished in gridEquiRotate.
    %  Below creates the equidistant grids depending on localFlagInput.


    %  Create Equidistant Input Grid
    [iX,iY]=meshgrid([ixlim(1):idxdy:ixlim(2)],[iylim(1):idxdy:iylim(2)]);

    %  Make Elevation Input Grid
    iZ=iX*0+iz;

    %  Assign Input Grid to Wolrd/Local, and rotate accordingly depending on
    %  inputLocalFlag

    % 输入的参数为世界坐标的参数
    
    if localFlagInput==0
        % Assign World Grid as Input Grid
        X=iX;
        Y=iY;
        Z=iZ;

        % Assign local Grid as Rotated input Grid
        [ localX,localY]=localTransformEquiGrid(localOrigin,localAngle,1,iX,iY);
        localZ=localX.*0+iz; %z值基本设为0，对结果好像没有显著性的影响

    end
    %输入的参数为本地坐标
    if localFlagInput==1
        % Assign local Grid as Input Grid
        localX=iX;
        localY=iY;
        localZ=iZ;

        % Assign world Grid as Rotated local Grid
        [X,Y]=localTransformEquiGrid(localOrigin,localAngle,0,iX,iY);
        Z=X*.0+iz; %z值基本设为0，对结果好像没有显著性的影响
    end







    %% Section 8: Rectification

    % The function imageRectification will perform the rectification for both
    % world and local coordinates. The function utalizes xyz2DistUV to find
    % corresponding UVd values to the input grid and pulls the rgb pixel
    % intensity for each value. If the teachingMode flag is =1, the function
    % will plot corresponding steps (xyz-->UVd transformation) as well as
    % rectified output.

    % World Rectification
    [Ir]= imageRectifier(I,intrinsics,extrinsics,X,Y,Z,teachingMode);
    % Specify Title
    subplot(2,2,[2 4]);
    title(worldCoord);

    localIr = [];
    % Local Rectification (If specified)
    if localOrigin~=[0,0] & localAngle ~= 0
        [localIr]= imageRectifier(I,intrinsics,localExtrinsics,localX,localY,localZ,teachingMode);

        % Specify Title
        subplot(2,2,[2 4])
        title('Local Coordinates')

    end





    %% Section 9: Output/Saving
    % Save Grids
    save([savePath '/GRID_' saveName  ],'X','Y','Z','worldCoord','localAngle','localOrigin','localX','localY','localZ')

    % Save Images
    imwrite(flipud(Ir),[savePath  'World.png' ])

    if isempty(localIr) == 0
        imwrite(flipud(localIr),[savePath 'Local.png' ])
    end
       

end

