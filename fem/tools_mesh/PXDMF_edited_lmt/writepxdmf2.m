function status = writepxdmf2(data, varargin)
%
% Function to write a PXDMF file:
%
%    writepxdmf2(data, options) 
%    writepxdmf2(data,'OPTION_NAME1',VALUE1, ...)
%
%    data        : a vector of XdmfGrid 
%    options     : a writepxdmfset option struct
%
%   For output of tensor the order of the output is :
%
%   [[0 1 2 ];
%    [3 4 5 ];       [0 1 2 3 4 5 6 7 8]
%    [6 7 8 ]];
%
%   For symetric tensors (tensor6) the order of the output is 
%
%   [[0 1 2 ];
%    [1 3 4 ];       [0 1 2 3 4 5]
%    [2 4 5 ]];
%
% also can be used like
%   
%    writepxdmf2 with no input arguments display all properties names and their
%    possible values.
%
%    options = writepxdmf2() 
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%

%% Help and default values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin == 0)
  if  (nargout == 0)
    help writepxdmf2
  else
    status = writepxdmfset();
  end
  return;
end
opt = writepxdmfset(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options now are handel by the writpxdmfset 

s = whos('data');
if opt.HDF5 == 0 && opt.binary == 0 && s.bytes > 50000000
    fprintf(2,'Warning data to big for a ASCII file. Activating Binary option\n');
    opt.binary = true;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% internal variables 
opt.Int_bin_file = 0;
opt.Int_bin_filename = '';
opt.Int_bin_cpt = 0;
opt.Int_HDF5_filename= '';
opt.Int_HDF5_data_counter = 0;
opt.Int_path = '';
opt.Int_indent = 0;
opt.Int_xdmf_Topology_Printed = '';
opt.Int_xdmf_Geometry_Printed = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% parsing option and checking HDF5 and compression
%
if opt.HDF5 
  if exist('hdf5write')
    if opt.gzip 
       if exist('H5ML.id')
        avail = H5Z.filter_avail('H5Z_FILTER_DEFLATE');
        if ~avail
            disp('Warning: gzip filter not available. Using normal output.')
            opt.gzip = false ;
        else
            H5Z_FILTER_CONFIG_ENCODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_ENCODE_ENABLED');
            H5Z_FILTER_CONFIG_DECODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_DECODE_ENABLED');
            filter_info = H5Z.get_filter_info('H5Z_FILTER_DEFLATE');
            if ( ~bitand(filter_info,H5Z_FILTER_CONFIG_ENCODE_ENABLED) || ~bitand(filter_info,H5Z_FILTER_CONFIG_DECODE_ENABLED) )
                disp('Warning: gzip filter not available for encoding and decoding. Using normal output.')
                opt.gzip = false ;
            end
        end
       else
        opt.gzip = false;
        disp('Warning : Compression not available. Using normal output (HDMF5).')
       end
    end
  else
        opt.HDF5 = false;
        disp('Warning : HDF5 not available. Using normal output (ASCII).')
  end
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Path calcul and forming the filenames

[opt.Int_path ,NAME,EXT] = fileparts(opt.filename);
if isempty(EXT ) 
    if opt.xdmf
        opt.filename = [opt.filename '.xdmf' ];    
    else
        opt.filename = [opt.filename '.pxdmf' ];
    end
else
    if strcmpi(EXT,'.xdmf')
        opt.xdmf = 1;
    end
end

if ~isempty(opt.Int_path)
    opt.Int_path = [opt.Int_path filesep ];
end

opt.Int_HDF5_filename = [ NAME '.h5'];
opt.Int_bin_filename = [ NAME '.bin'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Debug

if(opt.verbose == 2)
    disp('vvvvvvvvvvvvvvv  debug information  vvvvvvvvvvvvvv')
    disp(opt)
    disp('^^^^^^^^^^^^^^^  debug information  ^^^^^^^^^^^^^^')
end

%% display information about the output

if opt.verbose
    disp('*******  Writing  ********' )
    disp(['File :' opt.filename ])
    if(opt.HDF5)
        disp(['Path :' opt.Int_path ])
        disp(['File :' opt.Int_HDF5_filename ])
        if(opt.gzip )
            disp('Compression : Active')    
        end
    end
    if(opt.binary)
        disp(['Path :' opt.Int_path ])
        disp(['File :' opt.Int_bin_filename ])
    end

    if(opt.HDF5 && opt.binary)
        disp('HDF5 and bin option are incompatible using only HDF5')
        opt.binary = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check the input values and display information 

for i = 1:numel(data)
    if ~data.CheckIntegrity(opt.verbose);
        disp(['Error in grid number ' int2str(i)])
        status = 0;
        return 
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% padding with zeros the spaces smaller than 3
% pxdmf needs nodes with 3 coordinates
% for i = 1:pgd_dims
%     if opt.constrectilinear(i)
%         if size(elements{i,1},2) == 2;
%             elements{i,1} = [elements{i,1} 0 ];
%         end
%         if size(elements{i,1},2) == 1;
%             elements{i,1} = [elements{i,1} 0 0];
%         end
%         
%         if size(nodes{i,1},2) == 2;
%             nodes{i,1} = [nodes{i,1} [0 1]' ];
%         end
%         if size(nodes{i,1},2) == 1;
%             nodes{i,1} = [nodes{i,1} [0 1]' [0 1]'];
%         end
%         nodes{i,1}(2,:)  = nodes{i,1}(2,:) + (nodes{i,1}(2,:) <= 0);
%     else
%       if opt.rectilinear(i) 
%         if size(elements{i,1},2) == 2;
%             elements{i,1} = [elements{i,1} 0 ];
%         end
%         if size(elements{i,1},2) == 1;
%             elements{i,1} = [elements{i,1} 0 0];
%         end
%       end
%       if size(nodes{i,1},2) == 2;
%           nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) ];
%       end
%       if size(nodes{i,1},2) == 1;
%           nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) zeros(size(nodes{i,1},1),1)];
%       end     
%     end
% end



