classdef XdmfGrid < XdmfGridBase
    %XDMFGrid is the new class to use with the New pxdmfwriter
    %
    % IMPORTANT Now the fields are in the same direction (1 term = 1 column)
    % as in the rest of the lib
    %
    % For Rectilinear an constRectilinear the the order of the data is 
    % xy for 2D (so '(:) can be used to order the data) and xyz for 3D
    % data. In this case to reshape into a 3D matrix this conversion can be used
    %
    % for the first nodes field
    % a = reshape(data.GetNodeField(1),data.topology+1));
    %
    %for the first element field
    % a = reshape(data.GetElementField(1),data.topology);
    %
    % This file is subject to the terms and conditions defined in
    % file 'LICENSE.txt', which is part of this source code package.
    %
    % Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
    %
    
    properties
        coordNames = {''};
        coordUnits = {};
        extraInformation = {};
        geometry = [];
        topology = [];
        nodeFields = cell(1,0);
        nodeFieldsNames = cell(1,0);
        elementFields = cell(1,0);
        elementFieldsNames = cell(1,0);
        gridFieldsNames = cell(1,0);
        gridFields = cell(1,0);
        type= 'Mixed'
        % types are
        % 'Mixed'
        % 'Rectilinear'
        % 'ConstRectilinear'
        %
        % any other like : 
        %
        % 'Quadrilateral_9' (35)
        % 'Hexahedron'      (9)
        % 'Wedge'           (8)
        % 'Quadrilateral'   (5)
        % 'Triangle'        (4)
        % 'Polyline'        (2 1)
        % 'Polyvertex'      (1 1)
    end
    
    methods 
        % constructor
        function obj = XdmfGrid(varargin)
            if nargin == 0
                return
            else
                data = varargin{1};
                if (isa(data,'struct'))
                    ndims = numel(data.nodes);
                    obj(ndims) = XdmfGrid;
                    
                    for d = 1 : ndims
                        %%Coordinate names and Units
                        if isfield(data,'names') 
                            obj(d).coordNames = data.names{d,1};    
                            if size(data.names,2)> 1
                                obj(d).coordUnits = data.names{d,2};    
                            end
                        end
                        %% Grid Type detection
                        obj(d).type = '';
                        if isfield(data,'mixed') && numel(data.mixed)==ndims && data.mixed(d)
                            obj(d).type  = 'Mixed';
                        end
                        if isfield(data,'rectilinear') && numel(data.rectilinear)==ndims && data.rectilinear(d)
                            obj(d).type  = 'ConstRectilinear';
                        end
                        if strcmpi(obj(d).type,'')
                            switch size(data.cells{d},2)
                                case 9
                                    obj(d).type = 'Quadrilateral_9';
                                case 8
                                    obj(d).type = 'Hexahedron';
                                case 6
                                    obj(d).type = 'Wedge';
                                case 4
                                    obj(d).type = 'Quadrilateral';
                                case 3
                                    obj(d).type = 'Triangle';
                                case 2
                                    obj(d).type = 'Polyline';
                                case 1
                                    obj(d).type = 'Polyvertex';
                            end
                        end
                        if strcmpi(obj(d).type,'')
                          disp('WARNING!! Automatic Element detection fail!! please fill the element type manualy')
                        end
                        %% Geometry transfert
                        obj(d).geometry = data.nodes{d};
                        %% Topology transfert
                        obj(d).topology = data.cells{d};
                        %% nodesFields transfert
                        for i= 1:numel(data.nodes_fields_names)
                            obj(d).nodeFields{i} = data.nodes_fields{d,i}';
                            obj(d).nodeFieldsNames = data.nodes_fields_names;
                        end
                        %% elementFields transfert
                        for i= 1:numel(data.cell_fields_names)
                            obj(d).elementFields{i} = data.cell_fields{d,i}';
                            obj(d).elementFieldsNames = data.cell_fields_names;
                        end
                    end
                else 
                    if isa(data,'XdmfGridBase')
                       ndims = numel(data);
                       obj(ndims) = XdmfGrid;
                       for d = 1 : ndims
                           obj(d).coordNames = data.GetCoordNames();
                           obj(d).coordUnits = data.GetCoordUnits();
                           obj(d).extraInformation = data.GetExtraInfomation();
                           obj(d).geometry = data.GetNodes();
                           obj(d).topology =  data.GetGrid();
                           for i =1:data.GetNumberOfNodeFields()
                                obj(d).nodeFieldsNames{1,i} = data.GetNodeFieldName(i);
                                obj(d).nodeFields{1,i} = data.GetNodeFieldName(i);
                           end
                           for i =1:data.GetNumberOfElementFields()
                                obj(d).elementFieldsNames{1,i} = data.GetElementFieldName(i);
                                obj(d).elementFields{1,i} = data.GetElementField(i);
                           end
                           for i =1:data.GetNumberOfGridFields()
                                obj(d).gridFieldsNames{1,i} = data.GetGridFieldName(i);
                                obj(d).gridFields{1,i} = data.GetGridField(i);
                           end
                           obj(d).type= data.type;
                           
                       end
                    end
                end
            end
            
        end
        % Names and Units
        function res = GetCoordNames(self)
            res = self.coordNames;
        end
        function res = GetCoordUnits(self)
            res = self.coordUnits;
        end
        % Geometry
        function res = GetNodes(self)
            res = self.geometry;
        end
        function res = GetNumberOfNodes(self)
            switch lower(self.type)
                case {'rectilinear'}
                     res= prod(self.topology + 1 );
                case {'constrectilinear'}
                    res = prod(self.topology + 1 );
                otherwise 
                    res = size(self.geometry,1);
            end
        end
        % Topology
        function res = GetGrid(self)
            res = self.topology;
        end
        function res = GetGridType(self)
            res = self.type;
        end
        function res = GetNumberOfElements(self)
            switch lower(self.type)
                case {'mixed'}
                    ncomp = numel(self.topology);
                    elcpt = 0;
                    i = 1;
                    cpt =0;
                    % we use a temporal variable to go faster
                    tmp = self.topology(:);
                    
                    % lines and bars are treated diferently
                    PointsPerElement = [0 0 0 3 4 4 5 6 8 zeros(1,24) 3 9 6 8  10  13 15 18 zeros(1,6) 20 24 27] +1;
                    PointsPerElement(1:3) = 0;
                    
                    while (i <= ncomp)
                        % re recover the type
                        t = tmp(i);
                        % if the type has a fix number of points
                        PPE = PointsPerElement(t);
                        
                        if( PPE )    
                            i = i +  PPE;
                        else
                            i = i + tmp(i+1) + 2;
                        end
                        
                        elcpt = elcpt +1;
                        
