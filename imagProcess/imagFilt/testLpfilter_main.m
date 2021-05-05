imgInfo.path = 'F:/workSpace/matlabWork/imgResult/orthImg/';
imgInfo.save_path = 'F:/workSpace/matlabWork/imgResult/gaussFilter/';


allFile = string(ls(imgInfo.path));
allFile = allFile(3:end);


for i = 1:length(allFile)
    org_pic = imread((imgInfo.path+allFile(i)));
    res = gaussfilter(org_pic,50);
    imwrite(res,(imgInfo.save_path+allFile(i)));

end



% pi1 = org_pic(:,90);
% res = gaussfilter(org_pic,50);
% pi2 = res(:,90);
% figure(1);plot((1:size(pi1,1)),pi1,'r',(1:size(pi1,1)),pi2,'black');
% figure(2);imshow(res);
%     