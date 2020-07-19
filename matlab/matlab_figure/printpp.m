function printpp(varargin)
%% Function Printpp
% printpp(name,varargin);
% printpp(h,name,varargin);
% Sauvegarde Organis�e Rapide de la figure (FIG, PNG, et TIKZ dans le cadre
% de la current figure
% 
test=false;
if ischar(varargin{1});h=gcf;name=varargin{1};varargin(1)=[];test=true;       % Cas printpp(name,varargin) -> gcf 
elseif ischar(varargin{2});h=varargin{1};name=varargin{2};
else error('L''expression de printpp ne convient pas : cf Help'); end; % Cas printpp(h,name,varargin) 

name = sprintf(name,varargin{:});

    id = regexpi(name,filesep);
    if isempty(id)
        dirname = [];
    else
        dirname = name(1:id(end)-1);
        name    = name(id(end)+1:end);        
    end

% Save Fig
if ~isdir([dirname filesep 'FIG']);mkdir([dirname filesep 'FIG']);end
savefig(h,[dirname filesep 'FIG' filesep name '.fig']);

% Save png
if ~isdir([dirname filesep 'PNG']);mkdir([dirname filesep 'PNG']);end
print(h,[dirname filesep 'PNG' filesep name],'-dpng','-r300');

% Save EPS
if ~isdir([dirname filesep 'EPS']);mkdir([dirname filesep 'EPS']);end
print(h,[dirname filesep 'EPS' filesep name],'-depsc');

% Save tikz
if ~isdir([dirname filesep 'TIKZ']);mkdir([dirname filesep 'TIKZ']);end
matlab2tikz([dirname filesep 'TIKZ' filesep name '.tex']);%['TIKZ' filesep name]

end
