% Read the ECG data file
filename = 'ECG_Data .txt';
fileContent = fileread(filename);

%Split the data by row
lines = strsplit(fileContent, '\n');

ecgData = [];
for i = 1:length(lines)
    line = strtrim(lines{i});
    if isempty(line)
        continue;
    end
    
    % Split the data by space
    tokens = strsplit(line, ' ');
    
    % Verify the header and tail of the data frame
    if ~strcmp(tokens{1}, 'aa') || ~strcmp(tokens{2}, '55') || ~strcmp(tokens{end}, 'cc')
        continue;
    end
    
    % Extract valid data portion (remove header A55 and end check field)
    validTokens = tokens(3:end-3);
    
    % Merge two hexadecimal bytes into a single sampling point
    for j = 1:2:length(validTokens)
        if j+1 > length(validTokens)
            break;
        end
        hexHigh = validTokens{j};
        hexLow = validTokens{j+1};
        hexValue = [hexHigh hexLow];
        
        % Hexadecimal to signed integer conversion
        rawValue = typecast(uint16(hex2dec(hexValue)), 'int16');
        ecgData = [ecgData; double(rawValue)];
    end
end

% Set sampling rate
fs = 1000; % Adjust according to the actual situation
t = (0:length(ecgData)-1) / fs;

% Draw waveform
figure;
plot(t, ecgData);
xlabel('Time (s)');
ylabel('amplitude');
title('ECG Waveform');
grid on;

% Automatically adjust the display range of coordinate axes
xlim([0 t(end)]);