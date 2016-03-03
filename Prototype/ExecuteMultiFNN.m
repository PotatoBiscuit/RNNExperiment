% Make Directory 
mkdir('FNNSoundFiles');

fprintf('Directory created: FNNSoundFiles \n');

% First File
fileID = fopen('FNNSoundFiles/SoundFile.phn_1','w');
fprintf(fileID, '0 1000 h#\n');
fprintf(fileID, '1000 2000 sh\n');
fprintf(fileID, '2000 3000 sh\n');
fprintf(fileID, '3000 4000 sh\n');
fclose(fileID);

% Second File

fileID = fopen('FNNSoundFiles/SoundFile.phn_2','w');
fprintf(fileID, '4000 5000 sh\n');
fprintf(fileID, '5000 6000 sh\n');
fprintf(fileID, '6000 7000 sh\n');
fprintf(fileID, '7000 8000 sh\n');
fprintf(fileID, '8000 9000 sh\n');
fprintf(fileID, '9000 10000 sh\n');
fclose(fileID);


% Third File

fileID = fopen('FNNSoundFiles/SoundFile.phn_3','w');
fprintf(fileID, '9000 10000 sh\n');
fprintf(fileID, '10000 11000 sh\n');
fprintf(fileID, '11000 12000 sh\n');
fprintf(fileID, '12000 13000 sh\n');
fprintf(fileID, '13000 14000 h#\n');
fclose(fileID);

fprintf('Directory and contents have been created');
