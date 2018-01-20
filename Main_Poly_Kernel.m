% Main file for Polynomial Kernel
% Calls all the sub routines

clc;
close all;
clear all;

% load('spamTest.mat');
% disp(['Number of emails in test data: ' num2str(length(ytest))]);
% disp('Spam ratio in test data: ');
% spam_test= sum(ytest)/length(ytest)
% 

% load('spamTrain.mat');
% disp(['Number of emails in train data: ' num2str(length(y))]);
% disp('Spam ratio in train data: ');
% spam_train= sum(y)/length(y)


%% Choosing Test and Training Sets

ratio= 0.2;
[X, y, Xtest, ytest]= email_dataset(ratio);

y(y==0)= -1;
ytest(ytest==0)= -1;



%% Training Phase

[m, n]= size(X); 
p= 3;

pairwise_product= (X*X'+1).^p; 
I= eye(m);
E= ones(m,1);
C= 10;


cvx_begin
    
    cvx_precision best
    variable alp(m)

    minimize (0.5*(alp'*(y*y'.*pairwise_product)*alp) - E'*alp) % (0.5*(alp.*y)'*pairwise_product*(alp.*y)-E'*alp)
        
        alp >= 0;
        alp <= C;
        alp'*y == 0;
        
                   
cvx_end
    

%% Finding b

w= (alp.*y)'*X;
Mb= (X*w'+1).^p;

cvx_begin
    variable bb(m)
    
    minimize 0

        alp.*(y.*(Mb+bb)-1)==0;

cvx_end

b= mean(bb);


%% Test data classification


y_svm= zeros(length(ytest),1);

for i= 1:length(ytest)
        
    prod_with_all_svs= (X*Xtest(i,: )'+1).^p;
    
    f_x= sum(alp.*y.*prod_with_all_svs)+b;
    
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


%% Train data classification

y_svm= zeros(length(y),1);

for i= 1:length(y)
        
    prod_with_all_svs= (X*X(i,: )'+1).^p;
    
    f_x= sum(alp.*y.*prod_with_all_svs)+b;
    
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
 


% save('Poly_Kernel_1.mat','C','alp','b','X','y','p');


