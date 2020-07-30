function model = read_ansys_mesh(filename)
% Read ANSYS FE mesh data (geometry data only)
%
% INPUT:
%   filename (string): [path\] input text file containing the following
%                      outputs from ANSYS: ETLIST, NLIST, ELIST, i.e.
%                      element types, nodes list, element list, created 
%                      using the included macro export.mac
% OUTPUT:
%  model.filename = path + filename of the model file
%  model.surf     = reduced model containing surface nodes/elements only, excl. midside nodes
%    node_table   = [node_number, x, y, z] single(n_nodes x 4)
%    elem_table   = [elem_number, type_no, mat_no, node1, ..., node8, com_x, com_y, com_z] single(n_elems x 14)
%    face_table   = [node1, node2, node3, node4, elem_no, centr_x, centr_y, centr_z] single(n_faces x 8)
%    max_dim      = largest range of coordinates in any x,y or z direction
%    model_com    = model center of mass [x,y,z]
%    e_size       = "avarage" element side length
%    e_types      = list of element type numbers
%    mapping      = maps between names and indices for nodes, elements and faces
%      node2ni    = node name (externally referenced number) -> node index in node_table
%      elem2ei    = element name -> element index in elem_table
%      face2elem  = face index -> element name
%      ni2face    = node index -> face index
%      ni2ei      = node index -> element index
% 
% Supported element types:
%   SOLID187: 3-D 10-Node Tetrahedral Solid
%   SOLID186: 3-D 20-Node Hexahedral Solid (also degenerated versions)
%
% 
% Demo: just call it without any outputs, e.g.
% >> read_ansys_model('model1.txt')
%
% Created by 
%  by M.M. Pedersen, mmp@et.aau.dk
%  Aalborg University, Denmark, 2015
%
%%
    
    tstart = tic;
    hwb = waitbar(0.1,'Reading model file');

    % read text file containing model definition
    [node_table,elem_table,elem_types] = read_file(filename);
    node2ni = create_node_map(node_table);
    
    % generate faces
    waitbar(0.4,hwb,'Generating face table');
    face_table = generate_faces(node2ni,elem_table,elem_types);

    % return data for entire model
    model.filename = filename;
    model.entire.node_table = node_table;
    model.entire.elem_table = elem_table;
    model.entire.elem_types = elem_types;
    model.entire.face_table = face_table;
    model.entire.node2ni    = node2ni;
    
    % reduction to surface model
    waitbar(0.6,hwb,'Removing collapsed faces');
    face_table = remove_collapsed(face_table);
    [node_table,elem_table,face_table] = remap(node_table,elem_table,face_table);

	face_table = remove_dup_faces(face_table,node_table,hwb);
    [node_table,elem_table,face_table] = remap(node_table,elem_table,face_table);
      
    waitbar(0.8,hwb,'Calculating model dimensions');
    [elem_table,face_table,max_dim,model_com,esize] = model_dimensions(elem_table,face_table,model.entire);
    
    mapping = create_number_maps(node_table,elem_table,face_table);
    
    % return data for surface model
    model.surf.node_table = node_table;
    model.surf.elem_table = elem_table;
    model.surf.face_table = face_table;
    model.surf.mapping    = mapping;
    model.surf.max_dim    = max_dim;
    model.surf.model_com  = model_com;
    model.surf.esize      = esize;
    model.surf.etypes     = unique(elem_table(:,2));
    
   
    % subdivide model according to material no. (sub-parts)
    part_nos = unique(model.surf.elem_table(:,3));
    for i = 1:length(part_nos)
        model.parts(i).no    = part_nos(i);
        model.parts(i).name  = ['Material #' num2str(part_nos(i))];
        
        part_elem_idx   = (model.surf.elem_table(:,3) == part_nos(i));
        part_elem_names = model.surf.elem_table(part_elem_idx,1);
        
        %[~,model.parts(i).faces] = ismember(part_elem_names,face_table(:,5));    
        [Lia] = ismember(face_table(:,5),part_elem_names);    
        model.parts(i).faces = find(Lia);
        
    end
    
    waitbar(0.85,hwb,'Extracting interior nodes');
    model.interior.node_table = interior_nodes(model);
    
    waitbar(0.87,hwb,'Determining face normals');
    model.surf.face_norms = face_normals(face_table,node_table,elem_table(:,12:14),model.surf.mapping.elem2ei);
    
    waitbar(0.89,hwb,'Determining node normals');
    [model.surf.node_normals, model.surf.node_axis] = node_normals(model);
    
    waitbar(0.92,hwb,'Detecting edges');
    edge_detection_limit = 45*(pi/180); % angle to exceed, if edge is to be part of wire frame
    model.surf.wire_frame = edge_detection(face_table,node_table,model.surf.face_norms,edge_detection_limit);
        
    fclose all;
    waitbar(1,hwb,'Done.');
    delete(hwb);
    fprintf('%.2fs\n',toc(tstart))
    
    % demo-mode:
    if nargout==0

        figure('name','ANSYS mesh example','NumberTitle','off'); 
        
        % plot elements using patch
        faces = model.surf.face_table(:,1:4);
        verts = model.surf.node_table(:,2:4);
        patch('Faces',faces,'Vertices',verts,'facecolor','c','edgecolor','k');

        % plot at thicker line around sharp edges 
        wf = model.surf.wire_frame;
        line(wf(1,:), wf(2,:), wf(3,:),'color','k','linewidth',1.5);
        
        axis equal
        axis vis3d
        view(30,35);
        
    end
    
    
