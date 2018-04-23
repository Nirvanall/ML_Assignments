%% Q-Learning for clean robot
S = 1:1:6; % states
A = [-1; 1]; % actions
gamma = 0.5;
alpha_array = [0.01, 0.05, 0.1, 0.2, 0.3, 0.4]; 
e_array = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7];
%pi = [0, -1, 1, 1, 1, 0];
%Q_f_left = [0, 1, 0.5, 0.625, 1.25, 0];
%Q_f_right = [0, 0.625, 1.25, 2.5, 5, 0];
%Q_f = [0, 1, 1.25, 2.5, 5, 0];
Q_left = zeros(1,6);
Q_right = zeros(1,6);
r = 0; % return in every step
%s = randi([3 4], 1,1); % initialize state 0 as 2 or 3 randomly
s = 3;
d = zeros(7,1000);
%d = zeros(1, 1000);
alpha = 0.1;
e = 0.5;
%for j = 1:7
    %e = e_array(j);
    
for i = 1:10000
% e-greedy
if (rand(1) > e)
    %a = pi(s); % arg max Q(s,a)
    if(Q_left(s)>Q_right(s))
        a = -1;
    else
        a = 1;
    end
else
    a = 1 - randi([0 1], 1, 1)*2; % random action
end
s_t1 = State(s, a);
r = Return(s, s_t1);
if (a==-1)
    if (Q_left(s_t1) > Q_right(s_t1))
        Q_left(1,s) = Q_left(1,s) + alpha*(r+gamma*Q_left(s_t1) - Q_left(1, s));
    else
        Q_left(1,s) = Q_left(1,s) + alpha*(r+gamma*Q_right(s_t1) - Q_left(1, s));
    end
elseif (a == 1)
    if (Q_left(s_t1) > Q_right(s_t1))
        Q_right(1,s) = Q_right(1,s) + alpha*(r+gamma*Q_left(s_t1) - Q_right(1, s));
    else
        Q_right(1,s) = Q_right(1,s) + alpha*(r+gamma*Q_right(s_t1) - Q_right(1, s));
    end
end
d(1,i) = norm([Q_f_left, Q_f_right] - [Q_left, Q_right]);
%d(1,i) = norm([Q_f_left, Q_f_right] - [Q_left, Q_right]);
s = s_t1;

if(s==1 || s==6)
    s = 3;
end

end
%end

% plot(d(1,:), 'LineWidth', 1)
% hold on
% for i = 2:7
%     plot(d(i, :), 'LineWidth', 1)
% end
% title('Difference Between Q-learning and Q-iteration')
% xlabel('Time of trial')
% ylabel('2-norm difference')
% legend('\epsilon = 0.1', '\epsilon = 0.2', '\epsilon = 0.3', '\epsilon = 0.4','\epsilon = 0.5', '\epsilon = 0.6', '\epsilon = 0.7')
% hold off
plot(d(1,:))
title('Difference between Q-learning and Q-iteration with \alpha = 0.1 and \epsilon = 0.5')
xlabel('Time of iteration')
ylabel('2-norm difference')



   