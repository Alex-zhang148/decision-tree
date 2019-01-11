function tree = ID3(train_features,train_targets,varargin)
    pruning=35; 
    thres_disc=10;
    if nargin>3
        pruning=varargin{1};
        thres_disc=varargin{2};
    elseif nargin>2
        thres_disc=varargin{1};
    end
    [fea,num]=size(train_features); %num��ѵ����������fea��������Ŀ  
    pruning=pruning*num/100;  %���ڼ�֦  
    %�ж�ĳһά����������ɢȡֵ��������ȡֵ��0��������������
    discrete_dim =discreteOrContinue(train_features,thres_disc); 
    disp('Building Tree')
    tree=buildTree(train_features,train_targets,discrete_dim,0,0,pruning);
    disp('Saving Tree')
    save tree.mat tree;
end

