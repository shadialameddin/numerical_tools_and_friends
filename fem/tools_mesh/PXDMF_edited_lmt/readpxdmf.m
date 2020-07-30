function data = readpxdmf(filename,varargin)
%
% Function to write a XDMF file:
%
%    data = readpxdmf(filename, <options>, ...)
%
%    filename : file name Note : it will add .pxdmf if the filename doesn't
%               have it
%    data.nodes : a cell with the matrix (number of nodes, 2 or 3) containing
%                 the positions of the nodes (only nodes used by the elements 
%                 are printed out). One cell for each PGD dimensions.
%    data.cells : a cell with the connectivity matrix. 
%                    size(number_of_elements, number_of_nodes_per_element) 
%             NOTE : index start from 0 NOT 1 (see option 'from1')
%    data.names : is a  cell of cell containing the names and the unit of
%                 each dimension in each PGD dimension.
%                 names{1,1}{2} = name of the second dim of the first PGD dim
%                 names{1,2}{3} = unit of the first dim of the first PGD dim
%    data.nodes_fields : a cell with the nodes fields (PGD_dim, fields). 
%                        field is a matrix with 1 row for each mode.
%    data.mixed : in the case one of the meshes is a mixed mesh
%     Ex. nodes_fields{1,1} = [1 2 3 4; 1 2 5 4] , one field (with 4 nodes 
%          and 2 modes), ). Note : one line for each mode .
%    data.cell_fields : a cell with the elements fields (PGD_dim, fields). field is a matrix  1 row for each mode. 
%                           Ex. elements_fields{1,1} = [[1 0 0 ];[.2 .5 .6 ]] ,one field (3 elements, 2 modes).
%                            Note : one line for each mode. 
%    data.nodes_fields_names    : a cell with the names of each node field. Ex. nodes_fields_names{1,1} = "Temp"
%    data.cell_fields_names : a cell with the names of each element field. Ex. elements_fields_names{1,1} = "Damage"
%    options : 'from1' will add 1 to the connectivity matrix (Matlab type) (default : nothing is added )
%    status = 0 if the file was successfully written
%    status = -1 if error
%
%    Note : To used mixed a matrix a extra row must be added with the element type number (not yet implemented, sorry)
%    Note : In Windows the reader does not work if the filename path contains spaces
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%

opt.bin = 0;					
opt.bin_filename= '';
opt.bin_cpt = 0;
opt.HDF5 = 0;					
opt.HDF5_filename= '';
opt.HDF5_data_counter = 0;
opt.HDF5_compression = 0;
opt.z = 0;
opt.TwoD = 0;
opt.from1 = 0;
opt.topology = cell(1);
opt.geometry = cell(1);
opt.current_data = 't';
opt.flipTimeSpace = 0;
opt.rectilinear = 0;
opt.dtd_file_created = 0;
opt.dtd_file ='Xdmf.dtd';
opt.path = '';
opt.debut = 0;
opt.verbose = 0;
opt.xdmf =0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path calcul
offset2 = strfind(filename,filesep);
if ~isempty(offset2)
    opt.path =filename(1:offset2(end));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:length(varargin)
    if strcmpi(varargin{k}, 'from1')
        opt.from1 = varargin{k+1};
    end
    if strcmpi(varargin{k}, 'verbose')
        opt.verbose = varargin{k+1};
    end
    if strcmpi(varargin{k}, 'xdmf')
        opt.xdmf = varargin{k+1};
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forming the filename
%

[opt.Int_path ,NAME,EXT] = fileparts(filename);

if isempty(EXT ) 
    if opt.xdmf
        filename = [filename '.xdmf' ];    
    else
        filename = [filename '.pxdmf' ];
    end
else
    if strcmpi(EXT,'.xdmf')
        opt.xdmf =1;
    end
    if strcmpi(EXT,'.xmf')
        opt.xdmf =1;
    end
end

if ~isempty(opt.Int_path)
    opt.Int_path = [opt.Int_path filesep ];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dtd file generation
offset2 = strfind(filename,'/');
if isempty(offset2)
    opt.dt_file ='./Xdmf.dtd';
else
    opt.dt_file =[ filename(1:offset2(end)) 'Xdmf.dtd'];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creating the xdmf.dtd
