function MainInterface
    while(true)
        try
            % hmm or fnn
            NeuralNetwork = input('\n\nPlease choose your method.  \n\n1. HMM\n2. FNN\n3. Quit\n\nInput an integer: ');
            if NeuralNetwork < 1 || NeuralNetwork > 3
                continue;
            else
                break;
            end
        catch
            continue;
        end
    end
    if NeuralNetwork == 3
        return;
    end
    FindModule(NeuralNetwork);
end

function FindModule(NeuralNetwork)
   % disp(int2str(NeuralNetwork));
    try
        load('FNN');
    catch
        FNNAccuracy = 0;
        %assignin(ws, 'FNNAccuracy', FNNAccuracy);
        save('FNN', 'FNNAccuracy');
    end
    try
        load('HMM');
    catch
        HMMAccuracy = 0;
        %assignin(ws, 'HMMAccuracy', HMMAccuracy);
        save('HMM', 'HMMAccuracy');
    end
    %disp(int2str(NeuralNetwork));
    while(true)
        try
            if NeuralNetwork == 1
                fprintf('\n\nYou have choosen the HMM.');
            else
                fprintf('\n\nYou have choosen the FNN.');
            end
            
            % Print Current Accuracy 
            if NeuralNetwork == 1
                fprintf(['\n\nCurrent HMM Accuracy: ' int2str(HMMAccuracy * 100) '%%\n']);
            else
                fprintf(['\n\nCurrent FNN Accuracy: ' int2str(FNNAccuracy * 100) '%%\n']);
            end
            
            fprintf(['\nWhat module would you like to run?\n' ...
            '\n1.  TRAIN MULTIPLE\n2.  TEST MULTIPLE\n' ...
            '3.  EXECUTE\n4.  EXECUTE MULTIPLE\n5.  BACK\n\n']);
            
            ModuleType = input('Input an integer: ');
            
            if ModuleType < 1 || ModuleType > 5
                continue;
            else
                break;
            end
        catch
            continue;
        end
    end
    if ModuleType == 5;
        MainInterface;
        return;
    end
    ModuleHandler(NeuralNetwork,ModuleType);
end

function ModuleHandler(NeuralNetwork,ModuleType)
    % Train Multiple: Choice 1
    if ModuleType == 1 
        if NeuralNetwork == 1
            TrainHMM;
            FindModule(NeuralNetwork);
            return;
        else
            TrainFNN;
            FindModule(NeuralNetwork);
            return;
        end
        
        
    % Test Multiple: Choice 2    
    elseif ModuleType == 2
        if NeuralNetwork == 1
            load('HMM');
            if HMMAccuracy == 0
                fprintf('\nThe accuracy of the HMM must be above 0%% to test\nPlease train the accuracy\n');
                FindModule(NeuralNetwork);
                return;
            else 
                TestHMM;
                FindModule(NeuralNetwork);
                return;
            end
        else
             load('FNN');
            if FNNAccuracy == 0
                fprintf('\nThe accuracy of the FNN must be above 0%% to test\nPlease train the accuracy\n');
                FindModule(NeuralNetwork);
                return;
            else 
                TestHMM;
                FindModule(NeuralNetwork);
                return;
            end
        end     
       
        
    % Execute: Choice 3   
    elseif ModuleType == 3 
        if NeuralNetwork == 1
            load('HMM');
            if HMMAccuracy == 0
                fprintf('\nThe accuracy of the HMM must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteHMM;
                FindModule(NeuralNetwork);
                return;
            end
        else 
            load('FNN');
            if FNNAccuracy == 0
                fprintf('\nThe accuracy of the FNN must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteFNN;
                FindModule(NeuralNetwork);
                return;
            end
        end
        
    % Execute Multiple: Choice 4    
    elseif ModuleType == 4
        if NeuralNetwork == 1
            load('HMM');
            if HMMAccuracy == 0
                fprintf('\nThe accuracy of the HMM must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteMultiHMM;
            end
        else 
            load('FNN');
            if FNNAccuracy == 0
                fprintf('\nThe accuracy of the FNN must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteMultiFNN;
            end 
        end
    FindModule(NeuralNetwork);
    end
end
