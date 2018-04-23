X = importdata('optdigitsubset.txt');
M_m = 0*ones(1,size(X,2)); % initial values of m-
M_p = 0*ones(1,size(X,2)); % initial values of m+
lambda = 1250000;
m = 0.00000001; % learning rate
change = 1; % inital change
%k = 0; % loop number
%while max(abs(change)) > 0.00001
for k = 1:200
    L = sum((X(1:554,:)-repmat(M_m,554,1)).^2) + sum((X(555:1125,:)...
    -repmat(M_p,571,1)).^2) + lambda*abs(M_m-M_p);
    dm = 554*2*M_m - sum(2*X(1:554,:))+lambda*sign(M_m-M_p); % gradient of m-
    dp = 571*2*M_p - sum(2*X(555:1125,:))-lambda*sign(M_m-M_p); % gradient of m+
    M_m = M_m - m * dm; % update m- to the opposite direction of its gradient
    M_p = M_p - m * dp; % update m+ to the opposite direction of its gradient
    L_temp = sum((X(1:554,:)-repmat(M_m,554,1)).^2) + sum((X(555:1125,:)...
    -repmat(M_p,571,1)).^2) + lambda*abs(M_m-M_p);
    change = L - L_temp;
    %k = k + 1;
    %m = 0.9*m;
end

img01 = reshape(M_m,[8, 8]);
img1 = mat2gray(img01);
figure
imshow(img1, 'InitialMagnification', 'fit');
 
img02 = reshape(M_p,[8, 8]);
img2 = mat2gray(img02);
figure
imshow(img2, 'InitialMagnification', 'fit');
