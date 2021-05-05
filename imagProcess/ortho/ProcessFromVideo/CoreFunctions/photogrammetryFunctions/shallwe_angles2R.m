%该函数用于计算旋转矩阵Rec = Ref*Rfc
%Rec为现实坐标系到相机坐标的旋转矩阵
%Ref为现实坐标到机体坐标的旋转矩阵
%Rfc为机体坐标到相机坐标的旋转矩阵

%利用ZYX旋转，yaw,pitch,roll(x,y,z)
function [R] = shallwe_angles2R(roll,pitch,yaw)

    
    R(1,1) = cos(pitch)*cos(yaw);
    R(1,2) = cos(pitch)*sin(yaw);
    R(1,3) = -sin(pitch);
    R(2,1) = sin(roll)*sin(pitch)*cos(yaw)-cos(roll)*sin(yaw);
    R(2,2) = sin(roll)*sin(pitch)*sin(yaw)+cos(roll)*cos(yaw);
    R(2,3) = sin(roll)*cos(pitch);
    R(3,1) = cos(roll)*cos(yaw)*sin(pitch)+sin(roll)*sin(yaw);
    R(3,2) = cos(roll)*sin(pitch)*sin(yaw)-sin(roll)*cos(yaw);
    R(3,3) = cos(roll)*cos(pitch);
    
end

