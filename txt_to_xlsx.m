findfiles = '*.txt';
listfiles = dir(findfiles);
for i = 1:length(listfiles)
    currentfile = listfiles(i).name;

    % arranging data into table
    mat = readmatrix(currentfile);
    data = array2table(mat,'VariableNames',{'FracDate','SeaLevel','MissingDays','Flag'});
    format long;

    % separating year and day
    frac_dates = data.FracDate;
    year = floor(frac_dates); % extracting year from date
    frac = frac_dates - year; % extracting day as fraction from date

    % accounting for leap years by finding total # of days in each year
    d1 = datenum(year,1,1);
    d2 = datenum(year+1,1,1);
    days_in_year = days(d2 - d1);
    data.DaysInYear = days_in_year;

    % classifying leap years
    data.LeapYear = data.DaysInYear == 366; % where true = leap year, false = not a leap year

    % computing # of days into each year
    day_of_year = frac .* days_in_year;
    data.DayOfYear = day_of_year;

    % convert to datetime
    yearstart = datetime(year,1,1);
    data.Date = yearstart + (day_of_year - 1); % accounting for extra day

    % indicate missing values
    data.SeaLevel(data.SeaLevel == -99999) = NaN;

    % flag readings with data issues/inconsistencies
    % either because month is missing days, data is flagged, or no SL reading
    % these may be removed from the dataset when computing trends
    data.Issues = (data.MissingDays == 99 | data.Flag > 000 | isnan(data.SeaLevel)); % where true = issue, false = accurate

    outputtable = data(:,{'Date','SeaLevel','Issues'});

    [~, name, ~] = fileparts(currentfile);
    filename = [name,'_Cleaned_Monthly.xlsx'];
    writetable(outputtable, filename);
    disp(filename)
end

