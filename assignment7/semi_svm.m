%% 96.380% fisher_svm_semi-supervised learning
% load training and testing data
load('Xtrn.mat');
load('Ytrn.mat');
load('Strn.mat');
load('Xtst.mat');

train_data = prdataset(Xtrn, Ytrn);
test_data = Xtst;
% train first AVA classfier from Fisher`s classifier
W_fisher_multi = train_data * mclassc([], fisherc, 'multi');
% generate labels for testing data
l = labeld(test_data, W_fisher_multi);

% perpare dataset for SVM
semidata = [Xtrn; Xtst];
semilabel = [Ytrn; l];

% train SVM classifier
W_svm =  fitcecoc(semidata, semilabel);
% generate labels for testing data
L = predict(W_svm, test_data);

% store results in csv file
id = 1:5580;
answer = [id', L];
csvwrite('answer.csv', answer);
