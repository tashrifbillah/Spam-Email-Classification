% Main file for soft margin SVM
% Calls all the sub routines

clc;
close all;
clear all;

tic;

error= [ ];

for rep= 1:5 % This model is run 5 times to validate average performance


% Professor's Data
% load('spamTest.mat');
% disp(['Number of emails in test data: ' num2str(length(ytest))]);
% disp('Spam ratio in test data: ');
% spam_test= sum(ytest)/length(ytest)
%  
% 
% load('spamTrain.mat');
% disp(['Number of emails in train data: ' num2str(length(y))]);
% disp('Spam ratio in train data: ');
% spam_train= sum(y)/length(y)


%% Choosing Training and Test Sets

ratio= 0.8;
[X, y, Xtest, ytest]= email_dataset(ratio);

y(y==0)= -1;
ytest(ytest==0)= -1;



%% Training Phase


[m, n]= size(X); 
I= eye(n);
E= ones(m,1);

C= 0.5;

cvx_begin
    
    variables w(n) b zeta(m)

    minimize (quad_form(w,I)/2 + C*E'*zeta)   
        
        y.*(X*w+b)-1+zeta >= 0;
        zeta >= 0;    
    
cvx_end
    



%% Test data classification

M= Xtest*w+b;

y_svm= zeros(length(ytest),1);

y_svm(M>=0)= 1;
y_svm(M<0)= -1;


%%

fprintf('\n\n');
disp('==========Test Data============');
  
disp('True classification rate of spam emails');
Tr= length(find(y_svm(ytest==1)==1))/length(find(ytest==1))
disp('False classification rate: given a non-spam email, it is classified as spam w.p.');
Fl= length(find(y_svm(ytest==-1)==1))/length(find(ytest==-1))


disp('True classification rate of non-spam emails');
Tr= length(find(y_svm(ytest==-1)==-1))/length(find(ytest==-1))
disp('False classification rate: given a spam email, it is classified as non-spam w.p.');
Fl= length(find(y_svm(ytest==1)==-11))/length(find(ytest==1))

disp('True classification rate of all emails');
Tr= length(find(y_svm==ytest))/length(ytest)
disp('False classification rate of all emails');
1-Tr


error= [error 1-Tr];

%% Train data classification 
M= X*w+b;
 
y_svm= zeros(length(y),1);

y_svm(M>=0)= 1;
y_svm(M<0)= -1;

y_svm(y_svm==0)= datasample([1 -1],1);



%% 

 
fprintf('\n\n');
disp('==========Train Data============');
  
disp('True classification rate of spam emails');
Tr= length(find(y_svm(y==1)==1))/length(find(y==1))
disp('False classification rate: given a non-spam email, it is classified as spam w.p.');
Fl= length(find(y_svm(y==-1)==1))/length(find(y==-1))


disp('True classification rate of non-spam emails');
Tr= length(find(y_svm(y==-1)==-1))/length(find(y==-1))
disp('False classification rate: given a spam email, it is classified as non-spam w.p.');
Fl= length(find(y_svm(y==1)==-11))/length(find(y==1))

disp('True classification rate of all emails');
Tr= length(find(y_svm==y))/length(y)
disp('False classification rate of all emails');
1-Tr


end

toc

disp(['Average accuracy: ', num2str(1-mean(error))]);
disp(['Average error: ', num2str(mean(error))]);




