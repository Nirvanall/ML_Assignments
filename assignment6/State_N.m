function [s_t1] = State_N(s_t, a)

    if (s_t<1.5 || s_t >=5.5)
        s_t1 = s_t;
    else
        s_t1 = s_t + a + 0.1*randn;           
    end

end