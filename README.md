# Spam-Email-Classification
The project aims to classify spam and non-spam emails from [Spam Assasin Database](http://spamassassin.apache.org/index.html).
The learning object was to familiarize with CVX toolbox on MATLAB and coding SVM optimization problem from scratch. 
[CVX toolbox](http://cvxr.com/cvx/) on MATLAB is needed to run the code. However, the work can be divided into three steps-

    1. Feature Extraction
    2. Email Classification
    3. Parameter Tuning

The steps are briefly elaborated below. However, please see the 
[project report](https://github.com/tashrifbillah/Spam-Email-Classification/blob/master/Spam%20Email%20Classification%20Project.pdf)
for detailed description.

# 1. Feature Extraction
Call the function [email_representation.m](https://github.com/tashrifbillah/Spam-Email-Classification/blob/master/email_representation.m)

The database of comes with 6,050 emails with a spam ratio of 30%. Firstly, all the emails are renamed as .txt file
using rename.m code. After all the files are accessible, a feature
vector is extracted for each email while the feature label is 1 for spam emails and 0 for non-spam emails.

For this task, processEmail.m is called with each email. It then stems the words in that email calling
porterStemmer.m following the normalization procedure given in the problem description. It then
compares each stemmed word with dictionary words in vocabList.txt file. There are 1899 words
in the dictionary. The initial feature vector is a column of zeros. If a word from the dictionary
appears in the email, the corresponding feature vector is set to 1 and 0 otherwise. Thereby, each
email is represented by 1899x1 feature vector.

# 2. Email Classification
Call the function [Main_Soft_Margin.m](https://github.com/tashrifbillah/Spam-Email-Classification/blob/master/Main_Soft_Margin.m)

The main function implements [soft margin SVM](http://www.di.ens.fr/~mallat/papiers/svmtutorial.pdf) for the classification purpose.
Example feature sets are provided for testing which are all the files with .mat extension.
However, you can make the feature set from scratch following the method described above.

In line 29 of Main_Soft_Margin.m, the mutually exclusive train to test data ratio is set to 0.8. Feel free to vary it in [0.7, 0.9]
to observe the performance of the algorithm. The code will run 5 times to give the user an idea about the algorithm performance.
Each iteration should take ~5 minutes. At the end of each iteration, the classification result is displayed on the MATLAB command window. The total running time should be ~25 minutes. Feel free to try out other Kernel SVMs also.

# 3. Parameter Tuning
The C, Sigma, and p parameters are adjusted through cross validation when using different Kernels. Feel free to play around with
provided functions that start with Cross_Validation_ to get a better result.
