function [Grids, metadata] = readpxdmf2(filename,varargin)
%
% Function to read a (P)XDMF file:
%
%    [Grids, metadata] = readpxdmf2(filename,'OPTION_NAME1',VALUE1, ...)
%
%    The output is a vector with XdmfGrid containing the data
%    metadata is writepxdmfset with the metadata of the file
%
%    filename    : the file to read
%
%    options are :
%
%         temporalGrids: if each grid must be treated as one time evolving domain [ true | {false} ]
%                  xdmf: if each grid must be treated as subdomain of a macro domain [ true | {false} ]
%               verbose: On screen display [ true | {false} ]
%
% also can be used like
%   
%    readpxdmf2 with no input/ouput will display this message 
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%

if (nargin == 0)
  if  (nargout == 0)
    help readpxdmf2
    return;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Metadat of the file 
opt.filename = filename;
opt.binary = false;
opt.precision = 'double';
opt.HDF5   = false;
opt.verbose = 0;
opt.temporalGrids = false;
opt.xdmf = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% internal metadata
opt.path = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path calcul
offset2 = strfind(filename,filesep);
if ~isempty(offset2)
    opt.path =filename(1:offset2(end));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% treating options
for k = 1:length(varargin)
    if strcmpi(varargin{k}, 'verbose')
        opt.verbose = logical(varargin{k+1});
    end
    if strcmpi(varargin{k}, 'xdmf')
        opt.xdmf = logical(varargin{k+1});
    end
    if strcmpi(varargin{k}, 'temporalGrids')
        opt.temporalGrids = logical(varargin{k+1});
    end 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forming the filename
%
[opt.Int_path ,~,EXT] = fileparts(filename);

if isempty(EXT )
    if opt.xdmf
        filename = [filename '.xdmf' ];
    else
        filename = [filename '.pxdmf' ];
    end
else
    if strcmpi(EXT,'.xdmf')
        opt.xdmf = true;
    end
    if strcmpi(EXT,'.xmf')
        opt.xdmf = true;
    end
end

if ~isempty(opt.Int_path)
    opt.Int_path = [opt.Int_path filesep ];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if opt.verbose
    disp('*******  Reading  ******* ' )
    disp(['File :' filename])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading the pxdmf file

% to disable DTD
dbf = javaMethod('newInstance', 'javax.xml.parsers.DocumentBuilderFactory');
dbf.setFeature('http://apache.org/xml/features/nonvalidating/load-external-dtd', false);

% parse the file 
opt.xDoc = xmlread(filename,dbf);
xRoot = opt.xDoc.getDocumentElement;


%% Get all grids in the first level
allGrids = GetElementsByTagNameFisrtLevel(xRoot.getElementsByTagName('Domain').item(0), 'Grid');

%% if the first level is a Collection then recover all the grids in the second level
if(numel(allGrids) > 0)
    if(allGrids(1).hasAttribute('GridType'))
        if(strcmpi( char(allGrids(1).getAttribute('GridType') ) , 'Collection' ) )
            allGrids = GetElementsByTagNameFisrtLevel(allGrids(1), 'Grid');
        end
    end
end

%% 


nb_Grids = numel(allGrids);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization of the output
Grids(nb_Grids) = XdmfGrid();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading of each grid

for i = 0:nb_Grids-1

    Grid = allGrids(i+1);
    
    if ~opt.xdmf
        GridToRead = Grid;
        
        [names, units,extras , opt] = read_information(GridToRead, opt);
        Grids(i+1).coordNames = names;
        Grids(i+1).coordUnits = units;
        Grids(i+1).extraInformation = extras; 
        
        %%Grids(i+1)
        [topo, topotype,geo,opt ]= read_topology_and_geometry(GridToRead, opt);
        Grids(i+1).topology = topo;
        Grids(i+1).geometry = geo;
        Grids(i+1).type = topotype;
        t = i+1;
        ioffset = 1;
        read_attributes();
        %%%%%%%%%%%
        
    else
        % loop over the timesteps
        % if not a temporal collection then only one grid
        %timeGrids = Grid.getElementsByTagName('Grid');
      
      if GetGridType(Grid) == 1 
         ioffset = 1;
         t = 1;
         GridToRead = Grid;
         [topo, topotype,geo,opt ]= read_topology_and_geometry(GridToRead, opt);
         Grids(i+ioffset).topology = topo;
         Grids(i+ioffset).geometry = geo;
         Grids(i+ioffset).type = topotype;
         read_attributes();
      else
        timeGrids = GetElementsByTagNameFisrtLevel(Grid, 'Grid');
        nb_timesteps = numel(timeGrids);
        if (nb_timesteps)
            if opt.verbose
                disp(['Number of time steps ' num2str(nb_timesteps)  ]);
            end
        else
            timeGrids = Grid;
            nb_timesteps = 1;
        end
        
        for t = 1: nb_timesteps
            if opt.verbose
                disp(['Reading step ' num2str(t)  ]);
            end
            GridToRead = timeGrids(t);
            if opt.temporalGrids
                [topo, topotype,geo,opt ]= read_topology_and_geometry(GridToRead, opt);
                Grids(i+t).topology = topo;
                Grids(i+t).geometry = geo;
                Grids(i+t).type = topotype;
                ioffset = t;
            else
              if t == 1 
                [topo, topotype,geo,opt ]= read_topology_and_geometry(GridToRead, opt);
                Grids(i+1).topology = topo;
                Grids(i+1).geometry = geo;
                Grids(i+1).type = topotype;
              end
              ioffset = 1;
            end
            
            read_attributes();
          end
        end
    end
