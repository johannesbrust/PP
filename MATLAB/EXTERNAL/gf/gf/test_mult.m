%---------------------- test_mult -----------------------------------------
%
% Testing the multiplicty of a co-ocurrence
%
% Assumes that M is a matrix with (0,1) entries
%--------------------------------------------------------------------------
% 01/11/21, J.B.

% Testing
[M1,N] = size(M);

error = 0;
for i=1:M1
    for j=i+1:M1
        inter = intersect(find(M(i,:)),find(M(j,:)));
        if length(inter)>1
            error=1;
            break;
        end
    end
end