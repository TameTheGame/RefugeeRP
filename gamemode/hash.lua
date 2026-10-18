
TS.HashTable = { }
TS.InvHashTable = { }
TS.HashKeys = { }

function AddHashKey( key, trans )

	for k, v in pairs( TS.HashTable ) do
	
		if( v == trans ) then
		
			Msg( trans .. " is already being used for " .. k .. " but is also being applied to " .. key .. "\n" );
			return;
			
		end		
	
	end

	TS.HashTable[key] = trans;
	TS.InvHashTable[trans] = key;
	
	table.insert( TS.HashKeys, key );

end

AddHashKey( "a", "3" );
AddHashKey( "b", "2" );
AddHashKey( "c", "4" );
AddHashKey( "d", "8" );
AddHashKey( "e", "7" );
AddHashKey( "f", "9" );
AddHashKey( "g", "0" );
AddHashKey( "h", "1" );
AddHashKey( "i", "5" );
AddHashKey( "j", "6" );
AddHashKey( "k", "b" );
AddHashKey( "l", "D" );
AddHashKey( "m", "l" );
AddHashKey( "n", "Q" );
AddHashKey( "o", "L" );
AddHashKey( "p", "w" );
AddHashKey( "q", "I" );
AddHashKey( "r", "Y" );
AddHashKey( "s", "u" );
AddHashKey( "t", "U" );
AddHashKey( "u", "m" );
AddHashKey( "v", "T" );
AddHashKey( "w", "X" );
AddHashKey( "x", "c" );
AddHashKey( "y", "A" );
AddHashKey( "z", "e" );

AddHashKey( "A", "i" );
AddHashKey( "B", "O" );
AddHashKey( "C", "h" );
AddHashKey( "D", "R" );
AddHashKey( "E", "x" );
AddHashKey( "F", "n" );
AddHashKey( "G", "M" );
AddHashKey( "H", "o" );
AddHashKey( "I", "P" );
AddHashKey( "J", "W" );
AddHashKey( "K", "B" );
AddHashKey( "L", "C" );
AddHashKey( "M", "q" );
AddHashKey( "N", "g" );
AddHashKey( "O", "F" );
AddHashKey( "P", "s" );
AddHashKey( "Q", "d" );
AddHashKey( "R", "V" );
AddHashKey( "S", "k" );
AddHashKey( "T", "v" );
AddHashKey( "U", "E" );
AddHashKey( "V", "S" );
AddHashKey( "W", "N" );
AddHashKey( "X", "t" );
AddHashKey( "Y", "f" );
AddHashKey( "Z", "K" );

AddHashKey( "0", "r" );
AddHashKey( "1", "y" );
AddHashKey( "2", "Z" );
AddHashKey( "3", "p" );
AddHashKey( "4", "a" );
AddHashKey( "5", "G" );
AddHashKey( "6", "H" );
AddHashKey( "7", "J" );
AddHashKey( "8", "z" );
AddHashKey( "9", "j" );

AddHashKey( " ", "&" );

function TS.Hashify( str, size )

	size = size or 50;
	size = size - string.len( str );

	local strtbl = { }
	
	for n = 1, string.len( str ) do
	
		table.insert( strtbl, string.sub( str, n, n ) );
	
	end
	
	local newstr = "";

	local prestring = "";
	
	if( size < 10 ) then
	
		prestring = TS.HashTable["0"] .. TS.HashTable[tostring( size )];
	
	else
	
		local d1 = string.sub( tostring( size ), 1, 1 );
		local d2 = string.sub( tostring( size ), 2, 2 );
		
		prestring = TS.HashTable[d1] .. TS.HashTable[d2];
	
	end

	prestring = prestring .. TS.HashTable["S"];
	
	for n = 1, size do
	
		prestring = prestring .. TS.HashTable[TS.HashKeys[math.random( 1, #TS.HashKeys )]];
	
	end

	for k, v in pairs( strtbl ) do
	
		newstr = newstr .. ( TS.HashTable[strtbl[k]] or strtbl[k] );
	
	end
	
	newstr = prestring .. newstr;
	
	return newstr;

end

function TS.UnHashify( str )

	local p = string.find( str, TS.HashTable["S"] ) - 1;
	local sizestr = string.sub( str, 1, p );
	local d1 = TS.InvHashTable[string.sub( sizestr, 1, 1 )];
	local d2 = TS.InvHashTable[string.sub( sizestr, 2, 2 )];
	sizestr = d1 .. d2;
	
	local size = tonumber( sizestr ) + 4;
	
	str = string.sub( str, size );
	
	local strtbl = { }
	
	for n = 1, string.len( str ) do
	
		table.insert( strtbl, string.sub( str, n, n ) );
	
	end
	
	local newstr = "";
	
	for k, v in pairs( strtbl ) do
	
		newstr = newstr .. ( TS.InvHashTable[strtbl[k]] or strtbl[k] );
	
	end
	
	return newstr;

end
