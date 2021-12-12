%Create Synthetic data for julia to run experiments on 4.5D curve
clc4
clear;
run('/home/hongyi/Documents/vlfeat-0.9.21/toolbox/vl_setup.m')
addpath('../');
addpath(genpath('/home/hongyi/Documents/Matlab_Utility/'));
addpath(genpath('/home/hongyi/Documents/Multiview/depthBasedPoseEst/'));
addpath(genpath('/home/hongyi/Documents/Multiview/Utility/'));

perturbationNumber = 10;
expNum = 200
counter = 1;
FailureChecker = zeros(1,expNum);
for g = 1:expNum
    g
%Generate Points
numPts = 300;
[rMat,T, K, EGT,DPointsOnImage, p1ImageOnImage, p2ImageOnImage] = generateRandomCameraAndPoints(numPts, 0, 0, 10);
%Extract 7 Points
expPoints = 5;
P1 = p1ImageOnImage(:,1:expPoints);
P2 = p2ImageOnImage(:,1:expPoints);
K1 = K';
K2 = K';
% str = generateDataFor65Dcurve(P1,P2)
pgt(:,:,1) = (inv(K1') * P1)';
pgt(:,:,2) = (inv(K2') * P2)';
% plot(P2(1,1:6),P2(2,1:6),'g.','MarkerSize',30); hold on
% plot(P2(1,7),P2(2,7),'r.','MarkerSize',30); hold on
% xlim([0,640])
% ylim([0,480])
Es = fivePointAlgorithmSelf(pgt);
[str_gt,str2_gt] = generateDataFor45Dcurve(P1,P2,K);
% curve = loadCurves();
% plot(curve(1,:),curve(2,:),'r.'); hold on

%%
checker = zeros(1,perturbationNumber);
%Add Different perturbations
for i = 1:perturbationNumber
    unstableFlag = 0;
    %Define Noise 
    N1 = normrnd(0.0,0.5,[2,5]);
    N2 = normrnd(0.0,0.5,[2,5]);
    %Create Perturbed Points
    P1b = P1 + [N1;zeros(1,5)];
    P2b = P2 + [N2;zeros(1,5)];
    
    %Compute 7-point algorithm
    vv(:,:,1) = (inv(K) * P1b)';
    vv(:,:,2) = (inv(K) * P2b)';
    Es_est = fivePointAlgorithmSelf(vv);
    if length(Es_est) < length(Es)
        unstableFlag = 1;
    end
    
    
    measure2 = zeros(length(Es),length(Es_est));
    for j = 1:length(Es)
        for k = 1:length(Es_est)
            measure2(j,k) = mean(mean((Es{j} ./ norm(Es{j})) ./ (Es_est{k} ./ norm(Es{j}))));
        end
    end
    
    error = abs(measure2) - ones(size(measure2));
    [A,B] = min(abs(error));
    if sum(A > 0.5) > 0 
        unstableFlag = 1;
    end
    
    if size(unique(B),2) ~= size(B,2)
        unstableFlat = 1;
    end
    checker(i) = unstableFlag;
    
      [str_est,str2_est] = generateDataFor45Dcurve(P1b,P2b,K);
%     curve = loadCurves();

end
    if sum(checker) > 0
        FailureChecker(g) = 1;
    end
    
    fid = fopen(strcat("./cases_E_0_1/",num2str(g),".txt"),'w');
    fprintf(fid,'%s\n',str_gt);
    fprintf(fid,'%s\n',str2_gt);
    fprintf(fid,'%s\n',str_est);
    fprintf(fid,'%s\n',str2_est);
    fprintf(fid,'%d',sum(checker));
    fclose(fid)
    counter = counter + 1;
end

