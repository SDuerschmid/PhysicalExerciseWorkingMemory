function waitingasterisks( idx,mrun )

if ismember( idx/100,1:mrun ) == 1;
    fprintf( '%i\n',idx )
else
    fprintf( '*' )
end
