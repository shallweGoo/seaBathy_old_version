function gridPlot(grid_pic)
% grid_picΪ1m�ֱ��ʵľ���
    
    cmap = colormap( 'jet' );
    colormap( flipud( cmap ) );  % ������ɫ

    row = size(grid_pic,1);
    col = size(grid_pic,2);

    %shading flat;
    
    pcolor(1:col,1:row,grid_pic);
    caxis([0 5]); %������ȵ���ʾ��Χ
    set(gca, 'ydir', 'nor');
    axis equal;
    axis tight;
    h = colorbar('peer', gca);
    set(h, 'ydir', 'rev');
    set(get(h,'title'),'string', 'h (m)');
    set(gca,'ydir','reverse');
    % set(gca,'XTick',1:col,'YTick',1:row);  % ��������
    % axis image xy;  % ��ÿ��������ʹ����ͬ�����ݵ�λ������һ��
%     title('���׵���ͼV');
end