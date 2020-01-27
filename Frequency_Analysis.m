

% make hashmap of pitches

% audio-recorder



% pick a window size
    % Need sample rate
    % piano range A0-C8
        % using A1 - A6 55 Hz - 1760 Hz
         
% window function it
    % DFT the whole window, only take values from where windows are 50 % overlapped
    % This is means in the time domain, use the currently relevant DFT
    % start a new DFT whenever time/2 has elapsed - 50% overlap?
    % experiment with overlap percentages
    % hamming window
    
    % which window?
        % look at MP3 window lengths
    
    % how long?
        % 1/N resolution * sampling frequency 


%% Editable Parameters
Fs = 44100;   %Piezo Sample Rate;
N = 2^12;     % Window Size 2^14 = 16384;
Overlap = 0.5; % fraction of overlap between windows;
Harmonics = 1; % Number of harmonics


%% Storing/Creating more Parameters
params.Fs = Fs;
params.N = N;
params.Res = Fs/N;
params.fbins = params.Res * (0:N/2 - 1);
params.Overlap = Overlap;
[params.PitchMap,params.PitchArray] = getPitches();


%% Audio recorder
recorder = audiorecorder(params.Fs,8,1);
disp('3')
pause(1)
disp('2')
pause(1)
disp('1')
disp('start')
recordblocking(recorder,4)
disp('end')
r = getaudiodata(recorder);
plot(r)
% freqs
% Current_Freqs
% Note_Freqs
% Note_Names

%% test
freqs = [71,115,125,150];
t = 0:1/Fs:2;
signal = 0*t;
for i = 1:length(freqs)
    signal = signal + i*sin(2*pi*freqs(i)*t);
end
% figure(1)
% plot(t,signal)

audioWindow = signal(1:params.N);
audioWindow = audioWindow.* hamming(params.N)';
plot(audioWindow)

[Current_Freqs,Power] = Measure_Freq(params,audioWindow,Harmonics);
[Note_Freqs, Note_Names] = Find_Note(params,Current_Freqs);



%% Functions

function [Note_Freqs, Note_Names] = Find_Note(params,Current_Freqs)
    for i = 1:length(Current_Freqs)
        [~,Note_idx] = min(abs(params.PitchArray - Current_Freqs(i)));
        Note_Freqs(i) = params.PitchArray(Note_idx);
        Note_Names{i} = params.PitchMap(Note_Freqs(i));
    end
end

function [Current_Freqs,Power] = Measure_Freq(params, audioWindow, varargin)
    if nargin < 3
        M = 1;
    else
        M = varargin{1};
    end
    Ak           = fft(audioWindow,params.N);
    Energy       = (Ak.*conj(Ak)/params.N);
    if M == 1
        [~,F_idxs]  = max(Energy(1:params.N/2)); 
    else
        [~,F_idxs] = sort(Energy(1:params.N/2),'descend');     
    end
    Current_Freqs = params.fbins(F_idxs(1:M));
    Power = Energy(F_idxs(1:M))/sum(Energy(1:params.N/2));
end