end

if opt.verbose
    disp('*************************' )
end

    function read_attributes()
        
        
        Attributes = GridToRead.getElementsByTagName('Attribute');
        nb_Attributes = Attributes.getLength;
        % TODO to clean
        %disp(['Number of attribustes ' int2str(nb_Attributes) ])
        for j = 0:nb_Attributes-1
            name = char(Attributes.item(j).getAttribute('Name'));
            
            type = Attributes.item(j).getAttribute('Center');
            if opt.xdmf || strcmpi(type,'Grid') 
                mode = t-1;
                if opt.temporalGrids
                    mode = 0;
                end
                field_name = deblank(name);
            else
                offset1 = strfind(name,'_');
                if isempty(offset1)
                    disp(['Warning field "' name '" does not contain a _, ignoring...'])
                    continue
                end
                field_name = strtrim(deblank(name(1:offset1(end)-1)));
                mode = str2double(strtrim(deblank(name(offset1(end)+1:end))));
            end
            DataItemAttributes = Attributes.item(j).getElementsByTagName('DataItem').item(0);
            %disp('***')
            %disp(DataItemAttributes)
            
            % read data only if we know where to put it
            if strcmpi(type,'Cell') || strcmpi(type,'Node') || strcmpi(type,'Grid')
                [AttributeData, opt] = Read_data_Item(DataItemAttributes, opt);
            end
            
            % puting data in the output structure
            if strcmpi(type,'Node')
                TF = strcmpi(field_name,Grids(i+ioffset).nodeFieldsNames);
                index = 0;
                for k1 =1:size(TF,2)
                    if TF(1,k1) == 1
                        index = k1;
                    end
                end
                if index==0
                    %try %TODO to clean
                    Grids(i+ioffset).nodeFieldsNames{size(Grids(i+ioffset).nodeFieldsNames,1),size(Grids(i+ioffset).nodeFieldsNames,2)+1} = field_name;
                    %catch
                    %    keyboard
                    %end
                    index = size(Grids(i+ioffset).nodeFieldsNames,2);
                end
                
                switch topotype
                    case { 'ConstRectilinear' 'Rectilinear' }
                        switch numel(size(AttributeData))
                            case 3
                             AttributeData =   reshape(permute(AttributeData,[2 1 3]),[],1);      
                            case 2
                             AttributeData =   reshape(AttributeData',[],1);   
                        end
                            
                    otherwise
                        if(size(AttributeData,2)~=1 )
                            AttributeData =   reshape(AttributeData',[],1);
                        end
                end
                
                
                Grids(i+ioffset).nodeFields{1,index}(:,mode+1) = AttributeData;
                
            else
              if strcmpi(type,'Cell')
                TF = strcmpi(field_name,Grids(i+ioffset).elementFieldsNames);
                index = 0;
                for k2 =1:size(TF,2)
                    if TF(1,k2) == 1
                        index = k2;
                    end
                end
                if index==0
                    Grids(i+ioffset).elementFieldsNames{size(Grids(i+ioffset).elementFieldsNames,1),size(Grids(i+ioffset).elementFieldsNames,2)+1} = field_name;
                    index = size(Grids(i+ioffset).elementFieldsNames,2);
                end
                if(size(AttributeData,2)~=1)
                    AttributeData =   reshape(AttributeData',[],1);
                end
                
                Grids(i+ioffset).elementFields{1,index}(:,mode+1) = AttributeData;
              else
                if(strcmpi(type,'Grid') )
                    TF = strcmpi(field_name,Grids(i+ioffset).gridFieldsNames);
                    index = 0;
                    for k2 =1:size(TF,2)
                        if TF(1,k2) == 1
                            index = k2;
                        end
                    end
                    
                    %% if field not found we put a new one
                    if index==0
                        Grids(i+ioffset).gridFieldsNames{size(Grids(i+ioffset).gridFieldsNames,1),size(Grids(i+ioffset).gridFieldsNames,2)+1} = field_name;
                        index = size(Grids(i+ioffset).gridFieldsNames,2);
                    end
                    %% reshape of the data
                    if(size(AttributeData,2)~=1)
                        AttributeData =   reshape(AttributeData',[],1);
                    end
                    %% we insert the data into the structure
                    Grids(i+ioffset).gridFields{1,index}(:,1) = AttributeData;
                else
                    disp(['Warning data type ' char(type) ' not readed'])    
                end
                
              end
                
            end
        end
        
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization of the metadata
metadata = writexdmf2();
metadata.filename = filename;
metadata.binary = opt.binary ;
metadata.precision = opt.precision ;
metadata.HDF5 = opt.HDF5   ;
metadata.temporalGrids = opt.temporalGrids ;
metadata.xdmf = opt.xdmf ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [topo, topotype, geo,opt] = read_topology_and_geometry(Grid,opt)

topotype = char(Grid.getElementsByTagName('Topology').item(0).getAttribute('TopologyType'));

if numel(topotype ) == 0
    topotype = char(Grid.getElementsByTagName('Topology').item(0).getAttribute('Type'));
end

switch upper(topotype)
    case '3DCORECTMESH'
        topotype = 'ConstRectilinear';
        
        temp = Grid.getElementsByTagName('Topology').item(0).getAttribute('Dimensions');
        topo = int32(fliplr(str2num(temp))-1);
        
        [DataItemGeometryOrigin, opt] = Read_data_Item(Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem').item(0), opt);
        DataItemGeometryOrigin = DataItemGeometryOrigin';
        [DataItemGeometrySpacing, opt] = Read_data_Item(Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem').item(1), opt);
        DataItemGeometrySpacing = DataItemGeometrySpacing';
        geo = zeros(2,3);
        
        geo(1,:) = fliplr(reshape(DataItemGeometryOrigin,1,[]));
        geo(2,:) = fliplr(reshape(DataItemGeometrySpacing,1,[]));
        
    case '3DRECTMESH'
        topotype =  'Rectilinear'               ;
        
        temp = Grid.getElementsByTagName('Topology').item(0).getAttribute('Dimensions');
        topo = int32(fliplr(str2num(temp))-1);
        thegeodataitems = Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem');
        
        [DGX,opt] = Read_data_Item(thegeodataitems.item(0), opt);
        [DGY,opt] = Read_data_Item(thegeodataitems.item(1), opt);
        [DGZ,opt] = Read_data_Item(thegeodataitems.item(2), opt);
        geo = zeros(max([numel(DGX) numel(DGY) numel(DGZ)]),3);
        geo(1:numel(DGX),1) = DGX;
        geo(1:numel(DGY),2) = DGY;
        geo(1:numel(DGZ),3) = DGZ;
    otherwise
        
        [ditem, opt] = get_DeReferenceItem(Grid.getElementsByTagName('Topology').item(0), opt);
        DataItemTopology = ditem.getElementsByTagName('DataItem').item(0);
        
        [topo,opt] = Read_data_Item(DataItemTopology, opt);
        
        [ditem, opt] = get_DeReferenceItem(Grid.getElementsByTagName('Geometry').item(0), opt);
        DataItemGeometry =  ditem.getElementsByTagName('DataItem').item(0);
        
        
        [geo, opt] = Read_data_Item(DataItemGeometry, opt);
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Oitem,opt] = get_DeReferenceItem(item,opt)

Oitem = item;
if(item.hasAttribute('Reference') )
    referencetype = char(item.getAttribute('Reference'));
    if strcmpi(referencetype, 'XML')
         % Import the XPath classes
         import javax.xml.xpath.*
         % Create an XPath expression.
         factory = XPathFactory.newInstance;
          xpath = factory.newXPath;
          expression = xpath.compile(item.getFirstChild.getData);
        
          % Apply the expression to the DOM.
          nodeList = expression.evaluate(opt.xDoc,XPathConstants.NODESET);
          Oitem =  get_DeReferenceItem(nodeList.item(0));
    end
else
    return 
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dim_name, dim_units,extras, opt] = read_information(Grid, opt)
Infos = Grid.getElementsByTagName('Information');
nb_dims = GetNbOfDimsInGrid(Infos);
dim_name = cell(1,nb_dims);
dim_units = cell(1,nb_dims);
extras = {};
for k = 0:Infos.getLength-1
     read = false;
     for j = 0: nb_dims -1
        if strcmpi(Infos.item(k).getAttribute('Name') ,['Dim'  num2str(j)])
            dim_name{j+1} = char(Infos.item(k).getAttribute('Value'));
            if isempty(dim_name{j+1})
                dim_name{j+1} = char(Infos.item(k).getFirstChild.getData);
            end
            read = true;
        end
        if  strcmpi(Infos.item(k).getAttribute('Name') ,['Unit'  num2str(j)])
            dim_units{j+1} = char(Infos.item(k).getAttribute('Value'));
            if isempty(dim_units{j+1}) && ~isempty(Infos.item(k).getFirstChild)
                dim_units{j+1} = char(Infos.item(k).getFirstChild.getData);
            end
            read = true;
        end
        if  strcmpi(Infos.item(k).getAttribute('Name') ,'Dims')
            read = true;
        end

     end
    if read ; continue; end
    Name = char(Infos.item(k).getAttribute('Name'));
    Value = char(Infos.item(k).getAttribute('Value'));
    extras = [extras Name Value];    
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, opt]  = Read_data_Item(DataItem, opt)

if (DataItem.hasAttribute('Reference'))
    referencetype = char(DataItem.getAttribute('Reference'));
    if strcmpi(referencetype, 'XML')
        % Import the XPath classes
        import javax.xml.xpath.*
        % Create an XPath expression.
        factory = XPathFactory.newInstance;
        xpath = factory.newXPath;
        expression = xpath.compile(DataItem.getFirstChild.getData);
        
        % Apply the expression to the DOM.
        nodeList = expression.evaluate(opt.xDoc,XPathConstants.NODESET);
        [data, opt] = Read_data_Item(nodeList.item(0), opt);
    end
else
    format = char(DataItem.getAttribute('Format'));
    if strcmp(char(DataItem.getAttribute('NumberType')), 'Float')  &&   (str2num(char(DataItem.getAttribute('Precision'))) == 4 )
      opt.precision = 'single';
    end
    if strcmpi(format, 'XML')
        [data, opt] = Read_data_Item_XML(DataItem, opt);
    else
        if strcmpi(format, 'HDF')
            [data, opt] = Read_data_Item_H5(DataItem, opt);
        else
            [data, opt] = Read_data_Item_BIN(DataItem, opt);
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, opt] = Read_data_Item_XML(DataItem, opt)


Dimensions = str2num(DataItem.getAttribute('Dimensions'));
%NumberType = char(DataItem.getAttribute('NumberType'));
%%data = str2num(DataItem.getFirstChild.getData.replaceAll('\n',' '));

if(DataItem.hasAttribute('NumberType'))
    type = DataItem.getAttribute('NumberType');
else
    type = DataItem.getAttribute('DataType');
end

switch lower(char(type))
    case 'int'
        
        if (~DataItem.hasAttribute('Precision')) ||  strcmpi(DataItem.getAttribute('Precision'), '4')
            data = int32(sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%i'));
        else
            data = int64(sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%li'));

        end
    case 'uint'
        data = sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%i');
        if (~DataItem.hasAttribute('Precision')) ||  strcmpi(DataItem.getAttribute('Precision'), '4')
            data = uint32(data);
        else
            data = uint64(data);
        end
    case 'char'
        data = int8(sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%i'));
    case 'uchar' 
        data = uint8(sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%i'));
    case 'float'
        data = sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%f');
        if strcmpi(DataItem.getAttribute('Precision'), '4')
            data = single(data);
        end
    
        
    otherwise
        disp('Warning Unknow data type using float')
        data = sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%f');
end
%disp('--------------')
%disp(Dimensions)
%disp(data)
if numel(Dimensions) == 2
    data = reshape(reshape(data',1,[]), fliplr(Dimensions) )';
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, opt] = Read_data_Item_H5(DataItem, opt)
opt.HDF5 = true;
Dimensions = str2num(DataItem.getAttribute('Dimensions'));
%NumberType = char(DataItem.getAttribute('NumberType'));
H5_file_and_path = char(DataItem.getFirstChild.getData);
offset1 = strfind(H5_file_and_path,':');
offset2 = strfind(H5_file_and_path,'/');
file = strtrim(deblank(H5_file_and_path(1:offset1-1)));
status = H5F.is_hdf5([opt.path file]);
if status ==0
    disp(['File ' file ' is not a h5 file'])
    return
else
    if status == -1
        disp(['File ' file ' corrupted. Sorry'])
        return
    end
end

if (isempty(offset2))
    path ='';
    offset2 = offset1;
else
    path = strtrim(deblank(H5_file_and_path(offset1+1:offset2(end))));
end
dataset = strtrim(deblank(H5_file_and_path(offset2(end)+1:end)));

%Open the File
H5_file = H5F.open([opt.path file], 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%Open the Dataset
datasetID = H5D.open(H5_file, [path dataset]);
%Read with no offset
data = H5D.read(datasetID, 'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%if (size(data,1) ~= Dimensions(1))
%    data =data';
%end
%if numel(Dimensions) ~= 1
%    data = reshape(data, fliplr(Dimensions))';
%end

if numel(Dimensions) == 2
    data = reshape(reshape(data,1,[]), fliplr(Dimensions) )';
else 
    data = reshape(data,[],1);
end

H5F.close(H5_file);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, opt] = Read_data_Item_BIN(DataItem, opt)
opt.binary = true;
Dimentions = fliplr(str2num(DataItem.getAttribute('Dimensions')));
BIN_file_and_path = char(DataItem.getFirstChild.getData) ;
file = [ opt.path strtrim(deblank(BIN_file_and_path))];

seek = str2num(DataItem.getAttribute('Seek'));
format = 'ieee-';

if strcmpi(DataItem.getAttribute('Endian'), 'Big')
    format = [format 'be'];
else
    format = [format 'le'];
end

str = DataItem.getAttribute('NumberType');

if DataItem.hasAttribute('Precision')
    if strcmpi(DataItem.getAttribute('Precision'), '8')
        format = [format '.l64'];
    end
end

[bin_file, MESSAGE] = fopen( file,'r',format);
if bin_file < 0
    disp(MESSAGE);
end
fseek(bin_file,seek,-1);

str = DataItem.getAttribute('NumberType');

switch lower(char(str))
    case 'int'
        if numel(Dimentions) == 2
            prodD = Dimentions;
        else
            prodD = prod(Dimentions);
        end
        
        if DataItem.hasAttribute('Precision')
            Prec = DataItem.getAttribute('Precision');
        else
            Prec = '4';
        end
        
        if strcmpi(Prec, '8')
            data = fread(bin_file, prodD, 'int64=>int64')';
        else
            data = fread(bin_file, prodD, 'int32=>int32')';
        end
    case 'char'
        data = fread(bin_file, prod(Dimentions), 'int8=>int8')';    
    case 'uchar'
        data = fread(bin_file, prod(Dimentions), 'uchar=>uchar')';    
    case 'float'
      Prec = DataItem.getAttribute('Precision');
      if strcmpi(Prec, '8')
        if numel(Dimentions) == 2
            data = fread(bin_file, Dimentions, 'double=>double')';
        else
            data = fread(bin_file, prod(Dimentions), 'double=>double')';
        end
      else
        if numel(Dimentions) == 2
            data = fread(bin_file, Dimentions, 'single=>single')';
        else
            data = fread(bin_file, prod(Dimentions), 'single=>single')';
        end
      end 
    otherwise
        disp('ERROR dont know how to read the binary data')
        disp(lower(char(str)))

end



if strcmpi(DataItem.getAttribute('NumberType'), 'int')
    
else
    

end

fclose(bin_file);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nb_dims = GetNbOfDimsInGrid(Infos)
for i=0:Infos.getLength-1
    if  strcmpi(Infos.item(i).getAttribute('Name'), 'Dims')
        break;
    end
end
nb_dims = str2num(Infos.item(i).getAttribute('Value'));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = GetElementsByTagNameFisrtLevel(father, Name)
cpt = 1;
childs = father.getChildNodes();
numberofchild = father.getChildNodes.getLength();
for i = 0:numberofchild -1;
    item = childs.item(i);
    if strcmp(char(item.getNodeName()),'Grid')
        res(cpt) = item;
        cpt = cpt + 1;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = GetGridType(Grid)
% 1 Uniform
% 0 Other
res = 1;
if Grid.hasAttribute('GridType')
    res = strcmpi(Grid.getAttribute('GridType'), 'Uniform');
end

end
