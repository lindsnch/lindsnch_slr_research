listfiles = dir('*_Monthly.csv');
numfiles = length(listfiles);
citynamestotal = cell(numfiles,1);
totalaccel = zeros(numfiles,1);
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

    % filtering out NaN values 
    elimNaN = ~isnan(y);
    y = y(elimNaN); 
    dates = dates(elimNaN);

    numeric_dates = datenum(dates);
    centeredDates = numeric_dates - numeric_dates(1);
    mdl_quad = polyfit(centeredDates, y, 2);
    disp(mdl_quad)
    
    %find accleration values
    mm_month = 2 * mdl_quad(1);
    accel = mm_month * 144

    y_fit = polyval(mdl_quad, centeredDates);

    figure;
    plot(dates, y, 'kx', 'DisplayName', 'Data Points'); 
    hold on;

    plot(dates, y_fit, 'b-', 'LineWidth', 2, 'DisplayName', 'Quadratic Fit');
    xlabel('Date');
    ylabel('Sea Level (mm)');
    title('Sea Level Quadratic Trends: ',cityname);
    legend("show");
    hold off;

    % exporting
    h = gcf;
    disp(h)
    isvalid(h)
    outputfile = [cityname,'_Quadratic_Plot.png'];
    saveas(gcf, outputfile);
    close(gcf);
    disp(outputfile)
    disp(accel)

    citynamestotal{k} = cityname;
    totalaccel(k) = accel;
    k = k + 1;
end

%% 
% exporting
finalcities = citynamestotal(1:numfiles);
finalaccel = totalaccel(1:numfiles);
newtable = table(finalcities, finalaccel, 'VariableNames', {'City', 'Acceleration(mm/year^2)'});
outputtable = 'Accelerations.csv';
writetable(newtable, outputtable);
disp(newtable)
