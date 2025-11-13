listfiles = dir('*_Monthly.csv');
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
    
    % assigning variables to be plotted
    y = readingt.SeaLevel;
    dates = readingt.Date;
    numeric_dates = datenum(dates);
    mdl = fitlm(numeric_dates,y);
    disp(mdl); 

    slope = mdl.Coefficients.Estimate(2);
    slopemmyr = slope*12

    % things for plot
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
    disp(slopemmyr)

    citynamestotal{k} = cityname;
    totalslopes(k) = slopemmyr;
    k = k + 1;
end

%% 
% exporting
finalcities = citynamestotal(1:numfiles);
finalslopes = totalslopes(1:numfiles);
newtable = table(finalcities, finalslopes, 'VariableNames', {'City', 'LinearSlope'});
outputtable = 'Northeast_Linear_Slopes.csv';
writetable(newtable, outputtable);
disp(newtable)
