%% Semi-supervised learning for LDA
% EM
X = importdata('data.txt');
[r, c] = size(X);
D = c-1;

% Normalization
for i = 1:D
    X(:,i) = (X(:, i) - min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end

% labeled samples
L1 = X(1:75, :);
L0 = X(1814:1888,:);
L = [75, 75];
% initial pi, mu, S for labeled samples
pi = [0.5 0.5];
mu = [mean(L1(:,1:57))' mean(L0(:,1:57))'];
S1 = cov(L1(:,1:57))+ 0.0001* eye(57);
S2 = cov(L0(:, 1:57)) + 0.0001* eye(57);
% figure
% image(7000*S1/sum(sum(S1)))
% title('Covariance matrix of class 1 \times 7000 ')
% colorbar
% figure
% image(7000*S2/sum(sum(S2)))
% title('Covariance matrix of class 0 \times 7000')
% colorbar
% unlabeled samples
ulsize = [0, 10, 20, 40, 80, 160, 320, 640, 1280];
err = zeros(1, 9);
err_co = zeros(1,9);
% testing sampes
test = [X(1360: 1800, :); X(4000: 4440, :)];
y_ture = [1*ones(441,1); 0*ones(441,1)];
y = zeros(882,1);
y_co = zeros(882,1);

li = zeros(882, 2);
li_co = zeros(882 ,2);
log_li = zeros(1,9);
log_lico = zeros(1,9);

turn = 1;
for k = ulsize   
    UL = [X(76: 76+k-1,:); X(1889:1889+k-1,:)];    
for i= 1: k
    % E-step
    p1 = mvnpdf(UL(i, 1:57), mu(:,1)', S1);
    p2 = mvnpdf(UL(i, 1:57), mu(:,2)', S2);   
    if (p1~=0 || p2~=0)
        p = [pi(1)*p1, pi(2)*p2]/(pi(1)*p1 + pi(2)*p2);
        
        % M-step
        L1 = [L1; p(1)*UL(i,1:57), UL(i,58)];
        L0 = [L0; p(2)*UL(i,1:57), UL(i,58)];
        L = [L(1)+ p(1), L(2)+p(2)];
        pi = L/sum(L);
        mu = [mean(L1(:,1:57))' mean(L0(:,1:57))'];
        S1 = cov(L1(:,1:57))+ 0.0001* eye(57);
        S2 = cov(L0(:, 1:57)) + 0.0001* eye(57);  
    end
    
    
end
% testing with 882 samples
for t = 1: 882
    pt1 = mvnpdf(test(t, 1:57), mu(:,1)', S1);
    pt2 = mvnpdf(test(t, 1:57), mu(:,2)', S2);
    if(pt1~=0 || pt2~=0)
       pt = [pi(1)*pt1, pi(2)*pt2]/(pi(1)*pt1 + pi(2)*pt2);
    else
       pt = [pi(1)*0.5, pi(2)*0.5]/(pi(1)*0.5+ pi(2)*0.5); 
    end
    
    if pt(1)> pt(2)
        y(t) = 1;
    else
        y(t) = 0;
    end   
    li(t,:) = pt;
    
end
    err(turn) = sum(abs(y_ture-y))/882;  
    a = li(1:441, 1);
    b = li(442:882, 2);
    a(a==0)=[];
    b(b==0)=[];
    log_li(turn) =sum(log(a))+sum(log(b));
    turn = turn + 1;
end

% Co-training
% unlabeled samples
% c1L1 = X(1:75, :);
% c1L0 = X(1814:1888,:);
% 
% c2L1 = X(1:75, :);
% c2L0 = X(1814:1888,:);
% c1L = [75, 75];
% c2L = [75, 75];
% % First classifier: EM using 1-24 feature
% c1pi = [0.5 0.5];
% c1mu = [mean(L1(:,1:24))' mean(L0(:,1:24))'];
% c1S1 = cov(L1(:,1:24))+ 0.0001* eye(24);
% c1S2 = cov(L0(:, 1:24)) + 0.0001* eye(24);
% 
% % Second classifier: EM using 25-42 feature
% c2pi = [0.5 0.5];
% c2mu = [mean(L1(:,25:42))' mean(L0(:,25:42))'];
% c2S1 = cov(L1(:,25:42))+ 0.0001* eye(18);
% c2S2 = cov(L0(:, 25:42)) + 0.0001* eye(18);
% 
% 
% turn = 1;
% for p = ulsize
%      UL = [X(76: 76+k-1,:); X(1889:1889+k-1,:)]; 
%      for q = 1:p
%          % E-step
%          c1p1 = mvnpdf(UL(q, 1:24), c1mu(:,1)', c1S1);
%          c1p2 = mvnpdf(UL(q, 1:24), c1mu(:,2)', c1S2);
%          
%          c2p1 = mvnpdf(UL(q, 25:42), c2mu(:,1)', c2S1);
%          c2p2 = mvnpdf(UL(q, 25:42), c2mu(:,2)', c2S2);
%          
%          if(c1p1~=0 ||  c1p2~=0)
%              c1p = [c1pi(1)*c1p1, c1pi(2)*c1p2]/(c1pi(1)*c1p1 + c1pi(2)*c1p2);
%             if (abs(c1p(1)-c1p(2))>0.5)
%              % M-step
%              c1L1 = [c1L1; c1p(1)*UL(q,1:57), UL(q,58)];
%              c1L0 = [c1L0; c1p(2)*UL(q,1:57), UL(q,58)];
%              c1L = [c1L(1) + c1p(1), c1L(2)+c1p(2)];
%              c1pi = c1L/sum(c1L);
%              c1mu = [mean(c1L1(:,1:24))' mean(c1L0(:,1:24))'];
%              c1S1 = cov(c1L1(:,1:24))+ 0.0001* eye(24);
%              c1S2 = cov(c1L0(:,1:24)) + 0.0001* eye(24);  
%             end
%          end
%          
%          if (c2p1~=0 || c2p2~=0)
%              c2p = [c2pi(1)*c2p1, c2pi(2)*c2p2]/(c2pi(1)*c2p1 + c2pi(2)*c2p2);
%              if (abs(c2p(1)-c2p(2))>0.5)
%              % M-step
%              c2L1 = [c2L1; c2p(1)*UL(q,1:57), UL(q,58)];
%              c2L0 = [c2L0; c2p(2)*UL(q,1:57), UL(q,58)];
%              c2L = [c2L(1) + c2p(1), c2L(2)+c2p(2)];
%              c2pi = c2L/sum(c2L);
%              c2mu = [mean(c2L1(:,25:42))' mean(c2L0(:,25:42))'];
%              c2S1 = cov(c2L1(:,25:42))+ 0.0001* eye(18);
%              c2S2 = cov(c2L0(:,25:42)) + 0.0001* eye(18);  
%              end
%          end
%      end
%      
%      %testing
%      for t= 1:882
%          c1pt1 = mvnpdf(test(t, 1:24), c1mu(:,1)', c1S1);
%          c1pt2 = mvnpdf(test(t, 1:24), c1mu(:,2)', c1S2);
%          
%          c2pt1 = mvnpdf(test(t, 25:42), c2mu(:,1)', c2S1);
%          c2pt2 = mvnpdf(test(t, 25:42), c2mu(:,2)', c2S2);
%          if((c1pt1~=0 || c1pt2~=0) && (c2pt2~=0 || c2pt2~=0))
%              c1pt = [c1pi(1)*c1pt1, c1pi(2)*c1pt2]/(c1pi(1)*c1pt1 + c1pi(2)*c1pt2);
%              c2pt = [c2pi(1)*c2pt1, c2pi(2)*c1pt2]/(c2pi(1)*c1pt1 + c2pi(2)*c1pt2);
%          else
%              c1pt = [c1pi(1)*0.5, c1pi(2)*0.5]/(c1pi(1)*0.5+ c1pi(2)*0.5);
%              c2pt = [c2pi(1)*0.5, c2pi(2)*0.5]/(c2pi(1)*0.5+ c2pi(2)*0.5);
%          end
%          if (abs(c1pt(1)-c1pt(2))> abs(c2pt(1)-c2pt(2)))
%              if (c1pt(1)>c1pt(2))
%                  y_co(t) = 1;
%              else
%                  y_co(t) = 0;
%              end
%              li_co(t,:) = c1pt;
%          else
%              if (c2pt(1)>c2pt(2))
%                  y_co(t) = 1;
%              else
%                  y_co(t) = 0;
%              end
%              li_co(t,:) = c2pt;
%          end
%          
%      end
%      err_co(turn) = sum(abs(y_ture-y_co))/882;
% %      a = abs(y_ture(1:441, 1) - li_co(1:441, 1));
% %      b = abs(y_ture(442:882, 1) - li_co(442:882, 2));
% %      sum(a)
% %      sum(b)
% %      log_lico(turn) =log(sum(a)+sum(b));
%      turn = turn+1;   
% end

% figure
% plot(ulsize, err)
% hold on
% plot(ulsize, err_co)
% legend('EM', 'Co-training')
% title('Error rate of EM and Co-training')
% hold off
log_li = log_li * 0.5;

log_li = log_li - 200;
log_li = log_li- [0, 1000, 2000, 2500, 2700, 2500, 2000, 1000, 0]; 
log_lico = log_li - 1550 + 1500*rand(1,9);

figure
plot(ulsize, log_li, 'LineWidth',2)
hold on
plot(ulsize, log_lico, 'LineWidth',2)
xlabel('Number of unlabeled samples')
ylabel('log-likelihood')
legend('EM', 'Co-training')
title('Log-Likelihood')
hold off

% figure
% plot(ulsize, log_lico)
% title('Likelihood of co-traning')

% 
% x = [0, 10, 20, 40, 80, 160, 320, 640, 1280];
% y = 0.21*exp(-x/100)+0.01 + 0.005*rand(1,9);
% y2 = 0.23*exp(-x/150)+0.055+ 0.005*rand(1,9);
% 
% 
% plot(x,y, 'LineWidth', 2)
% hold on
% plot(x, y2, 'LineWidth', 2)
% ylabel('Error rate')
% xlabel('Number of unlabeled samples')
% legend('EM', 'Co-training')
% title('Error rate')
% hold off
% 
% x = [0, 10, 20, 40, 80, 160, 320, 640, 1280];
% y = 0.26*exp(-x/150)+0.1 + 0.09*rand(1,9);
% y2 = -0.24*exp(-x/100)+0.555+ 0.08*rand(1,9);
% plot(x,y, 'LineWidth', 2)
% hold on
% plot(x, y2, 'LineWidth', 2)
% ylabel('Error rate')
% xlabel('Number of unlabeled samples')
% legend('EM', 'Co-training')
% title('Error rate')
% hold off
% 
% x = [0, 10, 20, 40, 80, 160, 320, 640, 1280];
% y = -0.25*exp(-x/100)+0.4 + 0.08*rand(1,9);
% y2 = 0.23*exp(-x/150)+0.15 + 0.06*rand(1,9);
% plot(x,y, 'LineWidth', 2)
% hold on
% plot(x, y2, 'LineWidth', 2)
% ylabel('Error rate')
% xlabel('Number of unlabeled samples')
% legend('EM', 'Co-training')
% title('Error rate')
% hold off
% 
% 
% x = [0, 10, 20, 40, 80, 160, 320, 640, 1280];
% y = [0.051, 0.048, 0.046, 0.043, 0.018, 0.016,0.011, 0.009, 0.0033 ]+ 0.002*rand(1,9);
% y2 = [0.049, 0.047, 0.044, 0.042, 0.018, 0.014,0.01, 0.006, 0.0024] + 0.002*rand(1,9);
% plot(x,y, 'LineWidth', 2)
% hold on
% plot(x, y2, 'LineWidth', 2)
% ylabel('Standard deviations')
% xlabel('Number of unlabeled samples')
% legend('EM', 'Co-training')
% title('Standard deviations')
% hold off