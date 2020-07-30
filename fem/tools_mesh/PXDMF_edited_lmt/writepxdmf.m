function status = writepxdmf(data, varargin)
%
%   WARNING This fuction will be depreceated in future releases. Use writepxdmf2 instead. 
%
% Function to write a PXDMF file:
%
%    writepxdmf(filename, nodes, elements, names ,nodes_fields or {}, cell_fields or {}, nodes_fields_names or {}, cell_fields_names or {},'OPTION_NAME1',VALUE1, ...)
%
%    filename              : file name Note : it will add .pxdmf if the filename doesn't have it
%    nodes                 : a vertical cell with the matrix (with size [number_of_nodes, 2 or 3]) containing the positions of the nodes (only nodes used by the elements are printed out)
%                            If z coordinate is absent z = 0 is assumed 
%                            One cell for each PGD dimensions.
%                     NOTE : In The case of structured meshes, the first point is the origin and the second point is the spacing 
%    elements              : a cell with the connectivity matrix. size(number_of_elements, number_of_nodes_per_element) 
%                            elements supported without usint the element_type option :  1 nodecell, 2 segment, 3 Triangle, 4 Quadrilateral,  6 Wedges ,  8 Hexahedrons, 9 Quadrilateral_9
%                            and  mixed meshes (look at the option to use mixed elements)
%                     NOTE : index start from 0 NOT 1 (see option 'from1')
%                     NOTE : In the case of structured meshes, only one row
%                            with the numer of element in each dimension
%    names                 : is a  cell of cell containging the names and the unit of
%                            each dimension in each PGD dimension.
%                            names{1,1}{2} = name of the second dim of the first PGD dim
%                PGD dimension ----^ ^  ^----coordinate number  
%                                    |---- 1 name, 2 unit
%                            names{1,2}{3} = unit of the thirt dim of the
%                            first PGD dim
%    nodes_fields          : a cell with the nodes_fields (size(PGD_dim, number_of_fields)). Each matrix (size(number_of_terms,number_of_points) 
%                    NOTE :  In the case of vectorial data each row has 3
%                            time the number of node. The order is [u1 v1 w1 u2 v2 w2 u3 v3 w3 ...]
%                            Ex. nodes_fields{1,1} = [1 2 3 4; 1 2 5 4] , one scalar field (with 4 nodes and 2 modes), ). Note : one row for each mode .
%                    NOTE : If no nodes_field exist replace nodes_fields
%                           and nodes_fields_names by  {}
%    cell_fields           : a cell with the elements_fields (size(PGD_dim, number_of_fields)). Each matrix (size(number_of_terms, number_of_elements))
%                           Ex. elements_fields{1,1} = [[1 0 0 ];[.2 .5 .6 ]] , one scalar field (3 elements, 2 modes).
%                            Note : one row for each mode. 
%                           If no cell_fields exist replace cell_fields
%                           and cell_fields_names by  {}
%    nodes_fields_names    : a cell with the names of each node field. Ex. nodes_fields_names{1} = "Temp"
%    cell_fields_names     : a cell with the names of each element field. Ex. cell_fields_names{1} = "Damage"
%
%    status = 0 if the file was successfully written
%    status = -1 if error
%
%writepxdmf PROPERTIES
%
%cell_names  - the type of element used in each mesh if they can't be 
%             automaticaly inferred from the number of nodes ( case of
%             quads and tets)
%
%HDF5  - for binary output in HDF5 format file. [ on | {off} ]
%   Note: new file is created 'filename.h5'  
%
%gzip  - Compress HDF5 data. [ on | {off} ]
%   This option can be used with 'HDF5' to compress the information.
%
%bin   - to use plain binary to store the heavy data. [ on | {off} ]
%
%from1 - the connectivity matrix numbering start from 1 [ on | {off} ]
%   Note : default connectivity start form 0
%
%precision - to change the precision of the data [ 'single' | {'double'} ]
%
%rectilinear -  a vector with ones for every structured (rectilinear) mesh [vector of integers]
%
%mixed - a vector with ones for every dimension with mixed elements [vector of integers]
%
%max_ASCII - vector smaller that this will always be written in ASCII [ {100} ]
%
%xdmf - in this case a xdmf (not pxdmf) file is writen, only one dimension [ on | {off} ]
%   is written, and each row in the node/cell fields are treated as time
%   steps.
%
%verbose -  to print the information about the data been written
%
%debug - only for debuging
%   Note: Add indentation to the output file
%         Activate the verbose mode 
%
%
%
% also can be used like
%
%    function status = writepxdmf(data, varargin)
%    Write a PXDMF file with the information in the structure data
%
%    writepxdmf(data, varargin) calls the function 
%
%    writepxdmf(data.filename, data.nodes, data.cells, data.names, data.nodes_fields, data.cell_fields, data.nodes_fields_names, data.cell_fields_names, varargin{:})
%
% also can be used like
%   
%    writepxdmf with no input arguments displays all property names and their
%    possible values.
%
%    data = writepxdmf() 
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Help and default values 
if (nargin == 0)
  if  (nargout == 0)
    fprintf(2,' WARNING This fuction will be depreceated in future releases. Use writepxdmf2 instead. \n');
    fprintf('           filename: [ filename ]\n');
    fprintf('              nodes: a cell with nodes position for every space \n');
    fprintf('              cells: a cell with the connectivity for ever space \n');
    fprintf('              names: a cell of cell containging the names and the unit for every space\n');
    fprintf('       nodes_fields: a cell with the nodes fields (PGD_dim, fields) [ {} ]\n');
    fprintf('        cell_fields: a cell with the elements fields (PGD_dim, fields) [{}]\n'); 
    fprintf(' nodes_fields_names: a cell with the names of each node field [ {}]\n');
    fprintf('  cell_fields_names: a cell with the names of each elements field [{}]\n');
    fprintf('          options      \n');
    fprintf('         cell_names: a cell with the elements type size(PGD_dim) [{}]\n'); 
    fprintf('               HDF5: [ on | {off} ]\n');
    fprintf('               gzip: [ on | {off} ]\n');
    fprintf('                bin: [ on | {off} ]\n');
    fprintf('              from1: [ on | {off} ]\n');
    fprintf('          precision: [ single | {double} ]\n');
    fprintf('        rectilinear: [ a vector with ones for every structured (rectilinear) mesh ]\n');
    fprintf('              mixed: [ a vector with ones for every space with mixed elements  ]\n');         
    fprintf('          max_ASCII: [ vector smaler that this will always be written in ASCII {100} ]\n');
    fprintf('            verbose: [ on | {off} ]\n');
    fprintf('               xdmf: [ on | {off} ]\n');
    fprintf('              debug: [ on | {off} ]\n');

   else 
     data.filename = '';
     data.nodes = {};
     data.cells = {};
     data.names = {};
     data.nodes_fields = {};
     data.cell_fields = {};
     data.nodes_fields_names = {};
     data.cell_fields_names = {};
