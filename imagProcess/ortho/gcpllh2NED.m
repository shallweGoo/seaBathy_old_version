%GCPÿһ��Ϊһ����γ�ߣ�����Ϊ����ʽ����Ϊ����
%org_llhΪԭ��ľ�γ��
function gcp_ned = gcpllh2NED(org_llh,gcp_llh)
     gcp_enu =  llh2enu(org_llh,gcp_llh);
     %enu->ned����ת����
     Renu_ned = Euler2Rotate(90,0,180);
     Renu_ned = Renu_ned';
     gcp_enu = gcp_enu';
 for i = 1:size(gcp_enu,2)
     gcp_ned(:,i) = Renu_ned*gcp_enu(:,i);
 end
 
    