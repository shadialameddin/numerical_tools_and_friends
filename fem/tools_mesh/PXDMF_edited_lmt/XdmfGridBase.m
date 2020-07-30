classdef XdmfGridBase < matlab.mixin.Heterogeneous
    %XdmfGridBase Summary of this class goes here
    %   Detailed explanation goes here
    %
    % This file is subject to the terms and conditions defined in
    % file 'LICENSE.txt', which is part of this source code package.
    %
    % Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
    %

    properties
    end
    
    methods (Abstract)
        % Names and Units
        res = GetCoordNames(self)
        res = GetCoordUnits(self)
        % Geometry
        res = GetNodes(self)
        res = GetNumberOfNodes(self)
        % Topology
        res = GetGrid(self)
        res = GetGridType(self)
        res = GetNumberOfElements(self)
        % Node Fields
        res = GetNumberOfNodeFields(self)
        res = GetNodeFieldName(self,Number)
        res = GetNodeFieldSize(self,Number)
        res = GetNodeField(self,NumberName)
        res = GetNodeFieldTerm(self,NumberName,Term)
        % Element Fields
        res = GetNumberOfElementFields(self)
        res = GetElementFieldName(self,Number)
        res = GetElementFieldSize(self,Number)
        res = GetElementField(self,NumberName)
        res = GetElementFieldTerm(self,NumberName,Term)
        % Extra Infomation tags    
    end
    methods
        function res = GetNumberOfExtraInfomation(self)
           res = 0;
        end;
        function res  = GetExtraInfomation(self)
            res = {};
        end;
        function res = GetNumberOfGridFields(self)
           res = 0;
        end;
        function res  = GetGridFieldName(self,number)
            res = '';
        end;
        function res  = GetGridField(self,number)
            res = [];
        end;
    end
    methods( Sealed )
        % pretty print
        function Print(self)
            if numel(self ) >1
                disp(['*****  ' num2str(numel(self)) ' Grids *****'])
                for i = 1: numel(self)
                    disp(['***** Grid N ' num2str(i) ' *****'])
                    self(i).Print()
                end
                return
            end
            
            disp([' Grid Type : ' self.type])
            disp([' Number Of Nodes : ' num2str(self.GetNumberOfNodes())])
            disp([' Number Of Elements : ' num2str(self.GetNumberOfElements())])
            names = self.GetCoordNames();
            units = self.GetCoordUnits();
            for i = 1:(size(names,2))
                mess = ['  Name : ' names{i} ];
                if size(units,2) >= i
                    mess = [ mess '  Units : ' units{i} ]; %#ok<AGROW>
                else
                    mess = [ mess '  Units : (no units) '  ]; %#ok<AGROW>
                end
                disp(mess)
            end
            
            disp(' Nodes Fields')
            for i = 1:self.GetNumberOfNodeFields()
                s = size(self.GetNodeField(i));
                mess = [ '  Name : ' self.GetNodeFieldName(i) ' Terms : ' num2str(s(2)) ];
                switch (s(1)/self.GetNumberOfNodes())
                    case 1
                        mess = [ mess ' (Scalar)']; %#ok<AGROW>
                    case 3
                        mess = [ mess ' (Vector)']; %#ok<AGROW>
                    case 6
                        mess = [ mess ' (Tensor6)']; %#ok<AGROW>
                    case 9
                        mess = [ mess ' (Tensor)']; %#ok<AGROW>
                end
                disp(mess);
            end
            
            disp(' Elements Fields')
            for i = 1:self.GetNumberOfElementFields()
                s = size(self.GetElementField(i));
                mess = [ '  Name : ' self.GetElementFieldName(i) ' Terms : ' num2str(s(2)) ];
                switch (s(1)/self.GetNumberOfElements())
                    case 1
                        mess = [ mess ' (Scalar)']; %#ok<AGROW>
                    case 3
                        mess = [ mess ' (Vector)']; %#ok<AGROW>
                    case 6
                        mess = [ mess ' (Tensor6)']; %#ok<AGROW>
                    case 9
                        mess = [ mess ' (Tensor)']; %#ok<AGROW>
                end
                disp(mess);
            end
        end
        % Integrity Check
        function res = CheckIntegrity(self,verbose)
            
            if nargin == 1
                verbose = false;
            end
            
            if numel(self) >1
                res = true;
                if verbose
                    disp(['*****  ' num2str(numel(self)) ' Grids *****'])
                end
                for i=1:numel(self)
                     if verbose
                         disp(['***** Grid N ' num2str(i) ' *****'])
                     end
                    res = res && self(i).CheckIntegrity(verbose);
                end
                return
            end
            
            res = true;
            
            %% Check the number of nodes with the size of the term in each  node field
            for f = 1:self.GetNumberOfNodeFields()
                siz = self.GetNodeFieldSize(f);
                if all(siz(1)/self.GetNumberOfNodes() ~= [ 1 2 3 6 9])
                    res = false;
                    fprintf(2,['Class:XdmfGridBase: Number of Nodes not compatible with the size of the terms in the field (' self.GetNodeFieldName(f) ')\n']);
                end
            end
            
            %% Check the number of elements with the size of the term in each element field
            for f = 1:self.GetNumberOfElementFields()
                siz = self.GetElementFieldSize(f);
                if all(siz(1)/self.GetNumberOfElements() ~= [ 1 2 3 6 9])
                    res = false;
                    fprintf(2,['Class:XdmfGridBase: Number of Elements not compatible with the size of the terms in the field (' self.GetElementFieldName(f) ')\n']);
                end
            end
            
            %% internal verification for XdmfGrid
            if isa(self,'XdmfGrid')
                if numel(self.nodeFields) ~=numel(self.nodeFieldsNames)
                    res = false;
                    fprintf(2,'Class:XdmfGrid:Incompatible size of nodeFieldsNames and nodesFields\n');
                end
                if numel(self.elementFields) ~=numel(self.elementFieldsNames)
                    res = false;
                    fprintf(2,'Class:XdmfGrid:Incompatible size of elementFieldsNames and elementFields\n');
                end
            end
            
            if verbose 
                self.Print()
            end
            
        end
    end

    methods (Static, Sealed, Access = protected)
        %This is to specify that unspecified elements in an heterogeneous
        %array of objects deriving from XdmfGridBase should be initialized as
        %XdmfGrid
        function default_object = getDefaultScalarElement
            default_object = XdmfGrid;
        end
    end
end

