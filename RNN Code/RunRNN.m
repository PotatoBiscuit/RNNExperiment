%Phone list
PhoneList = {'aa','ae','ah','ao','aw','ax','ax-h','axr','ay','b','bcl','ch','d','dcl','dh','dx','eh','el','em','en','eng','epi','er','ey','f','g','gcl','hh','hv','ih','ix','iy','jh','k','kcl','l','m','n','ng','nx','ow','oy','p','pau','pcl','q','r','s','sh','t','tcl','th','uh','uw','ux','v','w','y','z','zh'};

%Make sure your TEST and TRAIN folders are in the same directory as this
%.m file. This code retrieves a text file and sound file
ID = fopen(fullfile('TRAIN','DR1','FCJF0','SA1.phn'));
[y,Fs] = audioread(fullfile('TRAIN','DR1','FCJF0','SA1.wav'));

%Gather info from text file
file = textscan(ID, '%s');
Finish = str2double(file{1}{length(file{1}) - 1});
y = y.';

%Create Query and Answer Arrays
Query = y(1:(Finish + 1));
Answer = zeros(1,Finish + 1);

%Throw values into Answer Array (h# = -1, Other phones have values denoted
%by their index e.g. aa = 1 ae = 2)
index = 1;
value = -1;
while index < length(file{1})
    temp = file{1}{index + 2};
    if strcmp(temp,'h#') == 0
        value = find(ismember(PhoneList,temp));
    end
    
    for i = (str2double(file{1}{index}) + 1) : (str2double(file{1}{index + 1}) + 1)
        Answer(i) = value;
    end
    value = -1;
    index = index + 3;
end

%Grab a small part of the query and answer arrays. The RNN can't handle too
%much info for some reason.
PreppedQuery = con2seq(Query(3051:5724));
PreppedAnswer = con2seq(Answer(3051:5724));
%Train RNN
lrn_net = train(lrn_net,PreppedQuery,PreppedAnswer);

%Test RNN and display error
yp = sim(lrn_net,PreppedQuery);
plotresponse(PreppedAnswer,yp);