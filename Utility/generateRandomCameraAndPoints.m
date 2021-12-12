function [rMat,T, K, EGT,DPointsOnImage, p1ImageOnImage, p2ImageOnImage] = generateRandomCameraAndPoints(numPoints, option, planar, Tlength)
% option == 0: Free Run Mode
% option == 1: Pure Rotation case
% option == 2: Pure Translation case
% option == 3: Planar Pure Translation Case
%
% planar == 0: Not planar points;
% planar == 1: Generate planar points;
% planar == 2: Generate co-linear points;
flag = 0;
while (flag == 0)

if option == 0
    Temp = normrnd(0,1,[3,3]);
    [rMat,Q] = qr(Temp);    
    tP = (rand([1,2]) - 0.5) * 360; %[32,13];
    tP = deg2rad(tP);
    T = [cos(tP(1)) * cos(tP(2)); cos(tP(1)) * sin(tP(2)); sin(tP(1))];%For predefined translation and rotation
    T = Tlength * T;
else if option == 1
    T = [0;0;0];
    Temp = normrnd(0,1,[3,3]);
    [rMat,Q] = qr(Temp);  
    else if option == 2
            rMat = eye(3);
            tP = (rand([1,2]) - 0.5) * 360; %[32,13];
            tP = deg2rad(tP);
            T = [cos(tP(1)) * cos(tP(2)); cos(tP(1)) * sin(tP(2)); sin(tP(1))];%For predefined translation and rotation
        else if option == 3
                rMat = eye(3);
                tP = [rand(); rand(); 0];
                T = tP ./ norm(tP);
            end
        end
    end
end
%rMat = eul2rotmatrix(eulRot,'ZYX');
% intrinsic matrix K is pre-defined & Also the image size is pre-defined.
% K =   [718.8560         0  607.1928;
%          0  718.8560  185.2157;
%          0         0    1.0000;];
K = [525.0 0 319.5;
     0 525.0 239.5;
     0 0 1];
imSize = [640, 480];

% Build Essential Matrix tx * R
tx = [0 -T(3) T(2);
      T(3)  0 -T(1);
      -T(2) T(1) 0];
  
EGT = tx * rMat;

%%Generate 3D Points 
if planar == 0
    DX = (rand(1,100000) - 0.5) * 50;
    DY = (rand(1,100000) - 0.5) * 50;
    DZ = rand(1,100000) * 50;
    DPoints = [DX; 
               DY; 
               DZ];
else if planar == 1
    %Generate a plane
    plane = rand(1,4) - 0.5;
    plane = plane ./ norm(plane);
    DX = (rand(1,20000) - 0.5) * 20;
    DZ = rand(1,20000) * 10;
    DY = (plane(1) .* DX + plane(3) .* DZ + plane(4))...
         ./ plane(2);    
     DPoints = [DX; 
               DY; 
               DZ];
    else if planar == 2
            %Generate Point on a 3D line
            vv = (rand([1,2]) - 0.5) * 360; %[32,13];
            vv = deg2rad(vv);
            tt = [cos(vv(1)) * cos(vv(2));...
                 cos(vv(1)) * sin(vv(2));...
                 sin(vv(1))];
             DX0 = (rand() - 0.5) * 20;
             DY0 = (rand() - 0.5) * 20;
             DZ0 = rand() * 10;
             distance = (rand(1,100000) - 0.5) .* 10;
             model = distance .* tt;
             DX = DX0 + model(1,:);
             DY = DY0 + model(2,:);
             DZ = DZ0 + model(3,:);
             DPoints = [DX; 
               DY; 
               DZ];
        end
    end
end
       
%%Projected on images
for i = 1:size(DPoints,2)
    p1(:,i) = DPoints(:,i) ./ DPoints(3,i);
    p1Image(:,i) = K * p1(:,i);
    rho(i) = DPoints(3,i);
end

for i = 1:size(DPoints,2)
    P3D2(:,i) = rMat * (DPoints(:,i)) + T;
    p2(:,i) = P3D2(:,i) ./ P3D2(3,i);
    p2Image(:,i) = K * p2(:,i);
    rho_bar(i) = P3D2(3,i);
end



index1X = p1Image(1,:) < imSize(1) & p1Image(1,:) > 1;
index1Y = p1Image(2,:) < imSize(2) & p1Image(2,:) > 1;
index2X = p2Image(1,:) < imSize(1) & p2Image(1,:) > 1;
index2Y = p2Image(2,:) < imSize(2) & p2Image(2,:) > 1;
index3 = P3D2(3,:) > 0;

pointIndex = index1X & index1Y & index2X & index2Y & index3;

DPointsOnImage = DPoints(:,pointIndex);
p1ImageOnImage = p1Image(:,pointIndex);
p2ImageOnImage = p2Image(:,pointIndex);
p1OnImage = p1(:,pointIndex);
p2OnImage = p2(:,pointIndex);
rho = rho(:,pointIndex);
rho_bar = rho_bar(:,pointIndex);
if size(DPointsOnImage,2) > numPoints
        flag = 1;
        DPointsOnImage = DPointsOnImage(:,1:numPoints);
        p1ImageOnImage = p1ImageOnImage(:,1:numPoints);
        p2ImageOnImage = p2ImageOnImage(:,1:numPoints);
end
end


end