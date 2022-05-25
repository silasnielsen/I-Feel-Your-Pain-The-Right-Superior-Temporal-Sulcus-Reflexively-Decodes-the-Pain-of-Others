%% empathyParams - this function extracts important parameters for plotting
%% and summary statistics

clean
matFile=matloader(pwd);%function that loads whatever .mat file you select, takes as input
load(matFile);%the key file to load to access the linear fits with the outliers removed is 
 %*helle_inscan_behaviouraldatafitting_params_fig12_18-Sep-2013* however it
 %is backwardly compatible with other files, though be sure to change the
 %polyord factor. if in doubt the older version 2 will still work for that
 %data.
 
%constants
subjIndices{2}.group{1} = [6,11,12,15,16,17,18,19,20,21,22,23,24,26,28,32,34,36,37,40,42,44,45,48,49,53];% Helle_InScan - these are made up values. helle to change
subjIndices{2}.group{2} = [3,5,7,8,9,10,13,14,25,27,29,30,31,33,35,38,39,41,43,46,47,50,51,52];
fig=20;%12 is the figure which computes the latest linear fit for all subjects
group1=2;%index for group1
group2=3;%index for group2

polyord=1;%1for linear fit, 2 for non-linear

switch polyord
    
    case  1
        %params group1
        Curve1=zeros(1,length(subjIndices{2}.group{1}))';
        sensitivity1=squeeze(polymod_params(fig,group1,subjIndices{2}.group{1},1));
        constants1=squeeze(polymod_params(fig,group1,subjIndices{2}.group{1},2));
        %params group2
        Curve2=zeros(1,length(subjIndices{2}.group{2}))';
        sensitivity2=squeeze(polymod_params(fig,group2,subjIndices{2}.group{2},1));
        constants2=squeeze(polymod_params(fig,group2,subjIndices{2}.group{2},2));
 
    case  2
        %params group1
        Curve1=squeeze(polymod_params(fig,group1,subjIndices{2}.group{1},1));
        sensitivity1=squeeze(polymod_params(fig,group1,subjIndices{2}.group{1},2));
        constants1=squeeze(polymod_params(fig,group1,subjIndices{2}.group{1},3));

        %params group2
        Curve2=squeeze(polymod_params(fig,group2,subjIndices{2}.group{2},1));
        sensitivity2=squeeze(polymod_params(fig,group2,subjIndices{2}.group{2},2));
        constants2=squeeze(polymod_params(fig,group2,subjIndices{2}.group{2},3));      
end

precision1=[meanAbsStd{fig,group1,subjIndices{2}.group{1}}]';
cv1=[cv{fig,group1,subjIndices{2}.group{1}}]';

precision2=[meanAbsStd{fig,group2,subjIndices{2}.group{2}}]';
cv2=[cv{fig,group2,subjIndices{2}.group{2}}]';

%accuracy group1
comp=[sensitivity1';ones(1,length(sensitivity1))];
[min_sensitivity1,argmax]=min(comp);
[max_sensitivity1,argmax]=max(comp);
accuracy1=min_sensitivity1./max_sensitivity1;

%accuracy group2
comp=[sensitivity2';ones(1,length(sensitivity2))];
[min_sensitivity2,argmax]=min(comp);
[max_sensitivity2,argmax]=max(comp);
accuracy2=min_sensitivity2./max_sensitivity2;

%Concatenate params for group1 and group2
Curve=[Curve1;Curve2];
sensitivity=[sensitivity1;sensitivity2];
accuracy=[accuracy1';accuracy2'];
constants=[constants1;constants2];
precision=[precision1;precision2];
cvs=[cv1;cv2];

%statistics for group 1
stdCurve1=std(Curve1);
meanCurve1=mean(Curve1);
CVCurve1=(stdCurve1/meanCurve1);

stdsensitivity1=std(sensitivity1);
meansensitivity1=mean(sensitivity1);
CVsensitivity1=(stdsensitivity1/meansensitivity1);

stdaccuracy1=std(accuracy1);
meanaccuracy1=mean(accuracy1);
CVaccuracy1=(stdaccuracy1/meanaccuracy1);

stdconstants1=std(constants1);
meanconstants1=mean(constants1);
CVconstants1=(stdconstants1/meanconstants1);

stdprecision1=std(precision1);
meanprecision1=mean(precision1);

%statistics for group 2
stdCurve2=std(Curve2);
meanCurve2=mean(Curve2);
CVCurve2=(stdCurve2/meanCurve2);

stdsensitivity2=std(sensitivity2);
meansensitivity2=mean(sensitivity2);
CVsensitivity2=(stdsensitivity2/meansensitivity2);

stdaccuracy2=std(accuracy2);
meanaccuracy2=mean(accuracy2);
CVaccuracy2=(stdaccuracy2/meanaccuracy2);

stdconstants2=std(constants2);
meanconstants2=mean(constants2);
CVconstants2=(stdconstants2/meanconstants2);

stdprecision2=std(precision2);
meanprecision2=mean(precision2);

%statistics for both group 1 and 2
stdCurve=std(Curve);
meanCurve=mean(Curve);
CVCurve=(stdCurve/meanCurve);

stdsensitivity=std(sensitivity);
meansensitivity=mean(sensitivity);
CVsensitivity=(stdsensitivity/meansensitivity);

stdaccuracy=std(accuracy);
meanaccuracy=mean(accuracy);
CVaccuracy=(stdaccuracy/meanaccuracy);

stdconstants=std(constants);
meanconstants=mean(constants);
CVconstants=(stdconstants/meanconstants);

stdprecision=std(precision);
meanprecision=mean(precision);

%cross correlations between parameters
allparams_corrmatrix=corr([Curve,sensitivity,accuracy,constants,1./precision]);

%plot concatenated
figure
hold on
nplots=4;
subplot(1,nplots,1);
hist(sensitivity)
ylabel('Frequency')
xlabel('Sensitivity')

subplot(1,nplots,2);
hist(1-accuracy);
xlabel('Bias')

subplot(1,nplots,3);
hist(precision);
xlabel('Precision(meanAbsStd)')

subplot(1,nplots,4);
hist(cvs);
xlabel('Coefficient of Variance')



%plot group1 top row, group2 bottom row
figure
hold on

subplot(2,nplots,1);
hist(Curve1);
ylabel('Frequency Group1');
xlabel('Curvature');
subplot(2,nplots,2);
hist(sensitivity1);
xlim([0 3]);
xlabel('Sensitivity');
subplot(2,nplots,3);
hist(accuracy1);
xlim([0 1]);
xlabel('Accuracy');
subplot(2,nplots,4);
xlim([-10 +20]);
hold on
hist(constants1);
xlabel('Constants');
subplot(2,nplots,5);
hist(precision1);
hold on
xlim([0 40])
xlabel('Precision(meanAbsStd)')
subplot(2,nplots,6);
hist(cv1);
hold on
xlim([0 1.5])
xlabel('CV');

subplot(2,nplots,7);
hist(Curve2);
ylabel('Frequency Group2')
xlabel('Curvature')
subplot(2,nplots,8);
hist(sensitivity2);
xlim([0 3]);
xlabel('Sensitivity')
subplot(2,nplots,9);
hist(accuracy2);
xlim([0 1]);
xlabel('Accuracy')
subplot(2,nplots,10);
hist(constants2);
xlim([-10 +20]);
hold on
xlabel('Constants')
subplot(2,nplots,11);
hist(precision2);
hold on
xlim([0 40])
xlabel('Precision(meanAbsStd)');
subplot(2,nplots,12);
hist(cv2);
hold on
xlim([0 1.5])
xlabel('CV');
