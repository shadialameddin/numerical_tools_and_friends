SetFactory("OpenCASCADE");
// Mesh.CharacteristicLengthMin = 1;
// Mesh.CharacteristicLengthMax = 3;

p10=newp; Point(p10) = {-10,0,-10, 1};
p11=newp; Point(p11) = {10,0,-10, 1};
p12=newp; Point(p12) = {10,10,-10, 1};
p13=newp; Point(p13) = {-10,10,-10, 1};
l10=newl; Line(l10) = {p10,p11};
l11=newl; Line(l11) = {p11,p12};
l12=newl; Line(l12) = {p12,p13};
l13=newl; Line(l13) = {p13,p10};
ll10 = newll; Line Loop(ll10) = {l10,l11,l12,l13};
rs10 = news ; Plane Surface(rs10) = {ll10};
ex10[]= Extrude{0,0,30}{ Surface{rs10}; };
Physical Volume(1)={ex10[1]};

p20=newp; Point(p20) = {-10,10,-10, 1};
p21=newp; Point(p21) = {10,10,-10, 1};
p22=newp; Point(p22) = {10,30,-10, 1};
p23=newp; Point(p23) = {-10,30,-10, 1};
l20=newl; Line(l20) = {p20,p21};
l21=newl; Line(l21) = {p21,p22};
l22=newl; Line(l22) = {p22,p23};
l23=newl; Line(l23) = {p23,p20};
ll20 = newll; Line Loop(ll20) = {l20,l21,l22,l23};
rs20 = news ; Plane Surface(rs20) = {ll20};
ex20[]= Extrude{0,0,30}{ Surface{rs20}; };
Physical Volume(2)={ex20[1]};

p30=newp; Point(p30) = {-10,30,-10, 1};
p31=newp; Point(p31) = {10,30,-10, 1};
p32=newp; Point(p32) = {10,210,-10, 50};
p33=newp; Point(p33) = {-10,210,-10, 50};
l30=newl; Line(l30) = {p30,p31};
l31=newl; Line(l31) = {p31,p32};
l32=newl; Line(l32) = {p32,p33};
l33=newl; Line(l33) = {p33,p30};
ll30 = newll; Line Loop(ll30) = {l30,l31,l32,l33};
rs30 = news ; Plane Surface(rs30) = {ll30};
ex30[]= Extrude{0,0,30}{ Surface{rs30}; };
Physical Volume(3)={ex30[1]};

vblock=newv; Block(vblock) = {-10,-50,-10, 20,260,30};
v() = BooleanFragments{ Volume{1:3}; Delete; }{ Volume{vblock}; Delete; };
Physical Volume(0)={4};
