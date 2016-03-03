%This is the version of PatternNet that will train on an audio file by timestep, rather than phone type
%For example, in this code, a time step of 50 is used so that 50 frames of an audio file are evaluated at a time

%This is what the answer table may look like for two phones like 0 100 h# and 100 200 sh where we are training the Neural Network for h#
%[1 1 0 0]  <= row indicating if there is an h#
%[0 0 1 1]  <= row indicating if there is no h#

listing = dir('TEST');
listing1 = dir('TRAIN');


%Phone list
PhoneList = {'aa','ae','ah','ao','aw','ax','ax-h','axr','ay','b','bcl','ch','d','dcl','dh','dx','eh','el','em','en','eng','epi','er','ey','f','g','gcl','hh','hv','ih','ix','iy','jh','k','kcl','l','m','n','ng','nx','ow','oy','p','pau','pcl','q','r','s','sh','t','tcl','th','uh','uw','ux','v','w','y','z','zh'};


%Create Query and Answer Arrays
phone_cap = 10000;
sound_cap = 257;
timestep = 50;
Answer = zeros(2, phone_cap);
OtherQuery = zeros(sound_cap, phone_cap);
current_phones = 0;

index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
file_index = 1;
length1 = length(listing);

while index <= length1
    listing2 = dir(fullfile('TRAIN',listing(index).name));
    length2 = length(listing2);
    while index1 <= length2
        listing3 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.phn'));
        listing4 = dir(fullfile('TRAIN', listing(index).name, listing2(index1).name,'*.wav'));
        length3 = length(listing3);
        while index2 <= length3
            ID = fopen(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing3(index2).name));
            file = textscan(ID, '%s');
            [y,Fs] = audioread(fullfile('TRAIN', listing(index).name, listing2(index1).name, listing4(index2).name));
            
            SPIndex = 1;
            length5 = length(y);
            length4 = length(file{1});
            while (index3 + timestep) <= (length5 - 1) && file_index <= length4
                if current_phones >= phone_cap
                    break;
                end
                Query = pyulear(y(index3:(index3 + timestep)),8,512,16000); %there used to be a model order of 12
                Query = Query * 10^8;
                
                if strcmp(file{1}{file_index + 2}, 'h#') ~= 0
                    Answer(1, current_phones + 1) = 1;
                else
                    Answer(2, current_phones + 1) = 1;
                end
                
                for i = 1:257
                    OtherQuery(SPIndex, current_phones + 1) = Query(i);
                    SPIndex = SPIndex + 1;
                end
                
                SPIndex = 1;
                current_phones = current_phones + 1;
                index3 = index3 + timestep;
                
                if index3 >= str2double(file{1}{file_index + 1})
                    file_index = file_index + 3;
                end
            end
            
            if current_phones >= phone_cap
                break;
            end
            fclose(ID);
            
            index3 = 1;
            file_index = 1;
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


clear ans current_phones file i ID index index1 index2 index3 listing listing1 listing2 listing3 listing4 max_phone phone_cap PhoneList Query sound_cap temp total_phones value y length1 length2 length3 length4 length5 SPIndex

net = patternnet(200);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.epochs = 100;
net = train(net, OtherQuery, Answer);
