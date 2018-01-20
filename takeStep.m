%%%% Returns to examineExample.m

function flag_take= takeStep(i1,i2,E2)


            global epsilon tolerance C Sigma
            global I X y alp b Error D
            
            KER= @(u,v) exp(-sum_square(u- v)/(2*Sigma^2));


            if i1==i2
                flag_take= 0;
                return ;
            end   


            
            if ((alp(i1)<tolerance) || (alp(i1)> C-tolerance))

                tempe= I*X(i1,: );
                diff_from_all_svs= exp(-sum_square(X-tempe,2)/(2*Sigma^2));
                E1= sum(alp.*y.*diff_from_all_svs)- b- y(i1);

            else

                E1= Error(i1);

            end

    
          alpi1_prev = alp(i1);
          alpi2_prev = alp(i2);
          s= y(i1)*y(i2);

          % Finding L and H          
          if y(i1)==y(i2)               
              L = max(0, alp(i1)+alp(i2)-C);
              H = min(C, alp(i1)+alp(i2));
          else
              L = max(0, alp(i2)-alp(i1));
              H = min(C, C+alp(i2)-alp(i1));
          end

          % Condition checking  
          if H==L
              flag_take= 0;
              return;                         
          end

          
          
          k11= KER(X(i1,:),X(i1,:));
          k12= KER(X(i1,:),X(i2,:));
          k22= KER(X(i2,:),X(i2,:));

          % Finding eta
          eta = k11+k22- 2*k12;
          if eta > 0                      
              alp(i2) = s*(E1-E2)/eta;

              if alp(i2)<L
                  alp(i2)= L;
              elseif alp(i2)>H
                  alp(i2)= H;
              end

          else

              f1= y(i1)*(E1+b)-alp(i1)*k11-s*alp(i2)*k12;
              f2= y(i2)*(E2+b)-alp(i2)*k22-s*alp(i1)*k12;

              L1= alpi1_prev+ s*(alpi2_prev- L);
              H1= alpi1_prev+ s*(alpi2_prev- H);
             
              Lobj= L1*f1+ L*f2+ 0.5*L1^2*k11+ 0.5*L^2*k22+ s*L*L1*k12;
              Hobj= H1*f1+ H*f2+ 0.5*H1^2*k11+ 0.5*H^2*k22+ s*H*H1*k12;  

%               c1= eta/2;
%               c2= y(i2)*(E1-E2)- eta*alpi2_prev;
%                 
%               Lobj= c1*L^2+ c2*L;
%               Hobj= c1*H^2+ c2*H;

              if Lobj< Hobj-epsilon
                  alp(i2)= L;
              elseif Lobj> Hobj+epsilon
                  alp(i2)= H;              
              end
              

          end
          
          

          % Condition checking
          if abs(alpi2_prev-alp(i2)) < epsilon*(alpi2_prev+ alp(i2)+epsilon)                          
              flag_take= 0;
              return;                          
          end

          alp(i1) = alp(i1) + y(i1)*y(i2)*(alpi2_prev-alp(i2));

                    
          % Updating threshold b
          temp1= y(i1)*(alp(i1)-alpi1_prev)*k11+ y(i2)*(alp(i2)-alpi2_prev)*k12;
          temp2= y(i1)*(alp(i1)-alpi1_prev)*k12+ y(i2)*(alp(i2)-alpi2_prev)*k22;
          b1 = E1+ temp1+ b;
          b2 = E2+ temp2+ b;
          
          
          b_prev= b;
          
          if 0< alp(i1) < C
              b = b1;
          elseif 0< alp(i2) < C
              b = b2;
          else
              b = (b1+b2)/2;
          end
                              
         
          
          % Updating error cache         
          
          Error= Error+ y(i1)*(alp(i1)-alpi1_prev)*D(i1,:)'+ y(i2)*(alp(i2)- alpi2_prev)*D(i2,:)'+ b_prev- b;
          Error(i1)= 0;
          Error(i2)= 0;


          disp('Executing');
          flag_take= 1;
          return ;       



end

   
      
      


   
   