function ret=effective(ngp,ntp,nu,E,ncomp,dimension,sigma,D,h,typ_cal)
% Effective stress (3d case only)
% this function is very expensive to evaluate !!!!!
% {'_xx','_yy','_zz','_yz','_xz','_xy'}; Mandel notation

% use ncomp instead of 6
idx = reshape(1:ncomp*ngp,ncomp,ngp); 

sqrt2 = sqrt(2);
inv_sqrt2=1/sqrt2;
eps_e = zeros(size(sigma));
Y = zeros(ngp,ntp);

switch dimension
    case 1
        error('not implemented');
    case 2
        error('not implemented');
    case 3
        for i=1:ngp
            for j=1:ntp
                one_min_D = (1-D(i,j));
                one_min_hD = (1-h * D(i,j));
                      
                sigma_i_j =[sigma(idx(1,i),j),    inv_sqrt2*sigma(idx(6,i),j),inv_sqrt2*sigma(idx(5,i),j);... 
                            inv_sqrt2*sigma(idx(6,i),j),sigma(idx(2,i),j),    inv_sqrt2*sigma(idx(4,i),j);... 
                            inv_sqrt2*sigma(idx(5,i),j),inv_sqrt2*sigma(idx(4,i),j),sigma(idx(3,i),j)]; 
                
                [R,sigma_eigen] = eig(sigma_i_j);
                sigma_eigen_pos = sigma_eigen;
                sigma_eigen_pos(sigma_eigen_pos < 0) = 0;
                sigma_pos = R * sigma_eigen_pos * R'; 
                sigma_neg = sigma_i_j - sigma_pos;

                sigma_tr_pos=trace(sigma_pos);
                sigma_tr_neg=trace(sigma_neg);            
                                
                switch typ_cal
                    case 0
                        eps_e_i_j = real((1+nu)/E * (sigma_pos./one_min_D + sigma_neg./one_min_hD) ...
                            - nu/E * ( sigma_tr_pos ./ one_min_D + sigma_tr_neg ./ one_min_hD) *eye(3));
                        eps_e(1+(i-1)*6:6*i,j)=[eps_e_i_j(1);eps_e_i_j(5);eps_e_i_j(9);sqrt2*eps_e_i_j(8);sqrt2*eps_e_i_j(7);sqrt2*eps_e_i_j(4)];
                    case 1
                        Y(i,j) = real(0.5 * ((1+nu)/E * (sum(sigma_pos(:).^2)./(one_min_D.^2) + h* sum(sigma_neg(:).^2)./(one_min_hD.^2)) ...
                            - nu/E * (power(sigma_tr_pos / one_min_D,2) + h * power(sigma_tr_neg / one_min_hD,2))));
                end                
            end
        end
        
        %% how to compute eig val for a 3x3 matrixke
        % https://arxiv.org/pdf/physics/0610206.pdf
        % ref: https://en.wikipedia.org/wiki/Eigenvalue_algorithm#cite_note-Smith-12
        %      https://en.wikiversity.org/wiki/Principal_stresses
end
switch typ_cal
    case 0
        ret = eps_e;
    case 1
        ret = Y;
end
end