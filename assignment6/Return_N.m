function [r] = Return_N(s_t, s_t1)

if (s_t1 >= 5.5 && s_t < 5.5)
    r = 5;
elseif (s_t1 < 1.5 && s_t >= 1.5)
    r = 1;
else
    r = 0;
end
end