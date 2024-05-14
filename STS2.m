function x = STS2( x,sp );

[x1 x2 x3] = size( x );

x = permute( x,[2 1 3]);
d = (triu( ones( x2 ),-sp )+tril( ones( x2 ),sp ))-1;

for t = 1:x3;
    x( :,:,t ) = (d*x( :,:,t ));
end
x = permute( x,[2 1 3]);