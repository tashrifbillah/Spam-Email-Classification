%%%%% Creation of train and test data

function [Train_feature, Train_label, Test_feature, Test_label]= email_dataset(train_ratio)

Train_feature= [ ];
Train_label= [ ];
Test_feature= [ ];
Test_label= [ ];

files= {'easy_ham', 'spam', 'easy_ham_2', 'spam_2', 'hard_ham'};
feature_set= strcat(files, '_features.mat');
spam_flags= [0 1 0 1 0];
dir_length= [2500 500 1400 1400 250];

% train_ratio= 0.8;
% test_ratio= 0.2;


for j= 1:length(files)
      
    load(char(feature_set(j)));
    
    [train_indices,~,test_indices]= dividerand(dir_length(j),train_ratio,0,1-train_ratio);
    
    train_indices= sort(train_indices);
    test_indices= sort(test_indices);
    
    
    TempX= Local_feature(train_indices,: );
    Train_feature= [Train_feature; TempX];
    Train_label= [Train_label; spam_flags(j)*ones(size(TempX,1),1)];
    
    TempX= Local_feature(test_indices,: );
    Test_feature= [Test_feature; TempX];
    Test_label= [Test_label; spam_flags(j)*ones(size(TempX,1),1)];
    


end



end


