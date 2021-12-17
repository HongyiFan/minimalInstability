function cc = onlineStage(P1,P2)
    %Get Points
    x_x = P1(1,1:7);
    x_y = P1(2,1:7);
    
    y_x = P2(1,1:6);
    y_y = P2(2,1:6);
    
    str_x_x =  strcat(num2str(x_x(1)),'p100');
    str_x_y =  strcat(num2str(x_y(1)),'p100');
    for i = 2:7
        str_x_x = strcat(str_x_x, ',', num2str(x_x(i)),'p100');
        str_x_y = strcat(str_x_y, ',',num2str(x_y(i)),'p100');
    end
    
    str_y_x = strcat(num2str(y_x(1)),'p100');
    str_y_y = strcat(num2str(y_y(1)),'p100');
    for i = 2:6
        str_y_x = strcat(str_y_x, ',',num2str(y_x(i)),'p100');
        str_y_y = strcat(str_y_y, ',',num2str(y_y(i)),'p100');
    end
    
    %Send commands to M2
    cmd1 = strcat("X= matrix{{", str_x_x, "}} || matrix{{", str_x_y, "}};");
    [~,~] = system(strcat('nc -N localhost 5000 <<< "', cmd1,'"'));
    cmd2 = strcat("Y= matrix{{", str_y_x, "}} || matrix{{", str_y_y, "}};");
    [~,~] = system(strcat('nc -N localhost 5000 <<< "', cmd2,'"'));
    [~,~] = system('nc -N localhost 5000 <<< "X = X || matrix{{1,1,1,1,1,1,1}}"');
    [~,~] = system('nc -N localhost 5000 <<< "R5 = RR_100[y_1,y_2]"');
    [~,~] = system('nc -N localhost 5000 <<< "Y = (Y | matrix{{y_1},{y_2}}) || matrix{{1,1,1,1,1,1,1}}" ');
    [~,~] = system('nc -N localhost 5000 <<< "Z={};" ');

    [~,~] = system('nc -N localhost 5000 <<< "for i from 0 to 6 do( Z = join(Z,{flatten entries(submatrix(X,,{i})*transpose(submatrix(Y,,{i})))}););" ');
    [~,~] = system('nc -N localhost 5000 <<< "Z=transpose matrix Z;" ');
    [~,~] = system('nc -N localhost 5000 <<< "ultimateSubs = apply(myIndices, t -> q_t => det(submatrix''(Z,toList t,)));"');
    [status,cmdOut] = system('nc -N localhost 5000 <<< "sexticPoly = substitute(ultimateDisc, ultimateSubs);" ');
    [status,cmdOut] = system('nc -N localhost 5000 <<< "sexticPoly / 10e80;"');
    
    %Parsing final expression
    ss = cmdOut;
    cc = zeros(1,28);
    counter = 1;
    while 1
        timeSym = find(ss == '*',1);
        if isempty(timeSym)
            break;
        end
        single_coef = ss(1:timeSym-1);
        cc(counter) = str2num(single_coef);
        ss = ss(timeSym+1:end);
        plusSym = find(ss == '+' | ss == '-',1);
        ss = ss(plusSym:end);
        counter = counter + 1;
    end
    cc(28) = str2num(ss);
end