function xvals = get_xvals_for_plot(dv, loc_flag)

if nargin<2 || isempty(loc_flag)
    loc_flag = 1;
end

switch loc_flag
    case 1
        loc(dv<=-1.5) = -2;
        loc(dv<=-.75 & dv>-1.5) = -1;
        loc(dv<=-.375 & dv>-.75) = -.5;
        loc(dv<=-.1875 & dv>-.375) = -.25;
        loc(dv<=-.0625 & dv>-.1875) = -.125;
        loc(dv>-.0625 & dv<.0625) = 0;
        loc(dv>=.0625 & dv<.1875) = .125;
        loc(dv>=.1875 & dv<.375) = .25;
        loc(dv>=.375 & dv<.75) = .5;
        loc(dv>=.75 & dv<1.5) = 1;
        loc(dv>=1.5) = 2;
    case 2
        [uni_dvs,idx_dvs] = index_prctile(abs(dv),[0:20:100]);
        uni_dvs(1) = 0;
        loc = uni_dvs(idx_dvs)'.*sign(dv);
    case 3
        u = linspace(-100,100,12);
        u(u<0) = [];
        u = [0,u];
        
        [uni_dvs,idx_dvs] = index_prctile(abs(dv),u);
        uni_dvs(1) = 0;
        loc = uni_dvs(idx_dvs)'.*sign(dv);

end


[~,vals] = curva_media(dv,loc,[],0);

[~,~,idx] = unique(loc);
xvals = index_to_val(idx,vals);

end