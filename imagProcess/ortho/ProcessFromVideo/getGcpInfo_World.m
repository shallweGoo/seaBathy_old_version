function gcpInfo_world = getGcpInfo_World(gcp_llh,o_llh,euler_ned2new,savePath) 
% �ú������ڻ�ȡgcp���Խ�����ϵ�µ����꣬Ҫ����˳�������
% �������Ϊgcp_llh(gps),o_llh(ԭ��gps),cmPara(�������)
% ������gps(��γ��llh) -> ������(enu) -> ������(ned) -> �Խ�����ϵ(new)������һ������,ԭ����Ҫ��ѡ
%
    
    addpath('F:/workSpace/matlabWork/seaBathymetry/imagProcess/ortho/ProcessFromVideo/CoreFunctions/');

    if nargin < 4 
        savePath = './'; 
    end

    
    objectPoints = gcpllh2NED(o_llh,gcp_llh); % gcp->enu ���������֮ǰ���ļ���
    objectPoints = objectPoints';

    yaw = euler_ned2new(1);
    pitch = euler_ned2new(2);
    roll = euler_ned2new(3);
    
    Rotate_ned2new = Euler2Rotate(yaw,pitch,roll); 
    Rotate_ned2new = Rotate_ned2new'; %��ȡned->new����ת����
    
    gcpInfo_world = Rotate_ned2new*objectPoints';
    gcpInfo_world = gcpInfo_world';
    
    
    
    if isempty(savePath) ~= 1
        saveName = 'gcpInfo';
        save([savePath saveName '_world'],'gcpInfo_world');
    end
    
        
end