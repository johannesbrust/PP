%-------------------- test_dDisjunct -------------------------------------%
%
% Test for a d-disjunct matrix
%
%-------------------------------------------------------------------------%
% 02/24/22, J.B.,
function e =  test_dDisjunct(M,d)

[r,c] = size(M);

NCK = nchoosek(1:c,d);

od = ones(d,1);

% Error
e = 0;

for i=1:size(NCK,1)
   
    % All possible columns
    for j=1:c
        
        % If column is not contained in the linear combination
        if sum(NCK(i,:)==j)==0
           
            csB = (M(:,NCK(i,:))*od>0);
            cB = M(:,j)>0;
            
            if sum(cB > csB)==0
                e = 1;
                break;
            end              
            
        end
        if e==1; break; end;
        
    end        
    
end

end