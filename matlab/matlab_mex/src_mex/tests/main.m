%%
MexBuild_linux
solver_eigen_mex(sparse(2*eye(3)),sparse([1 0 0]'))
solver_pastix_mex(sparse(2*eye(3)),sparse([1 0 0]'))
direct_solver_mex(sparse(2*eye(3)),sparse([1 0 0]'))
return

clc
clear all;
delete('comman_history.txt')
diary comman_history.txt
diary on

load ('Kc.mat','Kc');
load('RHSc.mat','RHSc');
size(Kc)
nnz(Kc)

%% solve with mex-file, directive solver in Eigen
disp('solve with mex-file, directive solver in Eigen')
nn=10;
Kc = Kc(1:nn,1:nn);
RHSc = RHSc(1:nn,1);
prhs={};
[Ir,Jc,nnzval_K] = find(Kc);
[m_K,n_K] = size(Kc);
prhs.nnzval_K=nnzval_K;
prhs.nnz_K=int32(length(nnzval_K));
prhs.m_K=int32(m_K);
prhs.n_K=int32(n_K);
prhs.Ir_K=int32(Ir);
prhs.Jc_K=int32(Jc);
prhs.rhs_matrix=RHSc(:,1);
disp('go to mex-file...')
tic
Ucp=direct_solver_mex(prhs);
toc
disp('go out mex-file...')
return
%% solve with directive solver matlab
disp('solve with directive solver matlab')
tic
Ucd=Kc\RHSc(:,1);
toc
%% solve with directive solver matlab
disp('solve with directive solver matlab')
tic
Ucd=distributed(Kc)\distributed(RHSc(:,1));
toc
disp('solve with directive solver matlab')
tic
Ucd=codistributed(Kc)\distributed(RHSc(:,1));
toc

spmd
    A = [11:20; 21:30; 31:40];
    D = codistributed(A);
    getLocalPart(D)
end
composite

d=distributed(Kc);
spmd
    c=getLocalPart(d);    % Unique value on each worker
end

%% solve with iterivative solver matlab
disp('solve with iterivative solver matlab')
tic
L = ichol(Kc,struct('type','ict','droptol',1e-3));
% L = ichol(Kc);
Uc=pcg(Kc,RHSc(:,1),1e-6,300,L,L'); % minres or pcg
toc
      
% norm(Uc-Ucd)/norm(Ucd)

% tic
% D  = spdiags(1./diag(Kc),0,size(Kc,1),size(Kc,2));
% Uc=pcg(Kc,RHSc(:,1),1e-6,30,D);
% toc

%% solve with mex-file, directive solver in Eigen
disp('solve with mex-file, directive solver in Eigen')
prhs={};
[Ir,Jc,nnzval_K] = find(Kc);
[m_K,n_K] = size(Kc);
prhs.nnzval_K=nnzval_K;
prhs.nnz_K=int32(length(nnzval_K));
prhs.m_K=int32(m_K);
prhs.n_K=int32(n_K);
prhs.Ir_K=int32(Ir);
prhs.Jc_K=int32(Jc);
prhs.rhs_matrix=RHSc(:,1);
disp('go to mex-file...')
tic
Ucp=solver_pastix_mex(prhs);
toc
disp('go out mex-file...')
%% solve with mex-file, iterative solver in Eigen
disp('solve with mex-file, iterative solver in Eigen')
prhs={};
[Ir,Jc,nnzval_K] = find(Kc);
[m_K,n_K] = size(Kc);
prhs.nnzval_K=nnzval_K;
prhs.nnz_K=int32(length(nnzval_K));
prhs.m_K=int32(m_K);
prhs.n_K=int32(n_K);
prhs.Ir_K=int32(Ir);
prhs.Jc_K=int32(Jc);
prhs.rhs_matrix=RHSc(:,1);
disp('go to mex-file...')
tic
Uc=itera_solver_eigen_lhs_vector_mex(prhs);
toc
disp('go out mex-file...')
%%
diary off
