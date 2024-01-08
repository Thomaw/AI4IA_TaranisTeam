function loadedDataStruct_t_x_y = loadDataSetAs_t_x_y(data_path,options)
% Read all CSV data in a folder and returns a structure array with 4 fields
%    -- t: array representing time data in each file
%    -- x: array reprenting x data in each file
%    -- y: array reprenting y data in each file
%    -- fname: filename associated to each data
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Moubarak Gado
%%% Maintainer: Moubarak Gado
%%% Email: moubarak.gado@mathworks.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    arguments
        data_path (1,1) string
        options.t_index (1,:) {mustBeInteger, mustBeNonzero}= 1
        options.x_index (1,:) {mustBeInteger, mustBeNonzero}= 2
        options.y_index (1,:) {mustBeInteger, mustBeNonzero}= 3:7
    end
    
    loadedDataStruct = utilities.loadDataSet(data_path);
    
    data_all = {loadedDataStruct.data};
    fnames = {loadedDataStruct.fname};
    
    %% check that all files has the same number of column and the same VariableNames
    variableNamesCellArray = cellfun(@(x) x.Properties.VariableNames, data_all,'UniformOutput', false);

    % check if same column number
    haveSameColumnNumberChecks = cellfun (@(x) isequal(length(variableNamesCellArray{1}),length(x)) , variableNamesCellArray);
    if ~all(haveSameColumnNumberChecks)
        fprintf("Folder '%s' contains files of differents column number:\n",data_path );
        error("#File '%s' column number differs from other files.\n",fnames{haveSameColumnNumberChecks==0})
    end

    % check if same column names
    haveSameColumnNameChecks =  cellfun (@(x) isequal(variableNamesCellArray{1},x) , variableNamesCellArray);
    if ~all(haveSameColumnNameChecks)
        fprintf("Folder '%s' contains files of differents column names:\n",data_path );
        error("#File '%s' column names differ from other files ones.\n",...
            fnames{haveSameColumnNumberChecks==0})
    end

    %% 
    variableNames = string(variableNamesCellArray{1});
    variableIndexes = 1:length(variableNames);
    
    % check t index in table
    if  ~ismember(options.t_index,variableIndexes)
        error("Variable Index #%d# not in table dimensions.\n",options.t_index)
    end
    %check x index or variable names in table
    if  ~ismember(options.t_index,variableIndexes)
        error("Variable Index #%d not in table dimensions.\n",options.t_index)
    end
    %check y index in table
    if  ~ismember(options.t_index,variableIndexes)
        error("Variable Index #%d not in table dimensions.\n",options.t_index)
    end   
    %%
    get_column_fn = @(idx) cellfun(@(x) x{:,idx},...
        {loadedDataStruct.data}, "UniformOutput", false);
    
    t = get_column_fn(options.t_index);
    x = get_column_fn(options.x_index);
    y = get_column_fn(options.y_index);
    
    
    
    %% return as a structure array
    loadedDataStruct_t_x_y = struct("t", t, "x",x,"y",y, "fname",fnames);
    
end

