function [net] = LM(train_features,train_targets)
    %����������
    net = patternnet(10,'trainlm');
    net.trainParam.epochs=1000;
    net.trainParam.show=25;
    net.trainParam.showCommandLine=0;
    net.trainParam.showWindow=0; 
    net.trainParam.goal=0;
    net.trainParam.time=inf;
    net.trainParam.min_grad=1e-6;
    net.trainParam.max_fail=5;
    net.performFcn='mse';

    %ѵ��������
    net= train(net,train_features,train_targets);
end

