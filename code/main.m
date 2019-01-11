clc;
clear;
%% ��������
datafile='./data/������ģ��������.xls';
thres_disc=10;
%% ����Ԥ����
[data,txt]=xlsread(datafile);
label=toInt(txt(2:size(txt),7)); 
orginal=cat(2,data,label);

%% �������ݼ� train:test=7:3
[trainData,testData]=splitData(orginal);
% ��ȡfeatures��targets
train_features=trainData(:,1:(size(trainData,2)-1))';  
train_targets=trainData(:,size(trainData,2))';  
test_features=testData(:,1:(size(testData,2)-1))';  
test_targets=testData(:,size(testData,2))';

%% ����ģ��ѵ��
%�ж�ĳһά����������ɢȡֵ��������ȡֵ��0��������������
discrete_dim =discreteOrContinue(train_features,thres_disc); 
% 1.ID3
id3Tree=ID3(train_features,train_targets);
test_predict1= predict(id3Tree,test_features, 1:size(test_features,2), discrete_dim);
% 2.C4.5
c45Tree=C4_5(train_features,train_targets);
test_predict2= predict(c45Tree,test_features, 1:size(test_features,2), discrete_dim);
% 3.LM
lmNet=LM(train_features,arrayToMatrix(train_targets'));
test_predict3=sim(lmNet,test_features);
% 4.BP
bpNet=BP(train_features,arrayToMatrix(train_targets'));
test_predict4=sim(bpNet,test_features);
%% ģ������
% ��������
plotconfusion(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
figure;
plotconfusion(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
figure;
plotconfusion(arrayToMatrix(test_targets'),test_predict3);
figure;
plotconfusion(arrayToMatrix(test_targets'),test_predict4);
% ROC����
figure;
[AUC1,FPR1,TPR1]=plot_roc(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[AUC2,FPR2,TPR2]=plot_roc(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
[AUC3,FPR3,TPR3]=plot_roc(test_predict3,arrayToMatrix(test_targets'));
[AUC4,FPR4,TPR4]=plot_roc(test_predict4,arrayToMatrix(test_targets'));
plot(FPR1,TPR1,'r-',FPR2, TPR2,'b-',FPR3,TPR3,'g-',FPR4,TPR4,'y-');
legend('ID3','C4.5','LM������','BP������');
xlabel('��������(FPR)');
ylabel('��������(TPR)');
title('ROC����');
% PR����
figure;
[precision1,recall1]=plot_pr(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[precision2,recall2]=plot_pr(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
[precision3,recall3]=plot_pr(test_predict3,arrayToMatrix(test_targets'));
[precision4,recall4]=plot_pr(test_predict4,arrayToMatrix(test_targets'));
plot(precision1,recall1,'r-',precision2,recall2,'b-',precision3,recall3,'g-',precision4,recall4,'y-');
legend('ID3','C4.5','LM������','BP������');
xlabel('��ȷ��');
ylabel('�ٻ���');
title('PR����');
% ׼ȷ��
disp('׼ȷ��')
accuracy(1)=cal_accuracy(test_targets,test_predict1);
accuracy(2)=cal_accuracy(test_targets,test_predict2);
accuracy(3)=cal_accuracy(test_targets,vec2ind(test_predict3));
accuracy(4)=cal_accuracy(test_targets,vec2ind(test_predict4));
fprintf('ID3��%f\nC4.5��%f\nLM��%f\nBP��%f\n',accuracy(1),accuracy(2),accuracy(3),accuracy(4));