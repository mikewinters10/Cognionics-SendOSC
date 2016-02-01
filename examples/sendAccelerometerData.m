% A function to send raw accelerometer data from MATLAB over a network
% using OSC.  This function is basically a copy of ReceiveDataInChunks.m 
% with additional code for opening and sending just the accelerometer data 
% as OSC. 
% 
% R. Michael Winters
% January 31, 2016

function sendAccelerometerData(ip_address, port)

disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});

% Open OSC Port
u = udp(ip_address,port); 
fopen(u);

disp('Now receiving chunked data...');
while true
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    for s=1:length(stamps)
        % Give just the accelerometer data
        %fprintf('%.2f\t',chunk(9:11,s));
        %fprintf('\n');
        oscsend(u,'/Acc','fff', chunk(9,s), chunk(10,s), chunk(11,s)); 
    end
    pause(0.05);
end

% Close UDP Connection
fclose(u)