function xytick = same_xytick(hax,xytick)
if nargin==0
    hax = gca;
end
    
for i=1:length(hax)
    set(gcf,'CurrentAxes',hax(i));
    if nargin<2
        xtick = get(hax(i),'xtick');
        ytick = get(hax(i),'ytick');
        % one with fewer ticks
        if length(xtick)<length(ytick)
            xytick = xtick;
        else
            xytick = ytick;
        end
    end
    set(hax(i),'xtick',xytick,'ytick',xytick);

end