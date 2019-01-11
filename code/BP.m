function [net] = BP(train_features,train_targets)
    
    net = newff(train_features,train_targets,20); %����BP������
    net.trainParam.show=50;%��ʾѵ����������
    net.trainParam.lr=0.05;%ѧϰ��
    net.trainParam.epochs=300;%���ѵ������
    net.trainParam.goal=1e-5;%ѵ��Ҫ�󾫶�
    net.trainParam.showWindow=0; %����ʾ����
    [net,tr]=train(net,train_features,train_targets);%����ѵ��
    
    W1=net.lw{1,1};%����㵽�м���Ȩֵ
    B1=net.b{1};%�м������Ԫ��ֵ
    W2=net.lw{2,1};%�м�㵽������Ȩֵ
    B2=net.b{2};%��������Ԫ��ֵ
end

