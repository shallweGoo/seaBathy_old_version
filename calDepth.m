%�ú������ڼ������е����
% f��c������������ʾ
function seaDepth = calDepth(c,f)
        const = 2*pi;
        seaDepth = (c./f/const).*atanh(const/10*c.*f);
end

