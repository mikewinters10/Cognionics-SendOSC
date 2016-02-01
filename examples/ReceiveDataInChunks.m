% instantiate the library
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
u = udp('192.168.1.6',7401); 
fopen(u);

disp('Now receiving chunked data...');
while true
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    for s=1:length(stamps)
        % and display it
        % Give just the accelerometer data
        fprintf('%.2f\t',chunk(9:11,s));
        oscsend(u,'/test','ifsINBTF', chunk(9:11,s)); 
        % fprintf('%.5f\n',stamps(s));
    end
    pause(0.05);
end

% Close UDP Connection
fclose(u)