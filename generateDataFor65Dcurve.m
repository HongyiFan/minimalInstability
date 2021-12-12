function [str, str2] = generateDataFor65Dcurve(p1ImageOnImage,p2ImageOnImage)
    P1_first6 = p1ImageOnImage(:,1:end-1);
    P2_first6 = p2ImageOnImage(:,1:end-1);
    Q1 = P1_first6';
    Q2 = P2_first6';

    P1_7 = p1ImageOnImage(:,7);
    P2_7 = p2ImageOnImage(:,7);

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
    data_output = [basis_output P1_7(1:2)'];
        
    str = [];
    for i = 1:length(data_output)
        str = strcat(str,sprintf("%.20f",data_output(i)),';');
    end
    str = strcat("real_data=[",str,"];");
    str2 = strcat("P1=[",sprintf("%.20f",P2_7(1)),";",sprintf("%.20f",P2_7(2)),"];");
end