%                         switch(tmp(i))
%                             case 1  % XDMF_POLYVERTEX
%                                 i = i + 1;
%                                 cpt = self.topology(i);
%                             case 2  % XDMF_POLYLINE
%                                 i = i + 1;
%                                 cpt = self.topology(i);
%                             case 3  % XDMF_POLYGON
%                                 i = i + 1;
%                                 cpt = self.topology(i);
%                             case 4  % XDMF_TRI
%                                 cpt = 3 ;
%                             case 5 % XDMF_QUAD
%                                 cpt = 4 ;
%                             case 6 % XDMF_TET
%                                 cpt =  4 ;
%                             case 7 % XDMF_PYRAMID
%                                 cpt = 5 ;
%                             case 8 % XDMF_WEDGE
%                                 cpt = 6 ;
%                             case 9 % XDMF_HEX
%                                 cpt = 8 ;
%                             case 34 % XDMF_EDGE_3
%                                 cpt = 3 ;
%                             case 36 % XDMF_TRI_6
%                                 cpt = 6 ;
%                             case 37 % XDMF_QUAD_8
%                                 cpt = 8 ;
%                             case 35 % XDMF_QUAD_9
%                                 cpt =  9 ;
%                             case 38 % XDMF_TET_10
%                                 cpt = 10 ;
%                             case 39 % XDMF_PYRAMID_13
%                                 cpt = 13 ;
%                             case 40 % XDMF_WEDGE_15
%                                 cpt =  15 ;
%                             case 41 % XDMF_WEDGE_18
%                                 cpt =  18 ;
%                             case 48 % XDMF_HEX_20
%                                 cpt = 20 ;
%                             case 49 % XDMF_HEX_24
%                                 cpt =  24 ;
%                             case 50 % XDMF_HEX_27
%                                 cpt =  27 ;
%                             otherwise
%                                 disp(['ERROR : Element not coded yet sorry, element type ' num2str(self.topology(i))]);
%                                 return;
%                         end
                        %%elcpt = elcpt +1;
                        %%i = i+cpt+1;
                        %for j = 1:cpt
                        %    i = i + 1;
                            %self.topology(i) = self.topology(i) - opt.from1;
                        %end
                        %i = i +1;
                    end
                    res = elcpt;
                case {'rectilinear'}
                    res = prod(self.topology + cast(self.topology==0,class(self.topology) ) );
                case {'constrectilinear'}
                    res = prod(self.topology + cast(self.topology==0,class(self.topology) ) );
                otherwise 
                    res = size(self.topology,1);
                    
            end
        end
        %% clean topology
        % try to find is only one element is used and change the topology 
        
        function self = MixedToHomogeniusTopology(self)
            if(numel(self) > 1)
                for(i = 1:numel(self))
                    self(i) =  MixedToHomogeniusTopology(self(i));
                end
                return 
            end
                
            switch lower(self.type)
                case {'mixed'}
                    ncomp = numel(self.topology);
                    elcpt = 0;
                    i = 1;
                    cpt =0;
                    % we use a temporal variable to go faster
                    tmp = self.topology(:);
                    elementTypesUsed = zeros(1,50);
                    PointsPerElement = [0 0 0 3 4 4 5 6 8 zeros(1,24) 3 9 6 8  10  13 15 18 zeros(1,6) 20 24 27] +1;
                    PointsPerElement = PointsPerElement - ( PointsPerElement == 1); % make the zeros zero
                    NodesInThePointsBarsElements = 0;
                    while (i <= ncomp)
                        
                        elementtype = tmp(i);
                        % if the type has a fix number of points
                        PPE = PointsPerElement(elementtype);
                        
                        if( PPE )    
                            i = i +  PPE;
                        else
                            nnodes = tmp(i+1); 
                            i = i + nnodes + 2;
                            %% we have to check that the same number of points
                            % is used for every bar and point in the mesh
                            if(NodesInThePointsBarsElements ) 
                                if( NodesInThePointsBarsElements ~= nnodes)
                                    disp('Error : The number of points in the point/bars/polygon elements are not the same, nothing to do ')
                                end
                            else
                                NodesInThePointsBarsElements = nnodes;
                            end
                        end
                        
                        elcpt = elcpt +1;
                        
                        elementTypesUsed(elementtype) = 1;
                        
                        %for j = 1:cpt
                        %    i = i + 1;
                            %self.topology(i) = self.topology(i) - opt.from1;
                        %end
                        %i = i +1;
                    end
                    
                    %% we have only one type of element
                    % we do a reshape and eliminate the type element number
                    if(sum(elementTypesUsed) == 1 )
                         etype = find(elementTypesUsed);
                         % we treat diferently the points and bars
                         if(etype > 3 )
                             self.topology = reshape(self.topology, PointsPerElement(etype), [ ])';
                             self.topology = self.topology(:,2:end);
                         else
                             self.topology = reshape(self.topology, NodesInThePointsBarsElements+2, [ ])';
                             self.topology = self.topology(:,3:end);
                         end
                         
                         switch(etype)
                            case 1  % XDMF_POLYVERTEX
                                self.type = 'Polyvertex';
                            case 2  % XDMF_POLYLINE
                                self.type = 'Polyline';
                            case 3  % XDMF_POLYGON
                                self.type = 'Polygon';
                            case 4  % XDMF_TRI
                                self.type = 'Triangle';
                            case 5 % XDMF_QUAD
                                self.type = 'Quadrilateral' ;
                            case 6 % XDMF_TET
                                self.type = 'Tetrahedron';
                            case 7 % XDMF_PYRAMID
                                self.type = 'Pyramid';
                            case 8 % XDMF_WEDGE
                                self.type = 'Wedge';
                            case 9 % XDMF_HEX
                                self.type = 'Hexahedron';
                            case 34 % XDMF_EDGE_3
                                self.type = 'Edge_3';
                            case 36 % XDMF_TRI_6
                                self.type = 'Triagle_6';
                            case 37 % XDMF_QUAD_8
                                self.type = 'Quadrilateral_8';
                            case 35 % XDMF_QUAD_9
                                self.type = 'Tetrahedron_9';
                            case 38 % XDMF_TET_10
                                self.type = 'Tetrahedron_10';
                            case 39 % XDMF_PYRAMID_13
                                self.type = 'Pyramid_13';
                            case 40 % XDMF_WEDGE_15
                                self.type = 'Wedge_15';
                            case 41 % XDMF_WEDGE_18
                                self.type = 'Wedge_18';
                            case 48 % XDMF_HEX_20
                                self.type = 'Hexahedron_20';
                            case 49 % XDMF_HEX_24
                                self.type = 'Hexahedron_24';
                            case 50 % XDMF_HEX_27
                                self.type = 'Hexahedron_27';
                            otherwise
                                disp(['ERROR : Element not coded yet sorry, element type ' num2str(self.topology(i))]);
                                return;
                         end
                    else
                       disp('Mixed topology with different element types, nothing to do');                        
                    end
                otherwise 
                    disp('Not mixed topology, nothing to do');
                    
            end
        end
        %% Node Fields
        function res = GetNumberOfNodeFields(self)
            res = size(self.nodeFields,2);
        end
        function res = GetNodeFieldName(self,Number)
            res = self.nodeFieldsNames{1,Number};
        end
        function res = GetNodeFieldSize(self,Number)
            res = size(self.nodeFields{1,Number});
        end
        function res = GetNodeField(self,NumberName)
            if  isa(NumberName,'char')
                res = self.nodeFields{1,strcmp(NumberName, self.nodeFieldsNames)};
            else
                res = self.nodeFields{1,NumberName};
            end
        end
        function res = GetNodeFieldTerm(self,NumberName,Term)
            if  isa(NumberName,'char')
                res = self.nodeFields{1,strcmp(NumberName, self.nodeFieldsNames)}(:,Term);
            else
                res = self.nodeFields{1,NumberName}(:,Term);
            end
        end
        %Element Fields
        function res = GetNumberOfElementFields(self)
            res = size(self.elementFields,2);
        end
        function res = GetElementFieldName(self,Number)
            res = self.elementFieldsNames{1,Number};
        end
        function res = GetElementFieldSize(self,Number)
            res = size(self.elementFields{1,Number});
        end
        function res = GetElementField(self,NumberName)
            if  isa(NumberName,'char')
                res = self.elementFields{1,strcmp(NumberName, self.elementFieldsNames)};
            else
                res = self.elementFields{1,NumberName};
            end
        end
        function res = GetElementFieldTerm(self,NumberName,Term)
            if  isa(NumberName,'char')
                res = self.elementFields{1,strcmp(NumberName, self.elementFieldsNames)}(:,Term);
            else
                res = self.elementFields{1,NumberName}(:,Term);
            end
        end
        %% Extra Infomation tags 
        function res = GetNumberOfExtraInfomation(self)
            res  = size(self.extraInformation,1);
        end;
        function res = GetExtraInfomation(self)
            res = self.extraInformation;
        end;
        %% Grid fields
        
        function res = GetNumberOfGridFields(self)
           res = numel(self.gridFieldsNames);
        end;
        function res  = GetGridFieldName(self,number)
            res = self.gridFieldsNames{number};
        end;
        function res  = GetGridField(self,number)
            res = self.gridFields{number};
        end;
        
    end
    
end

