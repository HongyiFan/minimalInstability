function offlineStage()
    [~,~] = system('nc -N localhost 5000 <<< "I = Grassmannian(1,8);" ');
    [~,~] = system('nc -N localhost 5000 <<< "R = ring I;" ');
    [~,~] = system('nc -N localhost 5000 <<< "F1 = matrix{{1,0,-p_(1,2)},{-p_(1,3),-p_(1,4),-p_(1,5)},{-p_(1,6),-p_(1,7),-p_(1,8)}};" ');
    [~,~] = system('nc -N localhost 5000 <<< "F2 = matrix{{0,1,p_(0,2)},{p_(0,3),p_(0,4),p_(0,5)},{p_(0,6),p_(0,7),p_(0,8)}};" ');
    [~,~] = system('nc -N localhost 5000 <<< "R2 = R[t];" ');
    [~,~] = system('nc -N localhost 5000 <<< "F1 = promote(F1, R2);" ');
    [~,~] = system('nc -N localhost 5000 <<< "F2 = promote(F2, R2);" ');
    [~,~] = system('nc -N localhost 5000 <<< "f = det(F1 + t*F2);" ');
    [~,~] = system('nc -N localhost 5000 <<< "coeffs = (coefficients f)#1;" ');
    [~,~] = system('nc -N localhost 5000 <<< "a = lift(coeffs_(0,0),R);" ');
    [~,~] = system('nc -N localhost 5000 <<< "b = lift(coeffs_(1,0),R);" ');
    [~,~] = system('nc -N localhost 5000 <<< "c = lift(coeffs_(2,0),R);" ');
    [~,~] = system('nc -N localhost 5000 <<< "d = lift(coeffs_(3,0),R);" ');
    [~,~] = system('nc -N localhost 5000 <<< "disc = b^2*c^2 - 4*a*c^3 - 4*b^3*d - 27*a^2*d^2 + 18*a*b*c*d;" ');
    [~,~] = system('nc -N localhost 5000 <<< "J  = I + ideal(p_(0,1)-1);" ');
    [~,~] = system('nc -N localhost 5000 <<< "niceDisc = disc % J;" ');
    [~,~] = system('nc -N localhost 5000 <<< "(monos, nums) = coefficients niceDisc;" ');
    [~,~] = system('nc -N localhost 5000 <<< "newMonos = matrix{apply(flatten entries monos, t -> t*((p_(0,1))^(6 - first degree t)))};" ');
    [~,~] = system('nc -N localhost 5000 <<< "bestDisc = (newMonos*nums)_(0,0);" ');
    [~,~] = system('nc -N localhost 5000 <<< "myIndices = select(toList((0,0)..(8,8)), t -> t#1 > t#0);" ');
    [~,~] = system('nc -N localhost 5000 <<< "R3 = ZZ[join(flatten entries vars R, apply(myIndices, t-> q_t))]" ');
    [~,~] = system('nc -N localhost 5000 <<< "finalDisc = (map(R3,R))(bestDisc);" ');
    [~,~] = system('nc -N localhost 5000 <<< "answerDisc = substitute(finalDisc, apply(myIndices, t-> p_t => ((-1)^(1+t#0+t#1))*q_t))" ');
    [~,~] = system('nc -N localhost 5000 <<< "R4 = ZZ[apply(myIndices, t-> q_t)]" ');
    [~,~] = system('nc -N localhost 5000 <<< "ultimateDisc=(map(R4,R3))(answerDisc);" ');
   
end