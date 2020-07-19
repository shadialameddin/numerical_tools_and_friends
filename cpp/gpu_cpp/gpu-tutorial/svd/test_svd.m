clc
A=[2 4;1 3;0 0;0 0];
[u1,s1,v1]=svd(A);
% sqrt(eig(A'*A))
% sqrt(eig(A*A'))
[u2,s2]=eig(A*A');
v2=u2'*A./sqrt(diag(s2));

[v3,s3]=eig(A'*A);
u3=A*v3/sqrt(s3);

[m,n]=size(A);
A_eig = [zeros(m,m),A;
        A',zeros(n,n)];
svd(A)
eig(A_eig)