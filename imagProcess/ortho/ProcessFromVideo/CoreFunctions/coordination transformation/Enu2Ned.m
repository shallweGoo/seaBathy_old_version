%������ת������
%���������Ϊ3*n���������
function ned_cor = Enu2Ned(enu_cor)
    Renu_ned = Euler2Rotate(90,0,180);
    Renu_ned = Renu_ned';
    for i = 1:size(enu_cor,2)
        ned_cor(:,i) = Renu_ned*enu_cor(:,i);
    end
end