%disp(opt.Int_Number_of_Elements{d})
%file = fopen(filename,'wt');

%if (file<0)
%    disp(['Error opening file : ' filename] )
%    status = -1;
%    return
%end


%to create an empty file (H5)
if opt.HDF5 
    if opt.gzip == 1
        opt.HDF5_file = H5F.create([opt.Int_path opt.Int_HDF5_filename],'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
    else
        dset_details.Location = '/info';
        dset_details.Name = 'date';
        hdf5write([opt.Int_path opt.Int_HDF5_filename], dset_details,date );
    end
end

%to crate an empty file (bin)
if opt.binary
    if (strcmpi(opt.precision,'single'))
        formattmp =  'ieee-be';
    else
        formattmp =  'ieee-be.l64';
    end
    [opt.Int_bin_file, MESSAGE] = fopen([opt.Int_path opt.Int_bin_filename],'w',formattmp);
    if  opt.Int_bin_file < 0
        disp(['Error opening file : ' opt.Int_path opt.Int_bin_filename] );   
        disp(MESSAGE);
        return 
    end
end

docNode = com.mathworks.xml.XMLUtils.createDocument('Xdmf');
%docNode.appendChild(docNode.createDocumentType('Xdmf','','Xdmf.dtd'));
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('Version','2.0');
docRootNode.setAttribute('xmlns:xi','http://www.w3.org/2001/XInclude')
docNode.appendChild(docNode.createComment('File Created using the writepxdmf2 by Felipe Bordeu'));
domain = docNode.createElement('Domain');
domain.setAttribute('Name',opt.filename);
docRootNode.appendChild(domain);
opt.docNode = docNode;

if opt.xdmf
    subdomain = domain;
    
    if opt.temporalGrids
            gridtime = docNode.createElement('Grid');
            gridtime.setAttribute('Name','Domain Temporal');
            gridtime.setAttribute('GridType','Collection');
            gridtime.setAttribute('CollectionType','Temporal');
            domain.appendChild(gridtime);
            if numel(opt.timesteps) > 0 
                opt = write_time(gridtime, opt, opt.timesteps);    
            else
                opt = write_time(gridtime, opt, 0:(numel(data)-1));
            end
            subdomain = gridtime;
    end
    
    for g = 1:numel(data)
        
        max_time = 1;
        for i=1:data(g).GetNumberOfNodeFields()
            s = data(g).GetNodeFieldSize(i);
            max_time = max(max_time, s(2));
        end
        for i=1:data(g).GetNumberOfElementFields()
            s = data(g).GetElementFieldSize(i);
            max_time = max(max_time, s(2));
        end
        
        maindomain = subdomain;
        if max_time > 1
            gridtime = docNode.createElement('Grid');
            gridtime.setAttribute('Name',['Domain ' int2str(g) ' Space x Time']);
            gridtime.setAttribute('GridType','Collection');
            gridtime.setAttribute('CollectionType','Temporal');
            subdomain.appendChild(gridtime);
            opt = write_time(gridtime, opt, 0:(max_time-1));
            maindomain = gridtime;
        end

        for i = 1:max_time
            gridname = sprintf('Domain %i Time %i',g,i);
            opt.current_dim = i;
            opt = write_grid(maindomain, data(g),gridname,@(arg1) data(g).GetNodeFieldTerm(arg1,i)...
                ,@(arg1) data(g).GetElementFieldTerm(arg1,i), opt);
        end
        opt.Int_xdmf_Topology_Printed = '';
        opt.Int_xdmf_Geometry_Printed = '';
    end
else
     for i= 1:numel(data)
         opt.current_dim = i;
         gridname = sprintf('PGD%i',i);
         datai = data(i);
         opt = write_grid(domain, datai,gridname,@ datai.GetNodeField,@datai.GetElementField,  opt);
     end   
end

xmlwrite(opt.filename,docNode);

status = true;

if opt.binary
    if(opt.Int_bin_file>=0)
        fclose(opt.Int_bin_file);
    end
end
if opt.HDF5
    if opt.gzip == 1
        H5F.close(opt.HDF5_file);
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function res = extract_time_step(arg1,i)
% if size(arg1,2) >= i
%     res = arg1(:,i); 
% else  
%     res = [] ; 
% end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_information(father,names,units,extraInformation,opt) % OK
  if ~opt.xdmf
      pgd_dim_dim =  length(names);
      opt = write_information_tag(father,'Dims',sprintf('%i',pgd_dim_dim),opt);
      for j=1:pgd_dim_dim
          opt = write_information_tag(father,sprintf('Dim%i',j-1),sprintf('%s',names{j}),opt);
          if(numel(units)>=1) 
              opt = write_information_tag(father,sprintf('Unit%i',j-1),sprintf('%s',units{j}),opt);
          end
      end
  end
  for i= 0:(numel(extraInformation)/2-1)
      opt = write_information_tag(father,extraInformation{2*i+1},extraInformation{2*i+2},opt);
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_information_tag(father,Name,Values,opt) % OK
    Info = opt.docNode.createElement('Information');
    Info.setAttribute('Name',Name);
    Info.setAttribute('Value',Values);
    father.appendChild(Info);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_grid(father,griddata,gridname,nodedata,elemdata, opt)

grid = opt.docNode.createElement('Grid');
grid.setAttribute('Name',gridname);
father.appendChild(grid);

if ~opt.xdmf
   opt = write_information(grid,griddata.GetCoordNames(),griddata.GetCoordUnits(),griddata.GetExtraInfomation(),opt);
end

opt = write_topology(grid,griddata,opt);
opt = write_geomety(grid,griddata,opt);
%

if strcmpi(griddata.GetGridType(),'ConstRectilinear') || strcmpi(griddata.GetGridType(),'Rectilinear');
    support_size = fliplr(griddata.GetGrid())+1;
else
    support_size = griddata.GetNumberOfNodes();
end


opt2= write_data(grid,'Node',support_size,...
                           griddata.GetNumberOfNodeFields(),...
                           @griddata.GetNodeFieldName,...
                           @griddata.GetNodeFieldSize ,...
                           nodedata,...
                           opt);
opt = opt2;

if strcmpi(griddata.GetGridType(),'ConstRectilinear') || strcmpi(griddata.GetGridType(),'Rectilinear')
    support_size = fliplr(griddata.GetGrid()+cast(griddata.GetGrid()==0,class(griddata.GetGrid())));
else
    support_size = griddata.GetNumberOfElements();
end
    
opt= write_data(grid,'Cell',support_size,...
                           griddata.GetNumberOfElementFields(),...
                           @griddata.GetElementFieldName,...
                           @griddata.GetElementFieldSize,...
                           elemdata,...
                           opt);

opt= write_data(grid,'Grid',[1],...
                           griddata.GetNumberOfGridFields(),...
                           @griddata.GetGridFieldName,...
                           @(i)([1 1]),...
                           @griddata.GetGridField,...
                           opt);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt= write_data(father,centered,support_size,nbfields,data_names,s,datas ,opt)

for i=1:nbfields     
    datasize = s(i);
    if opt.xdmf
        %disp(datasize(2))
        %disp(opt.current_dim)
        datasize(2) =min(1,datasize(2)-opt.current_dim+1);
        %disp(datasize)
    end
    if datasize(2) < 1 
        continue
    end
    data = datas(i);
    for mode=1:datasize(2);
        att = opt.docNode.createElement('Attribute');
        father.appendChild(att);
        
        att.setAttribute('Center',centered);

        if opt.xdmf
            att.setAttribute('Name',data_names(i));
        else
            att.setAttribute('Name',sprintf('%s_%i',data_names(i),mode-1));
            %att.setAttribute('Name',sprintf('%s_%2.2d',data_names(i),mode-1));
        end

        if strcmpi(centered,'Grid') 
            att.setAttribute('Type','None');
            opt= write_DataItem(att, data(:,mode)','',opt.precision,[size(data(:,mode)')],opt );
            continue;
        end
        
        if datasize(1) ==  prod(support_size) 
            att.setAttribute('AttributeType','Scalar');
            opt= write_DataItem(att, data(:,mode),'',opt.precision, support_size ,opt );
        else
            if( datasize(1) ==  3*prod(support_size))
                att.setAttribute('AttributeType','Vector');
                opt= write_DataItem(att, data(:,mode),'',opt.precision,[support_size 3 ],opt );
            else
                if( datasize(1) ==  6*prod(support_size))
                    att.setAttribute('AttributeType','Tensor6');
                    opt= write_DataItem(att, data(:,mode),'',opt.precision,[support_size 6],opt );
                else
                    if ( datasize(1) ==  6*prod(support_size))
                        att.setAttribute('AttributeType','Tensor');
                        opt= write_DataItem(att, data(:,mode),'',opt.precision,[support_size 9],opt );
                    else
                        %% 
                        if round(datasize(1)/prod(support_size)) == (datasize(1)/prod(support_size)) 
                            att.setAttribute('Type','None');
                            opt= write_DataItem(att, data(:,mode),'',opt.precision,[prod(support_size) datasize(1)/prod(support_size)],opt );
                            
                            
                        else
                            disp(['Error : Field ' data_names(i) ' not compatible with the support. '] );
                            disp(['Field size ' int2str(datasize) ] );
                            disp(['support size ' int2str(prod(support_size)) ] );                            
                        end

                        continue
                    end
                end
            end
        end
                
    end
    
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_geomety(father,griddata, opt) %OK

