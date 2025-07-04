function newmatrix = onezerostandard( matrix );

[x1 x2 x3] = size( matrix );
for k = 1:x3;
    for nm = 1:x1
        
        matrix( nm,:,k )    = matrix( nm,:,k ) - (( min( matrix( nm,:,k ))) );
        matrix( nm,:,k )    = matrix( nm,:,k )+1e-3;
        newmatrix( nm,:,k ) = matrix( nm,:,k ) .* 1/max( matrix( nm,:,k ));
        
    end
end