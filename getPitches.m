function [PitchMap,PitchArray] = getPitches()
Starting_Octave = 2;
% Pitches for C2 to B2
Note_Names = {'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab','A', 'Bb', 'B'};
keyOriginal = {65.41, 69.30, 73.42, 77.78, 82.41, 87.31, 92.50, 98.00, 103.83, 110.00, 116.54, 123.47};
keySet = keyOriginal;
PitchArray = [];

for i = 1:length(keyOriginal)
    PitchArray(i) = keyOriginal{i};
end

Added_Octaves = 5;
for i = 1 : Added_Octaves
    for j = 1 : 12
        keySet{end+1} = keySet{(i*12-12)+j}*2.00;
        PitchArray(end+1) = keySet{(i*12-12)+j}*2.00;
    end
end

valueSet = cell(0);
for i = Starting_Octave:Added_Octaves + Starting_Octave
    for j = 1:12
        valueSet{end+1} = sprintf('%s%i', Note_Names{j}, i);
    end
end

PitchMap = containers.Map(keySet, valueSet);
end

