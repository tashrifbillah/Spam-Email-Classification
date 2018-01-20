%%%%%%%%%%% Extraction of feature %%%%%%%%%%%%%

function TempX= feature_extraction(indices)

indices= sort(indices);

TempX= zeros(1899,1);

TempX(indices)= 1;


end