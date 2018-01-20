%%%%% Representing each email by a feature vector %%%%%%
% clear all;
% close all;
% clc;


Global_feature= [ ];
files= {'easy_ham', 'easy_ham_2', 'hard_ham', 'spam', 'spam_2'};
spam_flags= [0 0 0 1 1];
dir_length= [ ];


tic;

for j= 1:length(files)
    
    tic;
    Local_feature= [ ];    
    
    char(files(j))
    cd(char(files(j)));    

    L= length(dir)-3;
    dir_length= [dir_length L];
    
    cd ..    
    
    for i= 1:dir_length(j)
       
        email_name= [char(files(j)) '\' sprintf('%05d',i) '.txt'];
        
        indices= processEmail(readFile(email_name));       
        TempX= feature_extraction(indices);
        Local_feature= [Local_feature; TempX'];
        
        
    end
    
    Global_feature= [Global_feature; Local_feature];    
    save([char(files(j)) '_features.mat'], 'Local_feature');
    
    toc;
    
end

toc;

 save('All_email_features.mat','Global_feature');





