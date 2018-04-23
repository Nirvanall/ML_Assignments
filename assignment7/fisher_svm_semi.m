% 88.853
load('Xtrn.mat');
load('Ytrn.mat');
load('Strn.mat');
load('Xtst.mat');

train_data = prdataset(Xtrn, Ytrn);
test_data = Xtst;

W_svm =  fitcecoc(Xtrn, Ytrn);
L = predict(W_svm, test_data);

semidata = [Xtrn; Xtst];
semilabel = [Ytrn; L];
semiset = prdataset(semidata, semilabel);

W_fisher_multi = semiset * mclassc([], fisherc, 'multi');
l = labeld(test_data, W_fisher_multi);

id = 1:5580;
answer = [id', l];
csvwrite('fisher_semi_svm.csv', answer);
