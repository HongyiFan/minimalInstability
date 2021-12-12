function curve = loadCurves()
    fid = fopen('/home/hongyi/Documents/julia-1.4.2/bin/F_row.txt','r');
intersect_point = {};
tline = fgetl(fid);
counter = 1;
while ischar(tline)
    counter;
    intersect_point{counter} = str2num(tline(5:end-1));
    tline = fgetl(fid);
    counter = counter + 1;
end
fclose(fid);

curve_points = [];
for i = 1:length(intersect_point)
    points = intersect_point{i};
    for j = 1:length(points)
        target_p = [points(j);i;1];
        curve_points = [curve_points target_p];
    end
end

%% Recover the point when Column is used;
fid = fopen('/home/hongyi/Documents/julia-1.4.2/bin/F_column.txt','r');
intersect_point = {};
tline = fgetl(fid);
counter = 1;
while ischar(tline)
    counter;
    intersect_point{counter} = str2num(tline(5:end-1));
    tline = fgetl(fid);
    counter = counter + 1;
end
fclose(fid);

curve_points_column = [];
for i = 1:length(intersect_point)
    points = intersect_point{i};
    for j = 1:length(points)
        target_p = [i;points(j);1];
        curve_points_column = [curve_points_column target_p];
    end
end
curve = [curve_points_column curve_points];

end