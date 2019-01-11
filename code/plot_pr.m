
function [x,y] = plo_pr( Predict,label)
    %��ʼ��Ϊ��1.0, 1.0��
    %�����ground_truth������������Ŀpos_num�͸���������Ŀneg_num
    [n,m]=size(label);
    x = zeros(m,5);
    y = zeros(m,5);
    for j=1:5
        ground_truth=label(j,:);
        predict=Predict(j,:);
        
        pos_num = sum(ground_truth==1);
        neg_num = sum(ground_truth==0);

        m = size(ground_truth,2);
        [pre,Index] = sort(predict);
        ground_truth = ground_truth(Index);
%         x(1,j) = 0.5; y(1,j) = 0.5; %����ֵΪ0.1ʱ����������Ϊ�����࣬���������ʺͼ����ʶ�Ϊ1.
        for i = 1:m
            TP = sum(ground_truth(i:m) == 1); %����x(i)�ı�ǩΪ1�Ķ�������������x(i)�ı�ǩΪ0�Ķ��Ǽ���
            FP = sum(ground_truth(i:m) == 0);
            x(i,j)=TP/pos_num;
            y(i,j)=TP/(TP+FP);
        end
    end
    x=mean(x');
    y=mean(y');
%     figure;
%     plot(x,y);
%     xlabel('ReCall');
%     ylabel('Predict');
%     title('PR����');
end 