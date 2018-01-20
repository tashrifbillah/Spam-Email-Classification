%%%%% Calls takeStep.m
%%%%% Returns to SMO_Main.m

function flag_examine= examineExample(i2)


    global tolerance C Sigma
    global I X y alp b Error

    flag_examine= 0;
    
    alph2= alp(i2);

    if ((alph2<tolerance) || (alph2>C-tolerance))
        tempe= I*X(i2,: );
        diff_from_all_svs= exp(-sum_square(X-tempe,2)/(2*Sigma^2));
        E2= sum(alp.*y.*diff_from_all_svs)- b- y(i2);
    else
        E2= Error(i2);
    end

    r2=E2*y(i2);
    
        
        
    if ((r2 < -tolerance) && (alph2<C)) || ((r2>tolerance) && (alph2 > 0))
        vio_indices= find(tolerance< alp <C-tolerance);

        if(~isempty(vio_indices)) && (E2>0)
            
            [~,i1]= max(Error);
            
            flag= takeStep(i1,i2,E2);
            if flag
                flag_examine= 1;
                return;
            end
            
            
        elseif (~isempty(vio_indices)) && (E2<0)
            [~,i1]= min(Error);
            
            flag= takeStep(i1,i2,E2);
            if flag
                flag_examine= 1;
                return;
            end
            
        end
    
        
        
        
       % Randomly loop over all non-zero and non-C alpha

        if (~isempty(vio_indices))
            startPoint= datasample(vio_indices,1);

            vio_indices=[vio_indices(startPoint:end)' vio_indices(1:startPoint-1)']';

                for i1= 1:length(vio_indices)

                    flag= takeStep(vio_indices(i1),i2,E2);
                    if flag
                        flag_examine= 1;
                        return;
                    end

                end
        end
    
    
    
      % Randomly loop over all lagrange multipliers
      
            for i1= 1:length(alp)
                
                flag= takeStep(i1,i2,E2);
                if flag
                    flag_examine= 1;
                    return;
                end
                
            end
            
            
    end
    
            
    
    
end
    
    
    
    
    