%% LOGLOG Regression analysis

%%
clear all;
close all;

%% load data
load trg1
load trg2
load trg3
load trg4
load trg5

%% target 1: BIC and loglikelihood

% 2nd order polynomial
t1_mdl_q = GeneralizedLinearModel.fit(log(trg1(:,1)),log((trg1(:,2)*99)+1),'quadratic');
t1_bic_q = t1_mdl_q.ModelCriterion.BIC
t1_lll_q = t1_mdl_q.LogLikelihood

% linear
t1_mdl_l = GeneralizedLinearModel.fit(log(trg1(:,1)),log((trg1(:,2)*99)+1),'linear');
t1_bic_l = t1_mdl_l.ModelCriterion.BIC
t1_lll_l = t1_mdl_l.LogLikelihood

% 
% % 2nd order polynomial
% t1_mdl_q = GeneralizedLinearModel.fit(log(trg1(:,1)),log(trg1(:,2)),'quadratic');
% t1_bic_q = t1_mdl_q.ModelCriterion.BIC
% t1_lll_q = t1_mdl_q.LogLikelihood
% 
% % linear
% t1_mdl_l = GeneralizedLinearModel.fit(log(trg1(:,1)),log(trg1(:,2)),'linear');
% t1_bic_l = t1_mdl_l.ModelCriterion.BIC
% t1_lll_l = t1_mdl_l.LogLikelihood



%% target person 1: Goodness of fit
 
% 2nd order polynomial
[t1_a_p2 t1_b_p2 t1_c_p2] = fit(log(trg1(:,1)),log((trg1(:,2)*99)+1),'poly2')


% Power
[t1_a_po t1_b_po t1_c_po] = fit(log(trg1(:,1)),log((trg1(:,2)*99)+1),'power2')


% linear
[t1_a_p1 t1_b_p1 t1_c_p1] = fit(log(trg1(:,1)),log((trg1(:,2)*99)+1),'poly1')


% % 2nd order polynomial
% [t1_a_p2_2 t1_b_p2 t1_c_p2] = fit(log(trg1(:,1)),log(trg1(:,2)),'poly2')
% 
% 
% % Power
% [t1_a_po_2 t1_b_po t1_c_po] = fit(log(trg1(:,1)),log(trg1(:,2)),'power2')
% 
% 
% % linear
% [t1_a_p1_2 t1_b_p1 t1_c_p1] = fit(log(trg1(:,1)),log(trg1(:,2)),'poly1')

% figure
% plot(t1_a_p1)
% 
% figure
% hold on
% plot(log(trg1(:,1)),log((trg1(:,2)*99)+1),'.r');
% plot(t1_a_p2);
% title('\it{loglog Psychometric pain function - target 1}','FontSize',12)
% xlabel('log Current (mA)');
% ylabel('log Pain (%VAS)');
% % xlim([2.7 3.7])
% % ylim([4.5 5.5])
% hold off
% print('-dpng','logTarget1');
% 
% figure
% hold on
% plot(log(trg1(:,1)),log((trg1(:,2)*99)+1),'.r');
% plot(t1_a_p1);
% title('\it{loglog Psychometric pain function - target 1}','FontSize',12)
% xlabel('log Current (mA)');
% ylabel('log Pain (%VAS)');
% % xlim([2.7 3.7])
% % ylim([4.5 5.5])
% hold off
% print('-dpng','logTarget1');




%% target 2: BIC and loglikelihood

% 2nd order polynomial
t2_mdl_p2 = GeneralizedLinearModel.fit(log(trg2(:,1))',log((trg2(:,2)*99)+1)','poly2');
t2_bic_p2 = t2_mdl_p2.ModelCriterion.BIC
t2_lll_p2 = t2_mdl_p2.LogLikelihood

% linear
t2_mdl_l = GeneralizedLinearModel.fit(log(trg2(:,1))',log((trg2(:,2)*99)+1)','linear');
t2_bic_l = t2_mdl_l.ModelCriterion.BIC
t2_bic_l = t2_mdl_l.ModelCriterion;
t2_lll_l = t2_mdl_l.LogLikelihood


%% target 2: Goodness of fit
 
