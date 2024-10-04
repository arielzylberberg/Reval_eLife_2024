function xvals = bin_dv(dv)

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


[~,vals] = curva_media(dv,loc,[],0);

[~,~,idx] = unique(loc);
xvals = index_to_val(idx,vals);

end

