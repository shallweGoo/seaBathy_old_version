%该程序为经纬度转北东地
addpath('./coordination transformation')



%坐标原点的经纬度
org_llh = [23.154491666666665 , 113.3430861111111 , -10.452];

%飞机在空中的快照提取的经纬度
air_llh = [23.154308333333333 113.343075 32.08];

% %5个gcp的经纬度信息
% GCP_llh = [[23.154666666666667 113.34315555555555 -10.433];
%         [23.154597222222222 113.34314444444445 -10.441];
%         [23.154522222222223 113.3431 -10.306];
%         [23.154544444444443  113.34302222222222 -10.434];
%         [23.15450277777778 113.34293055555555 -10.946]
%     ];

% %得到GCP的enu实际坐标
% GCP_ENU = llh2enu(org_llh,GCP_llh);
% %转化为ned坐标
% GCP_NED = Enu2Ned(GCP_ENU');

GCP_llh = [23.156594444444444 , 113.34138055555556 , -4.6];
org_llh = [23.156591666666667 , 113.34132222222222 , -4.3];

GCP_llh_rtk =[23.156573,113.341362,36.19];
org_llh_rtk = [23.156570,113.341305,36.14];


gcp_ned =  gcpllh2NED(org_llh, GCP_llh)
gcp_ned_rtk = gcpllh2NED(org_llh_rtk,GCP_llh_rtk)


