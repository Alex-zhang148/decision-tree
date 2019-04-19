clc;
clear;
%% ��������
datafile='./data/data.xlsx';
% datafile='./data/������ģ��������.xls';
thres_disc=10;
%% ����Ԥ����
[data,txt]=xlsread(datafile);
% label=labelToInt(txt(2:size(txt),7)); 
label=toInt(txt(2:size(txt),7));
orginal=cat(2,data,label);
orginal=delMissValue(orginal);
orginal=delZero(orginal);
%% �������ݼ� train:test=7:3
for i=1:10
[trainData,testData]=splitData(orginal);

% ��ȡfeatures��targets
train_features=trainData(:,1:(size(trainData,2)-1))';
train_features=train_features./1000;
% train_features=discretization(train_features);
train_targets=trainData(:,size(trainData,2))';  

test_features=testData(:,1:(size(testData,2)-1))';
test_features=test_features./1000;
% test_features=discretization(test_features);
test_targets=testData(:,size(testData,2))';
%% ����ģ��ѵ��
%�ж�ĳһά����������ɢȡֵ��������ȡֵ��0��������������
% discrete_dim =discreteOrContinue(train_features,thres_disc); 
% save ./save/discrete_dim.mat discrete_dim;
% 1.ID3
tic;
id3Tree=ID3(train_features,train_targets);

toc;
test_predict1= predict(id3Tree,test_features, 1:size(test_features,2));
% 2.�Ľ����C4.5
tic;
newc45Tree=newC4_5(train_features,train_targets);
toc;
[nodeids,nodevalues,features] = print_tree(newc45Tree);
tree_plot(nodeids,nodevalues,features);
test_predict2= predict(newc45Tree,test_features, 1:size(test_features,2));
% 3.C4.5
tic;
c45Tree=C4_5(train_features,train_targets);
toc;
[nodeids,nodevalues,features] = print_tree(c45Tree);
figure;
tree_plot(nodeids,nodevalues,features);
test_predict3= predict(c45Tree,test_features, 1:size(test_features,2));
% % 4.BP
tic;
bpNet=BP(train_features,arrayToMatrix(train_targets'));
toc;
test_predict4=sim(bpNet,test_features);
[max_a,index]=max(test_predict4,[],1);
test_predict4 =index;
% ģ������
% % ��������
% figure;
% plotconfusion(arrayToMatrix(test_predict1'),arrayToMatrix(test_targets'));
% figure;
% plotconfusion(arrayToMatrix(test_predict2'),arrayToMatrix(test_targets'));
% figure;
% plotconfusion(arrayToMatrix(test_predict3'),arrayToMatrix(test_targets'));
% figure;
% plotconfusion(arrayToMatrix(test_targets'),test_predict4);
% ROC����
figure;
[AUC1,FPR1,TPR1]=plot_roc(test_features,test_predict1',test_targets');
[AUC2,FPR2,TPR2]=plot_roc(test_features,test_predict2',test_targets');
[AUC3,FPR3,TPR3]=plot_roc(test_features,test_predict3',test_targets');
[AUC4,FPR4,TPR4]=plot_roc(test_features,test_predict4',test_targets');
plot(FPR1,TPR1,'r-',FPR2, TPR2,'b-',FPR3,TPR3,'g-',FPR4,TPR4,'y-');
legend('ID3','newC4.5','C4.5','BP Neural Network');
xlabel('False Positive Rate(FPR)');
ylabel('True Positive Rate(TPR)');
title('ROC curve');
% PR����
figure;
[precision1,recall1]=plot_pr(test_features,test_predict1',test_targets');
[precision2,recall2]=plot_pr(test_features,test_predict2',test_targets');
[precision3,recall3]=plot_pr(test_features,test_predict3',test_targets');
[precision4,recall4]=plot_pr(test_features,test_predict4',test_targets');
plot(precision1,recall1,'r-',precision2,recall2,'b-',precision3,recall3,'g-',precision4,recall4,'y-');
legend('ID3','newC4.5','C4.5','BP Neural Network');
xlabel('Precision');
ylabel('Recall');
title('PR Curve');
% % ׼ȷ��
disp('׼ȷ��')
accuracy(1)=cal_accuracy(test_targets,test_predict1);
accuracy(2)=cal_accuracy(test_targets,test_predict2);
accuracy(3)=cal_accuracy(test_targets,test_predict3);
accuracy(4)=cal_accuracy(test_targets,test_predict4);
fprintf('ID3��%f\nnewC4.5��%f\nC4.5��%f\nBP��%f\n',accuracy(1),accuracy(2),accuracy(3),accuracy(4));
figure;
end