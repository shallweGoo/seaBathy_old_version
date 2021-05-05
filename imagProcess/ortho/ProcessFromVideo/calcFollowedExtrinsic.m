function  calcFollowedExtrinsic(scp_path,gcp_path,rotateInfo_path,unsovledExtrinsic_pic_path,savePath,mode)
% calcFollowedExtrinsic �����ȶ���������ͼ��,��������ÿ֡����Σ����������������ַ���
% mode = 1������scp���������
% mode = 2������ģ����ƥ��gcp�������������


    %scpInfoΪscp��Ϣ�ṹ�壬����Ӧ��Ϊ�ṹ��
    %ieInfoӦ��Ϊextrinsics��intrinsic��initialCam�Ľṹ��
    %unsovledExtrinsic_pic_pathΪ���������֡ͼƬ��·��
    %savePathΪ�洢·��
    
    

 %  ��Ӻ��ĺ���
    addpath(genpath('./CoreFunctions/'));

    
    if nargin<6
        mode = 1;
    end
    
    tmp1 = load(scp_path);
    scp = tmp1.scp;
    
    tmp2 = load(gcp_path);
    gcp = tmp2.gcp;
    
    tmp3 = load(rotateInfo_path);
    extrinsics = tmp3.extrinsics;
    intrinsics = tmp3.intrinsics;
    initialCamSolutionMeta = tmp3.initialCamSolutionMeta;
    
    
    clear tmp1;
    clear tmp2;
    clear tmp3;
    
    
    if mode == 1  %ģʽ1����CRIN�ķ������м���
       %% Section 2: User Input:  Initial Frame information

        %  Enter the filename of the first image where IOEO is known. It should be
        %  the same image you did the initial solution for in
        %  C_singleExtrinsicsSolution (initialCamSolutionMeta.impath). It should be
        %  in the same directory as your other colleciton images imagesDirectory.

        imagePath = char(scp(1).imagePath);
        ind =  find(imagePath == '/');
        firstFrame= imagePath((ind(end)+1):end); %��һ֡ͼ��·��
        clear ind;
        clear imagePath;

        
        
        saveName = 'extrinsicFullyInfo';
       
        


        % ��һ��Ϊscp�ı�ţ��ڶ���Ϊscp����ʵ��������ϵ�µ�z����ֵ������ϵӦ���ͼ��������ʹ�õ�����ϵ��ͬ
        % initailCamSolutionMeta.worldCoordSys
        scpz=[ 1  7; % scp.num   z value
            2  7;
            3  7;
            4  7
            5  7];

        %  ��¼һ��zֵ��ʹ�õ�����ϵ
        % (initailCamSolutionMeta.worldCoordSys)

        scpZcoord= initialCamSolutionMeta.worldCoordSys;


        


        %% Section 3: User Input:  Collection Imagery

        %  ÿ֡ͼ��Ĵ��·�����ļ����б���ֻ����ͼƬ������������ʽ��Ϊ����Ӧ��Ϊ000001��000002�����ģ�����ʹ�þ���ʱ�䡣
        %  ��Ϊ֮���ʹ��string(ls(3:end))������ʽȥ�������Զ�������ʽ��Ҫ��
        imageDirectory= unsovledExtrinsic_pic_path;


        %  Enter the dt in seconds of the collect. If not known, leave as {}. Under
        %  t, images will just be numbered 1,2,3,4.
        %  �����¼�������֪�����ɿգ�֮��ͼƬĬ�ϻᱻ���Ϊ1��2��3��4
        dts= 1/scp(1).Fs; %Seconds 


        %  Enter the time of the initial image in MATLAB Datenum format; if unknown
        %  leave empty {}, to will be set to 0.
        to=datenum(2020,10,24,7,30,0); % ��ע�Ͳ�����ˣ�������Ϣ





       %% Section 4: Load IOEO and SCP Info

        % Assign SCP Elevations to each SCP Point.
        for k=1:length(scp)
            i=find(scpz(:,1)==scp(k).num);
            scp(k).z=scpz(i,2);
        end

        % Put SCP in format for distUV2XYZ
        for k=1:length(scp)
            scpZ(k)=scp(k).z;
            scpUVd(:,k)=[scp(k).UVdo'];
        end





        %% Section 5: Find List of Images and Assign TIme


        % ���е�ͼƬ�б�
        L=string(ls(imageDirectory));

        % �ҵ���ʹ�õ�һ֡��ͼƬλ��
        chk=cellfun(@isempty,strfind(L,firstFrame));
        ffInd=find(chk==0);

        % ��������ͼƬ����
        ind=ffInd:length(chk);

        % Assign time vector, if dts is left empty, vector will just be image
        % number
        if isempty(dts)==0
            t=(dts./24./3600).*([1:length(ind)]-1)+ to; %����ʱ��
        else if isempty(dts)==1
                t=(1:length(ind))-1;
            end
        end





       %% Section 6: Initialize Extrinsic Values and Figures for Loop

        % Plot Initial Frame and SCP Locations
        In=imread(strcat(imageDirectory,'/', L(ffInd,:))); %չʾһ�µ�һ֡��Ϣ
        f1 = figure; %ͼ����������ڲ���ͼ��
        imshow(In);
        hold on;
        for k=1:length(scp)
            plot(scp(k).UVdo(1),scp(k).UVdo(2),'ro','linewidth',2,'markersize',10)
        end

        if isempty(dts)==1
            title(['��һ֡: ' num2str(t(1))])
        else
            title(['��һ֡: ' datestr(t(1))])
        end


        % ������ṹ��
        extrinsicsVariable=nan(length(ind),length(extrinsics));
        extrinsicsVariable(1,:) = extrinsics; % First Value is first frame extrinsics.
        extrinsicsUncert(1,:)=initialCamSolutionMeta.extrinsicsUncert;


        %  Determine XYZ Values of SCP UVdo points
        %  We find the XYZ values of the first frame SCP UVdo points, assuming the
        %  z coordinate is the elevations we entered in Section 2. We find xyz,
        %  so when we find the corresponding SCP feature in our next images In,
        %  we can treat our SCPs as gcps, and solve for a new extrinsics_n for each
        %  iteration
        
        
        % ��һ�����Ƶ�zֵȥ����scp���������꣬�������㣬��Ϊ����Ҫ��֪һά��xyz��Ϣ���ܼ��㣬
        % �������Ѿ��ü����Ѿ�֪����z�ͽ�Ϊ��ȷ�����extrinsics����UV->xyz��ӳ����,���Եõ�xyz�Ĳ�����scp��ʵ�����ֻ꣬��Ϊ�����������κͼ����z����
        % ��scp���Խ�����ϵ�µ�����Ĺ���
        [xyzo] = distUV2XYZ(intrinsics,extrinsics,scpUVd,'z',scpZ);



        % Initiate and rename initial image, Extrinsics, and SCPUVds for loop

        extrinsics_n=extrinsics;
        scpUVdn=scpUVd;





        %% Section 7: Start Solving Extrinsics for Each image.
        imCount=1;
        len = length(ind)+2;
        for k=ind(2:end)

            % Assign last Known Extrinsics and SCP UVd coords
            extrinsics_o=extrinsics_n;%������һ֡����Ϣ������У��
            scpUVdo=scpUVdn; %������һ֡��scp��Ϣ����У��


            %  Load the New Image
            In=imread(strcat(imageDirectory, L(k,:)));


            % Find the new UVd coordinate for each SCPs
            for j=1:length(scp)
               
                %��֮ǰԤ��õ�scp��Ϣ�������뾶�Լ���ֵȥ������
                %�ڴ˿�����mode2 ģ��ƥ��ȥ��ȡscp������
                [ Udn, Vdn, ~, ~,~] = thresholdCenter(In,scpUVdo(1,j),scpUVdo(2,j),scp(j).R,scp(j).T,scp(j).brightFlag);
                % If the function errors here, most likely your threshold was too high or
                % your radius too small for  a scp. Look at scpUVdo to see if there is a
                % nan value, if so  you will have to redo E_scpSelection with bigger
                % tolerances.

                %Assingning New Coordinate Location
                scpUVdn(:,j)=[Udn; Vdn]; %ÿ�д���һ��scp����Ϣ
            end


            % Solve For new Extrinsics using last frame extrinsics as initial guess and
            % scps as gcps
            extrinsicsInitialGuess=extrinsics_o; %��֮ǰ�������Ϊ��ʼֵ�����н�һ������
            extrinsicsKnownsFlag=[0 0 0 0 0 0];
            [extrinsics_n,extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,scpUVdo',xyzo);


            % Save Extrinsics in Matrix
            imCount=imCount+1;
            extrinsicsVariable(imCount,:)=extrinsics_n; %����δ���extrinsicsVariable��
            extrinsicsUncert(imCount,:)=extrinsicsError;



            % Plot new Image and new UV coordinates, found by threshold and reprojected
            cla
            imshow(In);
            hold on

            % Plot Newly Found UVdn by Threshold
            plot(scpUVdn(1,:),scpUVdn(2,:),'ro','linewidth',2,'markersize',10);
            
            % Plot Reprojected UVd using new Extrinsics and original xyzo coordinates
            [UVd] = xyz2DistUV(intrinsics,extrinsics_n,xyzo);
            uvchk = reshape(UVd,[],2);
            plot(uvchk(:,1),uvchk(:,2),'yo','linewidth',2,'markersize',10);

            % Plotting Clean-up
            if isempty(dts)==1
                title(['Frame: ' num2str(t(imCount))]);
            else
                title(['Frame ' num2str(imCount) ': ' datestr(t(imCount))]);
            end
            legend('��һ֡SCP','��֡SCP');
            
            disp([ num2str( k./len*100) '% Fix Complete'])
            pause(.05)
        end


        


       %% Section 8: Plot Change in Extrinsics from Initial Frame

        f2 = figure;

        % XCoordinate
        subplot(6,1,1)
        plot(t,extrinsicsVariable(:,1)-extrinsicsVariable(1,1))
        ylabel('/Delta x')
        title('Change in Extrinsics over Collection')

        % YCoordinate
        subplot(6,1,2)
        plot(t,extrinsicsVariable(:,2)-extrinsicsVariable(1,2))
        ylabel('/Delta y')

        % ZCoordinate
        subplot(6,1,3)
        plot(t,extrinsicsVariable(:,3)-extrinsicsVariable(1,3))
        ylabel('/Delta z')

        % Azimuth
        subplot(6,1,4)
        plot(t,rad2deg(extrinsicsVariable(:,4)-extrinsicsVariable(1,4)))
        ylabel('/Delta Azimuth [^o]')

        % Tilt
        subplot(6,1,5)
        plot(t,rad2deg(extrinsicsVariable(:,5)-extrinsicsVariable(1,5)))
        ylabel('/Delta Tilt[^o]')

        % Swing
        subplot(6,1,6)
        plot(t,rad2deg(extrinsicsVariable(:,6)-extrinsicsVariable(1,6)))
        ylabel('/Delta Swing [^o]')


        % Set grid and datetick if time is provided
        for k=1:6
            subplot(6,1,k)
            grid on

            if isempty(dts)==0
                datetick
            end
        end





       %% Section 9: Saving Extrinsics and Metadata
        %  Saving Extrinsics and corresponding image names
        extrinsics=extrinsicsVariable;
        imageNames=L(ind);


        % Saving MetaData
        variableCamSolutionMeta.scpPath=scp_path;
        variableCamSolutionMeta.scpo=scp;
        variableCamSolutionMeta.scpZcoord=scpZcoord;
        variableCamSolutionMeta.ioeopath=rotateInfo_path;
        variableCamSolutionMeta.imageDirectory=imageDirectory;
        variableCamSolutionMeta.dts=dts;
        variableCamSolutionMeta.to=to;


        % Calculate Some Statsitics
        variableCamSolutionMeta.solutionSTD= sqrt(var(extrinsics));

        %  Save File
        save([savePath saveName ],'extrinsics','variableCamSolutionMeta','imageNames','t','intrinsics');


        %  Display
        disp(' ')
        disp(['Extrinsics for ' num2str(length(L)) ' frames calculated.'])
        disp(' ')
        disp(['X Standard Dev: ' num2str(variableCamSolutionMeta.solutionSTD(1))])
        disp(['Y Standard Dev: ' num2str(variableCamSolutionMeta.solutionSTD(2))])
        disp(['Z Standard Dev: ' num2str(variableCamSolutionMeta.solutionSTD(3))])
        disp(['Azimuth Standard Dev: ' num2str(rad2deg(variableCamSolutionMeta.solutionSTD(4))) ' deg'])
        disp(['Tilt Standard Dev: ' num2str(rad2deg(variableCamSolutionMeta.solutionSTD(5))) ' deg'])
        disp(['Swing Standard Dev: ' num2str(rad2deg(variableCamSolutionMeta.solutionSTD(6))) ' deg'])
    end
    
    

end

