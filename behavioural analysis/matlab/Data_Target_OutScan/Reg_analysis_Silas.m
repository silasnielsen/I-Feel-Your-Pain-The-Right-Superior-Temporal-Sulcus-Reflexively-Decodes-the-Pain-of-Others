%% Regression analysis

% To estimate which regression fits the data the best by looking at the BIC
% value (the lower the better fit)

%%
clear all;
close all;

%% load data
load trg1
load trg2
load trg3
load trg5

%% target 1: BIC and loglikelihood

% 2nd order polynomial
t1_mdl_q = GeneralizedLinearModel.fit(trg1(:,1)',trg1(:,2)','quadratic');
t1_bic_q = t1_mdl_q.ModelCriterion.BIC;
t1_lll_q = t1_mdl_q.LogLikelihood;

% 3rd order polynomial
t1_mdl_p3 = GeneralizedLinearModel.fit(trg1(:,1)',trg1(:,2)','poly3');
t1_bic_p3 = t1_mdl_p3.ModelCriterion.BIC
t1_lll_p3 = t1_mdl_p3.LogLikelihood

% linear
t1_mdl_l = GeneralizedLinearModel.fit(trg1(:,1)',trg1(:,2)','linear');
t1_bic_l = t1_mdl_l.ModelCriterion.BIC;
t1_bic_l = t1_mdl_l.ModelCriterion;
t1_lll_l = t1_mdl_l.LogLikelihood;

% interactions
t1_mdl_i = GeneralizedLinearModel.fit(trg1(:,1)',trg1(:,2)','interactions');
t1_bic_i = t1_mdl_i.ModelCriterion.BIC;
t1_bic_i = t1_mdl_i.ModelCriterion;
t1_lll_i = t1_mdl_i.LogLikelihood;



%% target person 1: Goodness of fit
 
% 3rd order polynomial
[t1_a_p3 t1_b_p3 t1_c_p3] = fit(trg1(:,1),trg1(:,2),'poly3');


% 2nd order polynomial
[t1_a_p2 t1_b_p2 t1_c_p2] = fit(trg1(:,1),trg1(:,2),'poly2');


% Power
[t1_a_po t1_b_po t1_c_po] = fit(trg1(:,1),trg1(:,2),'power2')


% linear
[t1_a_p1 t1_b_p1 t1_c_p1] = fit(trg1(:,1),trg1(:,2),'poly1');


% purequadratic
t1_mdl_l = GeneralizedLinearModel.fit(trg1(:,1)',trg1(:,2)','purequadratic');
t1_bic_l = t1_mdl_l.ModelCriterion.BIC
t1_bic_l = t1_mdl_l.ModelCriterion;
t1_lll_l = t1_mdl_l.LogLikelihood;





%% target 2: BIC and loglikelihood

% 2nd order polynomial
t2_mdl_q = GeneralizedLinearModel.fit(trg2(:,1)',trg2(:,2)','quadratic');
t2_bic_q = t2_mdl_q.ModelCriterion.BIC
t2_lll_q = t2_mdl_q.LogLikelihood;

% 2nd order polynomial
t2_mdl_p2 = GeneralizedLinearModel.fit(trg2(:,1)',trg2(:,2)','poly2');
t2_bic_p2 = t2_mdl_p2.ModelCriterion.BIC
t2_lll_p2 = t2_mdl_p2.LogLikelihood;

% 3rd order polynomial
t2_mdl_p3 = GeneralizedLinearModel.fit(trg2(:,1)',trg2(:,2)','poly3');
t2_bic_p3 = t2_mdl_p3.ModelCriterion.BIC
t2_lll_p3 = t2_mdl_p3.LogLikelihood



% linear
t2_mdl_l = GeneralizedLinearModel.fit(trg2(:,1)',trg2(:,2)','linear');
t2_bic_l = t2_mdl_l.ModelCriterion.BIC
t2_bic_l = t2_mdl_l.ModelCriterion;
t2_lll_l = t2_mdl_l.LogLikelihood


%% target 2: Goodness of fit
 
% 3rd order polynomial
[t2_a_p3 t2_b_p3 t2_c_p3] = fit(trg2(:,1),trg2(:,2),'poly3');


% 2nd order polynomial
[t2_a_p2 t2_b_p2 t2_c_p2] = fit(trg2(:,1),trg2(:,2),'poly2');


% Power
[t2_a_po t2_b_po t2_c_po] = fit(trg2(:,1),trg2(:,2),'power2')


% linear
[t2_a_p1 t2_b_p1 t2_c_p1] = fit(trg2(:,1),trg2(:,2),'poly1');

