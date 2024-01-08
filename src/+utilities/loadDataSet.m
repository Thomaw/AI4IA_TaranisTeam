function loadedDataStruct = loadDataSet(data_path)
% Read all CSV data in a folder and returns a structure array with 2 fields
%    -- data: cell array of all data. Each cell is a table representing one file read
%    -- fname: filename associated to each data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Moubarak Gado
%%% Maintainer: Moubarak Gado
%%% Email: moubarak.gado@mathworks.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    arguments
        data_path (1,1) string
    end

% Read data as file datastore
data_fds = fileDatastore(data_path,...
    "FileExtensions",".csv", "ReadFcn",@readtable, "ReadMode","File"); 

% get file name associated to each data
[~,fnames,~] = fileparts(data_fds.Files); % get filename associated to each data

% read all data at once
data_all = readall(data_fds);
%% return as a structure array
loadedDataStruct = struct("data", data_all,"fname",fnames);

end

