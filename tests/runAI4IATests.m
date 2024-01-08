function runAI4IATests(trainedModelStruct, testOptions)
%% Run AI4IA main test script for your implementation of description 
%  and predict_timeseries

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Moubarak Gado
%%% Maintainer: Moubarak Gado
%%% Email: moubarak.gado@mathworks.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    arguments
        trainedModelStruct struct 
        testOptions string {mustBeMember(testOptions,["doOnlyQuickTests","doFullTests"]),...
            mustBeTextScalar, mustBeText, mustBeNonzeroLengthText } = "doFullTests"
    end

    %% check implementations files exist (or at least files with same names)
    listName=["description", "fit", "predict_timeseries"];
    for i = 1:length(listName)
        a = which(listName(i));
        txtMessage = sprintf("/!\\ A Model API function is missing: %s",listName(i));
        assert(~isempty(a),txtMessage) 
        fprintf("Using as Model API function <%s>, the file located at following path:\n",listName(i))

        disp("##### "+string(a))
        disp(' ')
    end

    %% Running test suite
    import matlab.unittest.TestSuite
    import matlab.unittest.parameters.Parameter
    import matlab.unittest.selectors.HasTag

    newData = {trainedModelStruct};
    param = Parameter.fromData('trainedModelStructGivenParam',newData);
    suite = TestSuite.fromClass(?ModelAPITest,'ExternalParameters',param);

    % do all tests (including fit) or not
    if testOptions == "doOnlyQuickTests"
        disp("runAI4IATests: doing only quick tests")
        suite =  suite.selectIf(~HasTag('fullTest'));
    end
    
    % run test suite
    results = suite.run;
    % display results
    disp(results)


end

