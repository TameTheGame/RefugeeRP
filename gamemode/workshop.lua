
--If there was a thing in TacoScript that I considered tough to script.  Workshop is it.

function ParseItemString( mixstring )

	local scpos = string.find( mixstring, ":" );
	
	if( not scpos ) then return; end

	local name = string.sub( mixstring, 1, scpos - 1 );
	local count = string.sub( mixstring, scpos + 1 );
	
	return name, tonumber( count );

end

function DoesItemHaveIngredient( item, ingredient )

	if( TS.ItemMixtures[item] ) then
	
		for k, v in pairs( TS.ItemMixtures[item] ) do
		
			local name, count = ParseItemString( v );
			
			if( name == ingredient ) then
			
				return true;
			
			end
		
		end
	
	end
	
	return false;

end

function FindItemsWithIngredients( ingredienttable )

	local retvalue = { }
	
	--Loop through all possible item mixtures
	for k, v in pairs( TS.ItemMixtures ) do
	
		local hasingredients = true;
	
		--Loop through our ingredient table
		for i, o in pairs( ingredienttable ) do
			
			if( hasingredients and not DoesItemHaveIngredient( k, i ) ) then
			
				hasingredients = false;
			
			end
			
		end
		
		if( hasingredients ) then
		
			table.insert( retvalue, k );
		
		end
	
	end
	
	return retvalue;

end

function FindNumberOfIngredientInItem( item, ingredient )

	for k, v in pairs( TS.ItemMixtures[item] ) do
	
		local name, count = ParseItemString( v );
		
		if( name == item ) then
		
			return count;
		
		end
	
	end

	return 0;

end

function CompareIngredientCount( items, ingredienttable )

	local retval = { }

	--Loop through the table of items; value is the item name
	for k, v in pairs( items ) do
	
		local sufficient = true;
	
		--Loop through our ingredients
		for n, m in pairs( ingredienttable ) do
		
			if( sufficient ) then
		
				local minnum = FindNumberOfIngredientInItem( v, n );
				local wehave = m;
				
				if( wehave >= minnum ) then
				
					--This ingredient is sufficient!
				
				else
				
					sufficient = false;
				
				end
				
			end
		
		end
		
		if( sufficient ) then
		
			table.insert( retval, v );
		
		end
	
	end
	
	return retval;

end

function FindItemTotalIngredientCount( item )

	local total = 0;

	for k, v in pairs( TS.ItemMixtures[item] ) do
	
		local _, count = ParseItemString( v );
		
		total = count + total;
	
	end

	return total;

end

function GetItemWithLeastIngredients( items ) 

	local least = nil;

	for k, v in pairs( items ) do
	
		if( not least ) then
		
			least = v;
		
		else
		
			if( FindItemTotalIngredientCount( v ) < FindItemTotalIngredientCount( least ) ) then
			
				least = v;
			
			end
		
		end
	
	end
	
	return least;

end

--ingredienttable: Table[ingredient_item] = ingredient_count

function TS.MixItems( ingredienttable )

	local possibleitems = FindItemsWithIngredients( ingredienttable );
	possibleitems = CompareIngredientCount( possibleitems, ingredienttable );
	
	-- We should now have a table of items that can be created. 
	
	-- No item to make.
	if( #possibleitems < 1 ) then
	
		return;
	
	end
	
	--We have our item!
	local item = GetItemWithLeastIngredients( possibleitems );
	
end

--[[
function IsGoodMixture( item, arg )

	for k, v in pairs( arg ) do
	
		local hasingred = false;
	
		for n, m in pairs( TS.ItemMixtures[item] ) do
		
			if( not hasingred and string.sub( m, 1, string.find( m, ":" ) - 1 ) == string.sub( v, 1, string.find( v, ":" ) - 1 ) ) then
			
				hasingred = true;	
			
			end
		
		end
		
		if( not hasingred ) then
		
			return false;
			
		end
	
	end
	
	return true;

end

function FindPossibleMixtures( arg )

	local possitems = { }

	for k, v in pairs( TS.ItemMixtures ) do
	
		if( IsGoodMixture( k, arg ) ) then
			table.insert( possitems, k );
		end
	
	end
	
	return possitems;

end

function GetNumberOfIngredients( item )

	local row = TS.ItemMixtures[item];
	local n = 0;
	
	for k, v in pairs( row ) do
	
		local amt = tonumber( string.sub( v, string.find( v, ":" ) + 1 ) );
	
		n = n + amt;
	
	end
	
	return n;

end

function MixtureCanMake( item, arg )

	local row = TS.ItemMixtures[item];
	
	for k, v in pairs( row ) do
	
		local rname = string.sub( v, 1, string.find( v, ":" ) - 1 );
	
		for n, m in pairs( arg ) do
		
			local aname = string.sub( m, 1, string.find( m, ":" ) - 1 );
		
			if( rname == aname ) then
			
				local rn = tonumber( string.sub( v, string.find( v, ":" ) + 1 ) );
				local an = tonumber( string.sub( m, string.find( m, ":" ) + 1 ) );
				
				if( an < rn ) then
					return false;
				end
				
			end
		
		end
	
	end

	return true;

end

function FindBestMixture( arg )

	local possitems = FindPossibleMixtures( arg );
	local stable = { }	
	local index = { }
	
	for k, v in pairs( possitems ) do
		table.insert( stable, GetNumberOfIngredients( v ) );
		index[#stable] = v;
	end
	
	table.sort( stable );
	
	for k, v in pairs( mixtable ) do
	
		if( MixtureCanMake( index[k], arg ) ) then
		
			return k;
		
		end
	
	end
	
	return "";

end

]]--