end


%% Sub functions
function [node_table,elem_table,elem_types] = read_file(filename)
% read model file exported from ANSYS/Simulation and
% return tables of nodes, elements and element types

    % read text file
    fid = fopen(filename);
    if fid==-1
        error('Can''t find or open file: %s\n',filename); 
    else
        fprintf('Importing FE model: %s ... ',filename);
    end
    file    = textscan(fid,'%s','delimiter',sprintf('\n'),'whitespace','');
    file    = file{1};
    str_array = char(file);
    
    % trim/pad file width
    file_width = 150;
    if size(str_array,2) > file_width
        
        str_array(:,file_width+1:end) = [];
        
    elseif size(str_array,2) < file_width
        
        missing = file_width - size(str_array,2);
        spaces(1:size(str_array,1),1:missing) = ' ';
        str_array = [str_array spaces];
        
    end
 
    [node_table,elem_table,elem_types] = read_mesh_ansys(str_array);

      
end
  
function face_table = remove_dup_faces(face_table,node_table,hwb)
% Remove faces with coincident centroids and returns surface-faces only

    waitbar(0.7,hwb,'Calculating face centroids');
    n_faces = size(face_table,1);
    c = calc_centroid(face_table,node_table);
    waitbar(0.8,hwb,'Removing internal faces');
    
    % find & remove faces with coincident centroids
    [~,ii,~] = unique(c,'rows','stable'); % ii = index of unique values in c
    repi = setdiff(1:n_faces,ii);   % repi = index of one of the repeated values in c
    repc = c(repi,:);
    [~,idx] = setdiff(c,repc,'rows');
    ufaces = face_table(idx,:); % surface faces
    ucentr = c(idx,:);          % associated centroids
    face_table = [ufaces ucentr];
    
end

function [node_table,elem_table,face_table] = remap(node_table,elem_table,face_table)
% Reduce node, element and face tables so they only include used entities.
% Furthermore remaps nodes to consecutive numbers starting from 1.
% [~,LocB]=ismember(A,B) Locb contains the index in B for each value in A

    face_verts = face_table(:,1:4);
    used_node_idx = unique(face_verts);
    %used_elem_idx = unique(face_table(:,5));
    used_elem_names = unique(face_table(:,5));
    [~,used_elem_idx] = ismember(used_elem_names,elem_table(:,1));
    
    % remove unused nodes & elements
    node_table = node_table(used_node_idx,:);
    elem_table = elem_table(used_elem_idx,:);
    
    % remap vertex entries in face table to point to new node indices
    [~,remapped_verts] = ismember(face_verts,used_node_idx);
    face_table = [remapped_verts face_table(:,5:end)];
    
