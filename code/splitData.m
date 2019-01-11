function [train,test] = splitData( data)

%�����ݻ���Ϊѵ�����Ͳ��Լ�������7:3������������С��
%����������������
%����ֵ��ѵ�����Ͳ⼯  
    train_index=randperm(length(data),floor(length(data)/10*7));
    test_index=setdiff(linspace(1,length(data),length(data)),train_index);
    train=data(train_index,:);
    test=data(test_index,:);
end

