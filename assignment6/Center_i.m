function idx = Center_i(s)
% return center index
if (s<1.5)
    idx = 1;
elseif (s<2.5)
    idx = 2;
elseif (s < 3.5)
    idx = 3;
elseif (s < 4.5)
    idx = 4;
elseif (s < 5.5)
    idx = 5;
else
    idx = 6;
end
end