%% mainEmpathy.m data does preprocessing & plotting for empathy psychophysics
%
% it computes psychophysical functions for empathy experiment, including
% pain-current, empathy-current, empathy-pain and luminance-lightness
% functions, and generating output for the spm analysis (estimated
% empathy/estimated luminance)
%
% it culminates in the generation of a data matrix - data
% data is a 3d matrix, which can be thought of as a stack of 2d matrices
% (trials = rows, observers = cols) where the dimensions are:
%
% 1. empathy reported by observer (1-100% vas)
% 2. pain reported by target (1-100% vas)
% 3. lightness reported by observer (1-100% vas)
% 4. objective luminance (in native psychopy units)
% 5. objective current (ma)
%
% it is part of the empathy plotting toolbox

% authors: oliver hulme*, silas nielsen
% work address: drcmr, copenhagen
% email: ollie.hulme@gmail.com
% last revision: jan 2015 ollie
% formerly known as runEmpathy

%% notes
% insert spearmans for empathy plots
% runemp=corr((data((targlp),87:172,2)'),(data((targlp),87:172,1)'),'type','spearman'); %correlation btw target pain and participant empathy rating

%% clean
clean %clears workspace etc.

%% set modes
testMode=1;%input('if developing script (1), else (0)');%for shortcutting the mode selection
if testMode==1
    expMode=3;runMode=2;userMode=1;plotNums=[21]; %#ok<*NBRAK>
else
    expMode=input('what experiment? [1target_outscan, 2helle_inscan, 3ayna_inscan, 4pilot_outscan, 5dummy_inscan]');
    runMode=input('what to run? [compiles all data(1), plot data & compute parameters(2) compute bonus for subjects(3) compile subject parameters into 1 group (4) ]');
    userMode=input('which user? [1=ollie,2=helle,3=silas, 4=tina, 5=ayna]');
    if runMode==2
        plotNums=input('which figures to plot e.g [1,2]');%[5];%put the numbers of the figures in here you want to plot
    end
end
if  any(expMode==[2 3]); % sets targetmode for which target subject is relevant
    targetMode=1;else targetMode=[];
end;

%% miscellaneous constants
NaN=nan;
%outlierDef=exp(1.5);% %defining an outlier for empathy

%% figure constants

%% fonts
FontName = 'times'; %#ok<*snasgu>
FSsm = 7; % small font size
FSmed = 10; % medium font size
FSlg = 11; % % large font size

%% line & dot widths
LWthick = 3; % % thick lines
LWthin = 1.5; % % thin lines
LWthinnest=1;
DTthick = 4; % %thick dots
DTthin = 2; % %thin dots

%% colors
col1 = [1,0,0];%red
col2 = [3/4,0,1];%purple
col3 = [1,0,3/4];%pink
col4 = [1,3/4,0];%orange
col5 = [0,0,1];%blue
col6 = [0,1,3/4];%cyan
col7 = [0,3/4,1];%lighy blur
col8 = [3/4,1,0];%light green
col9 = [0,0,0];%black
multcols=[col1;col2;col3;col4;col5;col6;col7;col8;col9];

%% axis position
left = 0.10; % space on lhs of figure
right = 0.10; % space on rhs of figure
top = 0.10; % space above figure
bottom = 0.12;% space below figure
hspace = 0.10;% space between figures horizontally
vspace = hspace+0.02; %space between vertically

%% paper variables
PP = [0,0,21,29.7]; % here i set the paper position in centimeters
PS = PP(end-1:end); % paper size in centimeters

%% set directories
expDir={'Data_Pilot_Outscan';'Data_Helle_Inscan';'Data_Ayna_Inscan';'Data_Target_Outscan';...
    'Data_Dummy_Inscan';};% sets the directories for each experiment mode
userDir={'/Volumes/HDD';'/users/helllaursen';'/users/silas haahr nielsen';'users/ayna*********'};% sets the directoreies for each user
figDir={'Figures'};%sets the dir where the figures are stored

%% set film indices
filmIndices = [1,86,87,172;0 0 0 0];% rows for targets, columns indicate trial numbers for each film
filmInd{1} = filmIndices(targetMode,:);% choose film indices according to target subject
lengthFilm1 = filmInd{1}(2)-filmInd{1}(1);% calc length of film 1
lengthFilm2 = filmInd{1}(4)-filmInd{1}(3);% calc length of film 2
filmInd{2} = [1,lengthFilm2+1,lengthFilm2+2,(lengthFilm2+2)+lengthFilm1];% film indices for switched order of films
filmIndSess = [filmIndices(1,1):filmIndices(1,2);filmIndices(1,3):filmIndices(1,4)];

%% set subject indices
% put in here the order of which subjects to analyse, where number
% corresponds to their place in the data matrix. they are partitioned
% according to group1 or group2 (for 5ht or tbi vs control)
subjIndices{1}.group{1}= 1:4;% pilot_outscan data - nan

subjIndices{2}.group{1} = [6,11,12,15,16,17,18,19,20,21,22,23,24,26,28,32,34,36,37,40,42,44,45,48,49,53];% helle_inscan - these are made up values. helle to change
subjIndices{2}.group{2} = [3,5,7,8,9,10,13,14,25,27,29,30,31,33,35,38,39,41,43,46,47,50,51,52];
%53 not scanned yet but will belong to group1, 1,2,4 have wrong genotype

