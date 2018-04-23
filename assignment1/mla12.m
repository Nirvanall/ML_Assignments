%Question 2
m_minus = -8:0.01:8;
m_plus = -8:0.01:8;
[X,Y] = meshgrid(m_minus, m_plus);
L = (-1-Y).^2 + (1-Y).^2 + (3-X).^2 + (-1-X).^2 + 6*abs(X-Y);
% contour figure
figure
contourf(X,Y,L,20)
colorbar
% 3D figure
figure
surfc(X,Y,L)
colorbar
shading interp
% mean values
m = min(min(L));
[x,y] = find(L==m);
m_minus(x)
m_plus(y)
