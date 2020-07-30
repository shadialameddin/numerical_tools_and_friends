function options = writepxdmfset(varargin)
    %writepxdmfset Create/alter writepxdmf2 OPTIONS structure.
    %   OPTIONS = writepxdmfset('Param1',Value1,'Param2',Value2,...) creates a
    %   writepxdmf2 options structure OPTIONS in which the named parameters have
    %   the specified values.  Any unspecified parameter value (parameters
    %   with value []) indicate to use the default value for that parameter
    %   when OPTIONS is passed to the writepxdmf2 function
    %   It is sufficient to type only the leading characters that uniquely
    %   identify the parameter.  Case is ignored for parameter names.
    %
    %   OPTIONS = writepxdmfset(OLDOPTS,'Param1',Value1,...) creates a copy of OLDOPTS
    %   with the named parameters altered with the specified values.
    %
    %   OPTIONS = writepxdmfset(OLDOPTS,NEWOPTS) combines an existing options structure
    %   OLDOPTS with a new options structure NEWOPTS.  Any parameters in NEWOPTS
    %   with non-empty values overwrite the corresponding old parameters in
    %   OLDOPTS.
    %
    %   writepxdmfset with no input arguments and no output arguments displays this help,
    %   inclusing all parameter names and their possible values, with
    %   defaults for the writepxdmfset shown in {}
    %
    %   OPTIONS = writepxdmfset (with no input arguments) creates an options structure
    %   OPTIONS where all the default values.
    %
    %
    %writepxdmfset PARAMETERS for MATLAB
    %
    %     filename: File name used
    %       binary: Binary format for the heavy data [ {true} | false ]
    %    precision: Precission used for the data [ {'double'} | 'single' ]
    %         HDF5: HDF5 file system used for heavy data [ true | {false} ]
    %         gzip: Extra compression for inside the h5 file [ true | {false} ]
    %    max_ASCII: if data size is smaller this values, the it will be written in ASCII [ 100]
    %temporalGrids: if each grid must be treated as one time evolving domain [ true | {false} ]
    %    timesteps: the time steps
    %         xdmf: if each grid must be treated as subdomain of a macro domain [ true | {false} ]
    %      verbose: On screen display [ true | {false} ]
    %
    %
    %   Examples:
    %     To create an options structure with the default parameters
    %       options = writepxdmfset();
    %     To create an options structure with an expecified file name
    %       options = writepxdmfset('filename','output.pxdmf');
    %     To change the Verbose value of options to true
    %       options = writepxdmfset(options,'verbose',true);
    %
    %   See also writepxdmf2 writexdmf2 readpxdmf2 .
    %
    %
    % This file is subject to the terms and conditions defined in
    % file 'LICENSE.txt', which is part of this source code package.
    %
    % Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
    %                       Adrien Leygue (Adrien.Leygue@ec-nantes.fr)

    %display if no input & output are given  
    if(nargin==0 && nargout == 0)
        help writepxdmfset
        return;
    end
    
    %strip structures from empty fields if they appear as first or first
    %and second arguments
    input = varargin;
    if (numel(input)>=1) && (isstruct(input{1}))
        assert(isscalar(input{1}),'writepxdmfset structure input only accepts a scalar structure');
        input{1} = pruneStruct(input{1});
        if (numel(input)>=2) && (isstruct(input{2}))
            assert(isscalar(input{2}),'writepxdmfset structure input only accepts a scalar structure');
            input{2} = pruneStruct(input{2});
        end
    end
    
    %List of valid option names
    validOptions = { ...
        'Verbose'...
        'HDF5'...
        'gzip'...
        'binary'...
        'precision'...
        'max_ASCII'...
        'xdmf'...
        'filename' ...
        'temporalGrids'...
        'timesteps'
        };
    
    %option name strings that are a partial match to the full names are
    %expanded using the validatestring function
    first_option = find(cellfun(@ischar,input),1);
    for i=first_option:2:numel(input)
        if ischar(input{i})
            input{i} = validatestring(input{i},validOptions);
        end
    end
    
    %definition of default values
    default_Verbose = 0;
    default_HDF5 = false;
    default_gzip = false;
    default_binary = true;
    default_precision = 'double';
    default_max_ASCII = 100;
    default_xdmf = false;
    default_filename = [];
    default_temporalGrids= false;
    default_timesteps = [];
    
    %argument checking functions
    check_boolean = @(arg) isempty(arg) | (islogical(arg) & isscalar(arg));
    check_Natural = @(arg) isempty(arg) | (all(floor(arg)==arg) & isscalar(arg) & all(arg>=0) & all(isfinite(arg)));
    %check_Natural_or_Inf = @(arg)  isempty(arg) |(all(floor(arg)==arg) & isscalar(arg) & all(arg>=0));
    check_Real = @(arg) (isreal(arg) & all(arg>=0) );
    check_Precision = @(arg) isempty(arg) | any(strcmpi(arg,{ 'double', 'single'}));
    %construction of the input parser
    p = inputParser;
    
    addParamValue(p,'temporalGrids',default_temporalGrids,check_boolean);
    addParamValue(p,'HDF5',default_HDF5,check_boolean);
    addParamValue(p,'gzip',default_gzip,check_boolean);
    addParamValue(p,'binary',default_binary,check_boolean);
    addParamValue(p,'xdmf',default_xdmf,check_boolean);
    addParamValue(p,'filename',default_filename);
    
    addParamValue(p,'verbose',default_Verbose,check_Natural);
    addParamValue(p,'max_ASCII',default_max_ASCII,check_Natural);
    
    addParamValue(p,'precision',default_precision,check_Precision);
    addParamValue(p,'timesteps',default_timesteps,check_Real);
    
    %parse & exit
    parse(p,input{:});
    options = orderfields(p.Results);
    
end
%
%auxiliary functions
function out = pruneStruct(arg)
    %REMOVE THE EMPTY FIELDS FROM A STRUCTURE
    %NB: arg needs to be scalar (not a vector of structures)
    names = fieldnames(arg);
    values = struct2cell(arg);
    mask = ~cellfun(@isempty,values);
    out = cell2struct(values(mask),names(mask),1);
end