geo = opt.docNode.createElement('Geometry');
father.appendChild(geo);

nodes = griddata.GetNodes();



% padding with zeros the spaces smaller than 3
% pxdmf needs nodes with 3 coordinates
% for i = 1:pgd_dims
%     if opt.constrectilinear(i)
%         if size(elements{i,1},2) == 2;
%             elements{i,1} = [elements{i,1} 0 ];
%         end
%         if size(elements{i,1},2) == 1;
%             elements{i,1} = [elements{i,1} 0 0];
%         end
%         
%         if size(nodes{i,1},2) == 2;
%             nodes{i,1} = [nodes{i,1} [0 1]' ];
%         end
%         if size(nodes{i,1},2) == 1;
%             nodes{i,1} = [nodes{i,1} [0 1]' [0 1]'];
%         end
%         nodes{i,1}(2,:)  = nodes{i,1}(2,:) + (nodes{i,1}(2,:) <= 0);
%     else
%       if opt.rectilinear(i) 
%         if size(elements{i,1},2) == 2;
%             elements{i,1} = [elements{i,1} 0 ];
%         end
%         if size(elements{i,1},2) == 1;
%             elements{i,1} = [elements{i,1} 0 0];
%         end
%       end
%       if size(nodes{i,1},2) == 2;
%           nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) ];
%       end
%       if size(nodes{i,1},2) == 1;
%           nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) zeros(size(nodes{i,1},1),1)];
%       end     
%     end
% end




