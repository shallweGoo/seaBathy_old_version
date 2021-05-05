function downSampleFromVideo(step)
%DOWNSAMPLEFORVIDEO �ú������ڶ�һ����Ƶ����ͼ�񽵲���,���������֪��Video����Ϣ


%�Լ�д�Ĳ��֣�������string(ls),����д�ˣ�ֱ�ӽ��CIRN_A0������
%     obj = VideoReader(VideoPath);
%     totalFrames = obj.NumberOfFrames;% ��Ƶ֡������
%     frameInterval = floor(ceil(obj.FrameRate)/Fs);
%     lastFrames = floor(totalFrames/Multiple);
        
    
    
%         % imshow(frame);%��ʾ֡
%         imwrite(rgb2gray(frame),strcat(SavePath,"6Hz"+num2str(ceil(k/frameInterval)),'.jpg'),'jpg');
%     end

%     for k = 1 : frameInterval : lastFrames
%         frame = read(obj,k);
%% ����ΪCIRN�޸�

    %��������ò���Ƶ�ʺͲ���֡ʱ��Ĭ��Ϊ2Hz��ȫ��֡ת��
    
    videoPath = step.videoPath;
    savePath = step.savePath;
    
    if(isfield(step,'fs')) 
        fs = step.fs;
    else
        fs = 2;
    end
    
    if(isfield(step,'videoRange')) 
        videoRange = step.videoRange;
    else
        videoRange = [];
    end
    
    
%     if nargin < 3
%         fs = 2;
%         videoRange = []; 
%     elseif nargin < 4 
%         videoRange = [];
%     end 
        
    v =VideoReader(videoPath);

    to = datenum(2020,10,24,7,30,0); %��һ֡��������ʱ���룬��֪��Ҳû��ֱ������Ϊ0
    
    SaveName = 'downSample';
    
    
    
    % ��ʼ��ʱ��
    if to==datenum(0,0,0,0,0,0) % �����֪��ʱ��Ĭ��Ϊ0
        to=0;
    else % if to known
        to=(to-datenum(1970,1,1))*24*3600; % ��unixϵͳĬ�ϵ���ʱ�俪ʼ�������
    end

    % ��ʼ��ѭ��
    k=1;
    count=1;
    numFrames= v.Duration.*v.FrameRate;  %��֡��


    if isempty(videoRange) %Ϊ����˵����ͷ��β��ȡ��Ƶ֡
        while k <= numFrames

            I = read(v,k);

            if k==1
                vto=v.CurrentTime;%��λΪ��
            end

            t=v.CurrentTime; 
            ts= (t-vto)+to; % tsΪ��ȡ֡��Ӧ������,��λΪs




            %Because of the way Matlab defines time. 
            if k== numFrames
                ts=ts+1./v.FrameRate;
            end

            % ��ֹ�ļ����г���С��,����ת��Ϊ����
            ts=round(ts.*1000);

            % ����ͼƬ

            imwrite(rgb2gray(I),[savePath SaveName '_' num2str(ts) '.tif']);%���Կ��Ƿŵ����ȥ�ҶȻ�

            % ��ʾ���ȣ��ǳ���Ļ���
            disp([ num2str( k./numFrames*100) '% Extraction Complete'])

            % �õ���һ֡������
            k=k+round(v.FrameRate./fs);

            % ����ʱ����Ϣ
            T(count)=ts/1000; %ת��Ϊ��
            count=count+1;

        end

    %ָ��videoRange��Χ֮��
    else 
        %��ȷ������ʱ������Ӧ��֡��
        while k <= numFrames

            I = read(v,k);

            if k==1
                vto=v.CurrentTime;%��λΪ��
            end

            t=v.CurrentTime;
            if t < videoRange(1)
                k=k+round(v.FrameRate./fs);
                disp(['waiting for extraction:' num2str(videoRange(1)-t) 's']);
                continue;
            elseif t > videoRange(2)
                disp('Out of specific video range');
                break;
            end

            ts= (t-vto)+to; % tsΪ��ȡ֡��Ӧ������,��λΪs



            %Because of the way Matlab defines time. 
            if k== numFrames
                ts=ts+1./v.FrameRate;
            end

            % ��ֹ�ļ����г���С��,����ת��Ϊ����
            ts=round(ts.*1000);

            % ����ͼƬ

            imwrite(rgb2gray(I),[savePath SaveName '_' num2str(ts) '.tif']);%���Կ��Ƿŵ����ȥ�ҶȻ�

            % ��ʾ���ȣ��ǳ���Ļ���
            disp([ num2str( (t-videoRange(1))./(videoRange(2)- videoRange(1))*100) '% Extraction Complete'])

            % �õ���һ֡������
            k=k+round(v.FrameRate./fs);

            % ����ʱ����Ϣ
            T(count)=ts/1000; %ת��Ϊ��
            count=count+1;

        end
    end
    %��ʾת����ɵ���Ϣ
    disp(' ');
    disp(['ԭʼ��Ƶ֡��: ' num2str(v.FrameRate) ' fps'])
    disp(['ָ����Ƶ֡��: ' num2str(fs) ' fps']);
    disp(['ָ����ȡͼƬ��ʱ����: ' num2str(1./fs) ' s']);
    disp(['ʵ��ƽ��ʱ����: ' num2str(nanmean(diff(T(1:(end-1))))) ' s']);
% 	disp(['STD of actual dt: ' num2str(sqrt(var(diff(T(1:(end-1))),'omitnan'))) ' s']);

end




