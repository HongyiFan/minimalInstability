using Base
using HomotopyContinuation
using LinearAlgebra


open("/home/hongyi/Test_red") do f
    for (i, line) in enumerate(eachline(f))
        print("Line $i: $line")
    end
end

@var d[1:30]
@var x1 x2 x3 x4

real_data=[-0.00029844245538550074;-0.00218869738856456277;0.80622207021272163097;0.00000715936440027701;-0.00014027549150875319;-0.57892373024724486097;0.02127886929857574633;-0.11997213296855374631;-0.00151191873150577209;-0.00140583449818896893;0.00038289839966070639;0.03385537642773928796;0.00173832273903324285;-0.00135781253018852710;-0.15977082310970860957;-0.09075351106015278058;0.98238682062261950545;-0.00020991518569682188;-0.00000201188053179796;-0.00000131696313528925;0.00054866887900844078;0.00000153731869660265;-0.00000113361131673562;-0.00184708791458837213;-0.00121958161127574830;-0.00021830439644166989;0.99999737608813277223;407.88673321167419771882;241.00318333652685964807;];

f1 = Transpose(reshape(d[1:9],3,3));
f2 = Transpose(reshape(d[10:18],3,3));
f3 = Transpose(reshape(d[19:27],3,3));

F = x1 * f1 + x2 * f2 + f3;

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



#Track Each row
B = []
for i = 1:1028
    print(i)
    print("\n")
    temp = [0;i;1];
    tt = temp[2,1];
    r_data = [real_data;tt];
    E_target = solve(F_s, solutions(start_solution); start_parameters=start_param, target_parameters=r_data)
    SS = real_solutions(E_target);
    push!(B,SS);
end 

curve_intersect = [];
for i = 1:1028
    one_sol = [];
    for j = 1:length(B[i])
        push!(one_sol,B[i][j][4]);
    end
    push!(curve_intersect,one_sol);
end


f = open("F_row.txt","w");

for g in curve_intersect
    println(f,Transpose(g));
    #write(f,"\n");
end

close(f);

##################################################################################

#Column
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

#Track Each Column
B_column = []
for i = 1:679
    r_data = [real_data;i];
    E_target = solve(F_column, solutions(start_solution_column); start_parameters=start_param_column, target_parameters=r_data)
    SS = real_solutions(E_target);
    push!(B_column,SS);
end 

curve_intersect_column = [];
for i = 1:679
    one_sol_column = [];
    for j = 1:length(B_column[i])
        push!(one_sol_column,B_column[i][j][4]);
    end
    push!(curve_intersect_column,one_sol_column);
end


f = open("F_column.txt","w");

for g in curve_intersect_column
    println(f,Transpose(g));
    #write(f,"\n");
end

close(f);
