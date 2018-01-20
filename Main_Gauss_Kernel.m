% Main file for Gaussian Kernel SVM
% Calls all the sub routines

clc;
close all;
clear all;

% Professor's data
% load('spamTest.mat');
% disp(['Number of emails in test data: ' num2str(length(ytest))]);
% disp('Spam ratio in test data: ');
% spam_test= sum(ytest)/length(ytest)
% 
% load('spamTrain.mat');
% disp(['Number of emails in train data: ' num2str(length(y))]);
% disp('Spam ratio in train data: ');
% spam_train= sum(y)/length(y)


% etest= [ ];
% etrain= [ ];

%% Choosing Test and Training Sets

ratio= 0.8;
[X, y, Xtest, ytest]= email_dataset(ratio);

y(y==0)= -1;
ytest(ytest==0)= -1;


%% Training Phase

[m, n]= size(X); 
I= eye(m);
E= ones(m,1);

Sigma= 100;
M= sum_square(X,2);
D= exp(-(M*E'+E*M'-2*(X*X'))/(2*Sigma^2));
C= 50;

cvx_begin

    cvx_precision best    
    variable alp(m)
    minimize (0.5*(alp'*(y*y'.*D)*alp) - E'*alp)
        
        alp >= 0;
        alp <= C;
        alp'*y == 0;
            
cvx_end
    

%% Finding b

w= (alp.*y)'*X;
Tempb= E*w;

Mb= exp(-sum_square(X-Tempb,2)/(2*Sigma^2));

cvx_begin

    variables bb(m)
    
    minimize 0

        alp.*(y.*(Mb+bb)-1)==0;
        
cvx_end

b= mean(bb);


%% Test data classification

y_svm= zeros(length(ytest),1);

for i= 1:length(ytest)
    
    Temp= E*Xtest(i,: );
    
    diff_from_all_svs= exp(-sum_square(X- Temp,2)/(2*Sigma^2));
    
    f_x= sum(alp.*y.*diff_from_all_svs)+b;
    
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


% etest= [etest 1-Tr];
 

%% Train data classification

y_svm= zeros(length(y),1);

for i= 1:length(y)
    
    Temp= E*X(i,: );
    
    diff_from_all_svs= exp(-sum_square(X- Temp,2)/(2*Sigma^2));
    
    f_x= sum(alp.*y.*diff_from_all_svs)+b;
    
    y_svm(i)= 1*(f_x>=0)-1*(f_x<0);
    

end


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


% etrain= [etrain 1-Tr];

%% The following commands can be used to test the above model 

% save('Gauss_Kernel_1.mat','C','Sigma','alp','b','X','y');
% SVM_Model_Test('Gauss_Kernel_1.mat');



