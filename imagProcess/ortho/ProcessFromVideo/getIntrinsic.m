load('F:\workSpace\matlabWork\seaBathymetry\imagProcess\ortho\1920_1080_cameraIntrinsic.mat');

intrinsics = [];
intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.ImageSize(2));
intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.ImageSize(1));

intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.PrincipalPoint);
intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.FocalLength);


intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.RadialDistortion);
intrinsics = cat(2,intrinsics,calibrationSession.CameraParameters.TangentialDistortion);
intrinsics = cat(2,intrinsics,0);

save('./','intrinsic');