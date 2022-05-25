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

nr86trials=size(Empathy_group1, 2)
nrIngroup1_26=size(Empathy_group1,1)
nrIngroup2_24=size(Empathy_group2,1)

dlmwrite('Empathygroup1.txt', Empathy_group1')  % so one column per person
dlmwrite('Paingroup1.txt', Pain_group1')
dlmwrite('Empathygroup2.txt', Empathy_group2')
dlmwrite('Paingroup2.txt', Pain_group2')





        %nSubj=size(Empathy_group1,1);
        %emp_RATINGS=[];
        
		%for sublp=1:nSubj
        %    runemp1=corr((Empathy_group1(sublp,:)'),(Pain_group1(sublp,:)'),'type','spearman'); %correlation btw target pain and participant empathy rating
        %    emp_corr1=[emp_corr1 runemp1];
        %end
        
        %nSubj2=size(Empathy_group2,1);
        %emp_corr2=[];
        %for sublp=1:nSubj2
        %    runemp2=corr((Empathy_group2(sublp,:)'),(Pain_group2(sublp,:)'),'type','spearman'); %correlation btw target pain and participant empathy rating
        %    emp_corr2=[emp_corr2 runemp2];
        %end