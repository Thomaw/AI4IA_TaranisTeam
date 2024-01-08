function description_struc = description()
    %% ONLY MODIFY THIS PART: replace <string.empty> by your own information
    team_name         = "Taranis"; 
    email             = "Dubouchet-Thomas@hotmail.com";
    model_name        = "TaranisModel"; 
    affiliation       = "ELISA Aerospace"; 
    model_description = "Simple GRU model that support 1 inputs and 1 to 5 outputs";
    technology_stack  = "MATLAB";
    other_remarks     = ""; 

    %% DO NOT MODIFY THIS PART
    description_struc = struct(...
        'team_name', team_name, ...              %"team_name" NO SPACE ALLOWED
        'email', email,...                       %"your_email@gmail.com"
        'model_name', model_name,...             %"The_name_you_want_to_give_to_your_model" NO SPACE ALLOWED
        'affiliation', affiliation,...           %"Company/Institution"
        'description', model_description,...     %"description of the model and architecture"
        'technology_stack', technology_stack,... %"matlab"
    'other_remarks', other_remarks);             %"put here anything else you'd like us to know"    

end