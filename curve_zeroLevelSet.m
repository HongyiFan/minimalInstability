function curve_points = curve_zeroLevelSet(cc,w,h)
    [y_1, y_2] = meshgrid(1:w,1:h);
    A1 = y_1.^6 .* y_2.^0;
    A2 = y_1.^5 .* y_2.^1;
    A3 = y_1.^4 .* y_2.^2;
    A4 = y_1.^3 .* y_2.^3;
    A5 = y_1.^2 .* y_2.^4;
    A6 = y_1.^1 .* y_2.^5;
    A7 = y_1.^0 .* y_2.^6;

    A8 = y_1.^5 .* y_2.^0;
    A9 = y_1.^4 .* y_2.^1;
    A10 = y_1.^3 .* y_2.^2;
    A11 = y_1.^2 .* y_2.^3;
    A12 = y_1.^1 .* y_2.^4;
    A13 = y_1.^0 .* y_2.^5;

    A14 = y_1.^4;
    A15 = y_1.^3 .* y_2.^1;
    A16 = y_1.^2 .* y_2.^2;
    A17 = y_1.^1 .* y_2.^3;
    A18 = y_1.^0 .* y_2.^4;

    A19 = y_1.^3; 
    A20 = y_1.^2 .* y_2.^1;
    A21 = y_1.^1 .* y_2.^2;
    A22 = y_1.^0 .* y_2.^3;

    A23 = y_1.^2;
    A24 = y_1 .* y_2.^1;
    A25 = y_1.^0 .* y_2.^2;

    A26 = y_1;
    A27 = y_2;
    A28 = 1;
    
    Func = zeros(size(y_1));
    for i = 1:28
        mono = eval(strcat('A',num2str(i))) .* cc(i);
        Func = Func + mono;
    end
    fh = figure(1);
    set(fh, 'Visible','off')
    M = contour(y_1,y_2,Func,[0,10e-10]);
    A = [];
    while (1)
        if M(1,1) ~= 0
            break;
        end
        A = [A M(:,2:1+M(2,1))];
        M = M(:,2+M(2,1):end)
    end
    curve_points = A;
end