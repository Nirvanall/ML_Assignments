%% Q-interaction
Q_f_left = zeros(1,6);
Q_f_right = zeros(1,6);
gamma = 0.5;

S = 1:1:6;
%A = [-1, 1];
for i = 1:10000
for s = S
    % left
    a = -1;
    s_1 = State_i(s, a);
    if (Q_f_left(1, s_1)>Q_f_right(1, s_1))
        Q_s1 = Q_f_left(1, s_1);
    else
        Q_s1 = Q_f_right(1, s_1);
    end
    if (Q_f_left(1, s) > Q_f_right(1, s))
        Q_s = Q_f_left(1, s);
    else
        Q_s = Q_f_right(1, s);
    end
    Q_f_left(1, s) = 0.7*(Return(s, s_1) + gamma*Q_s1) + 0.3*(Return(s, s) + gamma*Q_s);

    
    % right
    a = 1;
    s_1 = State_i(s, a);
    if (Q_f_left(1, s_1)>Q_f_right(1, s_1))
        Q_s1 = Q_f_left(1, s_1);
    else
        Q_s1 = Q_f_right(1, s_1);
    end
    if (Q_f_left(1, s) > Q_f_right(1, s))
        Q_s = Q_f_left(1, s);
    else
        Q_s = Q_f_right(1, s);
    end
    Q_f_right(1, s) = 0.7*(Return(s, s_1) + gamma*Q_s1) + 0.3*(Return(s, s) + gamma*Q_s);

end
end
