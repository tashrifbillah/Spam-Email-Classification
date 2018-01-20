% Cross validation to choose penalty for soft margin SVM
% 5 fold over each of C= [0.01 0.1 0.5 1 3 5 10 100 500 1000]

clc;
close all;
clear all;

tic;

load('All_email_features.mat');
N= length(Global_feature);
fold= 5;
chunk= N/fold;


error= [ ];
min_error= 10;

for C= [0.01 0.1 0.5 1 3 5 10 100 500 1000]

tic;
error= 0;

for k= 1:fold

X= [ ];
y= [ ];
    

Xtest= Global_feature((k-1)*chunk+1:k*chunk,: );
ytest= Global_label((k-1)*chunk+1:k*chunk);

X= [Global_feature(1:(k-1)*chunk,: ); Global_feature(k*chunk+1:end,: )];
y= [Global_label(1:(k-1)*chunk); Global_label(k*chunk+1:end)];



%%
[m, n]= size(X);

I= eye(n);
E= ones(m,1);


cvx_begin
    
    variables w(n) b zeta(m)

    minimize (quad_form(w,I)/2 + C*E'*zeta)   
        
        y.*(X*w+b)-1+zeta >= 0;
        zeta >= 0;    
    
cvx_end
    



%% Test data accuracy

M= Xtest*w+b;

y_svm= zeros(length(ytest),1);

y_svm(M>=0)= 1;
y_svm(M<0)= -1;


 %%

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
% Fl= length(find(y_svm(ytest==1)==-11))/length(find(ytest==1))

disp('True classification rate of all emails');
Tr= length(find(y_svm==ytest))/length(ytest)
disp('False classification rate of all emails');
1-Tr

k

error= [error 1-Tr];

end  % Validation loop ends

error= mean(error)

if error<min_error
    disp(C)
    min_error= error;
end

toc;


end % Cost loop ends


toc;



