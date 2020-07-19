% Copyright (c) 2012-, Bram Vandoren (bram.vandoren@uhasselt.be, Hasselt University) & Angelo Simone (a.simone@tudelft.nl, Delft University of Technology)

% Coded by Bram Vandoren - 17 April 2013

function plotfade(X,Y,fadesteps)

hold on
backgroundcolor = get(gca,'Color');
firstcolor = [0 0 1];   % blue
lastcolor = backgroundcolor;
interpcolor = zeros(fadesteps+1,3);
for step = 0:fadesteps
    interpcolor(step+1,:) = firstcolor + ((lastcolor-firstcolor)./fadesteps).*step;
end

for icolor = 1:fadesteps
    if icolor == 1
        set(findobj('Type','line','Color',interpcolor(fadesteps-icolor+1,:)),'Visible','off') % make line with lightest colour invisible
    else
        set(findobj('Type','line','Color',interpcolor(fadesteps-icolor+1,:)),'Color',interpcolor(fadesteps-icolor+2,:),'LineWidth',1) % make line lighter
    end
end

set(findobj('Type','line','Color','r'),'Color',interpcolor(1,:),'LineWidth',1) % turn red into blue

plot(X,Y,'-rs','LineWidth',2,'MarkerSize',3) % plot in red  
