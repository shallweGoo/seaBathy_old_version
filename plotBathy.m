% ��ˮ�ͼ
%
function plotBathy(WorldCor,DepthInfo)
    % set up the figure
    set(gcf,'RendererMode','manual','Renderer','painters');
    cmap = colormap( 'jet' );
    colormap( flipud( cmap ) );

    clf;
%     subplot(121);
%     WorldCor.y = flipud(WorldCor.y);
    pcolor(WorldCor.x, WorldCor.y, DepthInfo);
    %֮��Ҫ�ǵ÷�תy����
    shading flat
    caxis([0 5]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    xlabel('x (m)');
    ylabel('y (m)');
%     titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
    titstr = "testBathy";
    title( titstr );
    h=colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    
%     set(gca,'ydir','reverse','xaxislocation','top');
     set(gca,'ydir','reverse');
    return;
end