%disp(opt.dt_file)
dtdfile = exist( opt.dt_file,'file');   
if dtdfile ~= 2
    opt.dtd_file_created = 1; 
    dtdfile = fopen(opt.dt_file,'w');
    fprintf(dtdfile,'<?xml version="1.0" encoding="UTF-8" ?> 					  \n');
    fprintf(dtdfile,'<!ELEMENT Xdmf (Domain) >									  \n');
    fprintf(dtdfile,'<!ELEMENT Domain (Grid+) >									  \n');
    fprintf(dtdfile,'<!ELEMENT Grid ((Topology,Geometry),Information+,Attribute?) >\n');
    fprintf(dtdfile,'<!ELEMENT Information ANY > 								  \n');
    fprintf(dtdfile,'<!ATTLIST Information Name CDATA #REQUIRED >				  \n');
    fprintf(dtdfile,'<!ATTLIST Information Value CDATA #REQUIRED >				  \n');
    fprintf(dtdfile,'<!ELEMENT Topology (DataItem) > 							  \n');
    fprintf(dtdfile,'<!ELEMENT Geometry (DataItem) > 							  \n');
    fprintf(dtdfile,'<!ELEMENT Attribute (DataItem) >							  \n');
    fprintf(dtdfile,'<!ELEMENT DataItem (#PCDATA) >								  \n');
	fclose(dtdfile);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if opt.verbose
    disp('*******  Reading  ******* ' )
    disp(['File :' filename])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading the pxdmf file 
opt.xDoc = xmlread(filename);
xRoot = opt.xDoc.getDocumentElement;
if opt.xdmf
    nb_Grids = 1;
else
    allGrids = xRoot.getElementsByTagName('Grid');
    nb_Grids = allGrids.getLength;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% seting up the output structure
data.filename = filename;
data.nodes = cell(nb_Grids,1);
data.cells = cell(nb_Grids,1);
data.names = cell(nb_Grids,2);
data.nodes_fields = cell(nb_Grids,0);
data.cell_fields = cell(nb_Grids,0);
data.nodes_fields_names= cell(1,0);
data.cell_fields_names= cell(1,0);
mixed = zeros(1,nb_Grids);
rectilinear = zeros(1,nb_Grids);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% straction of name in each dimention
if opt.xdmf 
    Domain =  xRoot.getElementsByTagName('Domain') ;
    mainGrid = xRoot.getElementsByTagName('Domain').item(0).getElementsByTagName('Grid').item(0); 
    allGrids = mainGrid.getElementsByTagName('Grid');

    nb_Grids = allGrids.getLength;
    if (nb_Grids)
        if opt.verbose
            disp(['Number of time steps ' num2str(allGrids.getLength)  ]);
        end
    else
        allGrids = xRoot.getElementsByTagName('Domain').item(0).getElementsByTagName('Grid');
        nb_Grids = allGrids.getLength;
    end
end

