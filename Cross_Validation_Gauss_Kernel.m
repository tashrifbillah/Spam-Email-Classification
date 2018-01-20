% Gauss Kernel Cross Validation
% C= [50 100];
% Sigma= [50 100];

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

for C= [50 100]

tic;

for Sigma= [50 100]

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

k

error= error+1-Tr;

end % Fold loop ends

error_record= [error_record error/fold];

if min_error> error/fold
    C
    Sigma
    min_error= error/fold;
end

end % Sigma loop ends

end % C loop ends

 



