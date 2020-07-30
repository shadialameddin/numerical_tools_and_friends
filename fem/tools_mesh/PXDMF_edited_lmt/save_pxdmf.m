function save_pxdmf(model,results,filename)
% todo: ​accound for Mandel notation when building the vtk file
%save_pxdmf(obj.model,obj.results,file);
if nargin<3
    dirname = 'output';
    filename = 'output';
else
    id = regexpi(filename,filesep);
    if isempty(id)
        dirname = 'output';
    else
        dirname = filename(1:id(end)-1);
        filename = filename(id(end)+1:end);
    end
end

for id_model = 1:numel(model)
    current_model       = model{id_model};
    current_geometry    = current_model.geometry;
    dimension           = current_geometry.dimension;
    ncomp               = sum(1:dimension);
    nb_parameters       = numel(current_model.parameters);
    Grids               = XdmfGrid();
    connectivity        = cell(nb_parameters,1);

    %% First Grid - Space
    Grids(1).geometry = current_geometry.nodes_position;
    if dimension == 1; Grids(1).geometry(:,2:3) = zeros(current_geometry.nodes_number,2); end;
    if dimension == 2; Grids(1).geometry(:,3)   = zeros(current_geometry.nodes_number,1); end;
    table = table_xdmfelements(current_geometry.elements_type);
    connectivity{1}   = current_geometry.connectivity_ne-1;
    Grids(1).topology = [table';connectivity{1}'];
    Grids(1).topology = Grids(1).topology(:);
    % Note: to know the number for each element please read the PXDMF format
    % file document at rom.ec-nantes.fr

    Grids(1).coordNames = {'X' 'Y' 'Z'};
    Grids(1).coordUnits = {'m' 'm' 'm'};

    Grids(1).coordNames = Grids(1).coordNames(1:dimension);
    Grids(1).coordUnits = Grids(1).coordUnits(1:dimension);

    %% Other Grids - Parameters
    % They are considered like discret points
    for id_parameter=2:nb_parameters
        Grids(id_parameter).geometry = current_model.parameters(id_parameter).mesh';
        connectivity{id_parameter}   = (0:numel(Grids(id_parameter).geometry)-1)';
        Grids(id_parameter).topology = [ones(1,numel(Grids(id_parameter).geometry));connectivity{id_parameter}'];
        Grids(id_parameter).topology = Grids(id_parameter).topology(:);
        Grids(id_parameter).coordNames = {current_model.parameters(id_parameter).name};
        Grids(id_parameter).coordUnits = {current_model.parameters(id_parameter).unit};
    end

    %% Fields Definition - Space
    % ! Only One Gauss Point per element (Old Paraview Restriction)
    if nargin >= 2
    Grids = fieldspxdmf(Grids,current_geometry,results(id_model),nb_parameters);
    end
    options = writepxdmf2();
    options.binary = false;
    options.filename = sprintf('%s%s%s-%d',dirname,filesep,filename,id_model);
    options.xdmf = false;
    output=v2tov1(Grids,options,connectivity);
    writepxdmf(output);
    copyfile([options.filename '.pxdmf'],[options.filename '.xdmf']);

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
function output=v2tov1(Grids,options,connectivity)
    output=struct;
    output.nodes                = {Grids(:).geometry}';
    output.cells                = connectivity;
    output.names                = {Grids(:).coordNames}';
    output.nodes_fields         = vertcat(Grids(:).nodeFields);
    output.nodes_fields         = cellfun(@transpose,output.nodes_fields,'Uniformoutput',false);

    output.nodes_fields_names   = Grids(1).nodeFieldsNames;
    output.cell_fields          = vertcat(Grids(:).elementFields);
    output.cell_fields          = cellfun(@transpose,output.cell_fields,'Uniformoutput',false);

    output.cell_fields_names    = Grids(1).elementFieldsNames;
    % Trick for tetrahedron
    if Grids(1).topology(1)==6; output.cell_names = {'tetrahedron'}; end
    output.filename             = options.filename;
end
