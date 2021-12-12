using Base
using HomotopyContinuation
using LinearAlgebra


@var d[1:48]
@var x1 x2 x3 x4 x5 x6 x7 x8

e0 = Transpose(reshape(d[1:9],3,3));
e1 = Transpose(reshape(d[10:18],3,3));
e2 = Transpose(reshape(d[19:27],3,3));
e3 = Transpose(reshape(d[28:36],3,3));
e4 = Transpose(reshape(d[37:45],3,3));
E = e0 + x1 * e1 + x2 * e2 + x3 * e3 + x4 * e4;
eqs = [2*(E*E')*E - tr(E*E')*E];
cubics = [eqs[1][1,1];eqs[1][1,2];eqs[1][1,3];eqs[1][2,1];eqs[1][2,2];eqs[1][2,3];eqs[1][3,1];eqs[1][3,2];eqs[1][3,3];det(E)]

#Sweeping row
p1 = [d[46];d[47];1];
p2 = [x8;d[48];1];
lin = Transpose(p2) * E * p1;
eqn = [cubics;lin];
J = differentiate(eqn,[x1,x2,x3,x4]);
Z = [x5;x6;x7;1];
eqnA = J * Z;
Eq = [eqn;eqnA];

F = System(Eq;variables=[x1,x2,x3,x4,x5,x6,x7,x8], parameters = d);
start_param = (rand(48) + rand(48) * im)
E_start = subs(Eq,d => start_param);
start_solution = solve(E_start);



#Sweeping column
p1_column = [d[46];d[47];1];
p2_column = [x8;d[48];1];
lin_column = Transpose(p2_column) * E * p1_column;
eqn_column = [cubics;lin_column];
J_column = differentiate(eqn_column,[x1,x2,x3,x4]);
Z_column = [x5;x6;x7;1];
eqnA_column = J_column * Z_column;
Eq_column = [eqn_column;eqnA_column];
F_column = System(Eq_column;variables=[x1,x2,x3,x4,x5,x6,x7,x8], parameters = d);
start_param_column = (rand(48) + rand(48) * im)
E_start_column = subs(Eq_column,d => start_param_column);
start_solution_column = solve(E_start_column);

K = [  525.0000         0  319.5000;
0  525.0000  239.5000;
0         0    1.0000];

f = 525.0;
c = 319.5;
v = 239.5;

fi = 1 / f;
ci = - c / f;
vi = - v / f;

#################################################################################################


Alldistances_gt = [];
flag_gt = [];
Alldistances_est = [];
global m_column = reshape([],2,0);
global m = reshape([],2,0);


for timer = 1:200
    print(timer)
    print('\n')
    lines = readlines("/media/hongyi/My Passport/Documents_2/JoeKhillel/New/Experiment_CVPR/cases_E_0_1/" * "$timer.txt")

    ex_data_gt = Meta.parse(lines[1]);
    p2_data_gt = Meta.parse(lines[2]);
    ex_data_est = Meta.parse(lines[3]);
    p2_data_est = Meta.parse(lines[4]);
    unstable_flag = parse(Int64,lines[5]);

    eval(ex_data_gt);
    eval(p2_data_gt);

    #Track each row
    B = []
    for i = max(trunc(Int,P1[2]) - 50,1):0.5:min(trunc(Int,P1[2]) + 50, 480)
        temp = inv(K) * [0;i;1];
        tt = temp[2,1];
        r_data = [real_data;tt];
        E_target = solve(F, solutions(start_solution); start_parameters=start_param, target_parameters=r_data)
        SS = real_solutions(E_target);
        push!(B,SS);
    end 


    curve_intersect = [];
    for i = 1:length(B)
        one_sol = [];
        for j = 1:length(B[i])
            push!(one_sol,B[i][j][8]);
        end
        push!(curve_intersect,one_sol);
    end

    global m = reshape([],2,0)
    vv = max(trunc(Int,P1[2]) - 50,1):0.5:min(trunc(Int,P1[2]) + 50, 480)
    for i = 1:length(curve_intersect)
        for j = 1:length(curve_intersect[i])
            p = [K[1,1] * curve_intersect[i][j] + K[1,3];vv[i]];
            global m = hcat(m,p);
        end
    end

    curve_points = m;

    if length(m) == 0
        min_dis = rand() * 20 + 60;
        #Compute the distance
    else
        error1 = P1[1] .- convert(Array{Float64,1}, curve_points[1,:]);
        error2 = P1[2] .- convert(Array{Float64,1}, curve_points[2,:]);
        distances = sqrt.(error1 .* error1 .+ error2 .* error2);
        min_dis = minimum(distances);
    end
    print(min_dis)
    print('\n')
    push!(Alldistances_gt,min_dis);
    push!(flag_gt,unstable_flag);
end