%% MICHAELS STIMONSETS

% This script automatically calculates Michaels stimonsets

%% CLEANING

clear all; close all;

%% Stim onsets, full movie

stimonset = [10.0000
   18.0976
   26.5280
   34.7335
   42.8233
   50.6706
   58.9624
   66.8376
   75.6211
   84.5484
   92.3153
  100.8988
  108.9566
  117.0927
  125.9438
  133.0859
  140.2602
  147.3006
  155.9659
  164.5222
  173.2622
  182.2194
  190.8177
  198.7407
  207.3018
  214.5383
  222.8182
  230.1049
  238.9942
  247.0379
  254.8672
  262.3963
  270.9448
  278.8571
  286.9940
  294.0315
  302.2668
  310.4910
  318.7249
  327.6124
  335.9760
  343.6950
  351.5691
  359.9644
  367.0848
  375.4183
  383.7596
  391.1804
  398.4382
  406.0691
  413.7965
  421.9369
  429.8141
  438.7909
  445.9949
  453.4127
  460.7353
  469.0415
  476.5481
  484.4807
  491.9696
  499.2875
  506.5083
  514.8209
  522.0973
  529.4905
  537.2279
  545.8699
  553.0641
  561.7400
  568.9322
  577.8851
  585.8224
  594.7759
  602.9856
  611.4642
  618.5425
  626.1081
  633.3485
  640.9408
  648.1783
  655.8142
  663.6428
  670.7711
  679.1560
  687.2892
  694.8200
  704.8200]';

% 1 second break between each movie.
% 2 seconds extra video after last stimuli in each of the 6 sessions.

m1 = stimonset(1:30);
m2 = ((m1(30)+2)*ones(1,31)+stimonset(1:31))+1; % 31 stimuli was given in session 2.
m3 = ((m2(31)+2)*ones(1,30)+stimonset(1:30))+1; 
m4 = ((m3(30)+2)*ones(1,30)+stimonset(1:30))+1;
m5 = ((m4(30)+2)*ones(1,30)+stimonset(1:30))+1;
m6 = ((m5(30)+2)*ones(1,30)+stimonset(1:30))+1;

ms_stimonset = [m1 m2 m3 m4 m5 m6];

ms_stimonset(end)/60

%% Stim onsets, movie divided into two sessions

% Session 1
m1 = stimonset(1:30);
m2 = ((m1(30)+2)*ones(1,31)+stimonset(1:31))+1; % 31 stimuli was given in session 2.
m3 = ((m2(31)+2)*ones(1,30)+stimonset(1:30))+1; 

ms_session1 = [m1 m2 m3]'
ms_session1(end)/60;

% Session 2
m4 = stimonset(1:30);
m5 = ((m4(30)+2)*ones(1,30)+stimonset(1:30))+1; 
m6 = ((m5(30)+2)*ones(1,30)+stimonset(1:30))+1; 

ms_session2 = [m4 m5 m6]'
ms_session2(end)/60;