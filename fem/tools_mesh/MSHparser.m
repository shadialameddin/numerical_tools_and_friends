function [n,e,t]=MSHparser(filename,ids_volume)

%% MSH ASCII Parser for read Nodes, Elems & Datas
% Input :
% Filename : AVS Filepath
%
% output :
% n     : List of Nodes and their position
% e     : connectivity table for each volume part
% t     : elements type for each volume part
%
% V2 - S. Nachar - 4/11/17
%
% ! : Read only mesh data and not

% Open the file
fileID = fopen(filename);
flag_last_volume = any(isnan(ids_volume));
parseType=create_parseType;
if flag_last_volume; num_parts=1; else; num_parts = numel(ids_volume); end
% Read lines to catch structure information
while ~feof(fileID)
    header=fgetl(fileID);
    switch header(2:end)
        case 'MeshFormat'
            header=fgetl(fileID);
            temp=sscanf(header,'%f %d %d');
            MSHVersion=temp(1);
            isASCII   =~temp(2);
            if MSHVersion~=2.2
                warning('MSH File Format Version isn''t 2.2 : Script may crash');
            end
            if ~isASCII
                error('This version is for MSH ASCII format');
            end
        case 'Nodes'
            num_nodes = str2double(fgetl(fileID));
            n = fscanf(fileID,'%d %f %f %f',[4,num_nodes+1]);
            n = n';
            n = n(n(:,1),:);
            n(:,1)=[];
            strEnd = fgetl(fileID);
            if ~strcmp(strEnd,'$EndNodes')
                warning('Something may be wrong with Nodes Parser');
            end
        case 'Elements'
            %elm-number elm-type number-of-tags < tag > … node-number-list
            num_elems = str2double(fgetl(fileID));
            BrutElems = fscanf(fileID,'%d');
            BrutElems = BrutElems';
            strEnd = fgetl(fileID);
            if ~strcmp(strEnd,'$EndElements')
                warning('Something may be wrong with Elems Parser');
            end
            idBrut=0;
            type    = cell(num_elems,1);
            connect = cell(num_elems,1);
            tags    = cell(num_elems,1);
            nb_tag  = zeros(num_elems,1);
            for id=1:num_elems
                type{id}    = BrutElems(idBrut+2);
                nb_tag(id)  = BrutElems(idBrut+3);
                tags{id}    = BrutElems(idBrut+3+(1:nb_tag(id)));
                nb_nodes    = parseType(type{id});
                connect{id} = BrutElems(idBrut+3+nb_tag(id)+(1:nb_nodes));
                idBrut=idBrut+3+nb_tag(id)+nb_nodes;
            end
            clear BrutElems
            if flag_last_volume; ids_volume=tags{end}(1); end
            flag_nb_tag = all(nb_tag==nb_tag(1));
            if flag_nb_tag; tags = cell2mat(tags); end

            e = cell(num_parts,1);
            t = cell(num_parts,1);
            for id_part = 1:num_parts
                id_volume = ids_volume(id_part);
                if flag_nb_tag
                    idx = any(tags == id_volume,2);
                else
                    idx = cellfun(@(C) any(C == id_volume),tags);
                end
                if flag_last_volume; idx = idx & cellfun(@(C) C == type{end},type); end
                t{id_part}=vertcat(type{idx});
                e{id_part}=vertcat(connect{idx});
            end
    end
end
fclose(fileID);
end
function parseType=create_parseType
parseType = zeros(16,1);
%2-Line
parseType(1) = 2;
%3-Node Triangle
parseType(2) = 3;
%4-Node Quadrangle
parseType(3) = 4;
%4-node tetrahedron.
parseType(4) = 4;
%8-node hexahedron.
parseType(5) = 8;
%6-node prism
parseType(6) = 6;
%5-node pyramid.
parseType(7)=5;
%3-node second order line (2 nodes associated with the vertices and 1 with the edge).
parseType(8)=3;
%6-node second order triangle (3 nodes associated with the vertices and 3 with the edges).
parseType(9)=6;
%9-node second order quadrangle (4 nodes associated with the vertices, 4 with the edges and 1 with the face).
parseType(14)=9;
%1-node point
parseType(15)=1;
%8-node second order quadrangle (4 nodes associated with the vertices and 4 with the edges).
parseType(16)=8;
end
% function nb_nodes=parseType(type)
% switch type
%     case 1 %2-Line
%         nb_nodes = 2;
%     case 2 %3-Node Triangle
%         nb_nodes = 3;
%     case 3 %4-Node Quadrangle
%         nb_nodes = 4;
%     case 4 %4-node tetrahedron.
%         nb_nodes = 4;
%     case 5 %8-node hexahedron.
%         nb_nodes = 8;
%     case 6 %6-node prism
%         nb_nodes = 6;
%     case 7 %5-node pyramid.
%         nb_nodes=5;
%     case 8 %3-node second order line (2 nodes associated with the vertices and 1 with the edge).
%         nb_nodes=3;
%     case 9 %6-node second order triangle (3 nodes associated with the vertices and 3 with the edges).
%         nb_nodes=6;
%     case 10 %9-node second order quadrangle (4 nodes associated with the vertices, 4 with the edges and 1 with the face).
%         nb_nodes=9;
%     case 15 %1-node point
%         nb_nodes=1;
%     case 16 %8-node second order quadrangle (4 nodes associated with the vertices and 4 with the edges).
%         nb_nodes=8;
% end
% end