listfiles = dir('*.csv');
numfiles = length(listfiles);
    
for i = 1:numfiles
    currentFile = listfiles(i).name;
    readingt = readtable(currentFile);
    
    [~, name_extless, ~] = fileparts(currentFile);
    parts = strsplit(name_extless, '_');
    cityname = parts{1};

    % script for individual files starts here
    startingt = readingt.Date(1);
    t = calmonths(between(startingt, readingt.Date, 'months'))+1;
    X = readingt.SeaLevel;
    
    % filtering out NaN values 
    elimNaN = ~isnan(X);
    X = X(elimNaN); 
    t = t(elimNaN); 
    N = length(t);
    
    % computing sea level annual harmonic
        for n = 1:N
            coss = cos((2*pi*t)/12);
            numA = sum(X .* coss);
            denA = sum(coss.^2);
            ca = numA/denA;
    
            sinn = sin((2*pi*t)/12);
            numB = sum(X .* sinn);
            denB = sum(sinn.^2);
            sa = numB/denB;
    
            amp = 0.5*sqrt(ca.^2 + sa.^2);
        end
    
        % checked above and was correct but idk about everything else below
    
    % finding the mean sea level for the original dataset
    meanSL = mean(readingt.SeaLevel, 'omitnan');
    % plugging in for NaN values in original dataset
    readingt.SeaLevel(isnan(readingt.SeaLevel)) = meanSL;
    X = readingt.SeaLevel;
    t = calmonths(between(startingt, readingt.Date, 'months'))+1;
    
    % redo ca and sa calc with new NaN substituted values
        for n = 1:N
            coss = cos((2*pi*t)/12);
            numA = sum(X .* coss);
            denA = sum(coss.^2);
            ca = numA/denA;
    
            sinn = sin((2*pi*t)/12);
            numB = sum(X .* sinn);
            denB = sum(sinn.^2);
            sa = numB/denB;
        end
    
    % removing annual harmonic from monthly time series
    Xdiff = X - ca*coss - sa*sinn;
    disp(Xdiff);
    readingt.AnnHarmonicRemoved = Xdiff;
    
    % standard dev from annual cycle
    window = [5 6];
    stdtm = movstd(Xdiff, window, 1);
    readingt.StdDev = stdtm;
    
    disp(readingt)
    disp(amp)

    % exporting
    [~, name, ~] = fileparts(currentFile);
    filename = [cityname,'_StandardDev.csv'];
    writetable(readingt, filename);
    disp(filename)

    [~, name, ~] = fileparts(currentFile);
    filenameAmp = [cityname,'_Amplitude.csv'];
    writetable(table(amp), filenameAmp);
    disp(filenameAmp)
end

