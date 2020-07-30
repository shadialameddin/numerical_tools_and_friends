function Grids = fieldspxdmf(Grids,geometry,results,nb_parameters)

if ~all(geometry.GP_nodes_number==geometry.GP_nodes_number(1))
    error('Multi-elements PXDMF not implemented');
end
dim     = geometry.dimension;
ncomp   = sum(1:dim);

nb_nodes = geometry.dofs_number;
nb_GPdof = ncomp*sum(geometry.GP_nodes_number);

idx_nodes = reshape(1:geometry.dofs_number          ,dim  ,geometry.nodes_number)';

%dofs_id   = cellfun(@(C) reshape(C,ncomp,numel(C)/ncomp),geometry.GP_dofs_id,'Uniformoutput',false);
CompVectNames = {'_x','_y','_z'};
CompTensNames = {'_xx','_yy','_zz','_xy','_yz','_xz'};

id_node = 1;
id_cell = 1;

for field = fieldnames(results)'
    tensor = create_ktensor(results.(field{:}));
    switch size(tensor,1)
        case nb_GPdof
            for id_parameter=1
                temp = reshape(tensor.u{id_parameter},ncomp,geometry.GP_nodes_number(1),geometry.elements_number,size(tensor.u{id_parameter},2));
                temp = mean(temp,2);
                temp = permute(temp,[1 3 4 2]);
                for id_ncomp=1:ncomp
                    temp2 = temp(id_ncomp,:,:);
                    temp2 = permute(temp2,[2 3 1]);
                    Grids(id_parameter).elementFields{id_ncomp,id_cell} = temp2;
                end
                Grids(id_parameter).elementFieldsNames(1:6,id_cell) = cellfun(@(c1,c2) [c1 c2],repmat(field,1,6),CompTensNames,'Uniformoutput',false)';
            end
            for id_parameter=2:nb_parameters
                for id_ncomp = 1:ncomp
                    Grids(id_parameter).elementFields{id_ncomp,id_cell} = tensor.u{id_parameter};
                end
            end
            id_cell = id_cell+1;            
            
        case nb_nodes
            for id_parameter=1
                for id_dim = 1:dim
                    Grids(id_parameter).nodeFields{id_dim,id_node} = tensor.u{id_parameter}(idx_nodes(:,id_dim),:);
                end
                Grids(id_parameter).nodeFieldsNames(1:3,id_node) = cellfun(@(c1,c2) [c1 c2],repmat(field,1,3),CompVectNames,'Uniformoutput',false)';
            end
            for id_parameter=2:nb_parameters
                for id_dim = 1:dim
                    Grids(id_parameter).nodeFields{id_dim,id_node} = tensor.u{id_parameter};
                end
            end
            id_node = id_node+1;
    end
end
%Grids(1).nodeFieldsNames = Grids(1).nodeFieldsNames(1:dim,:);
switch dim
    case 1
        Grids(1).elementFieldsNames = Grids(1).elementFieldsNames(1,:);
    case 2
        Grids(1).elementFieldsNames = Grids(1).elementFieldsNames([1 2 4],:);   
end
for id_parameter=1:nb_parameters
Grids(id_parameter).nodeFields         = Grids(id_parameter).nodeFields(:)'; 
Grids(id_parameter).elementFields      = Grids(id_parameter).elementFields(:)';
Grids(id_parameter).nodeFieldsNames    = Grids(1).nodeFieldsNames(:)';
Grids(id_parameter).elementFieldsNames = Grids(1).elementFieldsNames(:)';   
end
end
