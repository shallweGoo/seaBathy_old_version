function gcpInfo =  getGcpInfo_UV(step_info,mode)
    %�ú���������� (�ڲ��Ѿ�������궨�ó�)
    %�ֲ�(�ɷ�Ϊ���ַ��� 1)���µ�һ֡��gcp����,���Դ�Ϊ��׼ 2)���ڵ�һ֡��gcpģ�壬���ں����ģ��ƥ�� )
    %1.ѡ��gcp��ͼ������ϵ�е�����(U,V) 
    %2.��ȡgcp����ʵ�����е�����(X,Y)
    %3.��С���˷����������Ż����õ���Σ���ת����ƽ��������
    %4.ÿ��ͼƬ����Ҫ����һ�����

    %mode1 ����Ϊ��ȡ���Ƶ������
    %mode2 ��ʽΪģ��ƥ�� ���˻�ȡ���Ƶ������֮�⻹��ȡ��ģ��

    imagePath = step_info.UV.imagePath;
    gcpSavePath = step_info.UV.gcpSavePath;
    
    if( isfield(step_info.UV,'fs'))
        fs = step_info.UV.fs;
    else
        fs = 2;
    end

%     if nargin < 3
%         fs = 2; % Ĭ��Ƶ��Ϊ2Hz
%         mode = 1;  %Ĭ��ģʽΪ�Ե�һ֡��gcp����Ϊƥ���׼
%     end

    
    
    unvalid = -99;
    saveName = 'gcpInfo';
    
    %%

    if isempty(imagePath)==0

        % �½�һ�����ڱ����û�ѡ��gcp
        f1=figure;

        I=imread(imagePath);
        [r,c,~]=size(I);
           
        colormap(gray); %ӳ��Ϊ�Ҷ�ֵ
        imagesc(1:c,1:r,I); %RGBͼ������������Ҷ�ͼҪ���������Ǹ�ӳ��Ϊ�Ҷ�ֵ��colormap
        
        axis equal; % ����������̶ȣ�չ����ʵ����
        xlim([0 c]);
        ylim([0 r]);
        xlabel({ 'U';'����ѡ�˾͵������˳�'});
        ylabel('V');
        hold on;

        % ��ʼ������¼�
        x=1;
        y=1;
        button = 1;
        UVclick=[];
        % mode2 ����ȥ��ȡģ��
        if mode == 2
            templatelength = 30; %30�����ص��С��ģ�壬ʵ������31.
