% clean.m - Cleans workspace, command window, and closes cogent
%
% Inputs:
%    cleanMode - determines which type of cleaning
% 
% It is part of the empathy plotting toolbox
%
% Author: Oliver Hulme
% Work address: DRCMR, Copenhagen
% email: ollie.hulme@gmail.com
% Last revision: July 2013

if exist('cleanMode')==0 %if no clearmode then perform hard clear
   
    disp('cleaning whole system...');
    clear all; %clear all workspace including globals
    clc; %clear command window
    close all;%close all figures
    try %#ok<TRYNC> %stop cogent
        cgshut
        stop_cogent; %close cogent if open
    end
    disp('full cleaning successful')
    
else
    if clearmode==1 %soft clear
        disp('cleaning variables from workspace...');
        clear;
        clc;%just clears variables from worksp
        close all;
        disp('soft cleaning successful')
    else
        
        disp('no cleaning performed')
    end
end


