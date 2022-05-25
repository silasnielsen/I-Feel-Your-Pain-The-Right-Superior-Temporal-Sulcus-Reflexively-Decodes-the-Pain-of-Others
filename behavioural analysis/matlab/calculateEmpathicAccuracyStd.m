slopes=normrnd(2,0.5,1,1000);
stdslopes=std(slopes)
meanslopes=mean(slopes)
[H,P,CI,STATSslope]=ttest(slopes);
STATSslope

acc=slopes;
acc(slopes>1)=(1./slopes(slopes>1));
stdacc=std(acc)
meanacc=mean(acc)
[H,P,CI,STATSacc]=ttest(acc);
STATSacc

stdratio=stdslopes/stdacc
meanratio=meanslopes/meanacc
