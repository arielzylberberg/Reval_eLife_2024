function [newScat,newHist,bothBars,scatPoints] = makeCornerHist(x,y,xe,ye,nbins,xylimits,ratio,optHistc,addHist)
% function [newScat,newHist,bothBars,scatPoints] =
% (makeCornerHist(x,y,xe,ye,nbins,xylimits,ratio,optHistc,addHist)
%
% input args
%   ~~~~~~~~~~
%   x       vector of x values
%   y       vector of y values
%   xe      vector of x error
%   ye      vector of y errors
%   the rest of the inputs are optional:
%   nbins     the number of bins used for histogram. default creates 10
%           bins. can also use a vector (see help hist). all bins may not
%           show up on final plot, depending on how xylimits is set, but
%           all data is used
%   xylimits    vector of two values, the min and max for the scatter plot,
%           (the scatter plot is a square plot, both axis have same limits,
%           leave blank, [], to include all data - default), will affect
%           the size of the histogram, as we attempt to line up the
%           diagonals, and we make the histogram width 2/3 the size of the
%           scatterplot.
%   ratio   Ratio is optional to change the height of the hist plot
%           relative to its width - (ratio = width/height - ie. a ratio of
%           3 means that the height is one third of the width). default
%           ratio = 2, which usually makes a nice plot
%   optHistc    set to 1 to use histc instead of hist so vector in nbins
%           will define edges, not center (see help histc)
%   addHist vector same length as x and y, zeros and ones, ones signify
%           which data points to include in a second histogram (on same
%           graph as first), if desired. (currently not implemented)
%
%   return args
%   ~~~~~~~~~~~
%   newScat     handle to scatter plot axes
%   newHist     handle to hist plot axes
%   bothBars        handles to bars in histogram
%   scatPoints(1)   handle to main diagonal line
%   scatPoints(2)   handle to symbols
%   scatPoints(3)   handle to plot of the x error lines
%   scatPoints(4)   handle to plot of the y error lines
%
%   to change an axis label:
%   set(get(newScat,'XLabel'),'String','2 choice')
%   to add a title: 
%   title(newScat,'Example Plot                         ')
%   to move it up higher:
%   title(newScat,{'Example Plot                                             ';''})
%   need the extra space, because matlab only centers titles, and our
%   histogram will cover up part of the title otherwise...
%   to see how to manipulate the plots, see help cornerHist
%
%   uses additional lab functions cornerHist and errorbar2
%
%   created by Maria Mckinley, May, 2004
%   major update Apr, 2008

if nargin < 9
    addHist = [];
end
if nargin < 8
    optHistc = [];    
end
if nargin < 7
    ratio = 2;
end
if nargin < 6
    xylimits = [];
end
if nargin < 5 || isempty(nbins)
    nbins = 10;
end
if isempty(ratio)
    ratio = 2;
end

scatFig = figure;
hold on
[hsym,hxe,hye] = errorbar2(x,y,xe,ye);
pause(0.1)
set(hsym,'Color', 'r', 'MarkerFaceColor','r')
if isempty(xylimits)
    xlims = get(gca,'Xlim');
    ylims = get(gca,'Ylim');
    newMin = min(xlims(1),ylims(1));
    newMax = max(xlims(2),ylims(2));
    xylimits = [newMin newMax];
end
pause(0.1)
set(gca,'Xlim',xylimits)
set(gca,'Ylim',xylimits)
axis square
set(gca,'TickDir','out','FontSize',14,'Box','off');
line(get(gca,'XLim'), get(gca,'XLim'), 'Color', 'k');
xlabel('w_B (bimodal schedule)');
ylabel('w_B (unimodal schedule)');

histFig = figure;
d = x-y;
if optHistc == 1
    nn = histc(d,nbins);
%     if ~isempty(addHist)
%         N = find(addHist);
%         NN = histc(N,dd);
%     end
    histPlot = bar(nbins,nn,'histc');
else
    [nn dd] = hist(d,nbins);
%     if ~isempty(addHist)
%         N = find(addHist);
%         [NN dd] = hist(N,nbins);
%     end
    histPlot = bar(dd,nn,1);
end
set(gca,'TickDir','out','FontSize',14,'Box','off');
% let's make the histogram width 2/3 the width of the scatterplot, this
% should make a reasonably sized plot.
xlimit = 0.66 * (xylimits(2)-xylimits(1));
xlim([-xlimit xlimit]);
hold on
%shading flat
if ~isempty(addHist)
    set(histPlot,'FaceColor',[1 1 1])
    histPlot2 = bar(dd,NN,0.9);
    set(histPlot2,'FaceColor',[0.6 0.6 0.6])
    set(histPlot2,'EdgeColor','none')
else
    set(histPlot,'FaceColor',[0.6 0.6 0.6])
end
[newScat, newHist] = cornerHist(scatFig,histFig,ratio);
bothBars = get(newHist,'Children');
scatPoints = get(newScat, 'Children');
