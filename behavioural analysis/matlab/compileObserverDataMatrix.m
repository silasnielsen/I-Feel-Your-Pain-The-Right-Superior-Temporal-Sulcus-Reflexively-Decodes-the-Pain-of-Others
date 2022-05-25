function Data = compileObserverDataMatrix(dirName,targetMode,FilmInd)

% compileObserverDataMatrix - compiles matfiles into data matrix for targets
%
% This function sets up data variables, and then compiles them into single
% 3d data matrices that are input to this same function for analysis when run in
% mode 1 - NOTE: This is not complete for switching between target
% subjects though.
%
% Inputs:
%           dirName: directory where to find the observers data
%
% It is part of the empathy plotting toolbox
%
% Author: Oliver Hulme
% Work address: DRCMR, Copenhagen
% email: ollie.hulme@gmail.com
% Last revision: July 2013

% Import data
load('AllTargets')%load all target data

cd(dirName);%to folder only where subj mat files are
matfiles=dir('*.mat');%creates variable for entire contents of folder names

%loop around subjects, loading pain first, then luminance
for i=1:999
    try rawinput(i)=load(matfiles(i).name);%try loading but only if it has .name field - only subject files should have this
        %rawinput is loaded with variables in the order of subject1_rating lum, subject1_rating pain, subject2...etc
    catch
        break
    end
end

% Compiles rawdata into matrices
% this is a 3d matrix, which can be thought of as a stack of 2d matrices
% (subjects x variable) where the 1st is emp, 2nd is target pain
% 3rd is subjective lightness, and 4th is objective luminance, 5th
% is current
ndims=5;
nsubjects=size(rawinput,2)/2;%there should be half as many subjects as sessions in rawinput
ndata=max(size(AllTargets));%finds max num of observations across all targets
Data=nan(nsubjects,ndata,ndims);%initialise 3d matrix

filmInd=FilmInd{1};
filmInd2=FilmInd{2};

for sublp=1:nsubjects %cycle and load all subjects data into matrix
    
    film1File=(sublp*2)-1;%which index for film1 for this subject
    film2File=(sublp*2);%ditto for film2
    
    if regexp(matfiles(film1File).name, 'film1_ratinglum')>0 %if first file for subject has film1 rating luminance then dont switch for this subject
        
        % Put empathy reports from film2 into 2nd half of all trials
        Data(sublp,filmInd(3):filmInd(4),1)=rawinput(:,film2File).lastrate';%#ok<*PFBNS> %observers empathy rating
        
        % Put subjective pain into matrix in same order as recording
        Data(sublp,filmInd(1):filmInd(4),2)=AllTargets(targetMode,filmInd(1):filmInd(4),2);%#ok<*PFIIN> %targets subjective pain, all in same order as filming
        
        % Put lightness judgements from film1 into 1st half of all trials
        Data(sublp,filmInd(1):filmInd(2),3)=rawinput(:,film1File).lastrate';%observers lightness rating
        
        % Put 1st half luminance into 1st half & 2nd half into 2nd
        Data(sublp,filmInd(1):filmInd(2),4)=rawinput(:,film1File).randomintensity';%observers objective luminance
        Data(sublp,filmInd(3):filmInd(4),4)=rawinput(:,film2File).randomintensity';%observers objective luminance
        
        % Put objective current into matrix in same order as recording
        Data(sublp,filmInd(1):filmInd(4),5)= AllTargets(targetMode,filmInd(1):filmInd(4),1);%targets objective current, all in same order as filming
        
    elseif regexp(matfiles(film1File).name, 'film1_ratingpain')>0 % things have to be switched according to film switch
        
        % Put empathy reports from film1 into 2nd half of all trials
        Data(sublp,filmInd2(3):filmInd2(4),1)=rawinput(:,film1File).lastrate';%observers empathy rating
        
        % Put subjective pain into matrix in switched order
        Data(sublp,filmInd2(3):filmInd2(4),2)=AllTargets(targetMode,filmInd(1):filmInd(2),2);%targets subjective pain switched order
        Data(sublp,filmInd2(1):filmInd2(2),2)=AllTargets(targetMode,filmInd(3):filmInd(4),2);%targets subjective pain
        
        % Put lightness judgements of film2 into 1st half of all trials
        Data(sublp,filmInd2(1):filmInd2(2),3)=rawinput(:,film2File).lastrate';%observers lightness rating
        
        % Put luminance into matrix in switched order
        Data(sublp,filmInd2(1):filmInd2(2),4)=rawinput(:,film2File).randomintensity';%observers objective luminance
        Data(sublp,filmInd2(3):filmInd2(4),4)=rawinput(:,film1File).randomintensity';%observers objective luminance
        
        % Put currents into matrix in switched order
        Data(sublp,filmInd2(1):filmInd2(2),5)=AllTargets(targetMode,filmInd(3):filmInd(4),1);%targets objective current switched order
        Data(sublp,filmInd2(3):filmInd2(4),5)=AllTargets(targetMode,filmInd(1):filmInd(2),1);%targets objective current
        
    end
end
        
%% Convert Data into percentages to avoid zeros, important for logs
unconvData=Data;%saves old version of data for comparison
Data(:,:,[1,3,4])=(Data(:,:,[1,3,4])*99)+1;%converst empathy,and lightness to percentage...
                                         ...between 1 and 100. means log values (0:4.6), thus no neg numbers