% figure
% plot(t2_a_p3)
% 
% figure
% plot(t2_a_p2)
%    
% figure
% hold on
% plot(trg2(:,1),trg2(:,2),'.r');
% plot(t2_a_p3);
% title('\it{Psychometric function - target 2}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% %xlim([0 35]);
% hold off
% print('-dpng','Target2');


%% target 3: BIC and loglikelihood

% 2nd order polynomial
t3_mdl_q = GeneralizedLinearModel.fit(trg3(:,1)',trg3(:,2)','quadratic');
t3_bic_q = t3_mdl_q.ModelCriterion.BIC
t3_lll_q = t3_mdl_q.LogLikelihood

% 3rd order polynomial
t3_mdl_p3 = GeneralizedLinearModel.fit(trg3(:,1)',trg3(:,2)','poly3');
t3_bic_p3 = t3_mdl_p3.ModelCriterion.BIC
t3_lll_p3 = t3_mdl_p3.LogLikelihood


% linear
t3_mdl_l = GeneralizedLinearModel.fit(trg3(:,1)',trg3(:,2)','linear');
t3_bic_l = t3_mdl_l.ModelCriterion.BIC
t3_bic_l = t3_mdl_l.ModelCriterion;
t3_lll_l = t3_mdl_l.LogLikelihood

%% target 3: Goodness of fit
 
% 3rd order polynomial
[t3_a_p3 t3_b_p3 t3_c_p3] = fit(trg3(:,1),trg3(:,2),'poly3');


% 2nd order polynomial
[t3_a_p2 t3_b_p2 t3_c_p2] = fit(trg3(:,1),trg3(:,2),'poly2');


% Power
[t3_a_po t3_b_po t3_c_po] = fit(trg3(:,1),trg3(:,2),'power2')


% linear
[t3_a_p1 t3_b_p1 t3_c_p1] = fit(trg3(:,1),trg3(:,2),'poly1');

% figure
% plot(t3_a_p3)
% 
% figure
% plot(t3_a_p2)
%    
% figure
% hold on
% plot(trg3(:,1),trg3(:,2),'.r');
% plot(t3_a_po);
% title('\it{Psychometric function - target 3}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% %xlim([0 35]);
% hold off
% print('-dpng','Target3');

figure
hold on
plot(log(trg3(:,1)),log(trg3(:,2)),'.r');
plot(log(t3_a_po));
title('\it{Psychometric function - target 3}','FontSize',12)
xlabel('Current (mA)');
ylabel('Pain (%VAS)');
%xlim([0 35]);
hold off
print('-dpng','Target3');


%% target 4: BIC and loglikelihood

% 2nd order polynomial
t4_mdl_q = GeneralizedLinearModel.fit(trg4(:,1)',trg4(:,2)','poly2');
t4_bic_q = t4_mdl_q.ModelCriterion.BIC
t4_lll_q = t4_mdl_q.LogLikelihood

% 3rd order polynomial
t4_mdl_p4 = GeneralizedLinearModel.fit(trg4(:,1)',trg4(:,2)','poly3');
t4_bic_p4 = t4_mdl_p4.ModelCriterion.BIC
t4_lll_p4 = t4_mdl_p4.LogLikelihood


% linear
t4_mdl_l = GeneralizedLinearModel.fit(trg4(:,1)',trg4(:,2)','linear');
t4_bic_l = t4_mdl_l.ModelCriterion.BIC
t4_bic_l = t4_mdl_l.ModelCriterion;
t4_lll_l = t4_mdl_l.LogLikelihood

%% target 4: Goodness of fit
 
% 4rd order polynomial
[t4_a_p4 t4_b_p4 t4_c_p4] = fit(trg4(:,1),trg4(:,2),'poly3')


% 2nd order polynomial
[t4_a_p2 t4_b_p2 t4_c_p2] = fit(trg4(:,1),trg4(:,2),'poly2')


% Power
[t4_a_po t4_b_po t4_c_po] = fit(trg4(:,1),trg4(:,2),'power2')


% linear
[t4_a_p1 t4_b_p1 t4_c_p1] = fit(trg4(:,1),trg4(:,2),'poly1')

% figure
% plot(t4_a_p4)
% 
% figure
% plot(t4_a_p2)
%    
% figure
% hold on
% plot(trg4(:,1),trg4(:,2),'.r');
% plot(t4_a_po);
% title('\it{Psychometric function - target 4}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% %xlim([0 45]);
% hold off
% print('-dpng','Target4');

% figure
% hold on
% plot(log(trg4(:,1)),log(trg4(:,2)),'.r');
% plot(log(t4_a_po));
% title('\it{Psychometric function - target 4}','FontSize',12)
% xlabel('Current (mA)');
% ylabel('Pain (%VAS)');
% %xlim([0 45]);
% hold off
% print('-dpng','Target4');


%% target 5: BIC and loglikelihood

% 2nd order polynomial
t5_mdl_q = GeneralizedLinearModel.fit(trg5(:,1)',trg5(:,2)','poly2');
t5_bic_q = t5_mdl_q.ModelCriterion.BIC
t5_lll_q = t5_mdl_q.LogLikelihood

% 3rd order polynomial
t5_mdl_p5 = GeneralizedLinearModel.fit(trg5(:,1)',trg5(:,2)','poly3');
t5_bic_p5 = t5_mdl_p5.ModelCriterion.BIC
t5_lll_p5 = t5_mdl_p5.LogLikelihood


% linear
t5_mdl_l = GeneralizedLinearModel.fit(trg5(:,1)',trg5(:,2)','linear');
t5_bic_l = t5_mdl_l.ModelCriterion.BIC
t5_bic_l = t5_mdl_l.ModelCriterion;
t5_lll_l = t5_mdl_l.LogLikelihood

%% target 5: Goodness of fit
 
% 5rd order polynomial
[t5_a_p5 t5_b_p5 t5_c_p5] = fit(trg5(:,1),trg5(:,2),'poly3');


% 2nd order polynomial
[t5_a_p2 t5_b_p2 t5_c_p2] = fit(trg5(:,1),trg5(:,2),'poly2');


% Power
[t5_a_po t5_b_po t5_c_po] = fit(trg5(:,1),trg5(:,2),'power2')


% linear
[t5_a_p1 t5_b_p1 t5_c_p1] = fit(trg5(:,1),trg5(:,2),'poly1');
