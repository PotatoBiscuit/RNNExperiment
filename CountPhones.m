listing = dir('TEST');
listing1 = dir('TRAIN');
total_phones = 0;
total_file = 0;
max_phone = 0;
index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
while index <= length(listing)
    listing2 = dir(fullfile('TEST',listing(index).name));
    while index1 <= length(listing2)
        listing3 = dir(fullfile('TEST', listing(index).name, listing2(index1).name,'*.phn'));
        while index2 <= length(listing3)
            ID = fopen(fullfile('TEST', listing(index).name, listing2(index1).name, listing3(index2).name));
            total_file = total_file + 1;
            file = textscan(ID, '%s');
            while index3 <= length(file{1})
                if max_phone < (str2double(file{1}{index3 + 1}) - str2double(file{1}{index3}))
                    disp(fullfile('TEST', listing(index).name, listing2(index1).name, listing3(index2).name));
                    max_phone = (str2double(file{1}{index3 + 1}) - str2double(file{1}{index3}));
                end
                total_phones = total_phones + 1;
                index3 = index3 + 3;
            end
            
            fclose(ID);
            index3 = 1;
            index2 = index2 + 1;
        end
        
        index2 = 1;
        index1 = index1 + 1;
    end
    
    index1 = 3;
    index = index + 1;
end

index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
while index <= length(listing1)
    listing2 = dir(fullfile('TRAIN',listing1(index).name));
    while index1 <= length(listing2)
        listing3 = dir(fullfile('TRAIN', listing1(index).name, listing2(index1).name,'*.phn'));
        while index2 <= length(listing3)
            ID = fopen(fullfile('TRAIN', listing1(index).name, listing2(index1).name, listing3(index2).name));
            file = textscan(ID, '%s');
            while index3 <= length(file{1})
                total_phones = total_phones + 1;
                index3 = index3 + 3;
            end
            
            fclose(ID);
            index3 = 1;
            index2 = index2 + 1;
        end
        
        index2 = 1;
        index1 = index1 + 1;
    end
    
    index1 = 3;
    index = index + 1;
end

clear ans file ID index index1 index2 index3 listing2 listing3;
