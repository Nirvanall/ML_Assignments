function [s_t1] = State(s_t, a)

    if (s_t==1 || s_t == 6)
        s_t1 = s_t;
    else
    if(rand(1)>0.3)
        s_t1 = s_t + a;
    else
        s_t1 = s_t;
    end        
    end


end