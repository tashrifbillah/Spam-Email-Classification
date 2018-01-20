% Polynomial Kernel Cross Validation
% C= [10 50 100];
% p= [2 3];

clc;
close all;
clear all;

tic;

load('All_email_features.mat');
N= length(Global_feature);
fold= 3;
chunk= floor(N/fold);


min_error= 100;
error_record= [ ];

for C= [10 50 100]

tic;

for p= [2 3]

error= 0;

for k= 1:fold

X= [ ];
y= [ ];

Xtest= Global_feature((k-1)*chunk+1:k*chunk,: );
ytest= Global_label((k-1)*chunk+1:k*chunk);

X= [Global_feature(1:(k-1)*chunk,: ); Global_feature(k*chunk+1:end,: )];
y= [Global_label(1:(k-1)*chunk); Global_label(k*chunk+1:end)];


%% Training Phase

[m, n]= size(X); 

pairwise_product= (X*X'+1).^p; 
I= eye(m);
E= ones(m,1);


cvx_begin
    
    cvx_precision best
    variable alp(m)

    minimize (0.5*(alp'*(y*y'.*pairwise_product)*alp) - E'*alp) 
        
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


%% Test Phase


y_svm= zeros(length(ytest),1);

for i= 1:length(ytest)
        
    prod_with_all_svs= (X*Xtest(i,: )'+1).^p;
    
    f_x= sum(alp.*y.*prod_with_all_svs)+b;
    
    y_svm(i)= 1*(f_x>=0)-1*(f_x<0);
    

end




%% Results


% fprintf('\n\n');
% disp('==========Test Data============');
%   
% disp('True classification rate of spam emails');
% Tr= length(find(y_svm(ytest==1)==1))/length(find(ytest==1))
% disp('False classification rate: given a non-spam email, it is classified as spam w.p.');
% Fl= length(find(y_svm(ytest==-1)==1))/length(find(ytest==-1))
% 
% 
% disp('True classification rate of non-spam emails');
% Tr= length(find(y_svm(ytest==-1)==-1))/length(find(ytest==-1))
% disp('False classification rate: given a spam email, it is classified as non-spam w.p.');
% Fl= length(find(y_svm(ytest==1)==-1))/length(find(ytest==1))

disp('True classification rate of all emails');
Tr= length(find(y_svm==ytest))/length(ytest)
disp('False classification rate of all emails');
1-Tr


error= error+1-Tr;

end % Fold loop ends

error_record= [error_record error/fold];

if min_error> error/fold
    C
    p
    min_error= error/fold;
end

end % p loop ends

end % C loop ends

 



