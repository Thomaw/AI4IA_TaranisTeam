function [y, updatedModelStruct] = predict_timeseries(trainedModelStruct, x)
% PREDICT_TIMESERIES produce a prediction of target using as inputs the trained model and the entire time series from the beginning
%   trainedModelStruct: 1*1 structure array that encapsulates the trained model as long as additional parameters needed for prediction
%   x: input representing the entire time series as 2*D array (rows as time, and columns as targets)
%
%   y: corresponding output targets.
%   updatedModelStruct: 1*1 structure array that encapsulates the updated
%   model as long as additional parameters needed for prediction. Useful
%   when for example, your model struct has some internal states that are 
%   updated at each prediction. Note that updatedModelStruct may be equal 
%   to trainedModelStruct if model's state has not changed during 
%   prediction

net = trainedModelStruct.net;
y = predict(net, x');

y = y.';
trainedModelStruct.net = net;
updatedModelStruct = trainedModelStruct;
end