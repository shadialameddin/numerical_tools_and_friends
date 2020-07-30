function [Nodes,Elems,NodesData]=AVSparser(filename,onlyMesh)
%% AVS UCD ASCII Parser for read Nodes, Elems & Datas
% Input :
% Filename : AVS Filepath
% onlyMesh : If you only want Mesh data (Default : false;
%
% output :
% Nodes     : List of Nodes and their position
% Elems     : Structure of Elements
% NodesData  : Structure with Datas exprimed on Nodes
%
% V1 - S. Nachar - 28/05/16

if nargin==1; onlyMesh = false; end

% Open the file
fileID = fopen(filename);

% read the header to find comment line
block = 0;
while ~feof(fileID)
    header=fgetl(fileID);block = block +1;
    if ~ismember(header,char(35)) % Not a Comment line
        break;
    end
end

%% Use header informations
header=sscanf(header,'%d %d %d %d %d');
num_nodes=header(1);num_cells=header(2);
num_ndata=header(3);num_cdata=header(4);
num_mdata=header(5);

%% Catch Nodes
Nodes = fscanf(fileID,'%d %e %e %e',[4,num_nodes]);
Nodes(1,:)=[];
Nodes=Nodes';

%% Catch Elems (<cell_id 1> <mat_id> <cell_type> <cell_vert 1> ... <cell_vert n>)
%! Coded for one type of element for the whole structure
%  But an multielement model could be loaded with an repmat size incrasing
%  and a posttreatment
fgetl(fileID);
% Detect number of elements nodes
FirstElem=fgetl(fileID);
NbNodesParElems=length(regexp(FirstElem,'([0-9])+'))-2;
formatSpec = ['%d %d %s',repmat(' %f',1,NbNodesParElems)];
FirstElem = textscan(FirstElem,formatSpec);
BrutElems = textscan(fileID,formatSpec,num_cells-1);
% Catch Elems
for idComp=1:(NbNodesParElems+3)
    BrutElems{idComp} = [FirstElem{idComp};BrutElems{idComp}];
end
% Structure
Elems = struct;
Elems.materialId = BrutElems{2};
Elems.type = BrutElems{3};
Elems.connect = [BrutElems{4:end}];

%% Catch Node Datas (<num_comp for node data> <size comp 1> <size comp 2>...<size comp n>)
NodesData = struct;
if nargout<3;if ~onlyMesh
    fgetl(fileID);
    idData = 0;
    while ~feof(fileID)
        idData = idData+1;
        % Header Data :
        HeaderData=fgetl(fileID);
        HeaderData=regexp(HeaderData,'([0-9])+','match');
        NbCompNodeData=str2double(HeaderData{1});
        SizeComp = zeros(NbCompNodeData,1);
        NodesData(idData).CompLabel = cell(1,NbCompNodeData);
        % Catch Componants Label
        for idComp=1:NbCompNodeData
            SizeComp(idComp)=str2double(HeaderData{idComp+1});
            TextComp=fgetl(fileID);
            Comp=textscan(TextComp,'%s, %d');
            NodesData(idData).CompLabel{idComp} = Comp{1};
        end
        % Catch Values
        formatSpec = ['%d ',repmat('%f ',1,sum(SizeComp))];
        BrutData = textscan(fileID,formatSpec,num_nodes);
        BrutData(1)=[];
        NodesData(idData).Value=BrutData;
        fgetl(fileID);
    end
    end;end

% Close file
fclose(fileID);

end