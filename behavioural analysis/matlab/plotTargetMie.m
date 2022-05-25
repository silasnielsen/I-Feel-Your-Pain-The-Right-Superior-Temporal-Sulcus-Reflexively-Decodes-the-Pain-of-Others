% Seed 1
load('1_Empathy_20121203_18-20-16.mat'); 
% mA
power1 = [1.7000
    1.7000
    2.5000
    2.9000
    2.2000
    1.8000
    2.6000
    2.4000
    1.6000
    2.2000
    1.9000
    3.0000
    2.1000
    2.5000
    1.9000
    2.6000
    2.0000
    2.7000
    2.8000
    2.9000
    2.4000
    1.7000
    2.0000
    3.2000
    1.9000
    3.0000
    2.5000
    3.3000
    1.7000
    2.4000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
%mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 1 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 1');
grid;

clear all

% Seed 2
load('2_Empathy_20121203_18-30-56.mat')
% mA
power1 = [2.4000
    1.8000 
    3.2000	
    1.6000
    2.9000
    3.0000
    3.1000
    1.7000
    2.3000
    2.0000
    3.0000
    2.3000
    3.1000
    1.9000
    2.0000
    1.8000
    1.8000
    3.1000
    2.6000
    2.5000
    1.8000
    3.1000
    2.7000
    2.2000
    2.5000
    2.3000
    1.7000
    2.0000
    1.8000
    1.9000
    2.0000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 2 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 2');
grid;

clear all;

% Seed 3
load('3_Empathy_20121203_18-37-01.mat');
% mA
power1 = [2.3000 
    1.7000    
    1.7000
    3.1000
    3.2000
    2.4000
    2.4000
    2.2000
    3.1000
    2.2000
    1.8000
    2.9000
    2.3000
    2.0000
    2.3000
    1.8000
    1.8000
    3.2000
    3.2000
    2.6000
    1.7000
    2.0000
    2.2000
    3.0000
    1.6000
    1.7000
    1.9000
    2.7000
    2.8000
    2.7000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 3 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 3');
grid;

clear all;

% Seed 4
load('4_Empathy_20121203_18-52-27.mat')
% mA
power1 = [1.7000 
    1.7000
    2.5000
    2.9000
    3.2000	
    1.8000
    2.6000
    2.4000
    1.6000
    2.2000
    1.9000
    3.0000
    2.1000
    2.5000
    1.9000
    2.6000
    2.0000
    2.7000
    2.8000
    2.9000
    2.4000
    1.7000
    2.0000
    3.2000
    1.9000
    3.0000
    2.5000
    3.3000
    1.7000
    2.4000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 4 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 4');
grid;

clear all;

% Seed 5
load('5_Empathy_20121203_18-57-51.mat')
% mA
power1 = [2.1000 
    3.2000
    3.2000	
    1.6000
    2.9000
    3.0000
    3.1000
    1.7000
    2.3000
    2.0000
    3.0000
    2.3000
    3.1000
    1.9000
    2.0000
    1.8000
    1.8000
    3.1000
    2.6000
    2.5000
    1.8000
    3.1000
    2.7000
    2.2000
    2.5000
    2.3000
    1.7000
    2.0000
    1.8000
    1.9000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog 
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 5 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 5');
grid;

clear all;

% Seed 6
load('6_Empathy_20121203_19-04-22.mat')
% mA
power1 = [2.0000
    2.3000
    1.7000
    3.1000
    3.2000
    2.4000
    2.4000
    2.2000
    3.1000
    2.2000
    1.8000
    2.9000
    2.3000
    2.0000
    2.3000
    1.8000
    1.8000
    3.2000
    3.2000
    2.6000
    1.7000
    2.0000
    2.2000
    3.0000
    1.6000
    1.7000
    1.9000
    2.7000
    2.8000
    2.7000];
power1_1 = power1'; % transposing the matrix
power1_2 = power1_1(2:30)*10; % removing first trial and multiplying with 10, power
ratings1 = lastrate(2:30); % removing first trial, ratings
X = ratings1;
Y = power1_2; 
mdl = LinearModel.fit(X,Y);
% plot(mdl);

polyfit(log10(X),log10(Y),1); % polyfit, loglog
figure, loglog(X,Y,'k+');  
xlabel('Pain');
ylabel('mA');
title('Test 6 loglog');
grid;

polyfit(X,Y,1); % first number; slope - second number; y-intercept (e.g. plot)
figure, scatter(X,Y,'ro','filled'); % 'ro'; scatter points
xlabel('Pain');
ylabel('mA');
title('Test 6');
grid;

clear all;

