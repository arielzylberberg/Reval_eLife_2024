function xylim = same_xylim(hax,xylim)
for i=1:length(hax)
    set(gcf,'CurrentAxes',hax(i));
    if nargin==1
        xli=xlim;
        yli=ylim;
        xylim(1)=min(xli(1),yli(1));
        xylim(2)=max(xli(2),yli(2));
    end
    xlim(xylim)
    ylim(xylim)
end