subjIndices{3}.group{1} = [1,2,4,3,5,7,8,9,10,13,14,25,27,29,30,31,33,35,38,39,41,43,46,47,50,51,52,6,11,12,15,16,17,18,19,20,21,22,23,24,26,28,32,34,36,37,40,42,44,45,48,49,53];% helle_inscan - these are made up values. helle to change
% subjects 1 2 and 4, were heterozygotes?, 3,5... upto 52, were group 1,
% and 6,11,12... upto 53 were in group2

subjIndices{4}.group{1} = 1:5; % target_outscan

%% set variable limits for axes (and for logs)
currLimTarget=[0,25];% sets the range of values on the axes etc.
painLimTarget=[0,70]; % maximum pain not above 70 on vas
lcurrLimTarget=[0,0.8];
lpainLimTarget=[0,3];
currLimObs=[0,35];
painLimObs=[0,55];
lcurrLimObs=[0,0.8];
lpainLimObs=[0,3];
lumLim=[1,100];
lgtLim=[1,100];
lcurrLim=[2,4];

%% change to dropbox
dropboxDir=strcat(userDir{userMode},'/Dropbox/Empathy/Code_Matlab/');%change this according to your own path to this folder
%dropboxDir=('/Users/susannehenningsson/Dropbox/Helle, Ollie, Tina/Emp_plot/')
%cd ('/Users/susannehenningsson/Dropbox/Helle, Ollie, Tina/Emp_plot/')
%cd(dropboxDir);

