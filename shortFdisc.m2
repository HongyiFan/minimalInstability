I = Grassmannian(1,8);
R = ring I;
F1 = matrix{
    {1,0,-p_(1,2)},
    {-p_(1,3),-p_(1,4),-p_(1,5)},
    {-p_(1,6),-p_(1,7),-p_(1,8)}
    };
F2 = matrix{
    {0,1,p_(0,2)},
    {p_(0,3),p_(0,4),p_(0,5)},
    {p_(0,6),p_(0,7),p_(0,8)}
    };
R2 = R[t];
F1 = promote(F1, R2);
F2 = promote(F2, R2);
f = det(F1 + t*F2);
coeffs = (coefficients f)#1;
a = lift(coeffs_(0,0),R);
b = lift(coeffs_(1,0),R);
c = lift(coeffs_(2,0),R);
d = lift(coeffs_(3,0),R);

disc = b^2*c^2 - 4*a*c^3 - 4*b^3*d - 27*a^2*d^2 + 18*a*b*c*d;
J  = I + ideal(p_(0,1)-1);
niceDisc = disc % J;
(monos, nums) = coefficients niceDisc;
newMonos = matrix{apply(flatten entries monos, t -> t*((p_(0,1))^(6 - first degree t)))};
bestDisc = (newMonos*nums)_(0,0);
myIndices = select(toList((0,0)..(8,8)), t -> t#1 > t#0);
R3 = ZZ[join(flatten entries vars R, apply(myIndices, t-> q_t))]
finalDisc = (map(R3,R))(bestDisc);
answerDisc = substitute(finalDisc, apply(myIndices, t-> p_t => ((-1)^(1+t#0+t#1))*q_t))
R4 = ZZ[apply(myIndices, t-> q_t)]
ultimateDisc=(map(R4,R3))(answerDisc);
ultimateDisc --just to take a look
--this is it!!!

--everything above this point is PRECOMPUTATION once and for all
--really, we should save ultimateDisc in a file once and for all and load it in
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

--everything below this line is ONLINE calculation


X = random((RR_100)^2,(RR_100)^7) --or put input points here
Y = random((RR_100)^2,(RR_100)^6) --or put input points here
R5 = RR_100[y_1,y_2] 
Y = (Y | matrix{{y_1},{y_2}}) || matrix{{1,1,1,1,1,1,1}}
X = X || matrix{{1,1,1,1,1,1,1}}
Z = {};
for i from 0 to 6 do(
    Z = join(Z,{flatten entries(submatrix(X,,{i})*transpose(submatrix(Y,,{i})))}); --this might be off by a transpose depending on conventions
    )
Z = transpose matrix Z ;
time ultimateSubs = apply(myIndices, t -> q_t => det(submatrix'(Z,toList t,))); --probably shouldn't be doing this symbolically, can drive the timing here to near 0
time sexticPoly = substitute(ultimateDisc, ultimateSubs) --harder to drive the timing here to be very low, though Julia may help

--sexticPoly defines the 6.5pt curve as its zero set
--should probably scale the coefficients in sexticPoly to be near 1 before passing off to Mathematica to plot zero set

--if this does NOT match homotopy continuation then try changing the line with the transpose comment to the following
--Z = join(Z,{flatten entries(submatrix(Y,,{i})*transpose(submatrix(X,,{i})))})




