function trainedModelStruct = fit(xTraining, yTraining)
% FIT create and train a model on several (x,y) samples then returned the trained
% model and its additionnal parameters as a struct.
%   xTraining: input data given as 2D array, rows representing time and columns representing features
%   yTraining: target output for each given input data as 2D array. rows representing time and columns representing features
%   
%   trainedModelStruct: a 1*1 structure array that encapsulates all information (trained model and eventual additional parameters) 
%   needed to make prediction

nInputs  = size(xTraining,2);
nOutputs = size(yTraining,2);

figure()
plot(xTraining)
figure()
plot(yTraining)

layers = [
    sequenceInputLayer(nInputs,"Name","sequenceinput")
    gruLayer(100,"Name","gru_1")
    fullyConnectedLayer(nOutputs,"Name","fc")
    regressionLayer("Name","regressionoutput")];

%% definition des paramètres d'apprentissage
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','none', ...
    "InitialLearnRate",0.000002, ...
    'MaxEpochs',20000, ...
    'MiniBatchSize',64, ...
    "ExecutionEnvironment","auto",...
    'Plots','none');

%% Entrainement du réseau
[net, ~] = trainNetwork(xTraining', yTraining',layers,options);

%% Predictions sur les données d'entrainement
y_pred = predict(net, xTraining');
y_pred = y_pred.';

for i=1:nOutputs
    figure
    plot(yTraining(:,i), "DisplayName","reference")
    hold on
    plot(y_pred(:,i)', "DisplayName","prediction")
    hold off
    legend()
    grid on
    title("Output "+string(i)+" (Train)")
end

%% create a struct
trainedModelStruct = struct;
trainedModelStruct.net = net;
end