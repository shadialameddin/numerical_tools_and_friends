% http://gmsh.info/doc/texinfo/gmsh.html
% no PartitionedEntities and only hex + quad
% http://gmsh.info/bin/Linux/

clc

fileID = fopen('cube1.msh','r');

% fgetl(fid)
MeshFormat = textscan(fileID,'%s',3,'Delimiter','\n');
mesh_version = str2double(MeshFormat{1}{2}(1));
assert(mesh_version==4);

PhysicalNames_num = textscan(fileID,'$PhysicalNames \n %d'); % dimension physicalTag name
PhysicalNames = textscan(fileID,'%d %d %s',PhysicalNames_num{1},'Delimiter','\n','CollectOutput',1);
textscan(fileID,'%s',1,'Delimiter','\n');

topological_entities_num = textscan(fileID,'$Entities \n %d %d %d %d'); % numPoints numCurves numSurfaces numVolumes
Entities = textscan(fileID,'%s',sum(cell2mat(topological_entities_num)),'Delimiter','\n');
textscan(fileID,'%s',1,'Delimiter','\n');

Nodes_num = textscan(fileID,'$Nodes \n %d %d'); % numEntityBlocks numNodes
Nodes1 = textscan(fileID,['%d',repmat('%f',[1,3])],sum(cell2mat(Nodes_num)),'Delimiter','\n','CollectOutput',1);
% Nodes2 = textscan(fileID,['%d',repmat('%f',[1,3])],Nodes_num{2},'Delimiter','\n','CollectOutput',1);
NodalPos = Nodes1{2}(2:2:end,:);
assert(length(NodalPos)==Nodes_num{2})
textscan(fileID,'%s',1,'Delimiter','\n');

Elements_num = textscan(fileID,'$Elements \n %d %d');
% Elements = textscan(fileID,'%s',sum(cell2mat(Elements_num)),'Delimiter','\n');
Elements = textscan(fileID,repmat('%d',[1,9]),sum(cell2mat(Elements_num)),'Delimiter','\n','CollectOutput',1,'EmptyValue',-Inf);

fclose('all');


% -refine
% Perform uniform mesh refinement, then exit
% 
% -barycentric_refine
% Perform barycentric mesh refinement, then exit