% 2nd order polynomial
[t2_a_p2 t2_b_p2 t2_c_p2] = fit(log(trg2(:,1)),log((trg2(:,2)*99)+1),'poly2')


% Power
[t2_a_po t2_b_po t2_c_po] = fit(log(trg2(:,1)),log((trg2(:,2)*99)+1),'power2')


% linear
[t2_a_p1 t2_b_p1 t2_c_p1] = fit(log(trg2(:,1)),log((trg2(:,2)*99)+1),'poly1')


%% target 3: BIC and loglikelihood

% 2nd order polynomial
t3_mdl_q = GeneralizedLinearModel.fit(log(trg3(:,1))',log((trg3(:,2)*99)+1)','quadratic');
t3_bic_q = t3_mdl_q.ModelCriterion.BIC
t3_lll_q = t3_mdl_q.LogLikelihood

% linear
t3_mdl_l = GeneralizedLinearModel.fit(log(trg3(:,1))',log((trg3(:,2)*99)+1)','linear');
t3_bic_l = t3_mdl_l.ModelCriterion.BIC
t3_bic_l = t3_mdl_l.ModelCriterion;
t3_lll_l = t3_mdl_l.LogLikelihood

%% target 3: Goodness of fit
 
% 2nd order polynomial
[t3_a_p2 t3_b_p2 t3_c_p2] = fit(log(trg3(:,1)),log((trg3(:,2)*99)+1),'poly2')


% Power
[t3_a_po t3_b_po t3_c_po] = fit(log(trg3(:,1)),log((trg3(:,2)*99)+1),'power2')


% linear
[t3_a_p1 t3_b_p1 t3_c_p1] = fit(log(trg3(:,1)),log((trg3(:,2)*99)+1),'poly1')



%% target 4: BIC and loglikelihood

% 2nd order polynomial
t4_mdl_q = GeneralizedLinearModel.fit(log(trg4(:,1)),log((trg4(:,2)*99)+1),'poly2');
t4_bic_q = t4_mdl_q.ModelCriterion.BIC
t4_lll_q = t4_mdl_q.LogLikelihood

% linear
t4_mdl_l = GeneralizedLinearModel.fit(log(trg4(:,1)),log((trg4(:,2)*99)+1),'linear');
t4_bic_l = t4_mdl_l.ModelCriterion.BIC
t4_lll_l = t4_mdl_l.LogLikelihood

%% target 4: Goodness of fit
 

% 2nd order polynomial
[t4_a_p2 t4_b_p2 t4_c_p2] = fit(log(trg4(:,1)),log((trg4(:,2)*99)+1),'poly2')


% Power
[t4_a_po t4_b_po t4_c_po] = fit(log(trg4(:,1)),log((trg4(:,2)*99)+1),'power2')


% linear
[t4_a_p1 t4_b_p1 t4_c_p1] = fit(log(trg4(:,1)),log((trg4(:,2)*99)+1),'poly1')



%% target 5: BIC and loglikelihood

% 2nd order polynomial
t5_mdl_q = GeneralizedLinearModel.fit(log(trg5(:,1))',log((trg5(:,2)*99)+1)','poly2');
t5_bic_q = t5_mdl_q.ModelCriterion.BIC
t5_lll_q = t5_mdl_q.LogLikelihood

% linear
t5_mdl_l = GeneralizedLinearModel.fit(log(trg5(:,1))',log((trg5(:,2)*99)+1)','linear');
t5_bic_l = t5_mdl_l.ModelCriterion.BIC
t5_bic_l = t5_mdl_l.ModelCriterion;
t5_lll_l = t5_mdl_l.LogLikelihood

%% target 5: Goodness of fit
 
% 2nd order polynomial
[t5_a_p2 t5_b_p2 t5_c_p2] = fit(log(trg5(:,1)),log((trg5(:,2)*99)+1),'poly2')


% Power
[t5_a_po t5_b_po t5_c_po] = fit(log(trg5(:,1)),log((trg5(:,2)*99)+1),'power2')


% linear
[t5_a_p1 t5_b_p1 t5_c_p1] = fit(log(trg5(:,1)),log((trg5(:,2)*99)+1),'poly1')
