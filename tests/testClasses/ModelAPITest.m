classdef ModelAPITest < matlab.unittest.TestCase
%% Test classe that performs several unit test regarding the Model API functions candidates should implement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Moubarak Gado
%%% Maintainer: Moubarak Gado
%%% Email: moubarak.gado@mathworks.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (TestParameter)
        trainedModelStructGivenParam = struct("NoTrainedModel", struct.empty);
    end
    
    properties
        description_struc
        descriptionFieldNames
        mustExistFieldsInDescriptionList = ["team_name",...
            "email",...
            "model_name",...
            "affiliation",...
            "description",...
            "technology_stack",...
            "other_remarks"];
        %data
        data_dir=fullfile(currentProject().RootFolder,"data","DataSet_phase1");
        numberOfExpectedOuptutsFromModel = 5
        xTestSubmission
        yTestSubmission
    end
    
    methods(TestClassSetup)     
        function populateDescription(testCase)
            testCase.description_struc = description();
            testCase.descriptionFieldNames = fieldnames(testCase.description_struc);
        end
       
        function loadSampleDataForTest(testCase)
            dataStruct_t_x_y = utilities.loadDataSetAs_t_x_y(testCase.data_dir);
            % get a very small sample data (for e.g, only 10 points)
            fileIndex=1;
            testCase.xTestSubmission = dataStruct_t_x_y(fileIndex).x;
            testCase.yTestSubmission = dataStruct_t_x_y(fileIndex).y;
            idx_few_samples = 1:10;
            testCase.xTestSubmission = testCase.xTestSubmission(idx_few_samples);
            testCase.yTestSubmission = testCase.yTestSubmission(idx_few_samples,:);
        end % end loadSampleDataForTest
    end % end TestClassSetup 
    
    %% Test Method Block For Description
    methods (Test)

        function testDescription_isAStruct(testCase)
            txtMessage = "Error in description: output argument must be a structure data type";
            testCase.verifyInstanceOf(testCase.description_struc, "struct",txtMessage);
        end % testDescription_isAStruct
        
        function testDescription_isNotEmpty(testCase)
            for i=1:length(testCase.descriptionFieldNames)
                fieldName= testCase.descriptionFieldNames{i};
                value = testCase.description_struc.(fieldName);
                testCase.verifyNotEmpty(value);
            end
        end % end testDescription_isNotEmpty       
        
        
        function testDescription_checkNoMissingFields(testCase)
            isMemberOfExistingBoolArray = ismember(testCase.mustExistFieldsInDescriptionList, testCase.descriptionFieldNames);
            noMissingFieldBool = all(isMemberOfExistingBoolArray);
            
            txt = sprintf("Error in description: missing attribute #%s\n",...
                    testCase.mustExistFieldsInDescriptionList(isMemberOfExistingBoolArray==0));
                
            testCase.verifyTrue(noMissingFieldBool, txt);      
        end %end testDescription_checkNoMissingFields
        
        function testDescription_checkFieldsValuesAreTextScalars(testCase)
            
            for i=1:length(testCase.descriptionFieldNames)

                try
                    mustBeTextScalar(testCase.description_struc.(testCase.descriptionFieldNames{i}))
                catch 
                    txt = sprintf("Error in description: <%s> must be a text scalar\n",testCase.descriptionFieldNames{i});
                    testCase.assertTrue(false, txt)
                end
            
            end % for   
        
        end %end testDescription_checkFieldsValuesAreTextScalars
        
        function testDescription_checkNoSpaceForTeamNameAndModelName(testCase)
            %check if no space for team_name and model_name
            
            % team_name
            noSpaceForTeamName = any(isspace(testCase.description_struc.team_name));  
            txt = sprintf("Error in description:"+...
                " value <team_name> must contain no space -->'%s'",...
                testCase.description_struc.team_name) ;
            testCase.verifyFalse(noSpaceForTeamName,txt);
            
            % model_name
            noSpaceForModelName = any(isspace(testCase.description_struc.model_name));
            txt = sprintf("Error in description:"+...
                " value <model_name> must contain no space -->'%s'",...
                testCase.description_struc.model_name) ;
            testCase.verifyFalse(noSpaceForModelName,txt);
            
        end % end testDescription_checkNoSpaceForTeamNameAndModelName
        
        
        
    end % description test method block 
    
    
    %%  Test method Block for trainedModelStruct predict_series
    methods (Test)
        
        function test_predict_timeseries(testCase, trainedModelStructGivenParam)
            if isempty(trainedModelStructGivenParam)
                testCase.assertTrue(false, "Test did not run because no trainedModelStruct was given. Please Give a trainedModel struct as input")
            else
                [yPred, ~] = predict_timeseries(trainedModelStructGivenParam, testCase.xTestSubmission);
                txt = sprintf("Problem with predict_timeseries()"+...
                    " function: expected outputs size should be %s",size(testCase.yTestSubmission));
                testCase.verifySize(yPred,size(testCase.yTestSubmission),txt)

            end
        
        end  % test_predict_timeseries          
        
    end % Block test method predict*
    
    
    %%  Test method Block for training process : fit  ( and subsequent action: predict_series )
    methods (Test, TestTags = {'fullTest'})
        function test_fit_predict_series(testCase)
            fitOutput = fit(testCase.xTestSubmission, testCase.yTestSubmission);
            
            txt = "fit function must return a struct of size 1*1";
            testCase.verifySize(fitOutput,[1 1],txt);
            
            txt = "fit function must return a struct";
            testCase.verifyClass(fitOutput, "struct",txt);
            
            % try to make prediction with resuts
            % time series
            testCase.test_predict_timeseries(fitOutput);
                
        end % fit
    end % test method block training process (fit+)
    
    
end % classdef