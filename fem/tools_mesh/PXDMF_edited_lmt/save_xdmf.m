function save_xdmf(model,results,filename)

for id_model = 1:numel(model)
    current_model       = model{id_model};
    current_geometry    = current_model.geometry;
    dimension           = current_geometry.dimension;
    nb_parameters       = numel(current_model.parameters);
    connectivity        = cell(nb_parameters,1);
    
    Grids(1).geometry = current_geometry.nodes_position;
    if dimension == 1; Grids(1).geometry(:,2:3) = zeros(current_geometry.nodes_number,2); end;
    if dimension == 2; Grids(1).geometry(:,3)   = zeros(current_geometry.nodes_number,1); end;
    table = table_xdmfelements(current_geometry.elements_type);
    connectivity{1}   = current_geometry.connectivity_ne-1;
    Grids(1).topology = [table';connectivity{1}'];
    Grids(1).topology = Grids(1).topology(:);
    Grids(1).nbElements = current_geometry.elements_number;
    
    Grids(1).fields = struct('size',[],'data',[],'type',[],'dimensions',[],'center',[],'name',[]);
    fields = fieldnames(results);
    for id = 1:numel(fields)
        field = fields{id};
        tmp = AttributeType(current_geometry,results(id_model).(field));
        tmp.name = field;
        Grids(1).fields(id) = tmp;
    end
    xdmf3writer(sprintf('%s-%d',filename,id_model),Grids);
end
end

function table=table_xdmfelements(elements_type)
elem_def;
table = zeros(numel(elements_type),1);
all_elements_avaliable = fieldnames(ELDEF);
for id_ELDEF = 1:length(all_elements_avaliable)
    element             = all_elements_avaliable{id_ELDEF};
    ids_elements        = strcmp(element,elements_type);
    table(ids_elements) = ELDEF.(element).xdmf_corres;
end
end

function Out=AttributeType(geo,data)
Out.data         = double(data);
siz = num2cell(size(data));
switch siz{1}
    case geo.elements_number
        type        = 'Scalar';
        center      = 'Cell';
    case sum(geo.GP_nodes_number)
        [Out.data,siz]=mean_cell(Out.data,siz,1);
        type        = 'Scalar';
        center      = 'Cell';        
    case geo.nodes_number
        type        = 'Scalar';
        center      = 'Node';
    case 3 * geo.elements_number
        type        = 'Vector';
        center      = 'Cell';
    case 3 * sum(geo.GP_nodes_number)
        [Out.data,siz]=mean_cell(Out.data,siz,3);
        type        = 'Vector';
        center      = 'Cell';
    case 3 * geo.nodes_number
        type        = 'Vector';
        center      = 'Node';
    case 6 * geo.elements_number
        type        = 'Tensor6';
        center      = 'Cell';
    case 6 * geo.nodes_number
        type        = 'Tensor6';
        center      = 'Node';
    case 6 * sum(geo.GP_nodes_number)
        [Out.data,siz]=mean_cell(Out.data,siz,6);
        type        = 'Tensor6';
        center      = 'Cell';
    otherwise
        keyboard;
end
Out.type         = type;
Out.dimensions   = num2str(siz{1});
Out.center       = center;
Out.size         = sprintf('%d ',size(data)); Out.size(end)=[];

    function [data,siz]=mean_cell(data,siz,ncomp)
        idx = 0;
        tmpdata = zeros(geo.elements_number,siz{2:end});
        for id = 1:geo.elements_number
            tmp = data(idx+(1:geo.GP_nodes_number(id)*ncomp),:);
            tmp = mean(reshape(tmp,ncomp,geo.GP_nodes_number(id),siz{2:end}),2);
            tmp = squeeze(tmp);
            tmpdata(ncomp*(id-1)+(1:ncomp),:) = tmp;
            idx = idx+geo.GP_nodes_number(id)*ncomp;
        end
        data = tmpdata;
        siz{1}      = ncomp * geo.elements_number;
    end
end
