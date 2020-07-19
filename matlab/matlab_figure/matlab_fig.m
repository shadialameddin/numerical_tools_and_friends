clc
% close all
clear all
% The new defaults will not take effect if there are any open figures. To
% use them, we close all figures, and then repeat the first example.

width = 4*100;     % Width in inches
height = 3*100;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz

% Set the default Size for display
defpos = get(0,'defaultFigurePosition');
set(0,'defaultFigurePosition', [defpos(1) defpos(2) width, height]);

% Set the defaults for saving/printing to a file
set(0,'defaultFigureInvertHardcopy','on'); % This is the default anyway
set(0,'defaultFigurePaperUnits','points'); % This is the default anyway
defsize = [8.27,11.69]; % get(gcf, 'PaperSize');
left = (defsize(1)- width)/2;
bottom = (defsize(2)- height)/2;
defsize = [0, 0, width, height];
set(0, 'defaultFigurePaperPosition', defsize);

% Now we repeat the first example but do not need to include anything
% special beyond manually specifying the tick marks.
figure
hold on
grid on
box on

x=-pi:3*2*pi;
y=sin(x);
plot(x,y,'b-',x+pi/2,y,'r--',x+3*pi/2,y,'g*','LineWidth',lw,'MarkerSize',msz);
xlim([-pi pi]);
legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'SouthEast');
xlabel('x');
title('Automatic');
set(gca,'XTick',-3:3); %<- Still need to manually specific tick marks
set(gca,'YTick',0:10); %<- Still need to manually specific tick marks

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.Units= 'points';
fig.PaperPosition=[0 0 width height];
fig.PaperSize=[width height];

% set(gca,'Color','none');
% set(gcf, 'Color', 'none');


legend({'$y=\sin(t)$'},...
'FontUnits','points',...
'interpreter','latex',...
'FontSize',7,...
'FontName','Times',...
'Location','NorthEast')

ax=gca;
ax.LineWidth
ax.FontSize=15
ax.FontName='times'

print(gcf,'improvedExample','-depsc2');
close gcf

% filename = 'demo4.eps';
% print(gcf,'-depsc',filename,'-painters','-loose'); % loose option stops matlab
% print(gcf,'-depsc',filename); % loose option stops matlab


% pu = get(gcf,'PaperUnits');
% pp = get(gcf,'PaperPosition');
% set(gcf,'Units',pu,'Position',pp)

% print('example', '-dpng', '-r300');
% print('ScreenSizeFigure','-dpng','-r0')

% print -dpdf -painters epsFig
% print(gcf, '-depsc2', 'my-figure.eps');

% \psfrag{text in eps to replace}[l][l]{text in latex to use}

% transparent background in eps file - comment out lines in the eps file that read: ”X X X PR” or
% ”X X X X MP”, where X is some number.
% • Latex trick: use the layout package to find out how wide the page is for setting figure dimensions.