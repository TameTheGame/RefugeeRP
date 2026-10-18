
function GetItemFromArg( ply, arg )

	if( not IsItemSuitable( ply, arg ) ) then
	
		return nil;
	
	end
	
	local index = tonumber( arg[1] );
	
	if( not index ) then return nil; end
	
	return ents.GetByIndex( index );	

end

function IsItemSuitable( ply, arg )

	if( #arg < 1 ) then return false; end

	local index = tonumber( arg[1] );
	
	if( not index ) then return false; end
	
	local ent = ents.GetByIndex( index );
	
	if( not ent or not ent:IsValid() ) then return false; end

	if( ent:GetPos():Distance( ply:EyePos() ) > 128 ) then
	
		ply:PrintMessage( 2, "Too far from item" );
		return false;
	
	end
	
	return true;
	

end

local function PlaceInside( ply, cmd, arg )

	local ent = GetItemFromArg( ply, arg );
	
	if( not ent ) then return; end
	
	if( ent:IsItem() and ent:GetTable().Data.IsContainer ) then
	
		umsg.Start( "CreateItemPickMenu", ply );
		umsg.End();
		
		ply:GetTable().ItemPickCallBack = function( ply, item )
		
			
		
		end
	
		--[[
	
		umsg.Start( "CreateProcessBar", self.Owner );
			umsg.Short( -1 );
			umsg.Short( -1 );
			umsg.Short( 25 );
			umsg.String( "Placing in container" );
			umsg.Short( 1 );
			umsg.Short( 2 ); --time
			umsg.String( "rp_ia_finishplaceinside" );
			umsg.Entity( tr.Entity );
		umsg.End();

		self.Owner:SetField( "EndPlaceTime", CurTime() + 2 ); --time
		
		]]--
	
	end
	

end
concommand.Add( "rp_ia_placeinside", PlaceInside );