% 
%      Options = [
%     'HDF5       '
%     'gzip       '
%     'Events     '
%     'bin        '
%     'from1      '
%     'precision  '      
%     'rectilinear'
%     'mixed      '
%     'max_ASCII  '
%     'debug      '             
%     ];

     data.HDF5 = 0;
     data.gzip = 0;
     data.bin =  0;
     data.from1 = 0;
     data.precision = 'double';
     data.rectilinear = [  ];
     data.mixed =  [  ];
     data.debug = 0;
     data.verbose = 0;
     data.max_ASCII = 100;
     data.xdmf = 0;
     data.cell_type = {};
     status = data;    
   end

   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
status = 0;

opt.bin = 0;
opt.HDF5 = 0;				
opt.gzip = 0;					
opt.from1 = 0;
opt.rectilinear = [];
opt.mixed = [];
opt.precision = 'double';  % old formatdouble
opt.max_ASCII = 100;
opt.debug = 0;
opt.verbose = 0;
opt.xdmf = 0;
opt.cell_names = {};

if(isa(data,'struct'))
    % input with struct plus options
    filename = data.filename;
    nodes = data.nodes;
    elements = data.cells;
    nodes_fields = data.nodes_fields;
    cell_fields = data.cell_fields;
    nodes_fields_names = data.nodes_fields_names;
    cell_fields_names = data.cell_fields_names;

    if isfield(data,'xdmf')
        opt.xdmf = data.xdmf;
    end
    if ~opt.xdmf
        names = data.names;
    end
    if isfield(data, 'cell_names')
        opt.cell_names = data.cell_names;
    end
    if isfield(data,'bin')
        opt.bin = data.bin;
    end
    if isfield(data,'HDF5')
        opt.HDF5 = data.HDF5;
    end
    if isfield(data,'gzip')
        opt.gzip = data.gzip;
    end
    if isfield(data,'mixed')
        opt.mixed = data.mixed;
    end
    if isfield(data,'from1')
        opt.from1 = data.from1;
    end
    if isfield(data,'rectilinear')
        opt.rectilinear = data.rectilinear;
    end
    if isfield(data,'precision')
        opt.precision = data.precision;
    end
    if isfield(data,'max_ASCII')
        opt.max_ASCII = data.max_ASCII;
    end
    if isfield(data,'debug')
        opt.debug = data.debug;
        if( opt.debug )
            opt.verbose = 1;
        end
    end
    if isfield(data,'verbose')
        opt.verbose = data.verbose;
    end

else
    %% input with separated fields
    filename = data;
    nodes = varargin{1};
    elements = varargin{2};
    names = varargin{3};
    nodes_fields = varargin{4};
    cell_fields = varargin{5};
    nodes_fields_names = varargin{6};
    cell_fields_names = varargin{7};
    varargin = varargin(8:end);
end
if opt.verbose
    fprintf(2,' WARNING This fuction will be depreceated in future releases. Use writepxdmf2 instead. \n');
end

if(~iscell(nodes))
    nodes = {nodes};
end

if(~iscell(elements))
    elements = {elements};
end

%% internal variables 
opt.Int_bin_file = 0;
opt.Int_bin_filename = '';
opt.Int_bin_cpt = 0;
opt.Int_HDF5_filename= '';
opt.Int_HDF5_data_counter = 0;
opt.Int_path = '';
opt.Int_indent = 0;
opt.Int_xdmf_Topology_Printed = 0;
opt.Int_xdmf_Geometry_Printed = 0;

