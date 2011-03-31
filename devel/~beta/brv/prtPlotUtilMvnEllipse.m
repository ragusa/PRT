function varargout = prtPlotUtilMvnEllipse(mu,Sigma,nStds,n)
% PLOTMVNELLIPSE plots the confidence region of a multivariate Gaussian
%
% Syntax: [ellipseHandle, contourXY] = plotMvnEllipse(mu,Sigma,nStds)
%
% Adapted From: http://www.mathworks.com/matlabcentral/fileexchange/8793
% Then re-adpated from Beals Mixture of Factor Analyzes Code

assert(ismember(numel(mu),[2 3]),'plotMvnEllipse only works in 2 dimensions.');

if nargin < 3 || isempty(nStds)
    nStds = 1;
end
if nargin < 4 || isempty(n)
    n = 20;
end
mu = mu(:);

switch numel(mu)
    case 2
        theta = (0:1:n-1)/(n-1)*2*pi;
    
        epoints = nStds*sqrtm(Sigma) * [cos(theta); sin(theta)]*1   + mu*ones(1,n);
        
        ellipseHandle = plot(epoints(1,:),epoints(2,:),'LineWidth',3);
        
    case 3
        theta = (0:1:n-1)'/(n-1)*pi;
        phi = (0:1:n-1)/(n-1)*2*pi;
        
        sx = sin(theta)*cos(phi);
        sy = sin(theta)*sin(phi);
        sz = cos(theta)*ones(1,n);
        
        svect = [reshape(sx,1,n*n); reshape(sy,1,n*n); reshape(sz,1,n*n)];
        epoints = nStds*sqrtm(Sigma) * svect  + mu*ones(1,n*n);
        
        ex = reshape(epoints(1,:),n,n);
        ey = reshape(epoints(2,:),n,n);
        ez = reshape(epoints(3,:),n,n);
        
        ellipseHandle = mesh(ex,ey,ez);
end
% [Ev,D] = eig(Sigma);
% iV = inv(Sigma);
%
% % Find the l    arger projection
% P = [1,0;0,0];  % X-axis projection operator
% P1 = P * 2*sqrt(D(1,1)) * Ev(:,1);
% P2 = P * 2*sqrt(D(2,2)) * Ev(:,2);
% if abs(P1(1)) >= abs(P2(1)),
%     Plen = P1(1);
% else
%     Plen = P2(1);
% end
% count = 1;
% step = 0.001*Plen;
% Contour1 = zeros(2001,2);
% Contour2 = zeros(2001,2);
% for x = -Plen:step:Plen,
%     a = iV(2,2);
%     b = x * (iV(1,2)+iV(2,1));
%     c = (x^2) * iV(1,1) - 1;
%     Root1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
%     Root2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);
%     if isreal(Root1),
%         Contour1(count,:) = [x,Root1] + mu(:)';
%         Contour2(count,:) = [x,Root2] + mu(:)';
%         count = count + 1;
%     end
% end
% Contour1 = Contour1(1:count-1,:);
% Contour2 = [Contour1(1,:);Contour2(1:count-1,:);Contour1(count-1,:)];
%
% contourXY = cat(1,Contour1,flipud(Contour2));
%
% ellipseHandle = plot(contourXY(:,1),contourXY(:,2));

varargout = {};
if nargout
    varargout = {ellipseHandle};
end

end