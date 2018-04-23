load('Xtrn.mat');
load('Ytrn.mat');
load('Strn.mat');
load('Xtst.mat');

identifier = prdataset(Xtrn, Strn);
train_data = prdataset(Xtrn, Ytrn);
%% Classifier for identification
W_i = identifier * parzenc;
l = labeld(Xtrn, W_i); 
err = sum(l~=Strn)/4719; % test by train_data, err = 0 here
%% 
W = {};
for i = 1:15
    location = find(Strn==i);
    data = Xtrn(location,:);
    label = Ytrn(location);
    traindata = prdataset(data, label);
    w = traindata * (fisherc * loglc);
    W = [W, {w}];
end

%% start test
L = zeros(5580, 1);
for j = 1:5580
    j
    ident =labeld(Xtst(j, :), W_i);
    L(j) = labeld(Xtst(j, :), W{ident});
end

%%
id = 1:5580;
answer = [id', L];
csvwrite('mclassc_fisher_single.csv', answer);
