function calc_metrics(train_fileName, data_dir, test_fileName, output_dir)
% Perform fit process using given training data from data_dir, compute metrics with ...
% test_fileName and save metrics to given output_dir directory

arguments
    train_fileName string {mustBeTextScalar, mustBeText, mustBeNonzeroLengthText}
    data_dir string {mustBeTextScalar, mustBeText, mustBeNonzeroLengthText, mustBeFolder}   = fullfile(currentProject().RootFolder,"data","DataSet_phase1");
    test_fileName  string {mustBeTextScalar, mustBeText, mustBeNonzeroLengthText}           = "input2";
    output_dir string {mustBeTextScalar, mustBeText, mustBeNonzeroLengthText} = fullfile(currentProject().RootFolder,"metrics_results");
end


if ~exist(output_dir, 'dir')
   mkdir(output_dir)
end

calc_metrics_function(data_dir, output_dir, train_fileName, test_fileName);

end





function calc_metrics_function(data_dir, output_dir, train_fileName, test_fileName)
% Perform fit process using given training data, compute metrics with ...
% test_fileName and save metrics to given output directory

    %PLEASE NOTE THAT WE ONLY CONSIDER MODELS THAT COMPUTES ALL THE (5) OUTPUTS
    nOutputs=5;  % We only consider models that computes all 5 outputs
    %% load training data
    dataStruct_t_x_y = utilities.loadDataSetAs_t_x_y(data_dir);

    %% fit
    % get training data
    trainingFileLogicalIdx = {dataStruct_t_x_y.fname}==string(train_fileName);
    xTraining = dataStruct_t_x_y(trainingFileLogicalIdx).x;    
    yTraining = dataStruct_t_x_y(trainingFileLogicalIdx).y; 

    % time fit process
    fit_tStart = tic;
    trainedModelStruct = fit(xTraining, yTraining);
    metric_train_time = toc(fit_tStart);


    %% Load test data
    testFileLogicalIdx = {dataStruct_t_x_y.fname}==string(test_fileName);
    xTest = dataStruct_t_x_y(testFileLogicalIdx).x;
    yTest = dataStruct_t_x_y(testFileLogicalIdx).y;

    %% Inference time computation
    nSamplesTest = size(xTest,1);
    
    predict_timeseries_tStart = tic;
    [~, ~] = predict_timeseries(trainedModelStruct, xTest);
    inferenceTimeComputation = toc(predict_timeseries_tStart);

    % mean
    metric_mean_inference_time  = inferenceTimeComputation/nSamplesTest;

    %% Normalized error computation
    [yPred_timeseries, ~] = predict_timeseries(trainedModelStruct, xTest);


    %normalized by max ytest
    %compute mse for all 5 inputs
    max_yTest_values = max(abs(yTest));
    yTest = yTest./max_yTest_values;
    yPred_timeseries = yPred_timeseries./max_yTest_values;

    metric_normalized_mse = mean(yTest.^2 - yPred_timeseries.^2);

    weights = ones(1,nOutputs);
    metric_normalized_mse_sum = dot(weights , metric_normalized_mse);
    
    
    %% DEBUG : 
    sprintf("DEBUG : ")
    sprintf("Aggregated Metrics : %s\n",num2str(size(xTraining,1)/1e6))
    sprintf("Average inference time [seconds] : %s\n", num2str(metric_mean_inference_time))
    sprintf("Normalized MSE Sum : %s\n", num2str(metric_normalized_mse_sum))
    sprintf("Training time [seconds] : %s\n", num2str(metric_train_time/3600/1e3))
    
    %% Aggregated performance metric (as defined by organizers)
    aggregated_performance_indicator = metric_train_time/3600/1e3 + ...
        metric_mean_inference_time + ...
        metric_normalized_mse_sum  + ...
        size(xTraining,1)/1e6;    
    
    %% Save metric in a struct along with description
    metrics_info = struct;
    metrics_info.description = description();
    metrics_info.metric_train_time = metric_train_time;
    metrics_info.metric_mean_inference_time = metric_mean_inference_time;
    metrics_info.metric_normalized_mse = metric_normalized_mse;
    metrics_info.metric_normalized_mse_sum = metric_normalized_mse_sum;
    metrics_info.aggregated_performance_indicator = aggregated_performance_indicator;
    metrics_info.training_set_size = size(xTraining,1);

    %% Save metric (txt and json)
    metric_filename = sprintf("%s_%s_metrics",...
        metrics_info.description.team_name,...
        metrics_info.description.model_name);
    utilities.metrics.save_metric(metrics_info, metric_filename, output_dir)
    
end 