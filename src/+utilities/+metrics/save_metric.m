function save_metric(metricInfoStruct, ToFilename, location)
% Function that saves with given filename from given metric structure to the specified location

arguments
    metricInfoStruct struct
    ToFilename string
    location string = currentProject().RootFolder
end

%% check fields
mustExistFieldsList = ["description",...
    "metric_train_time",...
    "training_set_size",...
    "metric_mean_inference_time",...
    "metric_normalized_mse",...
    "metric_normalized_mse_sum", ...
    "aggregated_performance_indicator"];

isFieldArrayBool = isfield(metricInfoStruct,mustExistFieldsList);

if ~all(isFieldArrayBool)
    missingFieldsNames = mustExistFieldsList(isFieldArrayBool==0);
    disp("Missing fields are:")
    disp(missingFieldsNames)
    error("Missing fied in metricInfo struc.\n")
end
%% Formating

% format description part
description_struc_ordered = orderfields(metricInfoStruct.description);
descriptionFieldNames = fieldnames(description_struc_ordered);
str_description = {};
for i=length(descriptionFieldNames):-1:1
    key = descriptionFieldNames{i};
    value = description_struc_ordered.(key);
    str_description{i}= sprintf('%s : %s\n',key, value);
end

% format real metrics  part
str_metrics = {1,6};
str_metrics{1} = sprintf("Aggregated Metrics : %s\n", ...
    num2str(metricInfoStruct.aggregated_performance_indicator));
str_metrics{2} = sprintf("Average inference time [seconds] : %s\n",...
    num2str(metricInfoStruct.metric_mean_inference_time));
str_metrics{3} = sprintf("Normalized MSE : %s\n",...
    num2str(metricInfoStruct.metric_normalized_mse));
str_metrics{4} = sprintf("Normalized MSE Sum : %s\n",...
    num2str(metricInfoStruct.metric_normalized_mse_sum));
str_metrics{5} = sprintf("Training set size : %s\n", ...
    num2str(metricInfoStruct.training_set_size));
str_metrics{6} = sprintf("Training time [seconds] : %s\n", ...
    num2str(metricInfoStruct.metric_train_time));

% concatenate
metricInfoDisplay_str =  [str_description{:}, str_metrics{:}];
metricInfoDisplay_str = string(metricInfoDisplay_str);%convert cell to string


%% Display
displayedTextFormatted = sprintf("%s",metricInfoDisplay_str{:});
fprintf("%s",displayedTextFormatted);

%% Save to txt file
if ~exist(location, 'dir')
    mkdir(location); 
    fprintf("#Create folder --> %s\n", what(location).path)
end

ToFilename_ff = fullfile(location, ToFilename); 

fileID = fopen(ToFilename_ff,'w');
fprintf(fileID,'%s',displayedTextFormatted);
fclose(fileID);

% Also save as json: whole metric struc (metricInfoStruct) 
metrics_info_json = jsonencode(metricInfoStruct);
% get ride of file extension if there is any
[~,fname,~]= fileparts(ToFilename);
ToJSON_ff = fullfile(location, fname + ".json"); 
fileID = fopen(ToJSON_ff,'w');
fprintf(fileID,'%s',metrics_info_json);
fclose(fileID);


end

