function metricInfoStruct = loadMetricStructFromJSON(jsonFileName)
%LOADMETRICSTRUCTFROMJSON Load metric structure data from JSON


%% Load metric struct saved as txt file 
fileID = fopen(jsonFileName,'r');
A = fscanf(fileID,"%s");
fclose(fileID);

%% Decode json
A=jsondecode(A);
A.metric_normalized_mse_sum = A.metric_normalized_mse_sum';
A.metric_normalized_mse = A.metric_normalized_mse';

metricInfoStruct = A;

end

