    function [n,e,t] = read_avs(filename)
    %  V2 - S.Nachar - 28/05/2016
    [n,Elems]=AVSparser(filename);
    e=Elems.connect;
    typeAVS     = {'line','bar' ,'tri' ,'quad','tet' ,'hex' };
    typeROMlab  = {'bar2','bar2','tri3','qua4','tet4','cub8'};
    t=cell(size(Elems.type));
    for typeId=1:length(typeAVS);
        t(strcmp(typeAVS{typeId},Elems.type))=typeROMlab(typeId);
    end
    end