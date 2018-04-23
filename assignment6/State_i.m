function [s_t1] = State_i(s_t, a)

    if (s_t==1 || s_t == 6)
        s_t1 = s_t;
    else
        s_t1 = s_t + a;        
    end

end