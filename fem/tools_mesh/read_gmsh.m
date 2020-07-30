function [n,e,t] = read_gmsh(filename,id)
    if nargin == 1; id = nan; end
    [n,e,t]=MSHparser(filename,id);
    typeMSH     =[1:10,15:16];
    typeROMlab  = {'bar2','tri3','qua4','tet4','cub8','pri6','pyr5','bar3','tri6','qua9','poi1','qua8'};
    for id=1:numel(t)
    tmp = cell([size(t{id}) 1]);
    for typeId=1:length(typeMSH)
        idx = t{id}==typeMSH(typeId);
        tmp(idx) = typeROMlab(typeId);
    end
    t{id} = tmp;
    end
    if numel(e)==1
        e = e{1};
        t = t{1};
    end
end