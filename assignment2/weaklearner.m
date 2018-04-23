function [oy, ot, of] = weaklearner(data, dataweight)
%% Implementation of a weak learner
% the input data is a dataset
% the output oy is the optimized sign, 1 for >, and 2 for <
% the output ot is the average optimized threshold
% the output of is the index of the optimized feature

f = getdata(data); % features from a dataset
% fx: number of objects
% fy: number of features
[fx, fy] = size(f);

% labels of objects, assume lable could be 1 or 0 
label = data.labels;
%weight of every objects
weight = dataweight;
tweight = repmat(weight', 1, fy); % for compute the error

t = min(f(:)): 0.05*(max(f(:))-min(f(:))) : max(f(:)); %threshold
[tx, ty] = size(t); 

errorArray1 = zeros([ty, fy]); % initialize classification errors
errorArray2 = zeros([ty, fy]);
for i = 1:ty
    classification1 = zeros(fx,fy); % classification results for >
    classification2 = zeros(fx,fy); % classification results for <   
    for m = 1:fx
        for n = 1:fy
            if (f(m,n) > t(i))  % classify f with threshold t(i)
                classification1(m,n) = 1;
            else
                classification1(m,n) = 0;
            end
            if (f(m,n) < t(i))
                classification2(m,n) = 1;
            else
                classification2(m,n) = 0;
            end
        end    
    end
    % calculate error
     e1 = abs(classification1 - repmat(label, 1, fy));
     e2 = abs(classification2 - repmat(label, 1, fy));
     e1 = e1.*tweight;
     e2 = e2.*tweight;
%      for l = 1:fx
%          error_o1(l) = sum(e1(l,:)); % error for every object
%          error_o2(l) = sum(e2(l,:));
%      end   
     error1 = sum(e1); % error for every feature
     error2 = sum(e2);
     errorArray1(i, :) = error1;
     errorArray2(i, :) = error2;
end 

% find the min error and it position
% find the value of optimized y (1 as >, 2 as <)
if(min(min(errorArray1)) < min(min(errorArray2)))
    oy = 1;
    [pt, pf] = find(errorArray1==min(min(errorArray1)));
else
    oy = 2;
    [pt, pf] = find(errorArray2==min(min(errorArray2)));
end

% find the index number of optimized feature
of = round(mean(pf));
% find the value of optimized threshold
ot = mean(t(pt));
%plot the weight and error of every object in one figure
% figure
% plot(weight)
% hold on
% plot(error_o1)
% plot(error_o2)
% xlabel('index of objects')
% ylabel('error or weight')
% legend('weight', 'error1', 'error2')
% hold off
end