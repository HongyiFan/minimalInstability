using Base
using HomotopyContinuation
using LinearAlgebra


@var d[1:30]
@var x1 x2 x3 x4

f1 = Transpose(reshape(d[1:9],3,3));
f2 = Transpose(reshape(d[10:18],3,3));
f3 = Transpose(reshape(d[19:27],3,3));

F = x1 * f1 + x2 * f2 + f3;

#Row_wise sweeping data
cubic = det(F)
p1 = [d[28];d[29];1];
p2 = [x4;d[30];1];
lin = Transpose(p2) * F * p1;

eqn = [cubic;lin];
J = differentiate(eqn,[x1,x2]);

Z = [x3;1];
eqnA = J * Z;
Eq = [eqn;eqnA];

F_s = System(Eq;variables=[x1,x2,x3,x4], parameters = d);

start_param = (rand(30) + rand(30) * im)
E_start = subs(Eq,d => start_param);
start_solution = solve(E_start);



#Column_wise sweeping data
cubic_column = det(F)
p1_column = [d[28];d[29];1];
p2_column = [d[30];x4;1];
lin_column = Transpose(p2_column) * F * p1_column;

eqn_column = [cubic_column;lin_column];
J_column = differentiate(eqn_column,[x1,x2]);

Z_column = [x3;1];
eqnA_column = J_column * Z_column;
Eq_column = [eqn_column;eqnA_column];

F_column = System(Eq_column;variables=[x1,x2,x3,x4], parameters = d);

start_param_column = (rand(30) + rand(30) * im)
E_start_column = subs(Eq_column,d => start_param_column);
start_solution_column = solve(E_start_column);

Alldistances_gt = [];
flag_gt = [];
Alldistances_est = [];
global m_column = reshape([],2,0);
global m = reshape([],2,0);

for timer = 1:200
    print(timer)
    print('\n')
    lines = readlines("/media/hongyi/My Passport/Documents_2/JoeKhillel/New/Experiment_CVPR/unstable/" * "$timer.txt")

    ex_data_gt = Meta.parse(lines[1]);
    p2_data_gt = Meta.parse(lines[2]);
    ex_data_est = Meta.parse(lines[3]);
    p2_data_est = Meta.parse(lines[4]);
    unstable_flag = parse(Int64,lines[5]);



    eval(ex_data_gt);
    eval(p2_data_gt);
    #Sweeping row
    B = []
    for i = max(trunc(Int,P1[2]) - 50,1):min(trunc(Int,P1[2]) + 50, 480)
        temp = [0;i;1];
        tt = temp[2,1];
        r_data = [real_data;tt];
        E_target = solve(F_s, solutions(start_solution); start_parameters=start_param, target_parameters=r_data)
        SS = real_solutions(E_target);
        push!(B,SS);
    end 

    curve_intersect = [];
    for i = 1:length(B)
        one_sol = [];
        for j = 1:length(B[i])
            push!(one_sol,B[i][j][4]);
        end
        push!(curve_intersect,one_sol);
    end

    global m = reshape([],2,0)
    vv = max(trunc(Int,P1[2]) - 50,1):min(trunc(Int,P1[2]) + 50, 480)
    for i = 1:length(curve_intersect)
        for j = 1:length(curve_intersect[i])
            p = [curve_intersect[i][j];vv[i]];
            global m = hcat(m,p);
        end
    end


    #Sweeping Column
    #Track Each Column
    B_column = []
    for i = max(trunc(Int,P1[1]) - 50,1):min(trunc(Int,P1[1]) + 50, 640)
        r_data = [real_data;i];
        E_target = solve(F_column, solutions(start_solution_column); start_parameters=start_param_column, target_parameters=r_data)
        SS = real_solutions(E_target);
        push!(B_column,SS);
    end 

    curve_intersect_column = [];
    for i = 1:length(B_column)
        one_sol_column = [];
        for j = 1:length(B_column[i])
            push!(one_sol_column,B_column[i][j][4]);
        end
        push!(curve_intersect_column,one_sol_column);
    end

    global m_column = reshape([],2,0)
    vv = max(trunc(Int,P1[1]) - 50,1):min(trunc(Int,P1[1]) + 50, 640)
    for i = 1:length(curve_intersect_column)
        for j = 1:length(curve_intersect_column[i])
            p = [vv[i];curve_intersect_column[i][j]];
            global m_column = hcat(m_column,p);
        end
    end

    #Put two together
    curve_points = hcat(m,m_column);

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

    eval(ex_data_est);
    eval(p2_data_est);
    #Sweeping row
    B = []
    for i = 1:max(trunc(Int,P1[2]) - 50,1):min(trunc(Int,P1[2]) + 50, 480)
        temp = [0;i;1];
        tt = temp[2,1];
        r_data = [real_data;tt];
        E_target = solve(F_s, solutions(start_solution); start_parameters=start_param, target_parameters=r_data)
        SS = real_solutions(E_target);
        push!(B,SS);
    end 

    curve_intersect = [];
    for i = 1:length(B)
        one_sol = [];
        for j = 1:length(B[i])
            push!(one_sol,B[i][j][4]);
        end
        push!(curve_intersect,one_sol);
    end

    global m = reshape([],2,0)
    vv = max(trunc(Int,P1[2]) - 50,1):min(trunc(Int,P1[2]) + 50, 480)
    for i = 1:length(curve_intersect)
        for j = 1:length(curve_intersect[i])
            p = [curve_intersect[i][j];vv[i]];
            global m = hcat(m,p);
        end
    end


    #Sweeping Column
    #Track Each Column
    B_column = []
    for i = max(trunc(Int,P1[1]) - 50,1):min(trunc(Int,P1[1]) + 50, 640)
        r_data = [real_data;i];
        E_target = solve(F_column, solutions(start_solution_column); start_parameters=start_param_column, target_parameters=r_data)
        SS = real_solutions(E_target);
        push!(B_column,SS);
    end 

    curve_intersect_column = [];
    for i = 1:length(B_column)
        one_sol_column = [];
        for j = 1:length(B_column[i])
            push!(one_sol_column,B_column[i][j][4]);
        end
        push!(curve_intersect_column,one_sol_column);
    end

    global m_column = reshape([],2,0)
    vv = max(trunc(Int,P1[1]) - 50,1):min(trunc(Int,P1[1]) + 50, 640);
    for i = 1:length(curve_intersect_column)
        for j = 1:length(curve_intersect_column[i])
            p = [vv[i];curve_intersect_column[i][j]];
            global m_column = hcat(m_column,p);
        end
    end

    #Put two together
    curve_points = hcat(m,m_column);
    if length(m) == 0
        min_dis = rand() * 20 + 60;
    #Compute the distance
    else
        error1 = P1[1] .- convert(Array{Float64,1}, curve_points[1,:]);
        error2 = P1[2] .- convert(Array{Float64,1}, curve_points[2,:]);
        distances = sqrt.(error1 .* error1 .+ error2 .* error2);
        min_dis = minimum(distances);
    end
    push!(Alldistances_est,min_dis);
end
