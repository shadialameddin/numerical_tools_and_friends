classdef XdmfFemGrid < XdmfGridBase
    %XdmfFemGrid Export class for the FEM toolbox
    %syntax examples:
    %
    %//export of a FEM result
    %//create the export structure
    %toto = XdmfFemGrid(COORDS,[FEM_U1 FEM_U2 FEM_H FEM_Q],{'x','y'},{'m','m'});
    %//specify the domain to output (default=ALL)
    %toto = toto.setDomain('DomainA');
    %//write the file
    %writexdmf2(toto,'filename','output.xdmf');
    %
    %//export of a PGD result
    %//write a XdmfFemGrid for each dimension
    %toto(1) = XdmfGrid(XdmfFemGrid(COORDSx,,{'x'},{'m'})) // you can convert the XdmfFemGrid to XdmfGrid to chage the values whidout changing the Femfield
    %toto(2) = XdmfFemGrid(COORDSy,Uy,{'y'},{'m'})
    %toto(3) = XdmfFemGrid(COORDSz,Uz,{'z'},{'m'})
    %toto(4) = XdmfFemGrid(COORDSn,Un,{'nu'},{' '})
    %//one can specify a domain dor each PGD dimension
    %//write the file
    %writepxdmf2(toto,'filename','solution.pxdmf')
    %
    % This file is subject to the terms and conditions defined in
    % file 'LICENSE.txt', which is part of this source code package.
    %
    % Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
    %
    properties
        coordField;
        valueFields;
        nodeFieldIndex = [];
        elementFieldIndex = [];        
        coordNames = {};
        coordUnits = {};
        extraInformation = {};
        domain = '';
    end
    
    methods
        % Names and Units
        function     self = XdmfFemGrid(Coords,Fields,inputCoordNames,inputCoordUnits)
            if nargin>=1
                self.coordField = Coords;
            end
            if nargin>=2
                self.valueFields = Fields;
            end
            if nargin>=3
                self.coordNames = inputCoordNames;
            end
            if nargin>=4
                self.coordUnits = inputCoordUnits;
            end
            if any(strcmp('ALL',{Coords.INTERP.DOMAIN}))
            self = self.setDomain('ALL');
            end
        end
        % Extra Infomation tags 
        function res = GetNumberOfExtraInfomation(self)
            res  = size(self.extraInformation,1);
        end;
        function res = GetExtraInfomation(self)
            res = self.extraInformation;
        end;
        function SetExtraInfomation(self,varargin)
            self.extraInformation = varargin;
        end;
        %
        
        function self = setDomain(self,name)
            self.domain = name;
            Nelem = self.coordField.set_current_domain(name);
            if Nelem==0
                error('empty domain');
            end
            
            self.nodeFieldIndex = [];
            self.elementFieldIndex = [];
            for i=1:numel(self.valueFields)
                tmp = self.valueFields(i).set_current_domain(name);
                assert((tmp==Nelem)||(tmp==0),'Inconsistency in the number of elements of the domain');
                if tmp~=0
                    if self.valueFields(i).CURRENT_INTERP.ELEM.xdmf_cell_field
                        self.elementFieldIndex = [self.elementFieldIndex i];
                    else
                        self.nodeFieldIndex = [self.nodeFieldIndex i];
                    end
                end
            end   
        end
        
        function res = GetCoordNames(self)
            res = self.coordNames;
        end
        
        function res = GetCoordUnits(self)
            res = self.coordUnits;
        end
        % Geometry
        function res = GetNodes(self)
            res = self.coordField.get_values(self.domain);
        end
        function res = GetNumberOfNodes(self)
            res = self.coordField.CURRENT_INTERP.N_VALUES;
        end
        % Topology
        function res = GetGrid(self)
            res = renumber_compact(self.coordField.CURRENT_INTERP.CONNECTIVITY)-1;
        end
        function res = GetGridType(self)
            res = self.coordField.CURRENT_INTERP.ELEM.xdmf_name;
        end
        function res = GetNumberOfElements(self)
            res = self.coordField.CURRENT_INTERP.N_ELEMENTS;
        end
        % Node Fields
        function res = GetNumberOfNodeFields(self)
            res = numel(self.nodeFieldIndex);
        end
        function res = GetNodeFieldName(self,Number)
            res = self.valueFields(self.nodeFieldIndex(Number)).name;
        end
        function res = GetNodeFieldSize(self,Number)
            Ncomp = ModifiedNcomp(self.valueFields(self.nodeFieldIndex(Number)).Ncomp);
            if isempty(self.valueFields(self.nodeFieldIndex(Number)).CURRENT_INTERP)
                res = [self.coordField.CURRENT_INTERP.N_VALUES*Ncomp  0];
            else
                res = [self.coordField.CURRENT_INTERP.N_VALUES*Ncomp  self.valueFields(self.nodeFieldIndex(Number)).Nmodes];
            end
        end
        function res = GetNodeField(self,NumberName)
            if ischar(NumberName)
                number = find(strcmp(NumberName,{self.valueFields(self.nodeFieldIndex).name}));
            else
                number = NumberName;
            end
            res = zeros(GetNodeFieldSize(self,number));
            Npad = (ModifiedNcomp(self.valueFields(self.nodeFieldIndex(number)).Ncomp) - self.valueFields(self.nodeFieldIndex(number)).Ncomp);
            
            number = self.nodeFieldIndex(number);
            
            for term=self.valueFields(number).Nmodes:-1:1
                if(self.valueFields(number).CURRENT_INTERP==self.coordField.CURRENT_INTERP)
                    tmp = self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,term);
                    tmp = [tmp zeros(size(tmp,1),Npad)]';
                else
                    tmp = self.coordField.CURRENT_INTERP.interpolate(self.valueFields(number).CURRENT_INTERP,self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,term));
                    tmp = [tmp zeros(size(tmp,1),Npad)]';
                end
                res(:,term) = tmp(:);
            end
        end
        
        function res = GetNodeFieldTerm(self,NumberName,Term)
            if ischar(NumberName)
                number = find(strcmp(NumberName,{self.valueFields(self.nodeFieldIndex).name}));
            else
                number = NumberName;
            end
            Npad = (ModifiedNcomp(self.valueFields(self.nodeFieldIndex(number)).Ncomp) - self.valueFields(self.nodeFieldIndex(number)).Ncomp);

                        
            number = self.nodeFieldIndex(number);
            
            if(self.valueFields(number).CURRENT_INTERP==self.coordField.CURRENT_INTERP)
                tmp = self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,Term);
                tmp = [tmp zeros(size(tmp,1),Npad)]';
            else
                tmp = self.coordField.CURRENT_INTERP.interpolate(self.valueFields(number).CURRENT_INTERP,self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,Term));
                tmp = [tmp zeros(size(tmp,1),Npad)]';
            end
            res = tmp(:);
        end
        
        function res = GetNumberOfElementFields(self)
            res = numel(self.elementFieldIndex);
        end
        
        function res = GetElementFieldName(self,Number)
            res = self.valueFields(self.elementFieldIndex(Number)).name;
        end
        function res = GetElementFieldSize(self,Number)
            Ncomp = ModifiedNcomp(self.valueFields(self.elementFieldIndex(Number)).Ncomp);
            if isempty(self.valueFields(self.elementFieldIndex(Number)).CURRENT_INTERP)
                res = [self.coordField.CURRENT_INTERP.N_ELEMENTS*Ncomp  0];
            else
                res = [self.coordField.CURRENT_INTERP.N_ELEMENTS*Ncomp  self.valueFields(self.elementFieldIndex(Number)).Nmodes];
            end
        end
        
        function res = GetElementField(self,NumberName)
            if ischar(NumberName)
                number = find(strcmp(NumberName,{self.valueFields(self.elementFieldIndex).name}));
            else
                number = NumberName;
            end
            res = zeros(GetElementFieldSize(self,number));
            Npad = (ModifiedNcomp(self.valueFields(self.elementFieldIndex(number)).Ncomp) - self.valueFields(self.elementFieldIndex(number)).Ncomp);

            number = self.elementFieldIndex(number);
            for term=self.valueFields(number).Nmodes:-1:1
                tmp = self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,term);
                tmp = [tmp zeros(size(tmp,1),Npad)]';
                res(:,term) = tmp(:);
            end
        end
        
        function res = GetElementFieldTerm(self,NumberName,Term)
            if ischar(NumberName)
                number = find(strcmp(NumberName,{self.valueFields(self.elementFieldIndex).name}));
            else
                number = NumberName;
            end
            sz = GetElementFieldSize(self,number);
            Npad = (ModifiedNcomp(self.valueFields(self.elementFieldIndex(number)).Ncomp) - self.valueFields(self.elementFieldIndex(number)).Ncomp);
            
            number = self.elementFieldIndex(number);
            tmp = self.valueFields(number).get_values(self.domain,1:self.valueFields(number).Ncomp,Term);
            tmp = [tmp zeros(size(tmp,1),Npad)]';
            res = tmp(:);
        end
    end
end
    function result = ModifiedNcomp(Ncomp)
        assert(Ncomp<=9,'A field cannot have more than 9 components (xdmf export restriction)');
        sizes = [1 3 6 9];
       if any(Ncomp==sizes)
           result = Ncomp;
       else
           result = sizes(find(sizes>Ncomp,1,'first'));
       end
    end