%% run preprocessing / plotting / other computations
switch runMode
    
    case 1 % preprocessing Target subject data into the data matrix allTargets.mat
        % note: this is the same matrix for all users
        
        disp('preprocessing running');
        dirname=strcat(dropboxDir,expDir{4});%set up directory name for target data
        AllTargets = compileTargetDataMatrix(dirname); %compiles matfiles into data matrix for targets
        cd(dropboxDir)%saves data matrix in root directory
        save('AllTargets','AllTargets');%
        
        % preprocessing all data into data matrix and visualises them
        
        %compile observer data matrix
        dirName=strcat(dropboxDir,expDir{expMode});
        Data=compileObserverDataMatrix(dirName,targetMode,filmInd); %compiles the data matrix for observers
        disp('finished compiling observers data matrix')
        
        % visualise it for diagnostics
        nSubj2Vis=4;
        expName=expDir{expMode};
        outputDir=strcat(dropboxDir,figDir{1});%directory to save image into
        visualiseDataMatrix(nSubj2Vis,Data,outputDir,expName)
        
        % generate master data matrix to be partitioned according to
        % subject group. for the group dimension:
        %   data{1} = target subjects
        %   data{2} = group1
        %   data{3} = group2 (for some exp modes e.g. pilot there is only group1
        dataTemp{1}=AllTargets;
        dataTemp{2}=Data(subjIndices{expMode}.group{1},:,:);%set data for group1
        try
            dataTemp{3}=data(subjIndices{expMode}.group{2},:,:);%set data for group2
        catch
            disp('there is no group 2');
        end
        clear('Data')
        Data=dataTemp;%now Data is 4d, where 4th dim is subject group
        cd(dropboxDir)%saves Data matrix in root directory
        save (strcat(expDir{expMode},'_DataMatrix_',date),'Data');
        
    case 2 % plot Data, fit Data, and estimate unobserved Data
        
        %% load Data matrices and compute sizes
        disp('plotting Data and fitting Data');
        if testMode==0
            matFile=loadMatFiles(pwd);%function that loads whatever .mat file you select, takes as input
        else
            matFile='Data_Ayna_Inscan_DataMatrix_06-Feb-2015.mat';
        end
        load(matFile)
        
        %% set plot variables
        setPlotAppearance;%sets up basic appearance variables for plotting, fonts etc.
        
        %% setup registers - these define key variables for each figures
        % this is the key information that determines what figures are plotted. ideally
        % this should be used as a history of past plots, so that new plots are
        % just added to the end. this provides a means of regenerating old
        % plots, and keeping track of past analyses
        
        % these are the labels for the x-axis, different rows within this structure are for...
        % whether the plots are superimposed or not
        targetIndices=1:172;%which Data points to extract for target plots
        empIndices=filmIndSess(2,:);%which Data points to extract for empathy plots
        lghIndices=filmIndSess(1,:);%which Data points to extract for lightness plots
        
        nTarg=size(Data{1},1);%number of target subjects recieving pain
        nSubj1=size(Data{2},1);%number of observer subjects in group1
        try
            nSubj2=size(Data{3},1);%number of observer subjects in group2
        catch
            nSubj2=0;
        end
        
        %% figure notes
        
        %        2. group1 v group 2 emp v pain with mean super imposed
        %        3. curr v pain all targets with mean super imposed
        %        4. group1 v group 2 light v lum with mean super imposed
        %        repeat for log
        % specify figures
        % put all groups into same Data matrix.
        
        %% 1 targets: current v pain - linear
        n=1;%plot counter
        titLabels{n}='targets: current v pain - linear';%title of the plot, and filename for saving
        xLabels{n}='current (ma)';%x axis
        yLabels{n}='pain (%)';%ym axis
        nRows{n}=1;%number of rows to plot for this fig
        nCols{n}=1;%ditto columns
        nSubj{n}=4;%number of subjects to plot
        xIndices{n}=targetIndices;%indices for x Data
        yIndices{n}=xIndices{n};%indices for y Data
        xDim{n}=1;%dimension of relevant Data matrix x axis
        yDim{n}=2;%dimension of relevant Data matrix for y axis
        xLimits{n}=currLimTarget;%Limits for x-axis
        yLimits{n}=painLimTarget;%ditto for y
        superImp{n}=1;%superimpose all subjects onto 1 plot 1=yes 0=no
        colorSet{n}=lines(nSubj{n});%generates line colors - here a different color for each
        plotSubjects{n}.group{1}=subjIndices{1}.group{1};%subjIndices{4}.group{1};%which subjects to plot
        plotSubjects{n}.group{2}=[];%initialises an empty field for group2, used later for comparing groups
        plotGroups{n}=[1];%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=0;%0=linear, 1=take logs
        mieFactor{n}=1;%1= mie's Data in thick black
        polyOrd{n}=2;%how many polynomial orders to fit when plotting
        mieSuper{n}=0;%whether to superimpose mie (only makes sense for later observer plots
        fidFactor{n}=0;%whether to plot perfect empathy fiducial
        meanFactor{n}=0;%whether to plot mean function
        saveParams{n}=0;%whether to save parameters of Data fitting for this figure
        estimatePrecision{n}=0;
        outlierRemove{n}=0;%whether to remove outliers or not
        outThresh{n}=[];%the threshold for outliers if removing them
        logfitFactor{n}=[0];% 1 means to run the logfit programme
        logfitGraphtype{n}=[];%which type of fitting to plot
        threshRemove{n}=[];
        groupMean{n}=1;%whether to mean by groups 1=separate means for each, 0=overall mean
        subtractConstant{n}=0;
        omitScatter{n}=0;%whether to skip supperimposing scatter cloud
        
        %% 2 targets: current v pain - log
        n=n+1;%moves onto next figure without having to specify exact figure number
        titLabels{n}='targets: current v pain - log';
        xLabels{n}='log current (ma)';
        yLabels{n}='log pain (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=4;
        xIndices{n}=targetIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=1;
        yDim{n}=2;
        xLimits{n}=lcurrLimTarget;
        yLimits{n}=lpainLimTarget;
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=[1:4];%subjIndices{4}.group{1};
        plotGroups{n}=1;%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=1;%0=linear, 1=take logs
        mieFactor{n}=1;%1=superimpose mie's Data
        polyOrd{n}=2;%how many polynomial orders to fit when plotting
        fidFactor{n}=0;
        mieSuper{n}=0;%whether to superimpose mie (only makes sense for later observer plots
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        logfitFactor{n}=0;
        
        %% 3 observers: current v pain - linear';
        n=n+1;%moves onto next figure without having to specify exact figure number
        titLabels{n}='observers: current v pain - linear';
        xLabels{n}='current (ma)';
        yLabels{n}='pain (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=4;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=5;
        yDim{n}=1;
        xLimits{n}=currLimObs;%Limits for x-axis
        yLimits{n}=painLimObs;%ditto for y
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n}+1);
        colorSet{n}=colorSet{n}(2:end,:);
        plotSubjects{n}.group{1}=subjIndices{2}.group{1}(5:5+(nSubj{n}-1));%subjIndices{4}.group{1};
        plotGroups{n}=2;%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=0;%0=linear, 1=take logs
        mieFactor{n}=1;%1=superimpose mie's Data
        polyOrd{n}=2;%how many polynomial orders to fit when plotting
        mieSuper{n}=1;
        fidFactor{n}=0;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        logfitFactor{n}=0;
        
        %% 4 observers: current v pain - log';
        n=n+1;%moves onto next figure without having to specify exact figure number
        titLabels{n}='observers: current v pain - log';
        xLabels{n}='log current (ma)';
        yLabels{n}='log pain (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=4;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=5;
        yDim{n}=1;
        xLimits{n}=lcurrLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n}+1);
        colorSet{n}=colorSet{n}(2:end,:);
        plotSubjects{n}.group{1}=subjIndices{2}.group{1}(5:5+(nSubj{n}-1));%subjIndices{4}.group{1};
        plotGroups{n}=2;%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=1;%0=linear, 1=take logs
        mieFactor{n}=1;%1=superimpose mie's Data
        polyOrd{n}=2;%how many polynomial orders to fit when plotting
        mieSuper{n}=1;
        fidFactor{n}=0;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        logfitFactor{n}=0;
        
        %% 5 all observers: 5ht pain v empathy - linear
        n=n+1;
        titLabels{n}='all observers: 5ht pain v empathy - linear';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=lpainLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=1;%whether to estimate precision and save
        logfitFactor{n}=0;
        
        %% 6 all observers: 5ht pain v empathy - log
        n=n+1;
        titLabels{n}='all observers: 5ht pain v empathy - log';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=[1.5,4];
        yLimits{n}=lpainLimObs;
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=1;%0=linear, 1=take logs
        polyOrd{n}=1;
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=1;
        logfitFactor{n}=0;
        
        %% 7 group wise observers: 5ht pain v empathy - linear
        n=n+1;
        titLabels{n}='group1 & group2: 5ht pain v empathy - linear';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=1;
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=[repmat(col1,nSubj1,1);repmat(col2,nSubj2,1)];
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=0;
        logfitFactor{n}=0;
        
        %% 8 group wise observers: 5ht pain v empathy - log
        n=n+1;
        titLabels{n}='group1 & group2: 5ht pain v emp - log';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=1;
        nCols{n}=1;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=lcurrLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=1;
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=[repmat(col1,nSubj1,1);repmat(col2,nSubj2,1)];
        plotGroups{n}=[2 3];
        logFactor{n}=1;%0=linear, 1=take logs
        polyOrd{n}=2;
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=0;
        logfitFactor{n}=0;
        
        %% 9 all observers: 5ht pain v empathy - log-linear - individuals
        % (with error visualisation)
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - log';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=lpainLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=1;%0=linear, 1=take logs
        polyOrd{n}=1;%log linear fits only
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=1;
        logfitFactor{n}=0;
        
        %% 10 all observers: 5ht pain v empathy - log-linear - individuals
        % (with error visualisation)
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - linear';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=1;%log linear fits only
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        estimatePrecision{n}=1;
        logfitFactor{n}=0;
        
        %% 11 all observers: 5ht pain v emp - log - ind no-outliers CHANGED
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - log';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=lpainLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=1;%0=linear, 1=take logs
        polyOrd{n}=1;%log linear fits only
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=1;
        outlierRemove{n}=0;
        outThresh{n}=1.7;
        logfitFactor{n}=0;
        
        %% 12 all observers: 5ht pain v emp - lin - ind no-outliers, NO NOW ALSO so-called outliers
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - linear';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=1;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=1;
        outlierRemove{n}=0;
        outThresh{n}=exp(1.7); %What does this do?
        logfitFactor{n}=0;
        
        %% 13 all observers: 5ht pain v emp - lin - ind no-outliers NO NOW ALSO so-called outliers
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - lin 2ndorder';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=1;
        outlierRemove{n}=0;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=0;
        
        %% 14 all observers: 5ht pain v emp - logfit linear
        %this performs logfit function to find the best fit - from linear, exponential,
        %log and powerlaw
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - logfit function - linear fit';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=1;
        outlierRemove{n}=0;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=1;
        logfitGraphtype{n}='linear';%fit a linear function
        
        %% 15 all observers: 5ht pain v emp - logfit logarithmic
        %this performs logfit function to find the best fit - from linear, exponential,
        %log and powerlaw
        n=n+1;
        titLabels{n}='all obs: 5ht pain v emp - logfit function - logarithmic fit';
        xLabels{n}='log pain (%)';
        yLabels{n}='log empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{2}.group{1};
        plotSubjects{n}.group{2}=subjIndices{2}.group{2};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2 3];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=1;
        outlierRemove{n}=0;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=1;
        logfitGraphtype{n}='logx';%fit a logarithmic function
        
        %% 16 targets: current v pain - linear truncated threshremove axes
        n=n+1;%plot counter
        titLabels{n}='targets: current v pain - linear truncated threshremove';%title of the plot, and filename for saving
        xLabels{n}='current (mA)';%x axis
        yLabels{n}='pain (%)';%ym axis
        nRows{n}=4;%number of rows to plot for this fig
        nCols{n}=2;%ditto columns
        nSubj{n}=4;%number of subjects to plot
        xIndices{n}=targetIndices;%indices for x Data
        yIndices{n}=xIndices{n};%indices for y Data
        xDim{n}=1;%dimension of relevant Data matrix x axis
        yDim{n}=2;%dimension of relevant Data matrix for y axis
        xLimits{n}=currLimTarget;%Limits for x-axis
        yLimits{n}=painLimTarget;%ditto for y
        superImp{n}=1;%superimpose all subjects onto 1 plot 1=yes 0=no
        colorSet{n}=lines(nSubj{n});%generates line colors - here a different color for each
        plotSubjects{n}.group{1}=subjIndices{1}.group{1};%subjIndices{4}.group{1};%which subjects to plot
        plotSubjects{n}.group{2}=[];%initialises an empty field for group2, used later for comparing groups
        plotGroups{n}=[1];%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=0;%0=linear, 1=take logs
        mieFactor{n}=0;%1= mie's Data in thick black
        polyOrd{n}=2;%how many polynomial orders to fit when plotting
        mieSuper{n}=0;%whether to superimpose mie (only makes sense for later observer plots
        fidFactor{n}=0;%whether to plot perfect empathy fiducial
        meanFactor{n}=0;%whether to plot mean function
        saveParams{n}=0;%whether to save parameters of Data fitting for this figure
        estimatePrecision{n}=0;
        outlierRemove{n}=0;%whether to remove outliers or not
        outThresh{n}=[];%the threshold for outliers if removing them
        logfitFactor{n}=[0];% 1 means to run the logfit programme
        logfitGraphtype{n}=[];%which type of fitting to plot
        threshRemove{n}=1;
        
        %% 17 targets: current v pain - log
        n=n+1;%moves onto next figure without having to specify exact figure number
        titLabels{n}='targets: current v pain - log truncated threshremove';
        xLabels{n}='log current (mA)';
        yLabels{n}='log pain (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=4;
        xIndices{n}=targetIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=1;
        yDim{n}=2;
        xLimits{n}=lcurrLimTarget;
        yLimits{n}=lpainLimTarget;
        superImp{n}=1;
        colorSet{n}=multcols(1:4,:);%8 colours since 4 targets and 4 observers need unique colors
        plotSubjects{n}.group{1}=[1:4];%subjIndices{4}.group{1};
        plotGroups{n}=1;%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=1;%0=linear, 1=take logs
        mieFactor{n}=1;%1=superimpose mie's Data
        polyOrd{n}=1;%how many polynomial orders to fit when plotting
        fidFactor{n}=0;
        mieSuper{n}=0;%whether to superimpose mie (only makes sense for later observer plots
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        outlierRemove{n}=0;%whether to remove outliers or not
        outThresh{n}=[];
        logfitFactor{n}=0;
        threshRemove{n}=1;
        
        %% 18 observers: current v pain - log';
        n=n+1;%moves onto next figure without having to specify exact figure number
        titLabels{n}='observers: current v pain - log truncated threshremove';
        xLabels{n}='log current (mA)';
        yLabels{n}='log pain (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=4;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=5;
        yDim{n}=1;
        xLimits{n}=lcurrLimObs;
        yLimits{n}=lpainLimObs;
        superImp{n}=1;
        colorSet{n}=multcols(5:8,:);
        plotSubjects{n}.group{1}=subjIndices{2}.group{1}(5:5+(nSubj{n}-1));%subjIndices{4}.group{1};
        plotGroups{n}=2;%which groups to plot where 1=targets, 2=observers group1, 3=observers group2
        logFactor{n}=1;%0=linear, 1=take logs
        mieFactor{n}=1;%1=superimpose mie's Data
        polyOrd{n}=1;%how many polynomial orders to fit when plotting
        mieSuper{n}=1;
        fidFactor{n}=0;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        outlierRemove{n}=1;%whether to remove outliers or not
        outThresh{n}=1.7;
        logfitFactor{n}=0;
        threshRemove{n}=1;
        
        %% 19 4 observers: pain v emp - linear truncated
        %this performs logfit function to find the best fit - from linear, exponential,
        %log and powerlaw
        n=n+1;
        titLabels{n}='4 observers: pain v emp - linear truncated ';
        xLabels{n}='pain (%)';
        yLabels{n}='empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=4;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=1;
        colorSet{n}=multcols(5:8,:);
        plotSubjects{n}.group{1}=subjIndices{2}.group{1}(5:5+(nSubj{n}-1));%subjIndices{4}.group{1};
        plotGroups{n}=[2];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=1;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=0;%whether to plot mean function
        estimatePrecision{n}=0;
        outlierRemove{n}=1;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=0;
        logfitGraphtype{n}=[];%'logx';%fit a logarithmic function
        threshRemove{n}=1;
        subtractConstant{n}=1;
        
        %% 20 all observers: superimposed, pain v emp - linear
        n=n+1;
        titLabels{n}='all obs: pain v emp';
        xLabels{n}='Pain (%)';
        yLabels{n}='Empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=1;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{3}.group{1};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=1;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        groupMean{n}=0;%whether to mean by groups 1=separate means for each, 0=overall mean
        estimatePrecision{n}=1;
        outlierRemove{n}=1;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=0;
        logfitGraphtype{n}=[];%'linear';%fit a linear function
        threshRemove{n}=1;
        subtractConstant{n}=1;
        omitScatter{n}=1;
        
        %% 21 all observers: pain v emp - 2nd order polynomial
        n=n+1;
        titLabels{n}='all obs: pain v emp';
        xLabels{n}='Pain (%)';
        yLabels{n}='Empathy (%)';
        nRows{n}=4;
        nCols{n}=2;
        nSubj{n}=nSubj1+nSubj2;
        xIndices{n}=empIndices;
        yIndices{n}=xIndices{n};
        xDim{n}=2;
        yDim{n}=1;
        xLimits{n}=painLimObs;
        yLimits{n}=painLimObs;
        superImp{n}=0;
        colorSet{n}=lines(nSubj{n});
        plotSubjects{n}.group{1}=subjIndices{3}.group{1};
        colorSet{n}=repmat(col1,nSubj{n},1);
        plotGroups{n}=[2];
        logFactor{n}=0;%0=linear, 1=take logs
        polyOrd{n}=2;%
        mieSuper{n}=0;
        fidFactor{n}=1;
        meanFactor{n}=1;%whether to plot mean function
        groupMean{n}=0;%whether to mean by groups 1=separate means for each, 0=overall mean
        estimatePrecision{n}=0;
        outlierRemove{n}=1;
        outThresh{n}=exp(1.7);
        logfitFactor{n}=0;
        logfitGraphtype{n}=[];%'linear';%fit a linear function
        threshRemove{n}=0;
        subtractConstant{n}=0;
        omitScatter{n}=0;
        mieFactor{n}=0;
        
        %% assign Data fitting parameter matrix
        totFig=25;%aprox. upper Limit on number of figures
        totGroups=3;%total number of groups including targets, genetics group 1&2
        totSubj=53;%total number of subjects if analysing all as one group
        totOrders=3;%total number of params for fitting
        polymod_params=zeros(totFig,totGroups,totSubj,totOrders);%preassigns with zeros
        polymod_params_error=zeros(totFig,totGroups,totSubj,2);%the same but with 2 params since only need a linear fit of the errors
        
        %% figure loop - this loops around the different figure and generates the plots for each
        for figlp=plotNums %#ok<*PFUIX,PFRNG,FORFLG,*PFUNK,*forflg> %loops round whatever figure numbers are specified to plot
            
            disp(strcat('now plotting figure_',num2str(figlp)));
            groupct=0;%initialise group counter
            plotct=1;%initialises the plot counter for this figure
            figct=0;
            setPlotAppearance;%sets up some simple parameters for plotting this figure
            
            for grouplp=plotGroups{figlp}% group loop - how many groups to loop round for this figure
                
                subct=0;% reset subject counter
                groupct=groupct+1;
                
                for sublp=plotSubjects{figlp}.group{groupct}% subject loop
                    
                    subct=subct+1;%add to subject count
                    if sublp==plotSubjects{figlp}.group{groupct}(length(plotSubjects{figlp}.group{groupct}))
                        lastSubject=1; %calculate whether this is the last subject or not
                    else
                        lastSubject=0;
                    end
                    
                    % assign axis variables
                    if superImp{figlp}==0 %don't superimpose plots
                        
                        %start figure for first fig or if fig is full
                        if rem(subct,nplots)==1;%as soon as it spills over by 1 start new figure
                            h1=figure;
                            subplotct=1;%plot position within figure
                            set(h1,'paperpositionmode','manual','paperposition', ...
                                PP,'papersize',PS, 'paperunits','centimeters');
                            set(h1,'windowstyle','docked');
                            figct=figct+1;%plot counter for saving figures
                        else
                            subplotct=subplotct+1;%add to count to move onto new subplot for this figure
                        end
                        
                        pos=strcat('pos',num2str(subplotct));
                        ax1 = axes('position',eval(pos),'colororder', colorSet{figlp}); %#ok<pfbfn> % produce axis
                        title(strcat(titLabels{figlp},'subject#',num2str(sublp)),'FontName',FontName,'fontsize',FSmed)
                        
                        xlabel(xLabels{figlp},'FontName',FontName,'fontsize',FSmed) % add axis labels
                        ylabel(yLabels{figlp},'FontName',FontName,'fontsize',FSmed) % assign plot limits
                        set(ax1,'tickdir','out'); % alter the direction of the tick marks
                        set(ax1,'FontName',FontName,'fontsize',FSsm) % set the font name and size
                        set(ax1,'box','off') % turns the figure bounding box off
                        set(ax1,'layer','top') % stoPS problems with lines being plotted on top of the axis lines
                        set(ax1,'xlim',xLimits{figlp},'ylim',yLimits{figlp});
                        hold on
                        
                    else %superimpose plots
                        
                        %no overspill mechanisms since plots are superimposed
                        if subct==1 && groupct==1  % only plot if 1st subject and group
                            h1=figure;
                            set(h1,'paperpositionmode','manual','paperposition', ...
                                PP,'papersize',PS, 'paperunits','centimeters');
                            set(gcf,'windowstyle','docked');
                            pos=strcat('pos',num2str(1));
                            ax1 = axes('position',eval(pos),'colororder', colorSet{figlp}); %#ok<pfbfn> % produce axis
                            hold on
                            axis('fill')
                            xlabel(xLabels{figlp},'FontName',FontName,'fontsize',FSmed) % add axis labels
                            ylabel(yLabels{figlp},'FontName',FontName,'fontsize',FSmed)
                            % assign plot limits
                            set(ax1,'TickDir','out'); % alter the direction of the tick marks
                            set(ax1,'FontName',FontName,'fontsize',FSsm) % set the font name and size
                            set(ax1,'box','off') % turns the figure bounding box off
                            set(ax1,'layer','top') % stops problems with lines being plotted on top of the axis lines
                            set(ax1,'xlim',xLimits{figlp},'ylim',yLimits{figlp});
                            %title(strcat(titLabels{figlp}),'FontName',FontName,'FontSize',FSmed)
                        end
                    end
                    
                    % assign Data to x and y variables
                    Xvar=Data{grouplp}(subct,xIndices{figlp},xDim{figlp});%#ok<PFBNS> %extract Data for Xvariable
                    Yvar=Data{grouplp}(subct,yIndices{figlp},yDim{figlp});%extract Data for Yvariable
                    
                    %take logs according to loglp
                    if logFactor{figlp}==1
                        Xvar=log(Xvar);
                        Yvar=log(Yvar);
                    end
                    
                    if outlierRemove{figlp}==1
                        outXvar=Xvar(Yvar<=outThresh{figlp});%collect outliers into this variable
                        outYvar=Yvar(Yvar<=outThresh{figlp});%collect outliers into this variable
                        Xvar=Xvar(Yvar>outThresh{figlp});%remove outliers from x
                        Yvar=Yvar(Yvar>outThresh{figlp});%remove outliers from y
                    end
                    
                    if threshRemove{figlp}==1
                        Xvar=Xvar-min(Xvar);
                        if figlp==17 && sublp<2
                            Yvar=Yvar-1;%special case for target 2 who had some outlier low responses
                        else
                            Yvar=Yvar-min(Yvar);
                        end
                    end
                    
                    %generate Data-fit parameters - basic polynomial expansion fitting
                    if subtractConstant{figlp}==0
                        polymod_params(figlp,grouplp,sublp,1:(polyOrd{figlp}+1)) = polyfit(Xvar,Yvar,polyOrd{figlp});%polynomial coeffs in descending order 2nd, 1st, intercept
                    else
                        polymod_params(figlp,grouplp,sublp,1:(polyOrd{figlp}+1)) = polyfit(Xvar,Yvar,polyOrd{figlp});%polynomial coeffs in descending order 2nd, 1st, intercept
                        polymod_params(figlp,grouplp,sublp,2)=0;%this makes the constant (intercept) zero
                    end
                    
                    %generate fitted Data to plot
                    polymod_fit{figlp,grouplp,sublp}=polyval(squeeze(polymod_params(figlp,grouplp,sublp,1:(polyOrd{figlp}+1))),sort(Xvar)); %#ok<*PFPIE>
                    fittedYvar=polymod_fit{figlp,grouplp,sublp};
                    
                    %calculate std for cv
                    Yvar_error=abs(Yvar-fittedYvar);%calculate absolute fit error for each xvalue
                    polymod_params_error(figlp,grouplp,sublp,1:2) = polyfit(Xvar,Yvar_error,1);%polynomial coeffs in descending order 2nd, 1st, intercept
                    polymod_fit_error{figlp,grouplp,sublp}=polyval(squeeze(polymod_params_error(figlp,grouplp,sublp,1:2)),sort(Xvar));
                    fitted_Yvar_error= polymod_fit_error{figlp,grouplp,sublp};
                    cv{figlp,grouplp,sublp}=fitted_Yvar_error./fittedYvar;
                    
                    %scatter plot Data
                    scattercols=repmat(colorSet{figlp}(plotct,:),size(Xvar,2),1);%makes matrix for colored dots
                    
                    % which plots logfit or plot self-made fitting
                    if logfitFactor{figlp}==1
                        [logfitout{1}.graphtype,logfitout{1}.slope,logfitout{1}.intercept,logfitout{1}.mse,...
                            logfitout{1}.r2,logfitout{1}.s]= logfit(Xvar,Yvar,logfitGraphtype{figlp});
                        logfitparams{figlp,grouplp,sublp}=logfitout;
                    else
                        if omitScatter{figlp}==0
                            if superImp{figlp}==1
                                scatter(Xvar,Yvar,DTthick,scattercols);
                            else
                                scatter(Xvar,Yvar,DTthick,'k');%plot in black via 'k' since eps doesnt save otherwise
                            end
                        end
                        
                        %emphasise plot line for mie
                        if sublp==1 && mieFactor{figlp}==1
                            linewidth=LWthick;
                        else
                            if figlp==20
                                linewidth=LWthinnest;
                            else
                                linewidth=LWthin;
                            end
                        end
                        
                        %superimposing mie's Data onto observers
                        if plotct==1 && mieSuper{figlp}==1
                            load('MieData.mat') %#ok<*PFLD>
                            if logFactor{figlp}==0
                                if threshRemove{figlp}==0
                                    plot(MieData.curr,MieData.fittedpain,'linewidth',LWthick,'color','red');
                                else
                                    plot(MieData.curr_threshremove,MieData.fittedpain_threshremove,'linewidth',LWthick,'color','red');
                                end
                            else
                                if threshRemove{figlp}==0
                                    plot(log(MieData.curr),log(MieData.fittedpain),'linewidth',LWthick,'color','red');
                                else
                                    plot(MieData.logcurr_threshremove,MieData.logfittedpain_threshremove,'linewidth',LWthick,'color','red');
                                end
                            end
                        end
                        
                        %plot Data
                        
                        plot(sort(Xvar),polymod_fit{figlp,grouplp,sublp},'linewidth',linewidth,'color',colorSet{figlp}(plotct,:));
                        
                        
                        if estimatePrecision{figlp}==1
                            
                            %scatter error Data
                            scatter(Xvar,Yvar_error,DTthick,'r')
                            plot(sort(Xvar),polymod_fit_error{figlp,grouplp,sublp},'linewidth',linewidth,'color','r');
                            scatter(sort(Xvar),fitted_Yvar_error./fittedYvar,'g')%plots the coefficient of variance (cv)
                            
                            %generate Data-fit parameters - basic polynomial expansion fitting
                            polymods_mean(figlp,grouplp,sublp,1:(polyOrd{figlp}+1)) = polyfit(Xvar,Yvar,polyOrd{figlp});%polynomial coeffs in descending order 2nd, 1st, intercept
                            
                            %generate fitted Data to plot
                            polymod_fit{figlp,grouplp,sublp}=polyval(squeeze(polymods_mean(figlp,grouplp,sublp,1:(polyOrd{figlp}+1))),sort(Xvar));
                            fittedYvar=polymod_fit{figlp,grouplp,sublp};
                            
                            %calculate std for cv
                            Yvar_error=abs(Yvar-fittedYvar);%calculate absolute fit error for each xvalue
                            polymods_mean_error(figlp,grouplp,sublp,1:2) = polyfit(Xvar,Yvar_error,1);%polynomial coeffs in descending order 2nd, 1st, intercept
                            polymod_fit_error{figlp,grouplp,sublp}=polyval(squeeze(polymods_mean_error(figlp,grouplp,sublp,1:2)),sort(Xvar));
                            fitted_Yvar_error= polymod_fit_error{figlp,grouplp,sublp};
                            cv{figlp,grouplp,sublp}=mean(fitted_Yvar_error./fittedYvar);
                            meanAbsStd{figlp,grouplp,sublp}=mean(fitted_Yvar_error);
                            
                        end
                        
                        %superimpose fiducial/veridical line of perfect empathy
                        if plotct==1 && fidFactor{figlp}==1
                            plot(0:100,0:100,'--','linewidth',LWthin,'color','k')
                        end
                        
                    end %end of logfitFactor
                    
                    plotct=plotct+1;
                    
                    %%export figure as eps
                    if superImp{figlp}==0
                        if rem(subct,nplots)==0 || lastSubject==1;%only after aPPropriate subplots
                            %mtit(h1,filenames{figlp,loglp},'yoff',1)
                            % NEEDS UNCOMMENTING!             print(h1,'-depsc','-zbuffer','-r600',strcat('Figures/',strcat(expDir{expMode},'_',titLabels{figlp},num2str(figct)),'.eps'),'-loose');% choose the painters renderer, without croPPing
                        end
                        
                    else
                        if subct==nSubj{figlp}
                            %if loglp==2
                            print(h1,'-depsc','-zbuffer','-r600',strcat('Figures/',strcat(expDir{expMode},'_',titLabels{figlp},num2str(figct)),'.eps'),'-loose');% choose the painters renderer, without croPPing
                            %end
                        end
                    end
                    
                end % subject loop
                
                if meanFactor{figlp}
                    polymod_params;
                    m=squeeze(mean(polymod_params,3));%create mean across the subjects dimension
                    %m is a matrix of (#figures, #grouPS, #parameters)
                    if groupMean{figlp}==1
                        
                        %superimpose individual group mean onto current plot
                        mean_fit=polyval(squeeze(polymod_params(figlp,grouplp,sublp,1:(polyOrd{figlp}+1))),sort(Xvar));
                        if grouplp==2
                            plot(sort(Xvar),mean_fit,'linewidth',LWthick,'color','m');
                        elseif grouplp==3
                            plot(sort(Xvar),mean_fit,'linewidth',LWthick,'color','c');
                        end
                    end
                    
                    if groupMean{figlp}==0 && grouplp==3
                        allparams=[squeeze(polymod_params(figlp,2,plotSubjects{figlp}.group{1},1:2));squeeze(polymod_params(figlp,3,plotSubjects{figlp}.group{2},1:2))];
                        mean_fit=polyval(mean(allparams),sort(Xvar));
                        plot(sort(Xvar),mean_fit,'linewidth',LWthick,'color','k');
                    end
                    
                end
            end % group loop
            
            %print(h1,'-depsc','-zbuffer','-r600',strcat('Figures/',strcat(expDir{expMode},'_',titLabels{figlp},num2str(figct)),'.eps'),'-loose');% choose the painters renderer, without croPPing
            
        end%fig loop
        
        try
            save (strcat('_',expDir{expMode},'_behaviouraldatafitting_params_fig',num2str(figlp),'_',date),'polymod_params','cv','meanAbsStd');
            
        catch %#ok<*CTCH>
            save (strcat('_',expDir{expMode},'_behaviouraldatafitting_params_fig',num2str(figlp),'_',date),'polymod_params');
        end
        if logfitFactor{figlp}==1
            save (strcat('_',expDir{expMode},'_logfit_params_fig',num2str(figlp),date),'logfitParams');
        end
        
        %% statistics
        
        %         % group1 vs. group2 pain v empathy for each parameter of fit
        %         g1params=squeeze(polymod_params(7,2,:,:));
        %         g2params=squeeze(polymod_params(7,3,:,:));
        %
        %         g1params(all(g1params==0,2),:)=[];%remove rows with zeros for subjects that dont exist in that group
        %         g2params(all(g2params==0,2),:)=[];
        %
        %         meang1=mean(g1params,1);
        %         meang2=mean(g2params,1);
        %         stdg1=std(g1params,1);
        %         stdg2=std(g2params,1);
        %
        %         barerrorbar([meang1,meang2],[stdg1,stdg2])
        
        % need anova on effect of group
        
    case 3 % compute performance bonus
        % so correctness_score*100 = dkk participant will get as a bonus
        
        load('Helle_Inscan_DataMatrix_03-Sep-2013');
        group1=Data{2};
        group2=Data{3};
        Empathy_group1=group1(:, :, 1);
        Pain_group1=group1(:, :, 2);
        Empathy_group2=group2(:, :, 1);
        Pain_group2=group2(: , :, 2);
        
        Empathy_group1=Empathy_group1(:,87:172);
        Pain_group1=Pain_group1(:,87:172);
        Empathy_group2=Empathy_group2(:,87:172);
        Pain_group2=Pain_group2(:,87:172);
        
        nSubj=size(Empathy_group1,1);
        emp_corr1=[];
        for sublp=1:nSubj
            runemp1=corr((Empathy_group1(sublp,:)'),(Pain_group1(sublp,:)'),'type','spearman'); %correlation btw target pain and participant empathy rating
            emp_corr1=[emp_corr1 runemp1];
        end
        
        nSubj2=size(Empathy_group2,1);
        emp_corr2=[];
        for sublp=1:nSubj2
            runemp2=corr((Empathy_group2(sublp,:)'),(Pain_group2(sublp,:)'),'type','spearman'); %correlation btw target pain and participant empathy rating
            emp_corr2=[emp_corr2 runemp2];
        end
        
        %light_corr=[];
        %for sublp=1:nSubj;
        %    runlight=corr((Data((sublp),1:86,4)'),(Data((sublp),1:86,3)'),'type','spearman') %correlation btw real luminance and participant lightness rating
        %    light_corr=[light_corr runlight];
        %end
        
        correctness_score=(emp_corr+light_corr)/2; %correctness score across the two sessio
        
    case 4 % compile subject parameters into 1 group
        
        %Note subjects 1 2 and 4 missing from this list, need to be
        %included
        
        compileMode=2;
        
        switch compileMode
            
            case 1 % old hacked version combining 2 groups into 1
                
                load('_Data_Helle_Inscan_behaviouraldatafitting_params_fig21_07-Jan-2015.mat')
                g2=squeeze(polymod_params(21,2,:,:));
                g3=squeeze(polymod_params(21,3,:,:));
                oneGroupParams=g3;
                oneGroupParams([6,11,12,15,16,17,18,19,20,21,22,23,24,26,28,32,34,36,37,40,42,44,45,48,49,53],:)=g2([6,11,12,15,16,17,18,19,20,21,22,23,24,26,28,32,34,36,37,40,42,44,45,48,49,53],:);
                          
            case 2 % updated version using single group of subjects
                
                load('_Data_Ayna_Inscan_behaviouraldatafitting_params_fig21_06-Feb-2015.mat')
                oneGroupParams=squeeze(polymod_params(21,2,:,:));
      
        end
        
                subplot(1,3,1),hist(oneGroupParams(:,1));title('curvature')
                subplot(1,3,2),hist(oneGroupParams(:,2));title('slope')
                subplot(1,3,3),hist(oneGroupParams(:,3));title('intercept')
                
                save('oneGroupParams')
end
