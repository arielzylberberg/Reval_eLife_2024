function xr = redondear(x, ndecimales, flag)
% xr = redondear(x,ndecimales)

if nargin<=2 || isempty(flag)
    flag = 1;
end

switch flag
    case 1
        xr = round(x*10^ndecimales)/10^ndecimales;
    case 2
        xr = floor(x*10^ndecimales)/10^ndecimales;
    case 3
        xr = ceil(x*10^ndecimales)/10^ndecimales;
end

% xr(isnan(x)) = nan; % added, new