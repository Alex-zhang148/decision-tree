function [nodeids_,nodevalue_,features_] = print_tree(tree)
%% ��ӡ�����������Ĺ�ϵ����
clear global nodeid nodeids nodevalue features;
global nodeid nodeids nodevalue features;
nodeids(1)=0; % ���ڵ��ֵΪ0
nodeid=0;
nodevalue={};
features=[];
if isempty(tree) 
    disp('������');
    return ;
end

queue = queue_push([],tree);
while ~isempty(queue) % ���в�Ϊ��
     [node,queue] = queue_pop(queue); % ������
     visit(node,queue_curr_size(queue));
     if isstruct(node.child)&&~strcmp(node.child(1),'null') % ��������Ϊ��
        queue = queue_push(queue,node.child(1)); % ����
     end
     if isstruct(node.child)&&~strcmp(node.child(2),'null') % ��������Ϊ��
         queue = queue_push(queue,node.child(2)); % ����
     end
end

%% ���� �ڵ��ϵ������treeplot��ͼ
nodeids_=nodeids;
nodevalue_=nodevalue;
features_=(features);
end

function visit(node,length_)
%% ����node �ڵ㣬����������ֵΪnodeid�Ľڵ�
    global nodeid nodeids nodevalue features;
    if isleaf(node)
        nodeid=nodeid+1;
%         disp('leaf')
%         fprintf('Ҷ�ӽڵ㣬node: %d\t������ֵ: %d\n', ...
%         nodeid, node.child);
        nodevalue{1,nodeid}=node.child;
        features{1,nodeid}=0;
    else % Ҫô��Ҷ�ӽڵ㣬Ҫô����
        %if isleaf(node.left) && ~isleaf(node.right) % ���ΪҶ�ӽڵ�,�ұ߲���
        nodeid=nodeid+1;
        nodeids(nodeid+length_+1)=nodeid;
        nodeids(nodeid+length_+2)=nodeid;
%         fprintf('node: %d\t����ֵ: %s\t��������Ϊ�ڵ㣺node%d��������Ϊ�ڵ㣺node%d\n', ...
%         nodeid, node.location,nodeid+length_+1,nodeid+length_+2);
        nodevalue{1,nodeid}=node.location;
        features{1,nodeid}=node.feature_tosplit;
    end
end

function flag = isleaf(node)
%% �Ƿ���Ҷ�ӽڵ�
%     if strcmp(node.child(1),'null') && strcmp(node.child(2),'null') % ���Ҷ�Ϊ��
%     if ~isstruct(node.child)&&
    if ~isstruct(node.child)
        flag =1;
    else
        flag=0;
    end
end

function [ newqueue ] = queue_push( queue,item )
%% ����

% cols = size(queue);
% newqueue =structs(1,cols+1);
newqueue=[queue,item];
end

function [ item,newqueue ] = queue_pop( queue )
%% ���ʶ���

if isempty(queue)
    disp('����Ϊ�գ����ܷ��ʣ�');
    return;
end

item = queue(1); % ��һ��Ԫ�ص���
newqueue=queue(2:end); % �����ƶ�һ��Ԫ��λ��

end

function [ length_ ] = queue_curr_size( queue )
%% ��ǰ���г���

length_= length(queue);

end