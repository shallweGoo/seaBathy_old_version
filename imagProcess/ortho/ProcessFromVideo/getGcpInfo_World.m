function gcpInfo_world = getGcpInfo_World(gcp_llh,o_llh,euler_ned2new,savePath) 
% 该函数用于获取gcp在自建坐标系下的坐标，要求有顺序的输入
% 输入参数为gcp_llh(gps),o_llh(原点gps),cmPara(相机参数)
% 借助了gps(经纬高llh) -> 东北天(enu) -> 北东地(ned) -> 自建坐标系(new)这样的一个流程,原点需要自选
%
    
    addpath('F:/workSpace/matlabWork/seaBathymetry/imagProcess/ortho/ProcessFromVideo/CoreFunctions/');

    if nargin < 4 
        savePath = './'; 
    end

    
    objectPoints = gcpllh2NED(o_llh,gcp_llh); % gcp->enu 这个函数在之前的文件夹
    objectPoints = objectPoints';

    yaw = euler_ned2new(1);
    pitch = euler_ned2new(2);
    roll = euler_ned2new(3);
    
    Rotate_ned2new = Euler2Rotate(yaw,pitch,roll); 
    Rotate_ned2new = Rotate_ned2new'; %获取ned->new的旋转矩阵
    
    gcpInfo_world = Rotate_ned2new*objectPoints';
    gcpInfo_world = gcpInfo_world';
    
    
    
    if isempty(savePath) ~= 1
        saveName = 'gcpInfo';
        save([savePath saveName '_world'],'gcpInfo_world');
    end
    
        
end