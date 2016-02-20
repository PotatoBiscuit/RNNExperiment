listing = dir('TEST');
listing1 = dir('TRAIN');

%CreateRNN
%Phone list
PhoneList = {'aa','ae','ah','ao','aw','ax','ax-h','axr','ay','b','bcl','ch','d','dcl','dh','dx','eh','el','em','en','eng','epi','er','ey','f','g','gcl','hh','hv','ih','ix','iy','jh','k','kcl','l','m','n','ng','nx','ow','oy','p','pau','pcl','q','r','s','sh','t','tcl','th','uh','uw','ux','v','w','y','z','zh'};


%Create Query and Answer Arrays



index = 3;
index1 = 3;
index2 = 1;
index3 = 1;
while index <= length(listing)
    listing2 = dir(fullfile('TEST',listing(index).name));
    disp('Start listing');
    while index1 <= length(listing2)
        listing3 = dir(fullfile('TEST', listing(index).name, listing2(index1).name,'*.phn'));
        listing4 = dir(fullfile('TEST', listing(index).name, listing2(index1).name,'*.wav'));
        while index2 <= length(listing3)
            ID = fopen(fullfile('TEST', listing(index).name, listing2(index1).name, listing3(index2).name));
            file = textscan(ID, '%s');
            disp(fullfile('TEST', listing(index).name, listing2(index1).name, listing3(index2).name));
            [y,Fs] = audioread(fullfile('TEST', listing(index).name, listing2(index1).name, listing4(index2).name));
            Finish = str2double(file{1}{length(file{1}) - 1});
            if Finish == length(y)
                Finish = Finish - 1;
            end
            y = y.';
            Query = y(1:(Finish + 1));
            Answer = zeros(1,Finish + 1);
            
            
            value = 0;
            SPindex = 1;
            while index3 <= length(file{1})
                temp = file{1}{index3 + 2};
                if strcmp(temp,'h#') == 0
                    value = find(ismember(PhoneList,temp));
                end

                for i = (str2double(file{1}{index3}) + 1) : (str2double(file{1}{index3 + 1}) + 1)
                    %if strcmp(temp, 'sh') == 0
                    %    Answer(i) = 1;
                    %end
                    Answer(i) = value;


                end
    
                    


                value = 0;
                
                index3 = index3 + 3;
            end
            
            
            fclose(ID);
            lrn_net = train(lrn_net, con2seq(Query), con2seq(Answer));
            index3 = 1;
            index2 = index2 + 1;
        end
        
        
        index2 = 1;
        index1 = index1 + 1;
    end
    
    
    index1 = 3;
    index = index + 1;
end

clear ans current_phones file i ID index index1 index2 index3 listing listing1 listing2 listing3 listing4 max_phone phone_cap PhoneList Query sound_cap SPindex temp total_phones value y
