function status = writexdmf2(data, varargin)
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
   status =  writepxdmf2();
   %%status = rmfield(status,'names');
   status.xdmf = true;
   return 
end


if(isa(varargin{1},'struct')) 
   if (nargin > 1) 
      disp('Warning: using struct and options is not suported, Please put the options inside the struct')
   else
       varargin{1}.xdmf = true;
       status =  writepxdmf2(data,varargin{1});   
   end
else
    status =  writepxdmf2(data,varargin{:}, 'xdmf',true);   
return 

end