%Create Synthetic data for julia to run experiments on 6.5D curve
clc;
clear;
run('/home/hongyi/Documents/vlfeat-0.9.21/toolbox/vl_setup.m')
addpath('../');
addpath(genpath('/home/hongyi/Documents/Matlab_Utility/'));
addpath(genpath('/home/hongyi/Documents/Multiview/depthBasedPoseEst/'));
addpath(genpath('/home/hongyi/Documents/Multiview/Utility/'));

perturbationNumber = 10;
expNum = 2000

FailureChecker = zeros(1,expNum);
counter = 0;
for g = 1:expNum
    g
%Generate Points
numPts = 300;
[rMat,T, K, EGT,DPointsOnImage, p1ImageOnImage, p2ImageOnImage] = generateRandomCameraAndPoints(numPts, 0, 0, 10);
%Extract 7 Points
expPoints = 7;
P1 = p1ImageOnImage(:,1:expPoints);
P2 = p2ImageOnImage(:,1:expPoints);
% str = generateDataFor65Dcurve(P1,P2)
pgt(:,:,1) = P1';
pgt(:,:,2) = P2';

[Fs, discr_gt] = sevenPointAlgorithmSelf(pgt);

% [Fs, discr_gt] = sevenPointAlgorithmSelf(pgt);
% [str_gt, str2_gt] = generateDataFor65Dcurve(P1,P2);
% curve = loadCurves();
% % 
% 
% figure;
% plot(P2(1,1:6),P2(2,1:6),'g.','MarkerSize',30); hold on
% plot(P2(1,7),P2(2,7),'r.','MarkerSize',30); hold on
% xlim([0,640])
% ylim([0,480])
% contour(y_1,y_2,Func,[-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6],'ShowText','on'); hold on
% %plot(curve(1,:),curve(2,:),'r.'); hold on
% set(findall(gcf,'-property','FontSize'),'FontSize',25)
%%
checker = zeros(1,perturbationNumber);

%Add Different perturbations
for i = 1:perturbationNumber
    unstableFlag = 0;
    %Define Noise 
    N1 = normrnd(0.0,0.1,[2,7]);
    N2 = normrnd(0.0,0.1,[2,7]);
    %Create Perturbed Points
    P1b = P1 + [N1;zeros(1,7)];
    P2b = P2 + [N2;zeros(1,7)];
    
    %Compute 7-point algorithm
    vv(:,:,1) = P1b';
    vv(:,:,2) = P2b';
    [Fs_est, discr] = sevenPointAlgorithmSelf(vv);
    if length(Fs_est) ~= length(Fs)
        unstableFlag = 1;
    end
    
    
    measure2 = zeros(length(Fs),length(Fs_est));
    for j = 1:length(Fs)
        for k = 1:length(Fs_est)
            measure2(j,k) = mean(mean((Fs{j} ./ norm(Fs{j})) ./ (Fs_est{k} ./ norm(Fs{j}))));
        end
    end
    
    error = abs(measure2) - ones(size(measure2));
    [A,B] = min(abs(error));
    if sum(A > 0.4) > 0 
        unstableFlag = 1;
    end
    
    if size(unique(B),2) ~= size(B,2)
        unstableFlat = 1;
    end
    checker(i) = unstableFlag;
    
     [str_est, str2_est]  = generateDataFor65Dcurve(P1b,P2b);
%     curve = loadCurves();

end
    if sum(checker) > 0
        FailureChecker(g) = 1;
    end
    
    fid = fopen(strcat("./F_matrix/",num2str(counter),".txt"),'w');
    fprintf(fid,'%s\n',str_gt);
    fprintf(fid,'%s\n',str2_gt);
    fprintf(fid,'%s\n',str_est);
    fprintf(fid,'%s\n',str2_est);
    fprintf(fid,'%d',sum(checker));
    fclose(fid)

end
    
