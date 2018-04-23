function [r] = Return(s_t, s_t1)

if (s_t1 == 6 && s_t ~= 6)
    r = 5;
elseif (s_t1 == 1 && s_t ~= 1)
    r = 1;
else
    r = 0;
end
end