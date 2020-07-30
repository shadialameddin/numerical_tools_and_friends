function xdmf3writer(filepath,Grid)
system(sprintf('rm %s.h5',filepath));
id = regexpi(filepath,filesep);
if isempty(id)
    filename = filepath;
else
    filename = filepath(id(end)+1:end);
end
global docNode
docNode = com.mathworks.xml.XMLUtils.createDocument('Xdmf');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('Version','2.0');
h5creation(filepath,Grid);
if exist(filepath,'file'); return; end
DomainNode = docNode.createElement('Domain');
nbf = numel(Grid.fields);
nbt = size(Grid.fields(1).data,2);

%% Create Time Grid
GridsTimeNode = docNode.createElement('Grid');
GridsTimeNode.setAttribute('GridType','Collection');
GridsTimeNode.setAttribute('CollectionType','Temporal');

for idt = 1:nbt
GridTimeStep = docNode.createElement('Grid');
GridTimeStep.setAttribute('GridType','Uniform');
TimeStep = docNode.createElement('Time');
TimeStep.setAttribute('Value',sprintf('%f',idt-1));
GridTimeStep.appendChild(TimeStep);
GridTimeStep.appendChild(TopologyRef);
GridTimeStep.appendChild(GeometryRef);
for idf = 1:nbf
	Attribute = docNode.createElement('Attribute');
	Attribute.setAttribute('AttributeType',Grid.fields(idf).type);
	Attribute.setAttribute('Name',Grid.fields(idf).name);
	Attribute.setAttribute('Center',Grid.fields(idf).center);
    tmp_HS = Fields(idf,idt);
	Attribute.appendChild(tmp_HS);
	GridTimeStep.appendChild(Attribute);
end
GridsTimeNode.appendChild(GridTimeStep);
end
DomainNode.appendChild(GridsTimeNode);
docRootNode.appendChild(DomainNode);
xmlFileName = sprintf('%s.xdmf',filepath);
xmlwrite(xmlFileName,docNode);

function Out = DataItemNode
Out = docNode.createElement('DataItem');
Out.setAttribute('Format','HDF');
Out.setAttribute('Precision','8');
end

function Out = TopologyRef
Out = docNode.createElement('Topology');
Out.setAttribute('TopologyType','Mixed');
Out.setAttribute('NumberOfElements',sprintf('%d',Grid.nbElements));

DataItemT = DataItemNode;
tmp = sprintf('%d ',size(Grid.topology));tmp(end) = [];
DataItemT.setAttribute('Dimensions',tmp);
DataItemT.appendChild(docNode.createTextNode(sprintf('%s.h5:/Topology',filename)));
Out.appendChild(DataItemT);
end

function Out = Fields(idf,idt)
	Out = DataItemNode;
	Out.setAttribute('Name',Grid.fields(idf).name)
	Out.setAttribute('Dimensions',Grid.fields(idf).dimensions);
	Out.appendChild(docNode.createTextNode(sprintf('%s.h5:/%s/Time %04d',filename,Grid.fields(idf).name,idt)));
end

function Out = GeometryRef
Out = docNode.createElement('Geometry');
Out.setAttribute('GeometryType','XYZ');
DataItemG = DataItemNode;
tmp = sprintf('%d ',size(Grid.geometry));tmp(end) = [];
DataItemG.setAttribute('Dimensions',tmp);
DataItemG.appendChild(docNode.createTextNode(sprintf('%s.h5:/Geometry',filename)));
Out.appendChild(DataItemG);
end
end

function h5creation(filename,Grid)
    h5create(sprintf('%s.h5',filename),'/Geometry',flip(size(Grid.geometry)));
    h5write(sprintf('%s.h5',filename),'/Geometry',Grid.geometry');
    h5create(sprintf('%s.h5',filename),'/Topology',flip(size(Grid.topology)));
    h5write(sprintf('%s.h5',filename),'/Topology',Grid.topology');
for id = 1:numel(Grid.fields)
    for idt = 1:size(Grid.fields(id).data,2)
        h5create(sprintf('%s.h5',filename),sprintf('/%s/Time %04d',Grid.fields(id).name,idt),[1 size(Grid.fields(id).data,1)]);
        h5write(sprintf('%s.h5',filename),sprintf('/%s/Time %04d',Grid.fields(id).name,idt),Grid.fields(id).data(:,idt)');
    end    
end
end