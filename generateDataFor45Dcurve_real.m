function [str,str2] = generateDataFor45Dcurve_real(P1,P2,K1,K2)

    P1_first4 = P1(:,1:4);
    P2_first4 = P2(:,1:4);
    Q1 = (inv(K1') * P1_first4)';
    Q2 = (inv(K2') * P2_first4)';

    %drawEpipolarGeometry(P1_first4,P2_first4,EGT,K,[480,640]);


    Q = [Q2(:,1).*Q1(:,1),...
        Q2(:,1).*Q1(:,2),...
        Q2(:,1).*Q1(:,3),...
        Q2(:,2).*Q1(:,1),...
        Q2(:,2).*Q1(:,2),...
        Q2(:,2).*Q1(:,3),...
        Q2(:,3).*Q1(:,1),...
        Q2(:,3).*Q1(:,2),...
        Q2(:,3).*Q1(:,3),...
        ];

    basis = null(Q);

    basis_output = basis(:)';
    pp1 = inv(K1') * P1(:,5);
    data_output = [basis_output pp1(1:2)'];


    str = [];
    
    str = strcat(str,sprintf("%.20f",data_output),';');
        

    
    str = [];
    for i = 1:length(data_output)
        str = strcat(str,sprintf("%.20f",data_output(i)),';');
    end
    str = strcat("real_data=[",str,"];");
    str2 = strcat("P1=[",sprintf("%.20f",P2(1,5)),";",sprintf("%.20f",P2(2,5)),"];");
end