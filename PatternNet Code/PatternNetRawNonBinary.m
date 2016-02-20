listing = dir('TEST');
listing1 = dir('TRAIN');

%CreateRNN
%Phone list
PhoneList = {'aa','ae','ah','ao','aw','ax','ax-h','axr','ay','b','bcl','ch','d','dcl','dh','dx','eh','el','em','en','eng','epi','er','ey','f','g','gcl','hh','hv','ih','ix','iy','jh','k','kcl','l','m','n','ng','nx','ow','oy','p','pau','pcl','q','r','s','sh','t','tcl','th','uh','uw','ux','v','w','y','z','zh'};


%Create Query and Answer Arrays
phone_cap = 30000;
sound_cap = 257;
OtherAnswer = zeros(60, phone_cap);
Answer = zeros(1, phone_cap);
OtherQuery = zeros(sound_cap, phone_cap);
current_phones = 0;

index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
while index <= length(listing)
    listing2 = dir(fullfile('TRAIN',listing(index).name));
    while index1 <= length(listing2)
        listing3 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.phn'));
        listing4 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.wav'));
        while index2 <= length(listing3)
            ID = fopen(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing3(index2).name));
            file = textscan(ID, '%s');
            [y,Fs] = audioread(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing4(index2).name));
            Query = y;
            
            
            value = 0;
            SPindex = 1;
            while index3 <= length(file{1})
                if current_phones >= phone_cap
                    break;
                end
                temp = file{1}{index3 + 2};
                if strcmp(temp,'h#') == 0
                    value = find(ismember(PhoneList,temp));
                    OtherAnswer(value, current_phones + 1) = 1;
                end
                if strcmp(temp, 'sh') ~= 0
                    Answer(current_phones + 1) = 1;
                end
    
                
                if ((str2double(file{1}{index3 + 1}) + 1) - (str2double(file{1}{index3}) + 1)) <= sound_cap
                    for i = (str2double(file{1}{index3}) + 1) : (str2double(file{1}{index3 + 1}))
                        
                        OtherQuery(SPindex, current_phones + 1) = Query(i);
                        

                        SPindex = SPindex + 1;
                    end
                else
                    for i = (str2double(file{1}{index3}) + 1) : (str2double(file{1}{index3}) + sound_cap)

                        OtherQuery(SPindex, current_phones + 1) = Query(i);


                        SPindex = SPindex + 1;
                    end
                end
                    
                current_phones = current_phones + 1;
                SPindex = 1;
                value = 0;
                
                
                
                index3 = index3 + 3;
            end
            
            if current_phones >= phone_cap
                break;
            end
            fclose(ID);
            index3 = 1;
            index2 = index2 + 1;
        end
        
        if current_phones >= phone_cap
            break;
        end
        index2 = 1;
        index1 = index1 + 1;
    end
    
    if current_phones >= phone_cap
        break;
    end
    index1 = 3;
    index = index + 1;
end

clear ans current_phones file i ID index index1 index2 index3 listing listing1 listing2 listing3 listing4 max_phone phone_cap PhoneList Query sound_cap SPindex temp total_phones value y

net = patternnet(200);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.epochs = 100;
net = train(net, OtherQuery, OtherAnswer);