end

function node2ni = create_node_map(node_table)
    
    % node name -> index
    nodes = node_table(:,1);
    node2ni  = zeros(max(nodes),1,'uint32');
    for ni = 1:size(nodes,1) % ni = internal node number
        n = nodes(ni);       % n  = external node name
        node2ni(n) = ni;
    end
    
end

function mapping = create_number_maps(node_table,elem_table,face_table)
% create maps between different number systems

    n_nodes = size(node_table,1);
    n_elems = size(elem_table,1);
    n_faces = size(face_table,1);
    

    % node name -> index
    node2ni = create_node_map(node_table);
    
    % element name -> index
    elems = elem_table(:,1);
    elem2ei = zeros(max(elems),1,'uint32');
    for ei = 1:size(elems,1) % ei = internal element number
        e = elems(ei);       % e  = external element name
        elem2ei(e) = ei;
    end
    
    
    % face index -> element name
    face2elem = face_table(:,5);
    
   
    % node index -> face no.
    faces = face_table(:,1:4);
    ni2face = zeros(n_nodes,10,'uint32');% node2face(node) = face
    nf = zeros(n_nodes,1,'uint8');
    
    for f = 1:n_faces
        
        if faces(f,3) == faces(f,4)
            fnodes = 3;
        else
            fnodes = 4;
        end
        
        for i = 1:fnodes
            ni = faces(f,i); % current node
            nf(ni) = nf(ni) + 1; % counter
            ni2face(ni,nf(ni)) = f; % current face
        end
        
    end
    
    
    % map node-idx -> connetected elem-idx
    ni2ei = zeros(n_nodes,15,'uint32');
    ne = zeros(n_nodes,1,'uint8');
    
    for ei = 1:n_elems
        for i = 3:10
            n = elem_table(ei,i); % current node
            if n>0 && n<=length(node2ni)
                ni = node2ni(n);
                if ni>0
                    ne(ni) = ne(ni) + 1; % counter
                    ni2ei(ni,ne(ni)) = ei; % current elem
                end
            end
        end
    end
    
    % return values
    mapping.node2ni   = node2ni;
    mapping.elem2ei   = elem2ei;
    mapping.face2elem = face2elem;
    mapping.ni2face   = ni2face;
    mapping.ni2ei     = ni2ei;
    
end

function [elem_table,face_table,max_dim,model_com,esize]= model_dimensions(elem_table,face_table,entire_model)
% Calculate model dimensions

    % use all nodes in model for these calculations
    node_table = entire_model.node_table;
    node2ni    = entire_model.node2ni;
    
    % find model CoM
    model_com = calc_com(node_table);
    
    % find max dimension
    max_dim = max(range(node_table(:,2:4)));
    
    % find & add element CoM to element table
    elem_table = calc_elem_com(elem_table,node_table,node2ni);
    
    % estimate element side length
    [esize,face_table] = calc_elem_size(node_table,face_table);
   

end

