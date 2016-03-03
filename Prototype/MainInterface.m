function MainInterface
    while(true)
        try
            NeuralNetwork = input('\n\nWould you like to use the:  (input an integer)\n1. HMM\n2. FNN\n3. Quit\n');
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
    disp(int2str(NeuralNetwork));
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
    disp(int2str(NeuralNetwork));
    while(true)
        try
            fprintf(['\n\nWhat module would you like to run?' ...
            '(input an integer)\n1. TRAIN\n2. TRAIN MULTIPLE\n3. TEST\n4. TEST MULTIPLE\n' ...
            '5. EXECUTE\n6. EXECUTE MULTIPLE\n7. Back\n']);
            if NeuralNetwork == 1
                fprintf(['HMM Accuracy: ' int2str(HMMAccuracy * 100) '%%\n']);
            else
                fprintf(['FNN Accuracy: ' int2str(FNNAccuracy * 100) '%%\n']);
            end
            
            ModuleType = input('Type Here: ');
            
            if ModuleType < 1 || ModuleType > 7
                continue;
            else
                break;
            end
        catch
            continue;
        end
    end
    if ModuleType == 7;
        MainInterface;
        return;
    end
    ModuleHandler(NeuralNetwork,ModuleType);
end

function ModuleHandler(NeuralNetwork,ModuleType)
    if ModuleType == 5 || ModuleType == 6
        if NeuralNetwork == 1
            load('HMM');
            if HMMAccuracy == 0
                fprintf('\nThe accuracy must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteHMM;
            end
        else
            load('FNN');
            if FNNAccuracy == 0
                fprintf('\nThe accuracy must be above 0%% to execute on an audio file\n');
                FindModule(NeuralNetwork);
                return;
            else
                ExecuteFNN;
            end
        end
    elseif ModuleType == 1 || ModuleType == 2
        if NeuralNetwork == 1
            TrainHMM;
        else
            TrainFNN;
        end
    elseif ModuleType == 3 || ModuleType == 4
        if NeuralNetwork == 1
            TestHMM;
        else
            TestFNN;
        end
    end
    FindModule(NeuralNetwork);
end
