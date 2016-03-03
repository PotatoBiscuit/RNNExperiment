%This code trains the patternnet on a dataset divided by phones rather than timesteps
%So, an answer array for this code would look something like this:

%For phones 0 100 h#; 100 200 sh; 200 300 axr, where we are only looking to identify sh
%[0 1 0]   <= Indicates if sh exists
%[1 0 1]   <= Indicates if sh does not exist

listing = dir('TEST');
listing1 = dir('TRAIN');

%CreateRNN
%Phone list
PhoneList = {'aa','ae','ah','ao','aw','ax','ax-h','axr','ay','b','bcl','ch','d','dcl','dh','dx','eh','el','em','en','eng','epi','er','ey','f','g','gcl','hh','hv','ih','ix','iy','jh','k','kcl','l','m','n','ng','nx','ow','oy','p','pau','pcl','q','r','s','sh','t','tcl','th','uh','uw','ux','v','w','y','z','zh'};


%Create Query and Answer Arrays
phone_cap = 1000;
sound_cap = 257;
OtherAnswer = zeros(61, phone_cap);
Answer = zeros(2, phone_cap);
OtherQuery = zeros(sound_cap, phone_cap);
current_phones = 0;

index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
done_index = 0;
length1 = length(listing);
while index <= length1
    listing2 = dir(fullfile('TRAIN',listing(index).name));
    length2 = length(listing2);
    disp(done_index);
    done_index = done_index + 1;
    while index1 <= length2
        listing3 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.phn'));
        listing4 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.wav'));
        length3 = length(listing3);
        while index2 <= length3
            ID = fopen(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing3(index2).name));
            file = textscan(ID, '%s');
            [y,Fs] = audioread(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing4(index2).name));
            
            %plot(Query);
            
            
            SPindex = 1;
            length4 = length(file{1});
            length5 = length(y);
            while index3 <= length4
                if current_phones >= phone_cap
                    break;
                end
                temp = file{1}{index3 + 2};
                
                if length5 < (str2double(file{1}{index3 + 1}) + 1)
                    Query = pyulear(y((str2double(file{1}{index3}) + 1):length5), 12,512,16000);  %FIX THISSSSSSS
                    Query = Query*10^8;
                else
                    Query = pyulear(y((str2double(file{1}{index3}) + 1):(str2double(file{1}{index3 + 1}) + 1)), 12,512,16000);  %FIX THISSSSSSS
                    Query = Query*10^8;
                end
                if strcmp(temp,'h#') == 0
                    value = find(ismember(PhoneList,temp));
                    OtherAnswer(value, current_phones + 1) = 1;
                else
                    OtherAnswer(61, current_phones + 1) = 1;
                end
                if strcmp(temp, 'sh') ~= 0
                    Answer(1, current_phones + 1) = 1;
                else
                    Answer(2, current_phones + 1) = 1;
                end
    
                
                if ((str2double(file{1}{index3 + 1}) + 1) - (str2double(file{1}{index3}) + 1)) <= sound_cap
                    for i = 1:257%(str2double(file{1}{index3}) + 1) : (str2double(file{1}{index3 + 1}))
                        
                        OtherQuery(SPindex, current_phones + 1) = Query(i);
                        

                        SPindex = SPindex + 1;
                    end
                else
                    for i = 1:257 %(str2double(file{1}{index3}) + 1) : (str2double(file{1}{index3}) + sound_cap)

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
net = train(net, OtherQuery, Answer);
