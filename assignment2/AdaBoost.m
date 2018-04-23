function [hypothesis, e, weight, oy, ot, of] = AdaBoost(N, D, T)
% input N: sequence of N labeled examples
% input D: distribution over the N examples
% input T: number of iterations

data = N.data; % get data from dataset
[x y] = size(data);
label = N.labels; % get labels from dataset
% Initialize the weight vector
weight = D;

H = zeros(T, x);
e = zeros(T,1); % error of every iteration
beta = zeros(T,1); 
output1 = zeros(T, x);
output2 = zeros(T, x);
% start interations
for i = 1: T
    p = weight/sum(weight);
    [oy(i), ot(i), of(i)] = weaklearner(N, p); % call weaklearner
    % obtain hypothesis ht
    if (oy(i) == 1)
        for m = 1:x
            if (data(m, of(i)) > ot(i))
                H(i, m) = 1;
            else
                H(i, m) = 0;
            end
        end
    else
        for m = 1:x
            if (data(m, of(i)) < ot(i))
                H(i, m) = 1;
            else
                H(i, m) = 0;
            end
        end
    end
    % calculate the error of ht
    e(i) = sum(p.*abs(H(i, :)- label'));
    beta(i) = e(i)/(1-e(i)); % set beta
    % set the weight vecot
    power = 1 - abs(H(i, :)- label');
    for n = 1:x
        weight(n) = beta(i)^power(n) * weight(n);
    end
    
    output1(i, :) = log(1/beta(i))*H(i,:);
    output2(i, :) = 0.5*log(1/beta(i));
end

h1 = sum(output1);
h2 = sum(output2);
% output hypothesis
hypothesis = h1 >= h2;
end


