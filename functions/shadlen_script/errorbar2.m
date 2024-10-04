function [hsym,hxe,hye] = errorbar2(x,y,xe,ye)
% plots a double errorbar plot.
% [hsym,hxe,hye] = errorbar2(x,y,xe,ye)
% Routine plots x+-xe vs. y+-ye
%
% input args
% ~~~~~~~~~~
% x  vector of x values
% y  vector of y values
% xe  vector of x error 
% ye  vector of y errors
% 
% return args
% ~~~~~~~~~~~
% hsym   handle to symbols
% hex    handle to plot of the x error lines
% hey    handle to plot of the y error lines

% 3/17/98 mns wrote it
% 7/28/03 replaced nans with repmat(nan,...)

x = x(:);
y = y(:);
xe = xe(:);
ye = ye(:);


% This is a trick to get line segments
qy = [y y repmat(nan,size(y))]';
qx = [x x repmat(nan,size(x))]';
qye = [y-ye y+ye repmat(nan,size(y))]';
qxe = [x-xe x+xe repmat(nan,size(x))]';

hxe = plot(qxe(:),qy(:),'k-'); hold on;
hye = plot(qx(:),qye(:),'k-'); hold on;

% Plot the symbols last, so they are in front.
hsym = plot(x,y,'ko');
set(hsym,'MarkerFaceColor','w');

hold off;




