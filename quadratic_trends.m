listfiles = dir('*.csv');
numfiles = length(listfiles);
citynamestotal = cell(numfiles,1);
totalslopes = zeros(numfiles,1);
k = 1;
    
for i = 1:numfiles
    currentFile = listfiles(i).name;
    readingt = readtable(currentFile);
    
    [~, name_extless, ~] = fileparts(currentFile);
    parts = strsplit(name_extless, '_');
    cityname = parts{1};
    
    % Process the second column of the table
    y = readingt.SeaLevel;
    dates = readingt.Date;
    numeric_dates = datenum(dates);
    mdl = fitlm(numeric_dates,y);
    % Display the summary of the linear model
    disp(mdl)

    slope = mdl.Coefficients.Estimate(2);

    figure;
    plot(dates, y, 'x', 'DisplayName','Data');
    hold on;

    plot(dates, mdl.Fitted, 'DisplayName','Fit');
    xlabel('Date');
    ylabel('Sea Level');
    title('Sea Level Linear Trends: ',cityname);
    hold off;

    % exporting
    outputfile = [cityname,'_Linear_Plot.png'];
    saveas(gcf, outputfile);
    close(gcf);
    disp(outputfile)
    disp(slope)

    citynamestotal{k} = cityname;
    totalslopes(k) = slope;
    k = k + 1;
end

%% 
% exporting
finalcities = citynamestotal(1:numfiles);
finalslopes = totalslopes(1:numfiles);
newtable = table(finalcities, finalslopes, 'VariableNames', {'City', 'LinearSlope'});
outputtable = 'Northeast_Linear_Slopes.xlsx';
writetable(newtable, outputtable);
disp(newtable)
