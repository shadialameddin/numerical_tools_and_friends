%% The code translates a given reduced basis bin file into an h5 file
% this translation tool expects the bin file to be written in the format
% used within Emmy-Noether-Group EMMA - Efficient Methods for Mechanical Analysis 

% The indices in the output file start from zero

clc
close all
clear 
data_dir = '/home/alameddin/src/data';

[ number_of_materials, ngp_mat, strain_rb, weights ] = readRB([data_dir,'/laminate_sphere/laminate_sphere.bin']);

material_idx=[];
for phase=1:number_of_materials
    material_idx = [material_idx; (phase-1) * ones(ngp_mat(phase), 1)];
end

strain_rb = strain_rb(:,1:80,:);
strain_rb_mat = reshape(strain_rb,prod(size(strain_rb,[1,2])),size(strain_rb,3))';




addpath('/home/alameddin/src/arch_and_tools/tensor_factorisation/h_matrices/Hmatrix-master')

% A = rand(100,500);
A = strain_rb_mat;
% delsq(numgrid('S', 10)); % assing YOUR table here (should show A = mytable; instead).

adm = @IsAdmissible; % this points to the default admissibility condition.
maxiterations = 20;
minBlockSize = 50;
relativeError = 1e-5;

S = supermatrix(full(A)); % initializes a Hmatrix tree with depth 1.
S = S.fulliterate(adm, maxiterations, minBlockSize, relativeError); % Does the actual tree structuring.

B = S.getTable(); % returns a simple matlab matrix from the supermatrix representation.

xi = rand(size(A,2),1);
Sx = supermatrix(full(xi)); % initializes a Hmatrix tree with depth 1.
Sx = Sx.fulliterate(adm, maxiterations, minBlockSize, relativeError); % Does the actual tree structuring.

tic; S * Sx; toc;
tic; strain_rb_mat * xi; toc;

norm(B-A)
% timeit(@() S * xi)

