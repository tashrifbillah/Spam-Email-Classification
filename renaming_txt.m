%%%% Renaming all the files at once


clc;
close all;
clear all;

files= {'easy_ham', 'easy_ham_2', 'hard_ham', 'spam', 'spam_2'};

tic;

for j= 1:length(files)

    cd(char(files(j)));    

    Names= dir;
    L= length(Names)


    for i= 3:L-1

       new_name= [Names(i).name(1:5) '.txt'];
       movefile(Names(i).name, new_name);

    end


    cd ..

end

toc