%             gcpTemplate = cell(1,10); % Ԥ��10��ģ��
%             for i = 1:10
%                 gcpTemplate{i} = unvalid; %��ʼ��ģ�����ݽṹ
%             end
        end 
        while x <= c && y <= r % �����x<=c �� y<=r Ϊ��Ч����

            title('�밴�������������ѡ��ģʽ');
            pause

            title('���ѡ��GCP,�Ҽ�ɾ��GCP');
            [x,y,button] = ginput(1); %�Ե�ǰ��������Ϊ�ο�


            % �������¼�,
            if button == 1  &&  x <= c && y <= r 

                % ��ͼƬ����ԲȦ��עgcp
                plot(x,y,'ro','markersize',10,'linewidth',3);  

                title('��������������GCP�ı��');

                num=input('������GCP�ı��:');

                
                % ����gcp��Ϣ
                UVclick=cat(1,UVclick, [num x y]);
                
                if mode == 2
                    
                    tp.x_up = round(x + templatelength/2);
                    tp.x_down = round(x - templatelength/2);
                    tp.y_up = round(y + templatelength/2);
                    tp.y_down = round(y - templatelength/2);
                    if  tp.x_up<= c &&  tp.x_down >= 0 && tp.y_up<=r && tp.y_down>= 0
                        gcpTemplate(num).tp = I(tp.y_down:tp.y_up,tp.x_down:tp.x_up);
                    else 
                        error('can not make this template because of its range!');
                    end
                    
                end
                
                
                % ͼ�ϱ�עgcp��Ϣ
                text(x+30,y,num2str(num),'color','r','fontweight','bold','fontsize',15);

                % ���������gcp��ֵ
                disp(['GCP ' num2str(num) ' [U V]= [' num2str(x) ' ' num2str(y) ']']);
                disp(' ');
                figure(f1);
                zoom out
            end

            % �Ҽ�����¼�ɾ������λ�������gcpλ��
            % ɾ������unvalid��������������ݸ���.
            if button==3 && x <= c && y <= r

                % Ѱ������������������gcp�����������
                Idx = knnsearch(UVclick(:,2:3),[x y]);

                % �ر���ͼ�ϵı�ע
                N=length(UVclick(:,1,1))*2+1; % Total Figure Children (Image+ 1 Text + 1 Marker for each Click)
                f1.Children(1).Children(N-(Idx*2)).Visible='off';   % �ر����������ֱ�ע
                f1.Children(1).Children(N-(Idx*2-1)).Visible='off'; % �ر�������ԲȦ��ע
                
                %�����д�ӡɾ����Ϣ
                disp(['ɾ�� GCP ' num2str(UVclick(Idx,1))]);

                % �������������Ӧ��ֵ����Ϊ��Чֵ�����ں�������
                UVclick(Idx,1)= unvalid;
                
                if mode == 2
                    gcpTemplate(Idx).tp= unvalid;
                end
                
                zoom out
            end



        end

        % ����Ч����ɾ��
        IND=find(UVclick(:,1) ~= unvalid);
        
        UVsave=UVclick(IND,:);
        
         % ����gcp��������
        [~,ic]=sort(UVsave(:,1)); %icΪ�������UVsave������
        UVsave(:,:)=UVsave(ic,:);
        
        if mode == 2
            %���ڽṹ��ֻ����ѭ������
            cur = 1;
            for i = 1:length(gcpTemplate)
                if(gcpTemplate(i).tp ~= unvalid)
                    Tsave(cur).tp = gcpTemplate(i).tp;
                    Tsave(cur).num = i;
                    cur = cur+1;
                end
            end
            clear cur;
            
            [~,ic]=sort([Tsave.num]); %icΪ�������UVsave������
            Tsave = Tsave(ic);
            
        end
        
         
        % ��������gcp��ʽ
        for k=1:length(UVsave(:,1))
            gcp(k).UVd=UVsave(k,2:3);
            gcp(k).num=UVsave(k,1);
            gcp(k).Fs = fs;
            if mode == 2 
                gcp(k).template = Tsave(k).tp;
            end    
        end
    end
        
    
    
    
    %% ���������gcp��Ϣ
    close all

    disp(['GCPs Entered for ' saveName ':'])
    disp(' ')

    % ���������gcp��Ϣ
    for k=1:length(gcp)
        disp(['gcp(' num2str(k) ').num = ' num2str(gcp(k).num(1)) ] )
        disp(['gcp(' num2str(k) ').UVd = [' num2str(gcp(k).UVd(1)) ' ' num2str(gcp(k).UVd(2)) ']'])
    end

    % ȷ��ÿ��gcp��ͼƬ��Դ·����ֻ�Ƿ���鿴���ѣ�û��ʵ�ʵ����ã�
    for k=1:length(gcp)
        if isempty(imagePath)==0
            gcp(k).imagePath=imagePath;
%         else
%             gcp(k).imagePath=imagePath_noclick;
        end
    end

    
    

    %����ģ��,��һ��mat,��һ��ͼ��
    if mode == 2
%         save([gcpSavePath saveName '_template'],'Tsave'); %mat��ʽ
%         �������Ѿ�������gcp����ṹ����
        for i = 1:length(Tsave)
            imwrite(Tsave(i).tp,[gcpSavePath  saveName '_template' num2str(i) '.jpg'],'jpg');
        end
    end
    
    %����gcp.mat����Ϣ
    
    save([gcpSavePath  saveName '_firstFrame'],'gcp');
    
    %�����Ϣ
    gcpInfo = gcp;
        
end
        
        
        


    
    
