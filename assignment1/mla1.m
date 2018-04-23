%% Exercise Regularization & Sparsity
% Question 1 (a)
m = -4:0.01:4; % range of m+
l0 = (-1-m).^2 + (1-m).^2 + 0*abs(1-m); % loss function with lambda 0
l2 = (-1-m).^2 + (1-m).^2 + 2*abs(1-m); % loss function with lambda 2
l4 = (-1-m).^2 + (1-m).^2 + 4*abs(1-m); % loss function with lambda 4
l6 = (-1-m).^2 + (1-m).^2 + 6*abs(1-m); % loss function with lambda 6
% plot all the loss function with lamda {0,2,4,6}
figure
plot(m,l0)
hold on
plot(m,l2)
plot(m,l4)
plot(m,l6)
title('Loss function as a function of m+')
xlabel('m+')
ylabel('loss')
legend('\lambda as 0', '\lambda as 2', '\lambda as 4', '\lambda as 6')
hold off
% (b)
% the minimumizer and the minimum values
m0 = min(l0);
m0_er = m(find(l0==m0));
m2 = min(l2);
m2_er = m(find(l2==m2));
m4 = min(l4);
m4_er = m(find(l4==m4));
m6 = min(l6);
m6_er = m(find(l6==m6));

% the point where the derivative equals 0
dx = 1e-3;
xi = -4:dx:4;

yi0 = interp1(m, l0, xi);
dyi0 = [0 diff(yi0)]/dx;
dy0 = interp1(xi, dyi0, m);
min_dy0 = min(abs(dy0(2:801)));
der0_pos1 = find(dy0==min_dy0);
m(der0_pos1)
l0(der0_pos1)

yi2 = interp1(m, l2, xi);
dyi2 = [0 diff(yi2)]/dx;
dy2 = interp1(xi, dyi2, m);
min_dy2 = min(abs(dy2(2:801)));
der2_pos1 = find(dy2==min_dy2);
m(der2_pos1)
l2(der2_pos1)

yi4 = interp1(m, l4, xi);
dyi4 = [0 diff(yi4)]/dx;
dy4 = interp1(xi, dyi4, m);
min_dy4 = min(abs(dy4(2:801)));
der4_pos1 = find(dy4==min_dy4);
m(der4_pos1)
l4(der4_pos1)

yi6 = interp1(m, l6, xi);
dyi6 = [0 diff(yi6)]/dx;
dy6 = interp1(xi, dyi6, m);
min_dy6 = min(abs(dy6(2:801)));
der6_pos1 = find(dy6==min_dy6);