switch lower(griddata.GetGridType())
    case 'constrectilinear'
        
        % padding with zeros
        if size(nodes,2) == 2;
           nodes = [nodes [0 1]' ];
        else
          if size(nodes,2) == 1;
            nodes = [nodes [0 1]' [0 1]'];
          end            
        end
        % ensure that the spacin is strictly positive 
        nodes(2,:)  = nodes(2,:) + (nodes(2,:) <= 0);
        
        
        geo.setAttribute('GeometryType','ORIGIN_DXDYDZ');
        opt = write_DataItem(geo, fliplr(nodes(1,:)), 'Origin', 'double',numel(nodes(1,:)), opt);
        opt = write_DataItem(geo, fliplr(nodes(2,:)), 'Spacing', 'double',numel(nodes(2,:)), opt);
    case 'rectilinear'
      
      % padding with zeros
      if size(nodes,2) == 2;
          nodes = [nodes zeros(size(nodes,1),1) ];
      else
        if size(nodes,2) == 1;
           nodes = [nodes zeros(size(nodes,1),2) ];
        end           
      end

      elements = griddata.GetGrid(); 
      
      % padding elements
      if size(elements,2) == 2;
        elements = [elements 0 ];
      else
        if size(elements,2) == 1;
            elements= [elements 0 0];
        end          
      end

        
      geo.setAttribute('GeometryType','VXVYVZ');
      
      opt = write_DataItem(geo, nodes(1:elements(1)+1,1), 'X', opt.precision , elements(1)+1, opt);
      opt = write_DataItem(geo, nodes(1:elements(2)+1,2), 'Y', opt.precision , elements(2)+1, opt);
      opt = write_DataItem(geo, nodes(1:elements(3)+1,3), 'Z', opt.precision , elements(3)+1, opt);
    otherwise
        
      % padding with zeros
      if size(nodes,2) == 2;
         nodes = [nodes zeros(size(nodes,1),1) ];
      end
      if size(nodes,2) == 1;
         nodes = [nodes zeros(size(nodes,1),2) ];
      end    

      geo.setAttribute('GeometryType','XYZ');

      if opt.xdmf && ~strcmp( opt.Int_xdmf_Geometry_Printed,'')
          opt= write_dataItem_reference(geo,opt.Int_xdmf_Geometry_Printed , opt);
      else
        opt= write_DataItem(geo, nodes,'', opt.precision, size(nodes),opt);
        opt.Int_xdmf_Geometry_Printed =  GetRefName(geo) ;
      end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_topology(father, griddata, opt) %OK

topo = opt.docNode.createElement('Topology');
father.appendChild(topo);

switch lower(griddata.GetGridType())
    case 'constrectilinear'
        elements = griddata.GetGrid(); 
        % padding elements
        if size(elements,2) == 2;
            elements = [elements 0 ];
        else
            if size(elements,2) == 1;
                elements= [elements 0 0];
            end          
        end
        
        topo.setAttribute('TopologyType','3DCORECTMESH');
        topo.setAttribute('Dimensions',sprintf('%s', int2str(fliplr(elements +1))));
    case 'rectilinear'
        elements = griddata.GetGrid(); 
        % padding elements
        if size(elements,2) == 2;
            elements = [elements 0 ];
        else
            if size(elements,2) == 1;
                elements= [elements 0 0];
            end          
        end
      
        topo.setAttribute('TopologyType','3DRECTMESH');
        topo.setAttribute('Dimensions',sprintf('%s', int2str(fliplr(elements +1))));
    otherwise
        topo.setAttribute('TopologyType',griddata.GetGridType());
        
        
        switch lower(griddata.GetGridType())
            case 'polyline'
                topo.setAttribute('NodesPerElement','2');
            case 'polyvertex'
                topo.setAttribute('NodesPerElement','1');
        end
        topo.setAttribute('NumberOfElements',sprintf('%d',griddata.GetNumberOfElements()));

        if opt.xdmf && ~strcmp( opt.Int_xdmf_Topology_Printed,'')
            opt= write_dataItem_reference(topo,opt.Int_xdmf_Topology_Printed, opt);
        else
            elements = int32(griddata.GetGrid());
            opt= write_DataItem(topo,elements,'','%i',size(elements), opt);
            opt.Int_xdmf_Topology_Printed = GetRefName(topo) ;
        end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_time(father, opt, timesteps)
    
   time = opt.docNode.createElement('Time');
   time.setAttribute('TimeType','List');

   father.appendChild(time);
   
   opt = write_DataItem(time, timesteps,'', 'double',numel(timesteps), opt );    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_DataItem(father, field, name, format, dims, opt)
   dataitem = opt.docNode.createElement('DataItem');
   if ~strcmp(name,'')
      dataitem.setAttribute('Name',name);
   end
   
   switch class(field)
       case 'double'
           dataitem.setAttribute('NumberType','Float');
           if(strcmpi(format,'single'))
               field = single (field);
               dataitem.setAttribute('Precision','4');
           else
               dataitem.setAttribute('Precision','8');
           end
       case 'single'
           dataitem.setAttribute('NumberType','Float');
           dataitem.setAttribute('Precision','4');
       case 'uint8'
           dataitem.setAttribute('NumberType','UChar');       
       case 'int8'
           dataitem.setAttribute('NumberType','Char');       
       case 'uint16'
           dataitem.setAttribute('NumberType','UInt');       
       case 'int16'
           dataitem.setAttribute('NumberType','Int');
       case 'uint32'
           dataitem.setAttribute('NumberType','Int');
           dataitem.setAttribute('Precision','4');
       case 'int32'
           dataitem.setAttribute('NumberType','Int');
           dataitem.setAttribute('Precision','4');
       case 'int64'
           dataitem.setAttribute('NumberType','Int');
           dataitem.setAttribute('Precision','8');
       otherwise
           disp('WARNING Data type not supported using Float 8 for the output')
           dataitem.setAttribute('NumberType','Float');
           dataitem.setAttribute('Precision','8');
   end
   
   dataitem.setAttribute('Dimensions',int2str(dims));
   
   
   if opt.HDF5 == 1 && numel(field) > opt.max_ASCII
       opt = write_DataItem_HDF(dataitem, field, dims, opt);
   else
       if opt.binary == 1 && numel(field) > opt.max_ASCII
           opt = write_DataItem_BIN(dataitem, field, dims, opt);
       else
           opt = write_DataItem_ASCII(dataitem, field, dims, opt);
       end
   end
   
   
   father.appendChild(dataitem);
   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_DataItem_HDF(dataitem, field,dims, opt)
   dataitem.setAttribute('Format','HDF');
   
   if  opt.gzip ==1 && numel(field) > 1000
     % Create dataspace.  Setting maximum size to [] sets the
     % maximum size to be the current size.  Remember to flip the dimensions.
     DIMS = size(field);
     space = H5S.create_simple (2, DIMS, []);
     %
     % Create the dataset creation property list, add the gzip
     % compression filter and set the chunk size.  Remember to flip
     % the chunksize.
     %
     dcpl = H5P.create('H5P_DATASET_CREATE');
     H5P.set_deflate (dcpl, 9);
     H5P.set_chunk (dcpl, DIMS);
     DATASET=  ['DataItem' num2str(opt.Int_HDF5_data_counter) ];
     
     switch class(field)
         case 'double'
             dset= H5D.create(opt.HDF5_file,DATASET,'H5T_IEEE_F64LE',space,dcpl);
             H5D.write(dset,'H5T_NATIVE_DOUBLE','H5S_ALL','H5S_ALL','H5P_DEFAULT',double(field'));
         case 'single'  
             dset= H5D.create(opt.HDF5_file,DATASET,'H5T_IEEE_F32LE',space,dcpl);
             H5D.write(dset,'H5T_NATIVE_FLOAT','H5S_ALL','H5S_ALL','H5P_DEFAULT',single(field'));
         otherwise 
             dset = H5D.create(opt.HDF5_file,DATASET,'H5T_STD_I32LE',space,dcpl);
             H5D.write(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT',field');
     end
     
     
     H5P.close(dcpl);
     H5D.close(dset);
     H5S.close(space);
     opt.Int_HDF5_data_counter = opt.Int_HDF5_data_counter +1;

     dataitem.appendChild(opt.docNode.createCDATASection(sprintf('%s:%s' , opt.Int_HDF5_filename ,DATASET)));

   else
       dset_details.Location = ['/dataset' num2str(opt.Int_HDF5_data_counter)];
       dset_details.Name = [ 'DataItem' num2str(opt.Int_HDF5_data_counter)  ];
       
       hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details, field','WriteMode','append');
   
       opt.Int_HDF5_data_counter = opt.Int_HDF5_data_counter +1;
       dataitem.appendChild(opt.docNode.createCDATASection(sprintf('%s:%s/%s' , opt.Int_HDF5_filename ,dset_details.Location, dset_details.Name )));

   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_DataItem_ASCII(dataitem, field,dims, opt)
    dataitem.setAttribute('Format','XML');
    
    switch class(field)
        case 'double'
            format = '%1.16g';
        case 'single'
            format = '%1.8g';
        otherwise
            format = '%d';    
    end

    format_ = repmat([format ' '],[ 1 size(field,2)]);
    format_ = [format_ '']; 
    dataitem.appendChild(opt.docNode.createCDATASection(sprintf(format_ , field' )));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_DataItem_BIN(dataitem, field,dims, opt)
    dataitem.setAttribute('Format','Binary');
    dataitem.setAttribute('Endian','Big');
    dataitem.setAttribute('Seek',sprintf('%i',opt.Int_bin_cpt));
    
    switch class(field)
        case 'double'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','double')*8 + opt.Int_bin_cpt;
        case 'single'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','single')*4 + opt.Int_bin_cpt;
        case 'uint8'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','uint8') + opt.Int_bin_cpt;
        case 'int8'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','int8') + opt.Int_bin_cpt;
        case 'uint16'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','integer*2')*2 + opt.Int_bin_cpt;     
        case 'int32'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','integer*4')*4 + opt.Int_bin_cpt;
        case 'uint32'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','integer*4')*4 + opt.Int_bin_cpt;          
        case 'int64'
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,field','int64')*8 + opt.Int_bin_cpt;          
        otherwise
            disp(class(field))
            disp('WARNING output in unknow format using uint32 in binary mode')
            opt.Int_bin_cpt = fwrite(opt.Int_bin_file,int32(field)','integer*4')*4 + opt.Int_bin_cpt;
    end    
    
    dataitem.appendChild(opt.docNode.createCDATASection(opt.Int_bin_filename));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_dataItem_reference(dataitem, field, opt)
  dataitem.setAttribute('Reference','XML');
  dataitem.appendChild(opt.docNode.createCDATASection(field));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = GetRefName(node)
  res = '';
  N = node;
  while(true)
    if N.hasAttribute('Name')
      res =[ '[@Name="'  char(N.getAttribute('Name'))  '"]'  res ];
    end
    res = [ char(N.getNodeName())   res ] ;
    res = ['/'  res ];
    if strcmp( char(N.getNodeName()),'Xdmf')
      break
    end
    N = N.getParentNode();
  end
  return
end
