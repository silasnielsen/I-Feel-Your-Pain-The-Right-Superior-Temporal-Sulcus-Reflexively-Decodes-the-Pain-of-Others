%%% SILAS bsc thesis plots

clear all; close all;


%% load data

load trg1
load trg2
load trg3
load trg4
load trg5




%% Regression, 2nd order polynomial
% 
% f1 = polyfit(trg1(:,1),trg1(:,2)+1)*99,2)
% fit1 = polyval(f1,trg1(:,1));
% 
% f2 = polyfit(trg2(:,1),trg2(:,2)+1)*99,2)
% fit2 = polyval(f2,trg2(:,1));
% 
% f3 = polyfit(trg3(:,1),trg3(:,2)+1)*99,2)
% fit3 = polyval(f3,trg3(:,1));
% 
% f4 = polyfit(trg4(:,1),trg4(:,2)+1)*99,2)
% fit4 = polyval(f4,trg4(:,1));
% 
% f5 = polyfit(trg5(:,1),trg5(:,2)+1)*99,2)
% fit5 = polyval(f5,trg5(:,1));
% 
% [t1_a_p2 t1_b_p2 t1_c_p2] = fit(trg1(:,1),trg1(:,2)+1)*99,'poly2');
% 
% [t2_a_p2 t2_b_p2 t2_c_p2] = fit(trg2(:,1),trg2(:,2)+1)*99,'poly2');
% 
% [t3_a_p2 t3_b_p2 t3_c_p2] = fit(trg3(:,1),trg3(:,2)+1)*99,'poly2');
% 
% [t4_a_p2 t4_b_p2 t4_c_p2] = fit(trg4(:,1),trg4(:,2)+1)*99,'poly2');
% 
% [t5_a_p2 t5_b_p2 t5_c_p2] = fit(trg5(:,1),trg5(:,2)+1)*99,'poly2');


%% Regression loglog

fL1 = polyfit(log(trg1(:,1)),log((trg1(:,2)+1)*99),1)
fitL1 = polyval(fL1,log(trg1(:,1)));

fL2 = polyfit(log(trg2(:,1)),log((trg2(:,2)+1)*99),1)
fitL2 = polyval(fL2,log(trg2(:,1)));

fL3 = polyfit(log(trg3(:,1)),log((trg3(:,2)+1)*99),2)
fitL3 = polyval(fL3,log(trg3(:,1)));

fL4 = polyfit(log(trg4(:,1)),log((trg4(:,2)+1)*99),1)
fitL4 = polyval(fL4,log(trg4(:,1)));

fL5 = polyfit(log(trg5(:,1)),log((trg5(:,2)+1)*99),2)
fitL5 = polyval(fL5,log(trg5(:,1)));


% %% using polyfit (2nd order pol)
% 
% figure
% hold on
% plot(trg1(:,1),trg1(:,2),'.r');
% plot(sort(trg1(:,1)),sort(fit1),'color','red');
% title('\it{Psychometric pain function - target 1}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 35]);
% hold off
% print('-dpng','Target1');
% 
% 
% figure
% hold on
% plot(trg2(:,1),trg2(:,2),'.r');
% plot(sort(trg2(:,1)),sort(fit2),'color','red');
% title('\it{Psychometric pain function - target 2}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 25]);
% hold off
% print('-dpng','Target2');
% 
% 
% figure
% hold on
% plot(trg3(:,1),trg3(:,2),'.r');
% plot(sort(trg3(:,1)),sort(fit3),'color','red');
% title('\it{Psychometric pain function - target 3}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 45]);
% hold off
% print('-dpng','Target3');
% 
% figure
% hold on
% plot(trg4(:,1),trg4(:,2),'.r');
% plot(sort(trg4(:,1)),sort(fit4),'color','red');
% title('\it{Psychometric pain function - target 4}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 45]);
% hold off
% print('-dpng','Target4');
% 
% figure
% hold on
% plot(trg5(:,1),trg5(:,2),'.r');
% plot(sort(trg5(:,1)),sort(fit5),'color','red');
% title('\it{Psychometric pain function - target 5}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 120]);
% hold off
% print('-dpng','Target5');


%% using fit (2nd order pol)

% figure
% hold on
% plot(trg1(:,1),trg1(:,2),'.r');
% plot(t1_a_p2);
% title('\it{Psychometric function - target 1}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 35]);
% hold off
% %print('-dpng','Target1');
% 
% 
% figure
% hold on
% plot(trg2(:,1),trg2(:,2),'.r');
% plot(t2_a_p2);
% title('\it{Psychometric function - target 2}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([5 30]);
% hold off
% %print('-dpng','Target2');
% 
% 
% figure
% hold on
% plot(trg3(:,1),trg3(:,2),'.r');
% plot(t3_a_p2);
% title('\it{Psychometric function - target 3}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([10 45]);
% hold off
% %print('-dpng','Target3');
% 
% 
% figure
% hold on
% plot(trg4(:,1),trg4(:,2),'.r');
% plot(t4_a_p2);
% title('\it{Psychometric function - target 4}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 45]);
% hold off
% %print('-dpng','Target4');
% 
% 
% figure
% hold on
% plot(trg5(:,1),trg5(:,2),'.r');
% plot(t5_a_p2);
% title('\it{Psychometric function - target 5}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% xlim([0 120]);
% hold off
% %print('-dpng','Target5');



%% loglog plots using polyfit (1st order pol)

close all;

figure
hold on
plot(log(trg1(:,1)),log((trg1(:,2)+1)*99),'.r');
plot(sort(log(trg1(:,1))),sort(fitL1),'color','red');
title('\it{loglog Psychometric pain function - target 1}','FontSize',12)
xlabel('log Current (mA)');
ylabel('log Pain (%VAS)');
xlim([2.7 3.7])
ylim([4.5 5.5])
hold off
print('-dpng','logTarget1');


figure
hold on
plot(log(trg2(:,1)),log((trg2(:,2)+1)*99),'.r');
plot(sort(log(trg2(:,1))),sort(fitL2),'color','red');
title('\it{loglog Psychometric pain function - target 2}','FontSize',12)
xlabel('log Current (mA)');
ylabel('log Pain (%VAS)');
xlim([2.3 3.3])
ylim([4.5 5.5])
hold off
print('-dpng','logTarget2');


figure
hold on
plot(log(trg3(:,1)),log((trg3(:,2)+1)*99),'.r');
plot(sort(log(trg3(:,1))),sort(fitL3),'color','red');
title('\it{loglog Psychometric pain function - target 3}','FontSize',12)
xlabel('log Current (mA)');
ylabel('log Pain (%VAS)');
xlim([2.8 3.8])
ylim([4.5 5.5])
hold off
print('-dpng','logTarget3');


figure
hold on
plot(log(trg4(:,1)),log((trg4(:,2)+1)*99),'.r');
plot(sort(log(trg4(:,1))),sort(fitL4),'color','red');
title('\it{loglog Psychometric pain function - target 4}','FontSize',12)
xlabel('log Current (mA)');
ylabel('log Pain (%VAS)');
xlim([2.8 3.8])
ylim([4.5 5.5])
hold off
print('-dpng','logTarget4');

figure
hold on
plot(log(trg5(:,1)),log((trg5(:,2)+1)*99),'.r');
plot(sort(log(trg5(:,1))),sort(fitL5),'color','red');
title('\it{loglog Psychometric pain function - target 5}','FontSize',12)
xlabel('log Current (mA)');
ylabel('log Pain (%VAS)');
xlim([2.5 5])
ylim([3.5 6])
hold off
print('-dpng','logTarget5');