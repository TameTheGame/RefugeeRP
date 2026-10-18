
local function MapData()

	local ent = ents.FindByName( "ind_checkpointdoor" );
	
	
	for k, v in pairs( ent ) do
	
		if( v:IsValid() ) then
			v:Remove();
		end
	
	end
	
end

timer.Simple( 2, MapData );