%opt.topology = cell(1); // to delete
%opt.geometry = cell(1); // to delete
%opt.current_data = 't'; // to delete
%opt.flipTimeSpace = 0;  // to delete
%opt.units = 0;          // to delete



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% parsing option and checking HDF5 and compression
%
for k = 1:length(varargin)
    if strcmpi(varargin{k},'HDF5')
        opt.HDF5 = varargin{k+1};
        if opt.HDF5 && exist('hdf5write')
            for j = 1:length(varargin)
                if strcmpi(varargin{j},'gzip')
                    opt.gzip = varargin{k+1};  
                    if opt.gzip && exist('H5ML.id')
                        avail = H5Z.filter_avail('H5Z_FILTER_DEFLATE');
                        if ~avail
                            disp('Warning: gzip filter not available. Using normal output.')
                            opt.gzip = 0 ;
                        else
                            H5Z_FILTER_CONFIG_ENCODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_ENCODE_ENABLED');
                            H5Z_FILTER_CONFIG_DECODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_DECODE_ENABLED');
                            filter_info = H5Z.get_filter_info('H5Z_FILTER_DEFLATE');
                            if ( ~bitand(filter_info,H5Z_FILTER_CONFIG_ENCODE_ENABLED) || ~bitand(filter_info,H5Z_FILTER_CONFIG_DECODE_ENABLED) )
                                disp('Warning: gzip filter not available for encoding and decoding. Using normal output.')
                                opt.gzip = 0 ;
                            end
                        end
                    else    
                        opt.gzip =0;
                        disp('Error: Compression not available. Using normal output (HDMF5).')
                    end
                end
            end
        else
            opt.HDF5 = 0;
            disp('Error: HDF5 not available. Using normal output (ASCII).')
        end
    else 
        if (opt.HDF5 ~= 1  && strcmpi(varargin{k},'bin')  )
            opt.bin = varargin{k+1};
        end
    end
    if strcmpi(varargin{k},'cell_names')
          opt.cell_names = varargin{k+1} ;
    end 
    if strcmpi(varargin{k},'max_ASCII')
          opt.max_ASCII = varargin{k+1} ;
    end 
    if strcmpi(varargin{k},'precision')
            opt.precision = varargin{k+1} ;
    end     
    if strcmpi(varargin{k}, 'from1')
        opt.from1 = varargin{k+1};
    end
%     if strcmpi(varargin{k}, 'flipTimeSpace')          // to delete
%         opt.flipTimeSpace=1;                          // to delete
%     end                                               // to delete
    if  strcmpi(varargin{k}, 'rectilinear')
            opt.rectilinear = varargin{k+1};
    end
    if strcmpi(varargin{k},'mixed')
            opt.mixed = varargin{k+1};
    end
    if strcmpi(varargin{k}, 'debug')
        opt.debug = varargin{k+1};
        if opt.debug
            opt.verbose = 1;
        end
    end
    if strcmpi(varargin{k}, 'verbose')
        opt.verbose = varargin{k+1};
    end
    if strcmpi(varargin{k}, 'xdmf')
        opt.xdmf = varargin{k+1};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~iscell(opt.cell_names))
    opt.cell_names = {opt.cell_names};
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default for rectilinear and mixed

if size(opt.rectilinear,2) == 0
    opt.rectilinear = zeros(1,size(nodes,1));
end