for i = 0:nb_Grids-1
    Grid = allGrids.item(i);
    
    if ~opt.xdmf
      Infos = Grid.getElementsByTagName('Information');
      nb_dims = GetNbOfDimsInGrid(Infos);
      dim_name = cell(1,nb_dims);
      dim_units = cell(1,nb_dims);
      for j = 0: nb_dims -1 
          for k = 0:Infos.getLength-1
              if strcmpi(Infos.item(k).getAttribute('Name') ,['Dim'  num2str(j)])
                  dim_name{j+1} = char(Infos.item(k).getAttribute('Value'));
                  if isempty(dim_name{j+1})
                      dim_name{j+1} = char(Infos.item(k).getFirstChild.getData);
                  end
              end
              if  strcmpi(Infos.item(k).getAttribute('Name') ,['Unit'  num2str(j)])
                   dim_units{j+1} = char(Infos.item(k).getAttribute('Value'));
                   if isempty(dim_units{j+1}) && ~isempty(Infos.item(k).getFirstChild)
                      dim_units{j+1} = char(Infos.item(k).getFirstChild.getData);
                   end
              end 
          end
      end
      data.names{i+1,1} = dim_name;
      data.names{i+1,2} = dim_units;
    end
    
    %% we read only one type in the case of a xdmf file
  if ~opt.xdmf || i ==0
    if strcmpi(char(Grid.getElementsByTagName('Topology').item(0).getAttribute('TopologyType')), '3DCORECTMESH') 
        opt.rectilinear=1;
        temp = Grid.getElementsByTagName('Topology').item(0).getAttribute('Dimensions');
        data.cells{i+1} = fliplr(str2num(temp))-1;
        
        DataItemGeometryOrigin = Read_data_Item(Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem').item(0), opt)';
        DataItemGeometrySpacing = Read_data_Item(Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem').item(1), opt)';
        data.nodes{i+1} = [ DataItemGeometryOrigin; DataItemGeometrySpacing];
        rectilinear(i+1) = 1;
    else
        DataItemTopology = Grid.getElementsByTagName('Topology').item(0).getElementsByTagName('DataItem').item(0);

        if strcmpi(char(Grid.getElementsByTagName('Topology').item(0).getAttribute('TopologyType')), 'Mixed') 
            mixed(i+1) = 1;
        end

        data.cells{i+1} = Read_data_Item(DataItemTopology, opt);
        
        if opt.from1
            data.cells{i+1} = data.cells{i+1} + cast(opt.from1,class(data.cells{i+1}));
        end
        
        if Grid.getElementsByTagName('Topology').item(0).hasAttribute('NodesPerElement') 
            NodesPerElement = str2double(Grid.getElementsByTagName('Topology').item(0).getAttribute('NodesPerElement'));
            %data.cells{i+1} = reshape(data.cells{i+1},NodesPerElement,[])';
        end

        DataItemGeometry = Grid.getElementsByTagName('Geometry').item(0).getElementsByTagName('DataItem').item(0);
        data.nodes{i+1} = Read_data_Item(DataItemGeometry, opt);
    end
  end
  
  
    Attributes = Grid.getElementsByTagName('Attribute');
    nb_Attributes = Attributes.getLength;
    for j = 0:nb_Attributes-1
       name = char(Attributes.item(j).getAttribute('Name'));
       
       type = Attributes.item(j).getAttribute('Center');
       if opt.xdmf
           mode = i;
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
       AttributeData = Read_data_Item(DataItemAttributes, opt);   
       
       if strcmpi(type,'Node')
           TF = strcmpi(field_name,data.nodes_fields_names);
           index = 0;
           for k =1:size(TF,2)
               if TF(1,k) == 1
                   index = k;
               end
           end
           if index==0
               data.nodes_fields_names{size(data.nodes_fields_names,1),size(data.nodes_fields_names,2)+1} = field_name;
               index = size(data.nodes_fields_names,2);
           end
           if(size(AttributeData,2)~=1) 
             AttributeData =   reshape(AttributeData',[],1);
           end
           if opt.xdmf
             data.nodes_fields{1,index}(mode+1,:) = AttributeData;   
           else
             data.nodes_fields{i+1,index}(mode+1,:) = AttributeData;
           end
       else
           TF = strcmpi(field_name,data.cell_fields_names);
           index = 0;
           for k =1:size(TF,2)
               if TF(1,k) == 1
                   index = k;
               end
           end
           if index==0
               data.cell_fields_names{size(data.cell_fields_names,1),size(data.cell_fields_names,2)+1} = field_name;
               index = size(data.cell_fields_names,2);
           end
           if(size(AttributeData,2)~=1) 
             AttributeData =   reshape(AttributeData',[],1);
           end

           %disp(field_name)
           %disp([i+1 index mode+1 size(AttributeData)])
           %disp(AttributeData(1))
           %keyboard
           if opt.xdmf
            data.cell_fields{1,index}(mode+1,:) = AttributeData;   
           else
            data.cell_fields{i+1,index}(mode+1,:) = AttributeData;
           end
           
           
       end
    end
end


[status, errors] = checkpxdmfstruct(data.nodes, data.cells, data.names, data.nodes_fields, data.cell_fields, data.nodes_fields_names, data.cell_fields_names, rectilinear, mixed,  opt.verbose);
if opt.verbose
    disp('*************************' )
end
if sum(mixed)  
    data.mixed = mixed;
end

if sum(rectilinear) 
   data.rectilinear = rectilinear;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elimination of dtd file 
if opt.dtd_file_created == 1; 
    delete([opt.path opt.dtd_file])
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = Read_data_Item(DataItem, opt)

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
        data = Read_data_Item(nodeList.item(0), opt);
    end
else
    format = char(DataItem.getAttribute('Format'));
    if strcmpi(format, 'XML')
        data = Read_data_Item_XML(DataItem, opt);
    else
        if strcmpi(format, 'HDF')
            data = Read_data_Item_H5(DataItem, opt);
        else
            data = Read_data_Item_BIN(DataItem, opt);
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = Read_data_Item_XML(DataItem, ~)
    Dimensions = str2num(DataItem.getAttribute('Dimensions'));
    %NumberType = char(DataItem.getAttribute('NumberType'));
   %%data = str2num(DataItem.getFirstChild.getData.replaceAll('\n',' '));
   
    data = sscanf(char(DataItem.getFirstChild.getData.replaceAll('\n',' ')), '%f');
    if ~strcmpi(DataItem.getAttribute('NumberType'), 'int')
        if strcmpi(DataItem.getAttribute('Precision'), '4')
            data = single(data);
        end
    else
        if (~DataItem.hasAttribute('Precision')) ||  strcmpi(DataItem.getAttribute('Precision'), '4')
            data = int32(data);
        else
            data = int64(data);
        end
    end 
    
    if numel(Dimensions) ~= 1
        data = reshape(reshape(data',1,[]), fliplr(Dimensions) )';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = Read_data_Item_H5(DataItem, opt)
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
    
    if (size(data,1) ~= Dimensions(1))
        data =data';
    end
    if numel(Dimensions) ~= 1
        data = reshape(data, Dimensions);
    end
    
    H5F.close(H5_file);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = Read_data_Item_BIN(DataItem, opt)
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
    if ~strcmpi(str, 'int')
        if strcmpi(DataItem.getAttribute('Precision'), '8')
            format = [format '.l64'];
        end
    end
       
    [bin_file, MESSAGE] = fopen( file,'r',format);
    if bin_file < 0
        disp(MESSAGE);
    end
    fseek(bin_file,seek,-1);
    
    if strcmpi(DataItem.getAttribute('NumberType'), 'int')
            data = fread(bin_file, Dimentions, 'int32=>int32')';
    else
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
