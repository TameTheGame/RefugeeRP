


function FormatLine( str, font, size, debug )

	local strtable = string.Explode( " ", str );
	local width = 0;	
	
	local newstr = "";
	local n = 0;
	
	surface.SetFont( font );
	
	for k, v in pairs( strtable ) do
	
		local w, h = surface.GetTextSize( v .. " " );
		
		width = width + w;

		if( string.find( v, "\n" ) ) then

			newstr = newstr .. v .. " ";

			width = 0;
			n = n + 1;		

		elseif( width >= size ) then

			newstr = newstr .. "\n" .. v .. " ";

			width = 0;
			n = n + 1;
			
		else
		
			newstr = newstr .. v .. " ";
	
		end
	
	end

	return newstr, n;

end

function Waxx()

	if( GetGlobalInt( "waxx" ) == 1 ) then return true; end
	
	return false;

end

if( CLIENT ) then
	TS = { }
end

function TS.GetBusinessInt( name, valname )

	return GetGlobalInt( "business." .. name .. "." .. valname ) or 0;

end

function TS.SetBusinessInt( name, valname, val )

	SetGlobalInt( "business." .. name .. "." .. valname, val );

end

function TS.SetBusinessFloat( name, valname, val )

	SetGlobalFloat( "business." .. name .. "." .. valname, val );

end

function TS.GetBusinessFloat( name, valname )

	return GetGlobalFloat( "business." .. name .. "." .. valname ) or 0;

end

function TS.GetBusinessString( name, valname )

	return GetGlobalString( "business." .. name .. "." .. valname ) or "";

end

function TS.SetBusinessString( name, valname, val )

	SetGlobalString( "business." .. name .. "." .. valname, val );

end

function TS.GetSomethingOutOfSupply( id )

	local n = TS.GetBusinessInt( id, "itemcount" );

	for j = 1, n do
		
		if( ( TS.GetBusinessInt( id, "item." .. j .. ".count" ) or 0 ) <= 0 ) then
			
			return TS.GetBusinessString( id, "item." .. j .. ".name" ) or "";
			
		end
	
	end
	
	return "";
	

end

function TS.GetBusinessStock( id, item )

	local n = TS.GetBusinessInt( id, "itemcount" );

	for j = 1, n do
		
		if( TS.GetBusinessString( id, "item." .. j .. ".name" ) == item ) then
		
			return TS.GetBusinessInt( id, "item." .. j .. ".count" ) or 0;
			
		end
	
	end	
	
	return 0;

end

function TS.GetBusinessItemTable( id )

	local n = TS.GetBusinessInt( id, "itemcount" );
	local items = { }
	
	for j = 1, n + 1 do
	
		if( ( TS.GetBusinessInt( id, "item." .. j .. ".count" ) or 0 ) > 0 ) then
		
			table.insert( items, TS.GetBusinessString( id, "item." .. j .. ".name" ) );
		
		end
	
	end
	
	return items;

end

local meta = FindMetaTable( "Player" );

function meta:CanTraceTo( ent )

	local trace = { }
	trace.start = self:EyePos();
	trace.endpos = ent:EyePos();
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:EntIndex() == ent:EntIndex() ) then return true; end
	
	return false;

end


