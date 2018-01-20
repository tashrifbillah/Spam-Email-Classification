%%%%% Fits trained parameters over an arbitrary test data
%%%%% Calculates average error
%%%%% Gaussian Kernel


function [ ]= SVM_Model_Test(FileName)


load(FileName);
[m, n]= size(X); 
I= ones(m,1);

error= [ ];

for rep= 1:5
    
ratio= 0.8;
[~, ~, Xtest, ytest]= email_dataset(ratio);

% y(y==0)= -1;
ytest(ytest==0)= -1;



%% Test data classification

y_svm= zeros(length(ytest),1);

for i= 1:length(ytest)
    
    Temp= I*Xtest(i,: );
    
    diff_from_all_svs= exp(-sum_square(X- Temp,2)/(2*Sigma^2));
    
    f_x= sum(alp.*y.*diff_from_all_svs)-b;
    
    y_svm(i)= 1*(f_x>=0)-1*(f_x<0);
    

end




fprintf('\n\n');
disp('==========Test Data============');
  
disp('True classification rate of spam emails');
Tr= length(find(y_svm(ytest==1)==1))/length(find(ytest==1))
disp('False classification rate: given a non-spam email, it is classified as spam w.p.');
Fl= length(find(y_svm(ytest==-1)==1))/length(find(ytest==-1))


disp('True classification rate of non-spam emails');
Tr= length(find(y_svm(ytest==-1)==-1))/length(find(ytest==-1))
disp('False classification rate: given a spam email, it is classified as non-spam w.p.');
Fl= length(find(y_svm(ytest==1)==-1))/length(find(ytest==1))

disp('True classification rate of all emails');
Tr= length(find(y_svm==ytest))/length(ytest)
disp('False classification rate of all emails');
1-Tr


error= [error 1-Tr];



end

disp(FileName);
disp(['Average accuracy: ', num2str(1-mean(error))]);
disp(['Average error: ', num2str(mean(error))]);


end

