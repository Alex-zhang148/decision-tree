%% 
%C4.5��Ľ���C4.5֮��ıȽ�
%%
clc;
clear;
%% ��������
datafile='./data/data.xlsx';
thres_disc=10;
%% ����Ԥ����
[data,txt]=xlsread(datafile);
label=labelToInt(txt(2:size(txt),7)); 
orginal=cat(2,data,label);
% orginal=delMissValue(orginal);
orginal=delZero(orginal);
%% �������ݼ� train:test=7:3
[trainData,testData]=splitData(orginal);
% ��ȡfeatures��targets
train_features=trainData(:,1:(size(trainData,2)-1))';  
train_targets=trainData(:,size(trainData,2))'; 
[trainData,testData]=splitData(orginal);
test_features=testData(:,1:(size(testData,2)-1))';  
test_targets=testData(:,size(testData,2))';
% save ./save/train_features.mat train_features;
% save ./save/train_targets.mat train_targets;
% save ./save/test_features.mat test_features;
% save ./save/test_targets.mat test_targets;
%% ����ģ��ѵ��
discrete_dim =discreteOrContinue(train_features,thres_disc);
% 2.C4.5
tic
newc45Tree=newC4_5(train_features,train_targets);
% save ./save/newc45Tree.mat newc45Tree
[nodeids,nodevalues,features] = print_tree(newc45Tree);
tree_plot(nodeids,nodevalues,features);
toc;
figure;
tic;
c45Tree=C4_5(train_features,train_targets);
[nodeids,nodevalues,features] = print_tree(c45Tree);
tree_plot(nodeids,nodevalues,features);
toc;

test_predict1= predict(newc45Tree,test_features, 1:size(test_features,2));
test_predict2= predict(c45Tree,test_features, 1:size(test_features,2));
figure;
plotconfusion(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
figure;
plotconfusion(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
figure;
[AUC1,FPR1,TPR1]=plot_roc(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[AUC2,FPR2,TPR2]=plot_roc(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
plot(FPR1,TPR1,'r-',FPR2, TPR2,'b-');
legend('�Ľ�C4.5','C4.5');
xlabel('��������(FPR)');
ylabel('��������(TPR)');
title('ROC����');
% PR����
figure;
[precision1,recall1]=plot_pr(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
[precision2,recall2]=plot_pr(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
plot(precision1,recall1,'r-',precision2,recall2,'b-');
legend('�Ľ�C4.5','C4.5');
xlabel('��ȷ��');
ylabel('�ٻ���');
title('PR����');
% ׼ȷ��
disp('׼ȷ��')
accuracy(1)=cal_accuracy(test_targets,test_predict1);
accuracy(2)=cal_accuracy(test_targets,test_predict2);
fprintf('�Ľ�C4.5��%f\nC4.5��%f\n',accuracy(1),accuracy(2));