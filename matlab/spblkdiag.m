function M = spblkdiag(blocks)
%function M = spblkdiag(blocks)
%
% function generating efficiently a sparse matrix containing
% subblocks blocks(:,:,i) as block i along the diagonal.
% this is 1000 times faster than blkdiag!!!!
%
% Bernard Haasdonk 31.8.2009

[n,m,k] = size(blocks);

row_ind = (1:n)'*ones(1,m*k);
row_offs =(ones(n*m,1)*(0:(k-1)))*n;
row_ind = row_ind(:)+row_offs(:);

col_ind = ones(n,1)*(1:(m*k));
col_ind = col_ind(:);

M = sparse(row_ind,col_ind,blocks(:));%| \docupdate 
end
