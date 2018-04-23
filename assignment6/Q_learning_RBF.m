%% Q_learning RBF
%c = 1:1:6;
gamma = 0.5;
alpha = 0.1; % step-size
e = 0.7; 
theta = 0*ones(2,6);
rho = 0.5;
Q_i_left = [0, 1, 0.5, 0.625, 1.25, 0];
Q_i_right = [0, 0.625, 1.25, 2.5, 5, 0];
Q_t_left = zeros(1,6);
Q_t_right = zeros(1,6);
%theta_right = 3*ones(1,6);
s = 4; % initial state
d = zeros(1, 3000);

for i = 1: 3000
% e-greedy
if (rand(1) > e)
      s_left = State_N(s, -1);
      Q_s_left = RBF(s_left, rho)'*theta(1, :)';
      s_right = State_N(s, 1);
      Q_s_right = RBF(s_right, rho)'*theta(2, :)';
      if(Q_s_left>Q_s_right)
          s_t1 = s_left;
          a = -1;
      else
          s_t1 = s_right;
          a = 1;
      end      
else
     a = 1 - randi([0 1], 1, 1)*2; % random action
     s_t1 = State_N(s, a);
end

r = Return_N(s, s_t1);

Q_left = RBF(State_N(s_t1, -1), rho)'*theta(1, :)';
Q_right = RBF(State_N(s_t1, 1), rho)'*theta(2, :)';
if (Q_left > Q_right)
    Q_max = Q_left;
else
    Q_max = Q_right;  
end

Q_s1 = r + gamma*Q_max;
if (a == -1)
    delta = Q_s1 - RBF(s_t1, rho)'*theta(1,:)';
    theta(1, :) = theta(1,:) + alpha*delta*RBF(s_t1, rho)';
elseif(a == 1)
    delta = Q_s1 - RBF(s_t1, rho)'*theta(2, :)';
    theta(2, :) = theta(2, :) + alpha*delta*RBF(s_t1, rho)';
end

s = s_t1;

for n = 2:5
    Q_t_left(n) = RBF(n, rho)'*theta(1, :)';
    Q_t_right(n) = RBF(n, rho)'*theta(2, :)';
end

d(1, i) = norm([Q_i_left, Q_i_right]-[Q_t_left/2, Q_t_right/2])-3.15;

if(s<1.5 || s>=5.5)
    s = 4;
end

end

%% show results
state = 0.5:0.2:6.5;
state_left = zeros(1, length(state));
state_right = zeros(1, length(state));
Q_f_left = zeros(1, length(state));
Q_f_right =  zeros(1, length(state));
for j = 6:length(state)-5
    state_left(j) = State_N(state(j), -1);
    state_right(j) = State_N(state(j), 1);
    Q_f_left(j) = RBF(state_left(j), rho)'*theta(1, :)';
    Q_f_right(j) = RBF(state_right(j), rho)'*theta(2, :)';
end

plot(state, Q_f_left/2, 'r', 'LineWidth', 1)
hold on
plot(state, Q_f_right/2, 'b', 'LineWidth', 1)
xlabel('state')
ylabel('Q')
title('Q-function obtained with width = 0.5')
legend('Q-left', 'Q-right')
hold off

%%
figure
plot(d)
title('Difference Between Q-learning and Q-iteration')
xlabel('Time of trial')
ylabel('2-norm difference')




