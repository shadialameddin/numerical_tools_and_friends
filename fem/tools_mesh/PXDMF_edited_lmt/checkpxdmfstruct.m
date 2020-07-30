function [ok,errors]=checkpxdmfstruct(nodes, cells, names, nodes_fields, cell_fields, nodes_fields_names, cell_fields_names,rectilinear, mixed,  plotinfo)
% function [ok,error]=function [ok,errors]=checkpxdmfstruct(nodes, elements,
% names, nodes_fields, cell_fields, nodes_fields_names, cell_fields_names,rectilinear, mixed, plotinfo)
%
%    function to check the integrity of a pxdmf structure
%
%   if plotinfo = 1 print info about the data
%
%   ok = 0 every thing ok,
%   ok > 0 error cout number
%
%   error is a list of string with the error descriptions
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%

if(isa(nodes,'struct'))
    % input with struct plus options
    plotinfo = cells;
    cells = nodes.cells;
    names = nodes.names;
    nodes_fields = nodes.nodes_fields;
    cell_fields = nodes.cell_fields;
    nodes_fields_names = nodes.nodes_fields_names;
    cell_fields_names = nodes.cell_fields_names;
    
    if isfield(nodes,'mixed')
        mixed = nodes.mixed;
    else
        mixed =zeros (size(nodes.nodes,1));
    end
    
    if isfield(nodes,'rectilinear')
        rectilinear = nodes.rectilinear;
    else
        rectilinear = zeros (size(nodes.nodes,1));;
    end
    
    nodes = nodes.nodes;
    
    
end


ok = 0;
errors = {};

pgd_dims = size(nodes,1) ;

% size verification for the cell
if size(nodes,1) ~= pgd_dims
    ok = ok + 1;
    errors = adderror(errors,'number of dims of nodes is no compatible with the number of dims of cells');
end

% size verification of node_fields (can be {})
if( size(nodes_fields,2) ~= length(nodes_fields_names)   )
    ok = ok +1;
    errors = adderror(errors,'number of dims of nodes_fields is no compatible with the numboer of dims of nodes_fields_names');
end

if(size(nodes_fields,1) ~= pgd_dims &&  size(nodes_fields,2) ~= 0  )
    ok = ok + 1;
    errors = adderror(errors,'number of dims of nodes is no compatible with the number of dims of nodes_fields');
end

% size verification of cell_fields (can be {})
if( size(cell_fields,2) ~= length(cell_fields_names)   )
    ok = ok +1;
    errors = adderror(errors,'number of dims of cell_fields is no compatible with the numboer of dims of cell_fields_names');
end

if(size(cell_fields,1) ~= pgd_dims &&  size(cell_fields,2) ~= 0  )
    ok = ok + 1;
    errors = adderror(errors,'number of dims of nodes is no compatible with the number of dims of cell_fields');
end

nbnodes = zeros(pgd_dims,1);
nbelem = zeros(pgd_dims,1);
for i = 1:pgd_dims
    if  rectilinear(i)
        nbelem(i) = prod(cells{i,1}(cells{i,1} > 0));
        nbnodes(i) = prod(cells{i,1}+1);
    else
        nbnodes(i) = size(nodes{i},1);
        if mixed(i)
            nbelem(i) = countelementMixed(cells{i,1});
        else 
            nbelem(i) = size(cells{i,1},1);
        end
    end
end

nodal_vectorial = zeros(size(nodes_fields,2),1);
cell_vectorial = zeros(size(nodes_fields,2),1);

