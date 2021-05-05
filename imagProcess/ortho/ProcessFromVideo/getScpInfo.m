function scpInfo = getScpInfo(gcp_path,savePath,fs,brightFlag)
% GETSCPINFO �ú�����ȡ����scp��stable control point������Ϣ�����ں����gcp��ƥ�䣬CRIN����
% ѡȡ�ķ�����ѡȡgcp�ķ�ʽһ������������ķ�ʽ
% ������ɫ��ֵ���þ�ֵ�������ĵķ���



    if nargin < 3
        fs = 2;
        brightFlag = 'bright';
    elseif nargin < 4
            brightFlag = 'bright';
    end
    
    
    tmp = load(gcp_path);
    gcp = tmp.gcp;
    clear tmp;
    
    imagePath = gcp.imagePath;
    saveName = 'scpInfo';
    
    if isempty(imagePath)==0

        % Display Image
        f1=figure;

        
        
        I=imread(imagePath);
        [r,c,~]=size(I);
        
        colormap(gray); %ӳ��Ϊ�Ҷ�ֵ,�������Ϊ��ɫͼ�ǾͲ������������
        imagesc(1:c,1:r,I);
        axis equal;
        xlim([0 c]);
        ylim([0 r]);
        xlabel({ 'U';'����ѡ�˾͵������˳�'});
        ylabel('V');
        hold on;

        % ��ʼ������¼�
        x=1;
        y=1;
        button=1;
        UVclick=[];
        unvalid = -99;
        while x<=c && y<=r 

            title('�밴�������������ѡ��ģʽ');
            pause

            title('���ѡ��SCP,�Ҽ�ɾ��SCP');
            [x,y,button] = ginput(1);


            % ����¼�
            if button==1  && x<=c && y<=r


                title('��������������SCP�Ĳ���')

                % 
                num=input('������SCP�ı��:');
                % ����scpλ��
                text(x+30,y,num2str(num),'color','r','fontweight','bold','fontsize',15)

                % User Input for UVd Pixel Radius
                % Allows user to input various values and display until one
                % is satisfactory. (Its really a square width, not radius)
                Rn=75;
                h=rectangle('position',[x-Rn,y-Rn,2*Rn,2*Rn],'EdgeColor','r','linewidth',1);
                while isempty(Rn)==0
                    R=Rn;
                    disp(['�����������뾶������Ѿ�����Ҫ���򲻱����루��ʱ�뾶' num2str(Rn) '������):']);
                    Rn=input('');
                    if isempty(Rn) == 0 %��Ϊ��
                        h.Position=[x-Rn,y-Rn,2*Rn,2*Rn];
                    end
                end

                % ���û��Զ���ѡ����ֵ

                % �½�һ����������չʾscpѡ��׼��׼
                Tn=100;%Ĭ����ֵ����~�ڶ�Ӧ��0~255��dark~bright
                f2=figure;

                % ����ֵӳ��ͼ
                subplot(121);
                hold on;
                title(['SCP: ' num2str(num) '����ֵӳ��ͼ']);
                colorbar
                colormap jet
                axis equal


                % ��ֵͼӳ��ͼ
                subplot(122)
                title(['SCP: ' num2str(num) '. ��ֵ:' num2str(Tn)]);
                hold on;
                hold on
                colormap jet
                axis equal


                % �û�������ֵ�Ĺ��̣���Ϊ0�Ϳ�������ѡ��

                while isempty(Tn)==0
                    %Initiate Values
                    T=Tn;
                    % Calculate New Center of Area (Udn,Vdn) given Threshold T
                    [ Udn, Vdn, i, udi,vdi] = thresholdCenter(I,x,y,R,T,brightFlag);

                    % Plot Calculated Subset, Image, and new Centers of
                    % ROI in regular image
                    subplot(121)
                    imagesc(udi,vdi,i), set(gca,'ydir','reverse')
                    p1=plot(Udn,Vdn,'ko','markersize',10,'markerfacecolor','w');
                    p1.XData=Udn;
                    p1.YData=Vdn;
                    xlim([udi(1) udi(end)])
                    ylim([vdi(1) vdi(end)])
                    xlabel('Ud')
                    ylabel('Vd')
                    % Plot Calculated Subset, Image, and new Centers of ROI
                    % In Thresholded image
                    subplot(122)
                    if strcmp(brightFlag,'bright')==1
                        imagesc(udi,vdi,i>T), set(gca,'ydir','reverse')
                    end
                    if strcmp(brightFlag,'dark')==1
                        imagesc(udi,vdi,i<T), set(gca,'ydir','reverse')
                    end


                    title(['SCP: ' num2str(num) '. Threshold:' num2str(Tn)])
                    p2=plot(Udn,Vdn,'ko','markersize',10,'markerfacecolor','w');
                    p2.XData=Udn;
                    p2.YData=Vdn;
                    xlim([udi(1) udi(end)])
                    ylim([vdi(1) vdi(end)])
                    xlabel('Ud')
                    ylabel('Vd')
                    hh=colorbar;
                    cmap=jet(100);
                    cmap=cmap([1 100],:);
                    colormap(gca,cmap)
                    hh.Ticks=[0 1];
                    % Have user Enter New Value
                    disp(['��������ֵ������Ѿ�����Ҫ���򲻱����루��ʱ��ֵΪ:' num2str(T) '):']);
                    Tn=input('');
                end
                % Close New Figure when user decides value
                close(f2)




                % Store Entered and Clicked Values
                UVclick=cat(1,UVclick, [num x y  R T Udn Vdn]);


                % Display Values
                disp(['SCP ' num2str(num) ' [Udo Vdo]= [' num2str(Udn) ' ' num2str(Vdn) ']'])
                disp(' ')

                % Make f1 current figure and in original view.
                figure(f1)
                zoom out
            end

            % �Ҽ�ɾ���¼�
            if button==3 && (x<=c && y<=r)
                % �ҵ�����ĵ�
                Idx = knnsearch(UVclick(:,2:3),[x y]);

                % Turn the visual display off.
                N=length(UVclick(:,1,1))*2+1; % Total Figure Children (Image+ 1 Text + 1 Marker for each Click)
                f1.Children(1).Children(N-(Idx*2)).Visible='off';   % Turn off Text
                f1.Children(1).Children(N-(Idx*2-1)).Visible='off'; % Turn off Marker

                %��ӡɾ����Ϣ
                disp(['ɾ�� SCP ' num2str(UVclick(Idx,1))]);

                % ����Ϊ��Чֵ
                UVclick(Idx,1)=unvalid;
                zoom out
            end
        end

        % Filter out values that were to be deleted
        IND=find(UVclick(:,1) ~= unvalid);
        UVsave=UVclick(IND,:);

        % Sort so SCP Numbers are in order
        [~,ic]=sort(UVsave(:,1));
        UVsave(:,:)=UVsave(ic,:);

        % ����scp�ṹ��
        for k=1:length(UVsave(:,1))
            scp(k).UVdo=UVsave(k,6:7);
            scp(k).num=UVsave(k,1);
            scp(k).R=UVsave(k,4);
            scp(k).T=UVsave(k,5);
            scp(k).brightFlag=brightFlag;
        end


    end





    %% Section 4: Display Results
    disp(['SCPs Entered for ' saveName ':'])
    disp(' ')

    for k=1:length(scp)
        disp(['scp(' num2str(k) ').num = ' num2str(scp(k).num(1)) ] )
        disp(['scp(' num2str(k) ').UVdo = [' num2str(scp(k).UVdo(1)) ' ' num2str(scp(k).UVdo(2)) ']'])
        disp(['scp(' num2str(k) ').R = ' num2str(scp(k).R(1)) ] )
        disp(['scp(' num2str(k) ').T = ' num2str(scp(k).T(1)) ] )
        disp(' ')
    end





    %% Section 5: Save File

    % Incorporate imagePath in structure
    for k=1:length(scp)
        scp(k).imagePath=imagePath;
        scp(k).Fs = fs;
    end
    
    % ����scp����ṹ��
    save([savePath saveName '_firstFrame' ],'scp');
    scpInfo = scp;
    
end

