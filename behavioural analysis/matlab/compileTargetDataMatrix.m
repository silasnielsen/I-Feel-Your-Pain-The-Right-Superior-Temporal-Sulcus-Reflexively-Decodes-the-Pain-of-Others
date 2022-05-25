function AllTargets = compileTargetDataMatrix(dirname)

% compileTargetDataMatrix compiles matfiles into data matrix for targets
%
% It is part of the empathy plotting toolbox
%
% Author: Oliver Hulme
% Work address: DRCMR, Copenhagen
% email: ollie.hulme@gmail.com
% Last revision: July 2013

cd(dirname);

matfiles=dir('*.mat');%creates variable for entire contents of folder names

for i=1:99
    try load(matfiles(i).name);%try loading but only if it has .name field... 
        % only subject files should have this
        % rawinput is loaded with variables in the order of subject1_rating lum...
        % subject1_rating pain, subject2...etc
        
        NaN=nan; allTargetsTemp=NaN(ones(1,181,2));%this is in the order (subject,trials,dims)
        
        targetDataTemp=eval(strcat('trg',num2str(i))); %#ok<*NASGU,*MFAMB,PFBFN> %transposes
        
        allTargetsTemp(1,1:size(targetDataTemp,1),1:2)=targetDataTemp;% converts to 
                                                                      % (subj,trials,dims)
        
        AllTargets(i,:,:)=allTargetsTemp;% loads up subject dimension as i iterates around
                                         % target subjects
        
        disp(strcat('Loading data into AllTargets: Target subject#',num2str(i)))
    
    catch break %#ok<*PFBR>
    end
end
%convert "0 to 1" variables to percentages (convenient for logs)
AllTargets(:,:,2)=(AllTargets(:,:,2)*99)+1;%converts to percentage
disp('Finished compiling all targets subjects into AllTargets.mat');