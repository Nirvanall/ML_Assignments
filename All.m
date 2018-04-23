load('Xtrn.mat');
load('Ytrn.mat');
load('Strn.mat');
load('Xtst.mat');

train_data = prdataset(Xtrn, Ytrn);
test_data = Xtst;
%%
L = zeros(5580, 6);
P = zeros(5580, 12);
% Classifiers
for i = 1:6
    labels = Ytrn;
    labels(labels ~= i) = 0;
    traindata = prdataset(Xtrn, labels);
    W = traindata * (fisherc * loglc);
    pp = test_data * W;
    P(:, 2*i-1:2*i) = pp.data ;
    L(:, i) = labeld(test_data, W);
end
P(:,[1, 3, 5, 7, 9, 11]) = [];

% get labels
LABEL = zeros(5580,1);
for j = 1:5580
    ll = 0;
    c = 0;
    for k = 1:6
        if(L(j,k)~=0)
            c = c + 1;
            ll = k;
        end
    end
    if c == 1
        LABEL(j) = ll;
    end
end
% check elements without possibility as 1
for j = 1:5580
    if LABEL(j) == 0
        if (size(find(P(j,:) == max(P(j, :))))==1)
            LABEL(j) = find(P(j,:) == max(P(j, :)));
        end
    end
end
%%
% 3 or 4
location34 = find(Ytrn==3|Ytrn==4);
data34 = Xtrn(location34,:);
label34 = Ytrn(location34);
% label34(label34 == 4) = 1;
% label34(label34 == 3) = 0;
dataset34 = prdataset(data34, label34);
W34 = dataset34 * fisherc;

test34 =[2601, 3969, 4417];
LABEL(test34,:) = labeld(test_data(test34,:), W34);

% 2, 5 or 6
location256 = find(Ytrn==2|Ytrn==5|Ytrn==6);
data256 = Xtrn(location256, :);
label256 = Ytrn(location256);
dataset256 = prdataset(data256, label256);
W256 = dataset256 * fisherc;
test256 = [1468, 4372, 4727];
LABEL(test256, :) = labeld(test_data(test256,:), W256);

% 2 or 3
location23 = find(Ytrn==2|Ytrn==3);
data23 = Xtrn(location23,:);
label23 = Ytrn(location23);
dataset23 = prdataset(data23, label23);
W23 = dataset23 * fisherc;
test23 = [3673, 4385];
LABEL(test23, :) = labeld(test_data(test23, :), W23);
%% semi svm
semidata = [Xtrn; Xtst];
semilabel = [Ytrn; LABEL];

W_svm =  fitcecoc(semidata, semilabel);
L = predict(W_svm, test_data);

%%
id = 1:5580;
answer = [id', L];
csvwrite('all_semi.csv', answer);