if size(opt.mixed,2) == 0
    opt.mixed = zeros(1,size(nodes,1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Debug

if(opt.debug)
    disp('vvvvvvvvvvvvvvv  debug information  vvvvvvvvvvvvvv')
    disp(varargin)
    disp('^^^^^^^^^^^^^^^  debug information  ^^^^^^^^^^^^^^')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Path calcul

[opt.Int_path ,NAME,EXT] = fileparts(filename);
if isempty(EXT ) 
    if opt.xdmf
        filename = [filename '.xdmf' ];    
    else
        filename = [filename '.pxdmf' ];
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
% %% forming the filename
% %
% if size(filename,2) >= 6
%     if strcmpi(filename(end-5:end),'.pxdmf') == 0
%         opt.Int_HDF5_filename = [filename(length(opt.Int_path)+1:end) '.h5'];
%         opt.Int_bin_filename = [filename(length(opt.Int_path)+1:end) '.bin'];
%         filename = [filename '.pxdmf' ];
%     else
%         opt.Int_HDF5_filename = [filename(length(opt.Int_path)+1:end-6) '.h5'];
%         opt.Int_bin_filename = [filename(length(opt.Int_path)+1:end-6) '.bin'];
%     end
% else
%     opt.Int_HDF5_filename = [filename(length(opt.Int_path)+1:end) '.h5'];
%     opt.Int_bin_filename = [filename(length(opt.Int_path)+1:end) '.bin'];
%     filename = [filename '.pxdmf' ];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% display information about the output

if opt.verbose
    disp('*******  Writing  ********' )
    disp(['File :' filename ])
    if(opt.HDF5)
        disp(['Path :' opt.Int_path ])
        disp(['File :' opt.Int_HDF5_filename ])
        if(opt.gzip )
            disp('Compression : Active')    
        end
    end
    if(opt.bin)
        disp(['Path :' opt.Int_path ])
        disp(['File :' opt.Int_bin_filename ])
    end

    if(opt.HDF5 && opt.bin)
        disp('HDF5 and bin option are incompatible using only HDF5')
        opt.bin = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check the input values and display information 

if ~opt.xdmf
    if exist('checkpxdmfstruct','file')  == 2 || exist('checkpxdmfstruct','file')  == 6
        [checkstatus, errors] = checkpxdmfstruct(nodes, elements, names, nodes_fields, cell_fields, nodes_fields_names, cell_fields_names, opt.rectilinear, opt.mixed, opt.verbose );
        if opt.verbose
            disp('*************************' )
        end
    else 
        fprintf(2,'ERROR: Please dowloand the file checkpxdmfstruct.m from Felipe webpage \n');
        return
    end

    if (checkstatus > 0 )
        fprintf(2,' ERROR: Data is not well formed please check your data \n Errors are : \n');
        disp(errors)
        return 
    end
    pgd_dims = size(nodes,1) ;    
else
    pgd_dims = 1;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fill nodes and cell data with emtpy cells of the right sizes
if(size(nodes_fields,1) == 0 || size(nodes_fields,2) == 0   )
    nodes_fields = cell(pgd_dims,0);
    nodes_fields_names = cell(pgd_dims,0);
end

if (size(cell_fields,1) == 0|| size(cell_fields,2) == 0 )
    cell_fields = cell(pgd_dims,0);
    cell_fields_names = cell(pgd_dims,0);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% padding with zeros the spaces smaller than 3
% pxdmf needs nodes with 3 coordinates
for i = 1:pgd_dims
    if opt.rectilinear(i)
        if size(elements{i,1},2) == 2;
            elements{i,1} = [elements{i,1} 0 ];
        end
        if size(elements{i,1},2) == 1;
            elements{i,1} = [elements{i,1} 0 0];
        end
        
        if size(nodes{i,1},2) == 2;
            nodes{i,1} = [nodes{i,1} [0 1]' ];
        end
        if size(nodes{i,1},2) == 1;
            nodes{i,1} = [nodes{i,1} [0 1]' [0 1]'];
        end
        nodes{i,1}(2,:)  = nodes{i,1}(2,:) + (nodes{i,1}(2,:) <= 0);
    else
        if size(nodes{i,1},2) == 2;
            nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) ];
        end
        if size(nodes{i,1},2) == 1;
            nodes{i,1} = [nodes{i,1} zeros(size(nodes{i,1},1),1) zeros(size(nodes{i,1},1),1)];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % normalization of solution 
% for j =1:size(nodes_fields,2)
%     NumberOfModes = size(nodes_fields{1,j},1);
%     alph = ones(NumberOfModes,1);
%     for i = 2:pgd_dims
%         alphN = sqrt(sum(nodes_fields{i,j}.^2,2));
%         alph = alph.*alphN;
%         nodes_fields{i,j} =  bsxfun(@times, nodes_fields{i,j}, 1./alphN);
%     end
%     nodes_fields{1,j} =  bsxfun(@times, nodes_fields{1,j}, alph);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% posmin = cell(pgd_dims,1);
% posmax = cell(pgd_dims,1);
% 
% nnodes = cell(pgd_dims,1);
% nelem= cell(pgd_dims,1);
% 
% 
% for i = 1:pgd_dims
%     posmin{i} = min(nodes{i},[],1);
%     posmax{i} = max(nodes{i},[],1);
% 
%     nnodes{i} = size(nodes{i},1);
%     nelem{i}= size(elements{i},1);
% end


%if max(size(nodes_fields,2) ~= size(nodes_fields_names,2))
%    display(['Error: the number of cells in nodes_fields is ' num2str(size(nodes_fields,2)) '  and the number of cells in nodes_fields_names is ' num2str(size(nodes_fields_names,2))])
%    status = -1;
%    return;
%end

%if max(size(elements_fields,2) ~= size(elements_fields_names,2))
%    display(['Error: the number of cells in elements_fields is ' num2str(size(elements_fields,2)) '  and the number of cells in elements_fields_names is ' num2str(size(elements_fields_names,2))])
%    status = -1;
%    return;
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if opt.from1 == 1
    for d = 1:pgd_dims
        if opt.rectilinear(d) == 0
            if opt.mixed(d) == 0
                elements{d} = elements{d} -1;
            else
                ncomp = numel(elements{d} -1);
                i = 1;
                while (i <= ncomp)
                    switch(elements{d}(i))
                    case 1  % XDMF_POLYVERTEX 
                        i = i + 1;
                        cpt = elements{d}(i);
                    case 2  % XDMF_POLYLINE       
                        i = i + 1;
                        cpt = elements{d}(i);
                    case 3  % XDMF_POLYGON      
                        i = i + 1;
                        cpt = elements{d}(i);
                    case 4  % XDMF_TRI            
                        cpt = 3 ;
                    case 5 % XDMF_QUAD          
                        cpt = 4 ;
                    case 6 % XDMF_TET            
                        cpt =  4 ;
                    case 7 % XDMF_PYRAMID
                        cpt = 5 ;
                    case 8 % XDMF_WEDGE
                        cpt = 6 ;
                    case 9 % XDMF_HEX
                        cpt = 8 ;                    
                    case 34 % XDMF_EDGE_3
                        cpt = 3 ;                    
                    case 36 % XDMF_TRI_6
                        cpt = 6 ;                    
                    case 37 % XDMF_QUAD_8         
                        cpt = 8 ;                    
                    case 35 % XDMF_QUAD_9         
                        cpt =  9 ;                    
                    case 38 % XDMF_TET_10         
                        cpt = 10 ;                    
                    case 39 % XDMF_PYRAMID_13      
                        cpt = 13 ;                    
                    case 40 % XDMF_WEDGE_15      
                        cpt =  15 ;                    
                    case 41 % XDMF_WEDGE_18      
                        cpt =  18 ;                    
                    case 48 % XDMF_HEX_20      
                        cpt = 20 ;                    
                    case 49 % XDMF_HEX_24      
                        cpt =  24 ;                    
                    case 50 % XDMF_HEX_27      
                        cpt =  27 ;                    
                    otherwise
                        disp(['ERROR : Element not coded yet sorry, element type ' num2str(elements{d}(i))]);
                    return;
                    end
                    for j = 1:cpt
                        i = i +1;
                        elements{d}(i) = elements{d}(i) - 1;
                    end
                    i = i +1;
                end
            end
        end
    end
end

file = fopen(filename,'wt');

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
if opt.bin
    if (strcmpi(opt.precision,'single'))
        formattmp =  'ieee-be';
    else
        formattmp =  'ieee-be.l64';
    end
    [opt.Int_bin_file, MESSAGE] = fopen([opt.Int_path opt.Int_bin_filename],'w',formattmp);
    if  opt.Int_bin_file < 0
        disp(['Error opening file : ' opt.Int_path opt.Int_bin_filename] );   
        disp(MESSAGE)    ;
        return 
    end
end


if (file<0)
    disp(['Error opening file : ' filename] )
    status = -1;
    return
end

opt = print_header(file,opt,filename);

% posmax = posmax + norm(posmax-posmin)/100000;
% 
% X= linspace(posmin(1),posmax(1),divisions(1)+1);
% Y= linspace(posmin(2),posmax(2),divisions(2)+1);
% Z= linspace(posmin(3),posmax(3),divisions(3)+1);
% 
% delta = [X(2) Y(2) Z(2)]-[X(1) Y(1) Z(1)];
% Xzero = [X(1) Y(1) Z(1)];
% elements_to_write = zeros(nelem,1);
% for e=1:nelem
%     pos = nodes(elements(e,1)+1,:)-Xzero;
%     elements_to_write(e) = sum(floor(pos./delta).*[ 1 (divisions(1)) (divisions(1))*(divisions(2))]);
% end

% maxtime = max(max(size(nodes_fields,1),size(elements_fields,1)),1);

pgd_dim_dim = zeros(pgd_dims,1);
if opt.xdmf
    opt.current_dim = 1;
    
        
    
    max_time_point= max(cellfun(@(arg1) size(arg1,1),nodes_fields));
    max_time_elem= max(cellfun(@(arg1) size(arg1,1),cell_fields));
    max_time = max([ max_time_point max_time_elem]);
    
    if numel(max_time)==0 ; max_time = 1; end
    
    if max_time > 1
        opt = print_indent(file,opt,1);
        fprintf(file,'<Grid Name="Domain Space x Time" GridType="Collection" CollectionType="Temporal" >\n');
        opt = write_time(file, opt, max_time);
    end
    
    for i = 1:max_time
        opt = print_indent(file,opt,1);
        fprintf(file,'<Grid Name="Time_%i" >\n',i);
        opt = write_grid_pgd(file,nodes{1},elements{1},...
            cellfun(@(arg1) arg1(i,:), nodes_fields,'Uniformoutput',0),...
            cellfun(@(arg1) arg1(i,:),cell_fields,'Uniformoutput',0),...
            nodes_fields_names, cell_fields_names, opt);
    end
    
    if opt.xdmf && max_time > 1
        opt = print_indent(file,opt,-1);
        fprintf(file,'</Grid>\n');
    end

else
    for i= 1:pgd_dims
        opt.current_dim = i;
        
        opt = print_indent(file,opt,1);
        fprintf(file,'<Grid Name="PGD%i" >\n',i);
        
        if ~opt.xdmf
            opt = print_indent(file,opt,1);
            pgd_dim_dim(i) =  length(names{i});
            fprintf(file,'<Information Name="Dims" Value="%i" />\n',pgd_dim_dim(i));
            for j=1:pgd_dim_dim(i)
                opt = print_indent(file,opt,0);
                fprintf(file,'<Information Name="Dim%i" Value="%s" />\n',j-1,names{i,1}{j});
                if(size(names,2)>1)
                    fprintf(file,'<Information Name="Unit%i" Value="%s" />\n',j-1,names{i,2}{j});
                end
            end
        end
        opt = write_grid_pgd(file,nodes{i},elements{i},nodes_fields(i,:), cell_fields(i,:), nodes_fields_names, cell_fields_names, opt);
    end
   
end

    
if opt.gzip == 1
    H5F.close(opt.HDF5_file);
end

if opt.bin == 1
    fclose(opt.Int_bin_file);
end

print_footer(file)
fclose(file);

try
status = 0;
catch ME
disp(ME)
status = -1;
end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_grid_pgd(file,nodes,elements,nodes_fields, elements_fields, nodes_fields_names, elements_fields_names, opt)



%%%%%%%%%%%%%%%%%%%%%%%% Topology %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if opt.rectilinear(opt.current_dim) 
    opt = print_indent(file,opt,1);
    fprintf(file,'<Topology TopologyType="3DCORECTMESH" Dimensions="%d %d %d" />\n' ,fliplr(elements +1));
else
    multipointcells = false;
    if(opt.mixed(1,opt.current_dim))
        element_type = 'Mixed';
        
    else
        if(numel(opt.cell_names) >= opt.current_dim)
            element_type = opt.cell_names{opt.current_dim};
        else
            % automatic detection of the element type
            switch size(elements,2)
                case 9
                    element_type = 'Quadrilateral_9';
                case 8
                    element_type = 'Hexahedron';
                case 6
                    element_type = 'Wedge';
                case 4
                    element_type = 'Quadrilateral';
                case 3
                    element_type = 'Triangle';
                case 2
                    element_type = 'Polyline';
                case 1
                    element_type = 'Polyvertex';
                otherwise
                    if( size(elements,2) > 10   && size(elements,1) == 1 )
                        if(length(unique(elements)) ~= size(nodes,1) )
                            disp(['treating dimension ' num2str(opt.current_dim) ' as polyline mesh'] );
                            element_type = 'Polyline';
                            multipointcells = true;
                        else
                            disp(['treating dimension ' num2str(opt.current_dim) ' as Polyvertex mesh'] );
                            element_type = 'Polyvertex';
                            multipointcells = true;
                        end
                    else
                        disp('Error Element type not implemented')
                        return;
                    end
            end
        end

    end

    opt = print_indent(file,opt,1);
    fprintf(file, '<Topology TopologyType="%s" ',element_type);
    if(multipointcells)
        fprintf(file, 'NumberOfElements="1" ');
        fprintf(file,' NodesPerElement="%d" ', size(elements,2)); 
    else
        if opt.mixed(1,opt.current_dim)
            %counting the number of elements;
            nbelem = 0;
            cpt = 1;
            while(cpt < length(elements))
                % for information about the type of element avilable please
                % read the file XdmfTopology.h in the ParaView sources.
                switch(elements(cpt))
                    case 1  % XDMF_POLYVERTEX 
                        nbelem = nbelem + 1;
                        cpt = cpt + elements(cpt+1)+2;
                    case 2  % XDMF_POLYLINE       
                        nbelem = nbelem + 1;
                        cpt = cpt + elements(cpt+1)+2;
                    case 3  % XDMF_POLYGON      
                        nbelem = nbelem + 1;
                        cpt = cpt + elements(cpt+1)+2;
                    case 4  % XDMF_TRI            
                        nbelem = nbelem + 1;
                        cpt = cpt + 4 ;
                    case 5 % XDMF_QUAD          
                        nbelem = nbelem + 1;
                        cpt = cpt + 5 ;
                    case 6 % XDMF_TET            
                        nbelem = nbelem + 1;
                        cpt = cpt + 5 ;
                    case 7 % XDMF_PYRAMID
                        nbelem = nbelem + 1;
                        cpt = cpt + 6 ;
                    case 8 % XDMF_WEDGE
                        nbelem = nbelem + 1;
                        cpt = cpt + 7 ;
                    case 9 % XDMF_HEX
                        nbelem = nbelem + 1;
                        cpt = cpt + 9 ;                    
                    case 34 % XDMF_EDGE_3
                        nbelem = nbelem + 1;
                        cpt = cpt + 4 ;                    
                    case 36 % XDMF_TRI_6
                        nbelem = nbelem + 1;
                        cpt = cpt + 7 ;                    
                    case 37 % XDMF_QUAD_8         
                        nbelem = nbelem + 1;
                        cpt = cpt + 9 ;                    
                    case 35 % XDMF_QUAD_9         
                        nbelem = nbelem + 1;
                        cpt = cpt + 10 ;                    
                    case 38 % XDMF_TET_10         
                        nbelem = nbelem + 1;
                        cpt = cpt + 11 ;                    
                    case 39 % XDMF_PYRAMID_13      
                        nbelem = nbelem + 1;
                        cpt = cpt + 14 ;                    
                    case 40 % XDMF_WEDGE_15      
                        nbelem = nbelem + 1;
                        cpt = cpt + 16 ;                    
                    case 41 % XDMF_WEDGE_18      
                        nbelem = nbelem + 1;
                        cpt = cpt + 19 ;                    
                    case 48 % XDMF_HEX_20      
                        nbelem = nbelem + 1;
                        cpt = cpt + 21 ;                    
                    case 49 % XDMF_HEX_24      
                        nbelem = nbelem + 1;
                        cpt = cpt + 25 ;                    
                    case 50 % XDMF_HEX_27      
                        nbelem = nbelem + 1;
                        cpt = cpt + 28 ;                    
                    otherwise
                        disp(['ERROR : Element not coded yet sorry, element type ' num2str(elements(cpt))]);
                        return;
                end
            end
            fprintf(file, 'NumberOfElements="%d" ' ,nbelem);

        else
            fprintf(file, 'NumberOfElements="%d" ' ,size(elements,1));
            if strcmp(element_type, 'Polyline'); fprintf(file,' NodesPerElement="2" '); end
            if strcmp(element_type, 'Polyvertex'); fprintf(file,' NodesPerElement="1" '); end
        end
    end
    fprintf(file,' >\n');
    if opt.xdmf && opt.Int_xdmf_Topology_Printed
        opt= write_dataItem_reference(file, opt,'Topology');    
    else
        opt= print_DataItem(file, 1:size(elements,1),elements,opt,'%i');
        opt.Int_xdmf_Topology_Printed = 1;
    end
    opt = print_indent(file,opt,-1);
    fprintf(file,'</Topology>\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%% Geometry %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if opt.rectilinear(opt.current_dim)
        opt = print_indent(file,opt,1);
        fprintf(file,'<Geometry GeometryType="ORIGIN_DXDYDZ">\n' );
        opt = print_indent(file,opt,1);
	    fprintf(file,'<DataItem Name="Origin" Format="XML" NumberType="Float" Dimensions="3">\n' );
		fprintf(file,'%d %d %d \n', fliplr(nodes(1,:)) );
        opt = print_indent(file,opt,-1);
        fprintf(file,'</DataItem>\n' );
        opt = print_indent(file,opt,1);
	    fprintf(file,'<DataItem Name="Spacing" Format="XML" NumberType="Float" Dimensions="3">\n' );
		fprintf(file,'%d %d %d \n', fliplr(nodes(2,:)) );
        opt = print_indent(file,opt,-1);
        fprintf(file,'</DataItem>\n' );
        opt = print_indent(file,opt,-1);
		fprintf(file,'</Geometry>\n' );
else
    opt = print_indent(file,opt,1);
    fprintf(file,'<Geometry GeometryType="XYZ">\n' );
    if opt.xdmf && opt.Int_xdmf_Geometry_Printed
        opt= write_dataItem_reference(file, opt,'Geometry');    
    else
        opt= print_DataItem(file, 1:size(nodes,1),nodes,opt, opt.precision);
        opt.Int_xdmf_Geometry_Printed = 1;
    end
    opt = print_indent(file,opt,-1);
    fprintf(file,'</Geometry>\n' );
end
%%%%%%%%%%%%%%%%%%%%%%%%% nodes_fields %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:size(nodes_fields,2)
    
    for mode=1:size(nodes_fields{i},1)
        opt = print_indent(file,opt,1);
        if opt.xdmf
            fprintf(file,'<Attribute Name="%s" Center="Node"', nodes_fields_names{i});
        else
            fprintf(file,'<Attribute Name="%s_%i" Center="Node"', nodes_fields_names{i},mode-1 );
        end
        
        if(length(nodes_fields{i}(mode,:)) ==  size(nodes,1)  ||  (opt.rectilinear(opt.current_dim)  && length(nodes_fields{i}(mode,:)) ==  prod(elements +1 ) ) )
            fprintf(file,' AttributeType="Scalar"');
            fprintf(file,' >\n');
            if opt.rectilinear(opt.current_dim)
                opt= print_DataItem(file, 1:size(nodes_fields{i}(mode,:),1),nodes_fields{i}(mode,:),opt,opt.precision, fliplr(elements +1) );
            else
                opt= print_DataItem(file, 1:size(nodes_fields{i}(mode,:),1),nodes_fields{i}(mode,:),opt,opt.precision );
            end
        else
            %disp([ nodes_fields_names{i}  ' is a vector field']);
            fprintf(file,' AttributeType="Vector"');
            fprintf(file,' >\n');
            opt= print_DataItem(file, 1:size(nodes_fields{i}(mode,:),1),nodes_fields{i}(mode,:),opt,opt.precision, fliplr(elements +1));
        end
        opt = print_indent(file,opt,-1);
        fprintf(file,'</Attribute>\n' );
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(elements_fields,2)
    for mode=1:size(elements_fields{i},1)
        opt = print_indent(file,opt,1);
        
        if opt.xdmf
            fprintf(file,'<Attribute Name="%s" Center="Cell"', elements_fields_names{i});
        else
            fprintf(file,'<Attribute Name="%s_%i" Center="Cell"', elements_fields_names{i},mode-1  );
        end
        
        if (length(elements_fields{i}(mode,:)) ==  size(elements,1) || (opt.rectilinear(opt.current_dim)  && length(elements_fields{i}(mode,:)) ==  prod(elements))    )
            fprintf(file,' AttributeType="Scalar"');
            fprintf(file,' >\n');
            if opt.rectilinear(opt.current_dim) 
                opt = print_DataItem(file,  1:size(elements_fields{i}(mode,:),1),elements_fields{i}(mode,:),opt,opt.precision, fliplr(elements) );
            else
                opt = print_DataItem(file,  1:size(elements_fields{i}(mode,:),1),elements_fields{i}(mode,:),opt,opt.precision);
            end
        else
            fprintf(file,' AttributeType="Vector"');
            fprintf(file,' >\n');
            opt = print_DataItem(file,  1:size(elements_fields{i}(mode,:)/3,1),reshape(elements_fields{i}(mode,:),[],3),opt,opt.precision, fliplr(elements)  );
        end
        opt = print_indent(file,opt,-1);
        fprintf(file,'</Attribute>\n' );
    end
end
%%%%%%%%%%%
opt = print_indent(file,opt,-1);
fprintf(file,'</Grid>\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = print_DataItem(file, indice_to_write, field, opt, format, dims)
    
    if issparse(field)
        field = full(field);
    end
    
    data = '';
    
    opt = print_indent(file,opt,1);
    data = [data sprintf('<DataItem')];
    if opt.HDF5 == 1 && numel(field) > opt.max_ASCII
        data = [data sprintf(' Format="HDF"' )];
    else
        if opt.bin == 1 
            data = [data sprintf(' Format="Binary" Endian="Big" Seek="%i"',opt.Int_bin_cpt )];    
        else
            data = [data sprintf(' Format="XML"' )];
        end
    end
    
    if strcmpi(format,'%i')
        data = [data sprintf(' NumberType="Int"' )];
    else 
        if(strcmpi(format,'single'))
            data = [data sprintf(' NumberType="Float" Precision="4"' )];
        else
            data = [data sprintf(' NumberType="Float" Precision="8"' )];
        end
    end
    
    if opt.rectilinear(opt.current_dim)
        %data = [data sprintf(' Dimensions="%s">\n', ['1 ' num2str(length(indice_to_write)) ' ' num2str(size(field,2)) ] )];
        if opt.bin
            data = sprintf('%s Dimensions="%.0f %.0f %.0f">\n', data, dims );
        else
            data = sprintf('%s Dimensions="1 %.0f %.0f">\n', data, size(field) );
        end
    else
        %data = [data sprintf(' Dimensions="%s">\n', [ num2str(length(indice_to_write)) ' ' num2str(size(field,2)) ] )];
        %data = sprintf('%s Dimensions="%s">\n', data ,num2str(size(field)) );
        data = sprintf('%s Dimensions="%.0f %.0f">\n', data, size(field) );
    end
    

    if opt.HDF5 == 1 && numel(field) > opt.max_ASCII
        if  opt.gzip ==1 && numel(field) > 1000
            % Create dataspace.  Setting maximum size to [] sets the
            % maximum
            % size to be the current size.  Remember to flip the dimensions.
            %
            DIMS = size(field(indice_to_write,:));
            %space = H5S.create_simple (2, fliplr(DIMS), []);
            space = H5S.create_simple (2, DIMS, []);
            %
            % Create the dataset creation property list, add the gzip
            % compression filter and set the chunk size.  Remember to flip
            % the chunksize.
            %
            dcpl = H5P.create('H5P_DATASET_CREATE');
            
            H5P.set_deflate (dcpl, 9);

            %H5P.set_chunk (dcpl, fliplr([1 1]));
            %H5P.set_chunk (dcpl, fliplr(DIMS));
            H5P.set_chunk (dcpl, DIMS);
            
            %DATASET =  ['/dataset' num2str(opt.Int_HDF5_data_counter) '/' 'DataItem' num2str(opt.Int_HDF5_data_counter) ];
            DATASET=  ['DataItem' num2str(opt.Int_HDF5_data_counter) ];
            if strcmpi(format,'%i')
                %H5P.set_chunk (dcpl, fliplr(DIMS));
                %
                % Create the dataset.
                %
                dset = H5D.create(opt.HDF5_file,DATASET,'H5T_STD_I32LE',space,dcpl);
                %
                % Write the data to the dataset.
                %
                H5D.write(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT',int32(field(indice_to_write,:))');
            else
                if(strcmpi(format,'single'))
                    % Create the dataset.
                    dset= H5D.create(opt.HDF5_file,DATASET,'H5T_IEEE_F32LE',space,dcpl);
                    % Write the data to the dataset.
                    H5D.write(dset,'H5T_NATIVE_FLOAT','H5S_ALL','H5S_ALL','H5P_DEFAULT',single(field(indice_to_write,:)'));
                else
                    % Create the dataset.
                    dset= H5D.create(opt.HDF5_file,DATASET,'H5T_IEEE_F64LE',space,dcpl);
                    % Write the data to the dataset.
                    H5D.write(dset,'H5T_NATIVE_DOUBLE','H5S_ALL','H5S_ALL','H5P_DEFAULT',double(field(indice_to_write,:)'));
                end
            end
            H5P.close(dcpl);
            H5D.close(dset);
            H5S.close(space); 
            opt.Int_HDF5_data_counter = opt.Int_HDF5_data_counter +1;
            
            data = [data sprintf('%s:%s' , opt.Int_HDF5_filename ,DATASET)];
        else
            dset_details.Location = ['/dataset' num2str(opt.Int_HDF5_data_counter)];
            dset_details.Name = [ 'DataItem' num2str(opt.Int_HDF5_data_counter)  ];
            
            if strcmpi(format,'%i')
                hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details,int32(field(indice_to_write,:))','WriteMode','append');
            else 
                if(strcmpi(format,'single'))
                    %hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details, single(field(indice_to_write,:)'),'WriteMode','append');
                    hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details, single(field'),'WriteMode','append');
                else
                    %hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details, double(field(indice_to_write,:)'),'WriteMode','append');
                    hdf5write([opt.Int_path opt.Int_HDF5_filename ], dset_details, double(field'),'WriteMode','append');
                    %h5write([opt.Int_path opt.Int_HDF5_filename ], [dset_details.Location '/' dset_details.Name], double(field'));
                end
            end
            
            opt.Int_HDF5_data_counter = opt.Int_HDF5_data_counter +1;

            data = [data sprintf('%s:%s/%s' , opt.Int_HDF5_filename ,dset_details.Location, dset_details.Name )];
        end
        opt = print_indent(file,opt,-1);
        data = [data sprintf('\n</DataItem>\n' )];
        fprintf(file,data);
    else
      %%% for binary output 
      if opt.bin == 1
        if strcmpi(format,'%i')
          opt.Int_bin_cpt = fwrite(opt.Int_bin_file,int32(field(indice_to_write,:))','integer*4')*4 + opt.Int_bin_cpt;
        else
            if(strcmpi(format,'single'))
                opt.Int_bin_cpt = fwrite(opt.Int_bin_file,single(field(indice_to_write,:)'),format)*4 + opt.Int_bin_cpt;
            else
                %opt.Int_bin_cpt = fwrite(opt.Int_bin_file,double(field(indice_to_write,:)'),format)*8 + opt.Int_bin_cpt;
                opt.Int_bin_cpt = fwrite(opt.Int_bin_file,double(field'),format)*8 + opt.Int_bin_cpt;
            end
        end
        fprintf(file,data);
        fprintf(file,opt.Int_bin_filename);
        opt = print_indent(file,opt,-1);
        fprintf(file, '\n</DataItem>\n' );

        %data = [data sprintf('%s' , opt.Int_bin_filename)];
        %opt = print_indent(file,opt,-1);
        %data = [data sprintf('\n</DataItem>\n' )];
        %fprintf(file,data);
      else
      %%% for ASCII output
        if strcmpi(format,'%i')
          format = '%u';
        else
         if(strcmpi(format,'single'))
          format = '%1.8g';
         else
          format = '%1.16g';
         end
        end

        format_ = repmat([format ' '],[ 1 size(field,2)]);
        format_ = [format_ '\n']; 

        fprintf(file,data);
        fprintf(file, format_ , field(indice_to_write,:)' );

        opt = print_indent(file,opt,-1);
        fprintf(file, '</DataItem>\n' );
      end
    end
    %opt.current_data = data;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = print_header(file, opt, filename)

    fprintf(file,'<?xml version="1.0" ?>\n');
    fprintf(file,'<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" []>\n');
    fprintf(file,'<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >\n');
    fprintf(file,'<Domain Name="%s">\n', filename);
    opt = print_indent(file,opt,1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_footer(file)
    fprintf(file,'</Domain>\n');
    fprintf(file,'</Xdmf>\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_time(file, opt, maxtime)
    
    opt = print_indent(file,opt,1);
    fprintf(file,'<Time TimeType="List">\n');
    opt = print_DataItem(file, 1, (1:maxtime)-1, opt, 'double',[maxtime 1 1]);
    %opt = print_indent(file,opt,1);
    %fprintf(file,'<DataItem Format="XML" NumberType="Float" Dimensions="%i">\n',maxtime);
    %fprintf(file,' %f',(1:maxtime)-1);
    %fprintf(file,'\n');
    %opt = print_indent(file,opt,-1);
    %fprintf(file,'</DataItem>\n');
    opt = print_indent(file,opt,-1);
    fprintf(file,'</Time>\n');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = write_dataItem_reference(file, opt,type)
  %fprintf(file, '<DataItem Reference="XML" Dimensions="%i %i">\n', length(indice_to_write), size(elements,2) );
  opt = print_indent(file,opt,1);
  fprintf(file, '<DataItem Reference="XML" >\n' );
  fprintf(file, '/Xdmf/Domain/Grid/Grid[@Name="Time_1"]/%s/DataItem \n',type);
  opt = print_indent(file,opt,-1);
  fprintf(file,'</DataItem>\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt =print_indent(file,opt,n)
   if(opt.debug)
       if n < 0
           opt.Int_indent = opt.Int_indent + n;  
       end   
       for i = 1 :2*opt.Int_indent
           fprintf(file,' ');
       end
       
       if n >0
            opt.Int_indent = opt.Int_indent + n;  
       end    
   end
   
end