function [node_normals,node_axis] = node_normals(model)
   
    faces   = model.surf.face_table(:,1:4);
    coords  = model.surf.node_table(:,2:4);
    n_nodes = length(coords);
    node_normals = zeros(n_nodes,3,'single');
    node_axis = zeros(n_nodes,3,'single');
    
    for ni = 1:n_nodes
                
        faces_on_node = model.surf.mapping.ni2face(ni,:);
        faces_on_node = faces_on_node(faces_on_node>0);
        all_nodes     = unique(faces(faces_on_node,:));
        
        % fit plane to all nodes on all faces connected to central node:
        X = coords(all_nodes,:);
        p = mean(X,1);
        R = bsxfun(@minus,X,p);
        
        % Computation of the principal directions of the samples cloud
        [V,~] = eig(R'*R);
        
        % surface tangent plane normal
        n = V(:,1);
        
        if 1
            elems_on_node = model.surf.mapping.ni2ei(ni,:);
            elems_on_node = elems_on_node(elems_on_node>0);
            
            % calculate combined COM of attached elements
            ec = [0 0 0]';
            for i = 1:length(elems_on_node)
                ei = elems_on_node(i);
                ec = ec + model.surf.elem_table(ei,12:14)';
            end
            ec = ec/length(elems_on_node);

            % node position
            np = coords(ni,:)';
            
            % if normal points 
            n1 = np + n;
            n2 = np - n;
            if norm(n1-ec) < norm(n2-ec)
                n = -n;
            end
            
        end
        
        % project global x-axis onto plane
        xg = [1 0 0]';
        x = xg - (dot(xg,n)/norm(n))*n;
        
        % if n==x, use y-axis
        if norm(x)==0
            yg = [0 1 0]';
            x = yg - (dot(yg,n)/norm(n))*n;
        end
        
        node_axis(ni,:) = unit(x)';

        % node normal best fit
        node_normals(ni,:) = real(n');
        
    end
        
end

function int_node_table = interior_nodes(model)
% return node_table for interior nodes only.

    all_nodes  = model.entire.node_table(:,1);
    surf_nodes = model.surf.node_table(:,1);
    
    [~,int_node_idx] = setdiff(all_nodes,surf_nodes,'stable');
    int_node_table = model.entire.node_table(int_node_idx,:);
    
end

function [node_table,elem_table,elem_types] = read_mesh_ansys(file)

    n_lines = size(file,1);

    % initialize arrays
    node_table = zeros(n_lines,4,'single');  % nodeno, x,y,z coordinates
    elem_table = zeros(n_lines,11,'single'); % elemno, typeno, matno, up to 8 nodes
    elem_types = zeros(n_lines,1,'uint16');
    
    % scan line by line and extract values
    nn = 0;
    ne = 0;

    in_node_block = false;
    in_elem_block = false;
    i = 0;
    
    while i < n_lines

        i = i+1;
        cur_line = file(i,:);

        % element types
        if strncmp(cur_line,' ELEMENT TYPE',13)
            
            type_line = cur_line;
            type_no_line = type_line(15:end);
            [type_no_str,rest] = strtok(type_no_line); 
            type_no = str2single(type_no_str);
            rest(1:3) = [];
            type_name = strtok(rest); 
            
            switch type_name
                case 'SOLID186'
                    elem_types(type_no) = 2;
                case 'SOLID187'
                    elem_types(type_no) = 3;
                case 'ROUGH' % handle new version 16+ ETLIST print out format:
                    % ELEMENT TYPES      3 THROUGH      5 ARE THE SAME AS TYPE      2   
                    [~,rest] = strtok(rest);
                    [type_no_end_str,rest] = strtok(rest);
                    [~,rest] = strtok(rest);
                    [~,rest] = strtok(rest);
                    [~,rest] = strtok(rest);
                    [~,rest] = strtok(rest);
                    [~,rest] = strtok(rest);
                    [same_type_str,~] = strtok(rest);
                    
                    type_no_end = str2single(type_no_end_str);
                    same_type_no = str2single(same_type_str);
                    
                    for multi_type = type_no:type_no_end
                        elem_types(multi_type) = elem_types(same_type_no); 
                    end
                    
                otherwise % unsupported
                    elem_types(type_no) = 99; 
            end
                    
            continue;
            
        end
        
                
        % nodes
        if strncmp(cur_line,'         ',9) || strncmp(cur_line,'1',1)
            in_node_block = false;
            continue;
        end

        if in_node_block
            nn = nn+1;
            
            [node_str,rest] = strtok(cur_line);
            [x_str,rest]    = strtok(rest);
            [y_str,rest]    = strtok(rest);
            z_str           = strtok(rest);
            
            node_no = str2single(node_str);
            x = str2single(x_str);
            y = str2single(y_str);
            z = str2single(z_str);
            
            node_table(nn,1:4) = [node_no x y z];
            continue;
        end

        if strncmp(cur_line,'   NODE',7)
            in_node_block = true;
            continue;
        end

        % elements
        if strncmp(cur_line,'                                   ',35)...
        || strncmp(cur_line,'1',1)
            in_elem_block = false;
        end

        if in_elem_block && ~strncmp(cur_line,'        ',8) 
            % ELEM MAT TYP REL ESY SEC    NODES
            % 316   4   4   1   0   4     74   444   443    75   370   251   252   371

            [elem_no_str,rest]  = strtok(cur_line); % elem no
            [cur_mat_str,rest] = strtok(rest); % eleme MAT no.
            [cur_typ_str,rest] = strtok(rest); % elem TYP no

            elem_no  = str2single(elem_no_str);
            cur_mat  = str2single(cur_mat_str);
            cur_type = str2single(cur_typ_str);
            
            if elem_no>0 && elem_types(cur_type)>0

                ne = ne+1;
                elem_table(ne,1) = elem_no;
                elem_table(ne,2) = cur_type;
                elem_table(ne,3) = cur_mat;

                switch elem_types(cur_type)
                    case 2 % SOLID186 (hex)
                        nodes_per_element = 8;

                    case 3 % SOLID187/SOLID92 (tet)
                        nodes_per_element = 4;
                        
                    otherwise 
                        nodes_per_element = 0; % to satisfy coder
                end

                for skip=1:3;
                    [~,rest] = strtok(rest);
                end
                
                for n = 1:nodes_per_element
                    [node,rest] = strtok(rest);
                    elem_table(ne,n+3) = str2single(node);
                end

                continue; 
            end
            
        end

        if strncmp(cur_line,'    ELEM',8)
            in_elem_block = true;
            i = i + 1;
            continue;
        end
        
    end

    % remove unused entries
    node_table(node_table(:,1)==0,:) = [];
    elem_table(elem_table(:,1)==0,:) = [];
    elem_types(elem_types==0)        = [];

end


% The following functions can be mex'ed for performance:
function face_table = generate_faces(node2idx,elem_table,elem_types)
% Generates table of faces for all elements
% incl. map of facenumber to element index

    % mapping of nodes on tet/hex elements to faces
    tetmap = [1 2 3 3; 1 2 4 4; 1 3 4 4; 2 3 4 4]; % use 4 vertices for tet faces also.
    hexmap = [1 2 3 4; 1 2 6 5; 2 3 7 6; 3 7 8 4; 1 4 8 5; 5 6 7 8];

    % face table: [node_idx1, node_idx2, node_idx3, node_idx4, elem_name]
    n_elems = size(elem_table,1);
    face_table = zeros(6*n_elems,5,'single');
    f = 0;
    
    for ei = 1:n_elems

        % get element type specifics
        cur_elem_type = elem_table(ei,2);
        elem_name     = elem_table(ei,1);
        
        switch elem_types(cur_elem_type)
            case 1 % 'TETRA10' (tet)
                nodes   = elem_table(ei,4:7);
                fmap    = tetmap;
                n_faces = 4;
            case 2 % 'SOLID186' (hex)
                nodes   = elem_table(ei,4:11);
                fmap    = hexmap;
                n_faces = 6;
            case 3 % 'SOLID187' (tet)
                nodes   = elem_table(ei,4:7);
                fmap    = tetmap;
                n_faces = 4;
            otherwise
                n_faces = 0;
        end
        
        % build face table
        for no = 1:n_faces
            f = f + 1;
            face_table(f,1:4) = node2idx(nodes(fmap(no,:)))';
            face_table(f,5)   = elem_name;
        end
        
    end
    
    % remove unused entries
    face_table(face_table(:,1)==0,:) = [];
    
end

function wire_frame = edge_detection(face_table,node_table,face_norms,atol)
    % Finds the hard edges in the mesh and construct wire frame model
    %
    % edge_table(v1 v2 f1 f2 h)
    % v1,v2 = vertices defining edge
    % f1,f2 = adjacent faces
    % h     = hard edge 1/0

    n_faces = size(face_table,1);
    n_edges = n_faces*4;

    edge_table = zeros(n_edges,5,'uint32');
    e = 1;


    % build edge table
    for f = 1:n_faces

        cur_face = uint32(face_table(f,1:4)); % indices of nodes (vertices)
        n_verts = length(unique(cur_face));

        for v = 1:n_verts

            % edge vertices
            v1 = cur_face(v);
            if v < n_verts
                v2 = cur_face(v+1);
            else
                v2 = cur_face(1);
            end

            edge_table(e,1:3) = [min(v1,v2) max(v1,v2) f];
            e = e + 1;

        end

    end


    % clear unused entries
    edge_table(edge_table(:,1)==0,:) = [];


    % remove duplicated edges (all edges are now registered twice)
    edge_table = sortrows(edge_table);
    n_edges = size(edge_table,1); % approx 2x no. edges, because of duplicates

    for i = 1:n_edges-1

        % vertices defining edge
        e_cur  = edge_table(i,1:3);
        e_next = edge_table(i+1,1:3);

        % if the vertices defining two subsequent edges in the sorted list,
        % eliminate one and add the associated face number to the other.
        if e_cur(1)==e_next(1) && e_cur(2) == e_next(2)
            edge_table(i,4) = e_next(3);
            edge_table(i+1,1:3) = [0 0 0];
        end

    end

    % clear unused entries
    edge_table(edge_table(:,1)==0,:) = [];


    % check for hard edges
    n_edges = size(edge_table,1);
    hard_edges = zeros(n_edges,2,'uint32');
    e = 1;
    for i = 1:n_edges

        % check angle between opposing face normals
        n1 = face_norms(edge_table(i,3),:)';

        opposing_face = edge_table(i,4);

        if ~opposing_face % skip (no opposing face)
            continue;
        else
            n2 = face_norms(opposing_face,:)';  

            v_cross = single(n1'*n2);
            if v_cross >1
                v_cross = single(1);
            elseif v_cross<-1
                v_cross = single(-1);
            end

            a = abs(real(acos(v_cross)));
        end

        if a > atol || ~opposing_face % (if no opposing faces found -> hard edge)
            hard_edges(e,:) = edge_table(i,1:2);
            e = e + 1;
        end

    end
    hard_edges(hard_edges(:,1)==0,:) = [];


    % build wireframe model
    n_edges = size(hard_edges,1);
    wire_frame = zeros(3,3*n_edges,'single');
    for e = 1:n_edges
        v1 = hard_edges(e,1);
        v2 = hard_edges(e,2);
        c1 = node_table(v1,2:4)';
        c2 = node_table(v2,2:4)';
        wire_frame(1:3, (e*3-2):(e*3) ) = [c1 c2 [NaN NaN NaN]'];
    end

end

function normals = face_normals(face_table,node_table,elem_centroids,elem2ei)
% Calculates face normals used for edge detection.

    n_faces   = length(face_table);
    normals   = zeros(n_faces,3,'single');

    for f = 1:n_faces

        % current face nodes
        cur_face = face_table(f,1:4);

        % find node coords: p,q,r (p=prev, q=center, r=next)
        p = node_table(cur_face(1),2:4)';
        q = node_table(cur_face(2),2:4)';
        r = node_table(cur_face(3),2:4)';

        % face centroid
        fc = face_table(f,6:8)';

        % construct edge vectors
        qp = p-q;
        qr = r-q;

        % unit face normal
        n = cross(qr,qp);
        n = n/norm(n);

        % element centroid
        ei = elem2ei(face_table(f,5));
        ec = elem_centroids(ei,:)';

        % fix normal so it points outwards
        n1 = fc + n;
        n2 = fc - n;
        if norm(n1-ec) < norm(n2-ec)
            n = -n;
        end

        % store
        normals(f,:)   = n';

    end
end

function face_table = remove_collapsed(face_table)
% Remove collapsed faces, i.e. faces where multiple vertex numbers 
% refer to the same nodes. E.g. face = point or face = line.

    n_faces = size(face_table,1);
    unique_nodes_on_face = zeros(n_faces,1,'uint32');
    
    for f = 1:n_faces
        
        unique_nodes_on_face(f) = length(unique(face_table(f,1:4)));
        
    end
    
    collapsed = [find(unique_nodes_on_face==1); 
    find(unique_nodes_on_face==2)];
    face_table(collapsed,:) = [];
    
end

function c = calc_centroid(face_table,node_table)

    n_faces = size(face_table,1);
    c   = zeros(n_faces,3,'single');
    
    % calculate centroid for all faces
    for f = 1:n_faces
        
        cur_face = unique(face_table(f,1:4));
        n_nodes = length(cur_face);
        
        for no = 1:n_nodes
            p = node_table(cur_face(no),2:4);
            c(f,:) = c(f,:) + p;
        end
        
        c(f,:) = c(f,:)/n_nodes;
    end
    
end

function model_com = calc_com(node_table)

    n_nodes = size(node_table,1);
    model_com = single([0 0 0]');
    
    for ni = 1:n_nodes
        p = node_table(ni,2:4)';
        model_com = model_com + p;
    end
    
    model_com = model_com/n_nodes;

end

function elem_table_out = calc_elem_com(elem_table,node_table,node2ni)
% find & add element CoM to element table

    n_elems = size(elem_table,1);
    elem_table_out = [elem_table zeros(n_elems,3,'single')];
    
    for ei = 1:n_elems
        
        c  = single([0 0 0]'); %CoM
        nn = 0; % no. nodes on element
        for j = 1:8
            n = elem_table(ei,j+3);
            if n>0
                ni = node2ni(n);
                p  = node_table(ni,2:4)';
                c  = c + p;
                nn = nn + 1;
            else
                continue;
            end
        end
        
        elem_table_out(ei,12:14) = c'/nn;
        
    end
    
end

function [esize, face_table] = calc_elem_size(node_table,face_table)
% estimate element side length

    n_faces = size(face_table,1);
    face_table_out = [face_table zeros(n_faces,1,'single')];
    
    for f = 1:n_faces
        
        cur_face = face_table(f,1:4);
        
        pi = node_table(cur_face(1),2:4);
        pj = node_table(cur_face(2),2:4);
        pk = node_table(cur_face(3),2:4);
        
        face_table_out(f,9) = (norm(pj-pi) + norm(pj-pk))/2;
        
    end
    
    esize = mean(face_table_out(:,9));

end

function num = str2single(input_str)
% % convert string to single (ready for mex-ing)
% 
%     str = strtrim(input_str);
%     n_digits = length(str);
%     i = 1;
%     num = single(0);
%     
%     % check sign
%     if str(1)=='-'
%         is_negative = true;
%         str(1) = [];
%         n_digits = length(str);
%     else
%         is_negative = false;
%     end
%     
%     % decimals before the comma
%     while i<=n_digits && str(i) >= '0' && str(i) <= '9'
%         cur_digit = single(str(i)-'0');
%         num = num*10 + cur_digit;
%         i = i+1;
%     end
% 
%     % decimals after the comma
%     if i<=n_digits && (str(i) == '.' || str(i) == ',')
% 
%         i = i+1;
% 
%         % decimal part
%         decimal = single(0);
%         divisor = single(1);
% 
%         while i<=n_digits && str(i) >= '0' && str(i) <= '9'
%             divisor = divisor * 10;
%             decimal = decimal * 10;
%             decimal = decimal + single(str(i) - '0');
%             i = i+1;
%         end
%         
%         num = num + decimal / divisor;
%    
%     end
% 
%     % scientific notation
%     if i<=n_digits && (str(i) == 'e' || str(i) == 'E')
%         i = i+1;
%         
%         is_negative_exp = false;
%         exp = single(0);
%         
%         switch str(i)
%             case '-'
%                 is_negative_exp = true;
%                 i = i+1;
%             case '+'
%                 i = i+1;
%         end
%         
%         while i<=n_digits && str(i) >= '0' && str(i) <= '9'
%             exp = exp * 10;
%             exp = exp + single(str(i) - '0');
%             i = i+1;
%         end
%         
%         if is_negative_exp
%             exp = -exp;
%         end
%         
%         num = num * 10^exp;
%     end
%     
%     % apply sign
%     if is_negative 
%         num = -num;
%     end
%    

    % the nicer way to do it (but cannot be mex'ed)
    num = single(str2double(input_str));

end

function u = unit(v)
% Returns the unit vector of input v

    u = v/norm(v);
    
end