% % verification of the size of the modes and the numbers of the modes (nodes)
for i = 1:size(nodes_fields,2)
    dim1modesnumber = size(nodes_fields{1,i},1);
    for d = 1:pgd_dims
        % mode number check
        if (size(nodes_fields{1,i},1) ~=  dim1modesnumber )
            ok = ok +1;
            errors = adderror(errors,[ 'field ' nodes_fields_names{i} ' : modes dim 0 (' num2str(dim1modesnumber) ') different of modes dim ' num2str(d) ' ('  num2str( size(nodes_fields{1,i},1))  ' )' ]);
        end
        if ( nbnodes(d)  ~=  size(nodes_fields{d,i},2))
            % case of vectorial data
             if size(nodes_fields{d,i},2)/3 ~= nbnodes(d)
                 ok = ok + 1;
                 errors = adderror(errors,[ 'field ' nodes_fields_names{i} ' : size of modes in dim ' num2str(d) ' (' num2str(size(nodes_fields{d,i},2)) ') is different of the number of nodes ' num2str(nbnodes(d))   ]);
             else
                nodal_vectorial(i) = 1;
             end
        end
    end
end


% verification of the size of the modes and the numbers of the modes (cells)
for i = 1:size(cell_fields,2)
    dim1modesnumber = size(cell_fields{1,i},1);
    for d = 1:pgd_dims
        if (size(cell_fields{1,i},1) ~=  dim1modesnumber )
            ok = ok +1;
            errors = adderror(errors,[ 'field ' cell_fields_names{i} ' : modes dim 0 (' num2str(dim1modesnumber) ') different of modes dim ' num2str(d) ' ('  num2str( size(cell_fields{1,i},1))  ' )' ]);
        end
        numberofcells = size(cells{d},1);
        if ( numberofcells  ~=  size(cell_fields{d,i},2))
            % case of vectorial data
            if size(cell_fields{d,i},2)/3 ~= numberofcells
                ok = ok +1;
                errors = adderror(errors,[ 'field ' cell_fields_names{i} ' : size of modes in dim ' num2str(d) ' (' num2str(size(cell_fields{d,i},2)) ') is different of the number of cells ' num2str(numberofcells)   ]);
             else
                cell_vectorial(i) = 1;
            end
        end
        %        disp([ ' Name : ' cell_fields_names{i} ' Modes : ' num2str(size(cell_fields{1,i},1)) ]);
    end
end






if ~exist('plotinfo','var')
    plotinfo = 0;
end



if plotinfo
    
    disp(['Number Of Spaces :' num2str(size(nodes,1)) ])
    
    for i = 1:pgd_dims

        disp([' PXDMF Dim :' num2str(i) '  Number of nodes :' num2str(nbnodes(i),'%5d') '  Number of Elements :' num2str(nbelem(i)) ]);
        if rectilinear(i)
           disp( '  Rectilinear mesh' );
        end
        if mixed(i)
            disp( '  Mixed mesh' );
        end
        for j = 1:(size(names{i,1},2))
            if size(names,2) == 2
                disp([ '  Name : ' names{i,1}{j} '  Unit : '  names{i,2}{j} ]);
            else
                disp([ '  Name : ' names{i,1}{j} '  Unit : (no units) ']);
            end
        end
    end
    disp('Nodes Fields')
    for i = 1:size(nodes_fields,2)
        mess = [ ' Name : ' nodes_fields_names{i} ' Modes : ' num2str(size(nodes_fields{1,i},1)) ];
        if nodal_vectorial(i)
            mess = [ mess ' (Vector field)'];
        else
            mess = [ mess ' (scalar field)'];
        end
        disp(mess);
    end
    
    disp('Cell Fields')
    for i = 1:size(cell_fields,2)
        mess =[ ' Name : ' cell_fields_names{i} ' Modes : ' num2str(size(cell_fields{1,i},1)) ];
        if cell_vectorial(i)
            mess = [ mess ' (Vector field)'];
        else
            mess = [ mess ' (scalar field)'];
        end
        disp(mess);
    end

end

end


function errors = adderror(errors,error)

errors{size(errors,1)+1,1} = error;

end

function nbelem = countelementMixed(elements)

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
                        cpt = cpt + 32 ;                    
            case 50 % XDMF_HEX_27      
                nbelem = nbelem + 1;
                cpt = cpt + 28 ;                    
            otherwise
                disp(['ERROR : Element not coded yet sorry, element type ' num2str(elements(cpt))]);
            return;
        end
    end
end