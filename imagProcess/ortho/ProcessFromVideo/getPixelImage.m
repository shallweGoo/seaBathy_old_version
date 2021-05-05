function getPixelImage(roi_path,extrinsicFullyInfo_path,unsolvedPic_path,savePath,inputStruct)
%GETPIXELIMAGE �ú�����ȡ����chooseRoi������ѡ����������طֱ��ʵȵó��Ľ����mat�ļ�����������ͼƬ��ȡ
% ʹ��ǰ�ǵü���addpath(genpath('CoreFunctions')),�����������������
% inputStructΪ����Ľṹ�壬Ӧ������roi_x,roi_y,dx,dy,x_dx,x_oy,x_rag,y_dy,y_ox,y_rag,localFlag
% localFlag = 0 Ϊ��������ϵ�� = 1 Ϊ��������ϵ
% roi_x,roi_y����Ҫ����ת����������local����ϵ������world����ϵ�ж�����,����Ҫ���ñ�־λlocalFlag
% dx,dy��Ϊroi_x,roi_y�����طֱ��ʣ���λΪm
% x_dx��Ϊ x_transect(Alongshore)�����ϵ����طֱ��ʣ���λΪm
% x_oy��Ϊx_transect����yֵ
% x_rag:x_transect�ķ�Χ��x�ķ�Χ
% y_dy,y_ox,y_rag ͬ�Ͻ���


    %���˻�ϵͳ�õ���ͼƬ���߲���Ҫ��ʱ����Ϊ�վ����ˣ��ں��������extrinsicFullyInfo���¼����
    t={};
    
    % ��������˻�ϵͳ�õ�ͼƬ���ǲ���Ҫ����ô��Ϊ�ռ���
    zFixedCam={}; 

    
    %���ڽ���grid�ṹ�����
    gridPath = roi_path;
    tmp1 = load(gridPath);
    X = tmp1.X; %��֮ǰ�õ���roi_pathֻ��Ϊ�˵õ��ɹ���ֵ��X,Y,Z����
    Y = tmp1.Y;
    Z = tmp1.Z;
    localAngle = tmp1.localAngle;
    localOrigin = tmp1.localOrigin;
    localX = tmp1.localX;
    localY = tmp1.localY;
    localZ = tmp1.localZ;
    worldCoord = tmp1.worldCoord; 
    clear tmp1;

    %����� �������� ����� ,�ò���
    ioeopath{1} = extrinsicFullyInfo_path;
    tmp2 = load(ioeopath{1});
    extrinsics = tmp2.extrinsics;
    intrinsics = tmp2.intrinsics;
    t = tmp2.t; %ʱ��о����Ǻ���Ҫ��
%     variableCamSolutionMeta = tmp2.variableCamSolutionMeta;
    clear tmp2;
    
    
    
    imageDirectory{1} = unsolvedPic_path; %�����ͼƬ·��,ֻ��һ��·����д��1�Ϳ�����
     
    saveName = 'pixelImg';




    %  If a Fixed station, most likely images will span times where Z is no
    %  longer constant. We have to account for this in our Z grid. To do this,
    %  enter a z vector below that is the same length as t. For each frame, the
    %  entire z grid will be assigned to this value.  It is assumed elevation
    %  is constant during a short
    %  collect. If you would like to enter a z grid that is variable in space
    %  and time, the user would have to alter the code to assign a unique Z in
    %  every loop iteration. See section 3 of D_gridGenExampleRect for more
    %  information. If UAS or not desired, leave empty.
    


    



    %% Section 4: User Input: Instrument Information



    % ʹ���Խ�����ϵ�����˱�־λ��Ϊ1��ʹ�����й淶����������ϵ��NED,ENU...������ñ�־λΪ0 
    % localAngle,localOrigin, and localX,Y,Z����Ϊ��
    localFlag = 1;

    
    %  Instrument Entries
    %  Enter the parameters for the isntruments below. If more than one insturment
    %  is desired copy and paste the entry with a second entry in the structure.
    %  Note, the coordinate system
    %  should be the same as specified above, if localFlag==1 the specified
    %  parameters should be in local coordinates and same units.

    %  Note: To reduce clutter in the code, pixel instruments were input in
    %  local coordinates so it could be used for both mulit and Uas demos. The
    %  entered coordinates are optimized for the UASDemo and may not be
    %  optmized for the multi-camera demo.



    %  grid����Ҳ���ǲ�����Ĳ������ã�dx,dy���Բ���ͬ��ȡ��������
    pixInst(1).type='Grid';
    pixInst(1). dx =inputStruct.dx;  % x�����طֱ��ʣ���ÿ�����صļ��
    pixInst(1). dy =inputStruct.dy;
    pixInst(1). xlim =inputStruct.x_rag;
    pixInst(1). ylim =inputStruct.y_rag;
    pixInst(1).z={}; % Leave empty if you would like it interpolated from input
    % Z grid or zFixedCam. If entered here it is assumed constant
    % across domain and in time.





    %  ��y���ϲɵ㣬��ΪyTransect��y��ΪAlong shore��������������ز���
    pixInst(2).type='yTransect';
    pixInst(2).x= inputStruct.y_ox; % y������Ӧx�ĳ�ʼλ��
    pixInst(2).ylim=inputStruct.y_rag;
    pixInst(2).dy =inputStruct.y_dy; %���طֱ���
    pixInst(2).z ={};  %ʵ������z���꣬�ں����Ͽ��Թ���Ϊ0��Ϊ��˵����ͨ�������Zֵ���в�ֵ��
    % �����Ϊ��˵��Ϊ�̶�ֵ

    %
    %
    %  Runup (Cross-shore Transects)
    %  ͬ�ϣ�x���ϲɵ㣬Cross-shore��������������ز���

    pixInst(3).type='xTransect';
    pixInst(3).y= inputStruct.x_oy;
    pixInst(3).xlim=inputStruct.x_rag;
    pixInst(3).dx =inputStruct.x_dx;
    pixInst(3).z ={};  % �ò�����Ϊ��˵��z��Ϊ��ֵ��Ϊ�տ�ͨ�������Zֵ���в�ֵ,����ֱ����Ϊ��





    %% Section X: Multi-Cam Demo input
    % % Uncomment this section for the multi-camera demo. Impath and ioeopath
    % % should be entered as cells, with each entry representing a different
    % % camera. It is up to the user that entries between the two variables
    % % correspond. Extrinsics between all cameras should be in the same World
    % % Coordinate System. Note that no new grid or instrument file is specified,
    % % the cameras and images are all rectified to the same grid, instrument
    % % points, and time varying elevation. Also it is important to note for
    % % ImageDirectory, each camera should have its own directory for images.
    % % The number of images in each directory should be the same (T) as well as
    % % ordered by MATLAB so images in the same order are simultaneous across
    % % cameras (i.e. the third image in c1 is taken at t=1s, the third image in
    % % c2 is taken at t=1s, etc). zVariable is from NOAA Tide Station at
    % % NAVD88 in meters.

    %  oname='fixedMultCamDemo_rect2mResolution';
    %
    %  odir= './X_FixedMultCamDemoData/output/fixedMultCamDemoRectified';
    %
    % ioeopath{1}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C1_FixedMultiCamDemo.mat';
    % ioeopath{2}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C2_FixedMultiCamDemo.mat';
    % ioeopath{3}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C3_FixedMultiCamDemo.mat';
    % ioeopath{4}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C4_FixedMultiCamDemo.mat';
    % ioeopath{5}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C5_FixedMultiCamDemo.mat';
    % ioeopath{6}=  './X_FixedMultCamDemoData/extrinsicsIntrinsics/C6_FixedMultiCamDemo.mat';%
    %
    %  imageDirectory{1}='./X_FixedMultCamDemoData/collectionData/c1';
    %  imageDirectory{2}='./X_FixedMultCamDemoData/collectionData/c2';
    %  imageDirectory{3}='./X_FixedMultCamDemoData/collectionData/c3';
    %  imageDirectory{4}='./X_FixedMultCamDemoData/collectionData/c4';
    %  imageDirectory{5}='./X_FixedMultCamDemoData/collectionData/c5';
    %  imageDirectory{6}='./X_FixedMultCamDemoData/collectionData/c6';
    %
    %
    %  t=[datenum(2015,10,8,14,30,0):.5/24:datenum(2015,10,8,22,00,0)];
    %
    % zVariable=[-.248 -.26 -.252 -.199 -.138 -.1 -.04 .112 .2 .315 .415 .506 .57 .586 .574 .519];
    %
    %



    %% Section 5: Load Files

    % Load Grid File And Check if local is desired
    % ѡ��local����ϵ���м���
    
    if localFlag==1
        X=localX;
        Y=localY;
        Z=localZ;
    end

    % ��������κ�Ŀ��ͼƬ·��

    %  Determine Number of Cameras
    camnum=length(ioeopath);

    for k=1:camnum
        % Load List of Collection Images
        L{k}=string(ls(imageDirectory{k}));
        L{k}=L{k}(3:end); % ǰ����Ϊ��ǰĿ¼.���ϼ�Ŀ¼..

        % Check if fixed or variable. If fixed (length(extrinsics(:,1))==1), make
        % an extrinsic matrix the same length as L, just with initial extrinsics
        % repeated.
        if length(extrinsics(:,1))==1 %������Ϊ�̶�ֵ����������ֻ��һ�飬1*6����ô�м���ͼƬ�͸��Ƽ��ݼ��ɣ�Ϊ�˳���ķ�����
            extrinsics=repmat(extrinsics,length(L{k}(:)),1);
        end
        if localFlag==1     %�����׼����(ned)->�Զ�������(local),CRIN�õ��Ƕ����죨ENU��
            extrinsics=localTransformExtrinsics(localOrigin,localAngle,1,extrinsics);
        end

        % �������ݱ��ں�������
        Extrinsics{k}=extrinsics;
        Intrinsics{k}=intrinsics;

        clear extrinsics;
        clear intrinsics;
    end






    %% Section 6: Initialize Pixel Instruments

    % Make XYZ Grids/Vectors from Specifications.
    [pixInst]=pixInstPrepXYZ(pixInst); %ƴ��pixInst�ṹ��

    % Assign Z Elevations Depending on provided parameters.
    % If pixInst.z is left empty, assign it correct elevation
    for p=1:length(pixInst)
        if isempty(pixInst(p).z)==1
            if isempty(zFixedCam)==1 % If a Time-varying z is not specified 
                pixInst(p).Z=interp2(X,Y,Z,pixInst(p).X,pixInst(p).Y); % ���������zֵ��ѡ���������в�ֵ
            end

            if isempty(zFixedCam)==0 % If a time varying z is specified
                pixInst(p).Z=pixInst(p).X.*0+zFixedCam(1); % �����ȷzֵ�Ǻ����Ķ�Ϊ��ֵ
            end
            
        end
    end





    %% Section 7: Plot Pixel Instruments

    for k=1:camnum
        % Load and Display initial Oblique Distorted Image
        I=imread(strcat(imageDirectory{k}, L{k}(1)));
        figure;
        hold on;

        imshow(I);
        hold on;
        title('Pixel Instruments');

        % For Each Instrument, Determin UVd points and plot on image
        for p=1:length(pixInst)

            % Put in Format xyz for xyz2distUVd
            xyz=cat(2,pixInst(p).X(:),pixInst(p).Y(:),pixInst(p).Z(:));
            %������������ݶԱ�
            if(p == 1)
                save('F:/workSpace/matlabWork/proPoints.mat','xyz');
            end
            %Pull Correct Extrinsics out, Corresponding In time

            extrinsics=Extrinsics{k}(1,:);
            intrinsics=Intrinsics{k};


            % Determine UVd Points from intrinsics and initial extrinsics
            [UVd] = xyz2DistUV(intrinsics,extrinsics,xyz); %����chooseRoi��ѡ�������������е�xyz��Ϣ��ֵ��õ�z�����ø�ֵ����uv����

            % Make A size Suitable for Plotting
            UVd = reshape(UVd,[],2);
            plot(UVd(:,1),UVd(:,2),'*');
            xlim([0 intrinsics(1)]);
            ylim([0  intrinsics(2)]);

            % Make legend
            le{p}= [num2str(p) ' ' pixInst(p).type ];
        end
        legend(le)
        clear I;
        clear extrinsics;
        clear intrinsics;
    end

    % Allows for the instruments to be plotted before processing
    pause(1)




    %% Section 7:  Loop for Collecting Pixel Instrument Data.

    for j=1:length(L{1}(:))

        % For Each Camera
        for k=1:camnum
            % Load Image
            I{k}=imread(strcat(imageDirectory{k}, L{k}(j)));
        end

        %  Loop for Each Pixel Instrument
        for p=1:length(pixInst)

            % Check if a time varying Z was specified. If not, wil just use constant Z
            % specified or interpolated from grid in Section 4 and 6 respectively.
            if isempty(pixInst(p).z)==1  % �����ʱ��zֵ��Ϊ��ʱ
                if isempty(zFixedCam)==0 % ���ʱ�̶�����Ļ�z���ڹ̶�ֵ����������̶�ֵ����
                    pixInst(p).Z=pixInst(p).X.*0+zFixedCam(j); % Assign First Value for First Image, spatially constant elevation
                end
            end

            %Pull Correct Extrinsics out, Corresponding In time
            for k=1:camnum
                extrinsics{k}=Extrinsics{k}(j,:);%��ʱ������Σ��о��е㻭��������
            end
            intrinsics=Intrinsics;

            % ��ȡ����������rgbͼ
            [Irgb]= imageRectifier(I,intrinsics,extrinsics,pixInst(p).X,pixInst(p).Y,pixInst(p).Z,0); 
            % ���һ������0Ϊ��ѧģʽ
            % ����չʾ��chooseRoiһ��������
            
            
            % ת��Ϊ�Ҷ�ͼ
            [Igray]=rgb2gray(Irgb);




            % If First frame, initialize pixInst structure entries
            if j==1
                pixInst(p).Igray=Igray;
                pixInst(p).Irgb=Irgb;
                
            end

            % If not First frame, tack on as last dimension (time).
            if j~=1
                s=size(Igray);
                nDim= length(find(s~=1)); % ���������ͼ����IgrayΪ2ά������Ǻ���棬��IgrayΪ1ά��
                
                % For Gray Scale it is straight forward
                pixInst(p).Igray=cat(nDim+1,pixInst(p).Igray,Igray); % ƴ�����ݣ�������1ά�ĺ�������ݾ�ƴ�ڵ�2ά���У���2ά�������ݾ�ƴ�ڵ�3ά

                % For RGB it is trickier since MATLAB always likes rgb values in
                % third dimension.
                % If a GridGrid Add in the fourth dimension
                if nDim==2
                    pixInst(p).Irgb=cat(nDim+2,pixInst(p).Irgb,Irgb); % rgbͼƬ��Զƴ�ڵ�4ά
                end
                % ���������ƴ�ڵ�2ά
                if nDim==1
                    pixInst(p).Irgb=cat(nDim+1,pixInst(p).Irgb,Irgb);
                end

            end
        end

        % Display progress
        disp([ 'Frame ' num2str(j) ' out of ' num2str(length(L{k}(:))) ' completed. ' num2str(round(j/length(L{k}(:))*1000)/10) '%'])

    end


    %% Section 8: Plot Instrument Data
    % For Each Instrument Plot the Data, note, if Grid data only the first
    % frame will be plotted.

    %��grid,x_transect,y_transect��������
    
    for p=1:length(pixInst)

        %�½�ͼ�����ڣ�������type��������
        figure;
        title([num2str(p) ' ' pixInst(p).type ])
        hold on

        % Grid��ͼ,ӳ���ϵ����x��y��������ӳ��
        if strcmp(pixInst(p).type,'Grid')==1
            rectificationPlotter(pixInst(p).Irgb(:,:,:,1),pixInst(p).X,pixInst(p).Y,1); % Plot First Frame RGB
        end
        
        % x_transect ����timestackͼ
        if strcmp(pixInst(p).type,'xTransect') == 1
            stackPlotter(pixInst(p).Irgb,pixInst(p).X,t, 'x', 1)

            %�����ʱ����Ϣ��ӵ�����������
            
            if isempty(t)==0
                datetick('y','keeplimits')
            end
        end
           
        % y_transect ����timestackͼ
        if strcmp(pixInst(p).type,'yTransect')==1
            stackPlotter(pixInst(p).Irgb,pixInst(p).Y,t, 'y', 1)
            %If t non empty, add datetick to axis
            if isempty(t)==0
                datetick('x','keeplimits');
            end
        end




    end






    %% Section 9: Save Instruments and Meta Data

    % Save metaData and Grid Data
    rectMeta.solutionPath=ioeopath;
    rectMeta.imageDirectory=imageDirectory;
    rectMeta.imageNames=L;
    rectMeta.t=t;
    rectMeta.worldCoord=worldCoord;

    % If A local Grid Add Information
    if localFlag==1
        rectMeta.localFlag=1;
        rectMeta.localAngle=localAngle;
        rectMeta.localOrigin=localOrigin;
    end


    save(strcat(savePath,saveName), 'pixInst','rectMeta','t')
    
    
    
    
end

% function [outputArg1,outputArg2] = rotImg(pixelInst_path,savePath)
% %ROTIMG Ϊ����תpixelInst�е������²���ͼ���õ������������ϴ�����Ч��ͼ
%     
% end






