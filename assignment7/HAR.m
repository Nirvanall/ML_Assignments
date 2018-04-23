load('Xtrn.mat');
load('Ytrn.mat');
load('Strn.mat');
load('Xtst.mat');

train_data = prdataset(Xtrn, Ytrn);
test_data = Xtst;
%%
W_qdc = qdc(train_data);
W_parzenc = parzenc(train_data);
W_fisher = fisherc(train_data);
%W_fisherc_i = train_data*(fisherc*qdc([],[], 1e-6));
%W_svm = libsvc(train_data);
% D_qdc = test_data*W_qdc;
% D_parzenc = test_data*W_parzenc;

% l = labeld(test_data, W_parzenc);
%l = labeld(test_data, W_qdc);
W_fisher_ldc = train_data * (fisherc*ldc);
l = labeld(test_data, W_fisher_ldc);

W_fisher_perl = train_data * (fisherc*perlc);
l = labeld(test_data, W_fisher_perl);

W_fisher_ldc2 = train_data * (fisherc * ldc([], 0.1, 0.1));
l = labeld(test_data, W_fisher_ldc2);

W_perl = train_data * perlc;
l = labeld(test_data, W_perl);

W_perl2 = train_data * perlc([], 5000, 0.02);
l = labeld(test_data, W_perl2);

W_ldc = train_data * ldc; % fail
l = labeld(test_data, W_ldc);

W_ldc = train_data * ldc([], 0.01, 0.5);
l = labeld(test_data, W_ldc);

W_log = train_data * loglc;
l = labeld(test_data, W_log);

W_fisher_log = train_data *(fisherc * loglc);
l = labeld(test_data, W_fisher_log);

W_fisher_log_ldc = train_data *(fisherc * loglc * ldc([], 0.01, 0.5));
l = labeld(test_data, W_fisher_log_ldc);

W_fisher_svm = train_data * (fisherc * mclassc);
l = labeld(test_data, W_fisher_svm);

W_svm = fitcecoc(Xtrn, Ytrn);
l = predict(W_svm, test_data);

W_libsvm = train_data * libsvc;% not work
l = labeld(test_data, W_libsvc);

W_fisher_multi = train_data * mclassc([], fisherc, 'multi');

W_f_l_p = train_data * (fisherc * loglc * perlc);
l = labeld(test_data, W_f_l_p);

%% semi: fail
% D_fisher = test_data*W_fisher;
% temp = D_fisher.data
% l = labeld(test_data, W_fisher);
% semi = [];
% for i = 1:5580
%     sample = temp(i,:);
%     label = l(i);
%     if (sample(label) > 0.9)
%       semi = [semi; i]; 
%     end
% end
% 
% semi_data = test_data(semi, :);
% semi_label = l(semi, :);
% new_data = [Xtrn ; semi_data];
% new_label = [Ytrn; semi_label];
% new_set = prdataset(new_data, new_label);
% W_new_fisher = fisherc(new_set);
% new_test = labeld(test_data, W_new_fisher);
%% Write label file
id = 1:5580;
answer = [id', l];
csvwrite('f_l_p.csv', answer);


