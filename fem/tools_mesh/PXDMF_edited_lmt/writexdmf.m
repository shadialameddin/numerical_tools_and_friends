function status = writexdmf(data, varargin)
%
% Function to write a XDMF file : 
%
% this fuction calls the writepxdmf with the option 'xdmf'
% 
% More information about the xdmf format http://www.xdmf.org
%
%
% This file is subject to the terms and conditions defined in
% file 'LICENSE.txt', which is part of this source code package.
%
% Principal developer : Felipe Bordeu (Felipe.Bordeu@ec-nantes.fr)
%
if (nargin == 0)
   status =  writepxdmf();
   status = rmfield(status,'names');
   status.xdmf =1;
   return 
end
    
if(isa(data,'struct'))
    if (nargin > 1) 
       disp('Warning: using struct and options is not suported, Please put the options inside the struct')
    end
   status =  writepxdmf(data);
else
    status =  writepxdmf(data, varargin{1}, varargin{2}, {},varargin{3},  varargin{4}, varargin{5}, varargin{6},'XDMF',1, varargin{7:end});
end

end