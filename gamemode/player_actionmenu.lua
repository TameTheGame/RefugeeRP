
function ActionMenu( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 128 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) ) then
	
		 if( tr.Entity:IsOwnable() ) then return; end
		 
		 if( tr.Entity:IsPlayer() or tr.Entity:IsItem() ) then
		 
		 	if( tr.Entity:IsItem() ) then
		 	
		 		if( not tr.Entity:GetTable().Data.Actions or
		 			#tr.Entity:GetTable().Data.Actions < 1 ) then return true; end
		 	
		 	end
		 
		 	if( tr.Entity:IsPlayer() ) then
		 	
		 		if( tr.HitPos:Distance( ply:EyePos() ) > 45 ) then
		 			return true;
		 		end
		 	
		 	end
		 
		 	umsg.Start( "ToggleActionMenu", ply );
		 		umsg.Entity( tr.Entity );
				ply:GetActionMenuOptions( tr.Entity );
		 	umsg.End();	
		 
		 end
	
	end
	
	return true;

end
hook.Add( "ShowSpare2", "ActionMenu", ActionMenu );

local meta = FindMetaTable( "Player" );

function meta:GetActionMenuOptions( target )

	local n = 0;
	local Options = { }

	if( target:IsPlayer() ) then
	
		if( self:IsCombineDefense() and target:Team() == 1 ) then
		
			n = n + 2;
			table.insert( Options, { "Get CID", "rp_getcid" } );
			table.insert( Options, { "Pat Down", "rp_patdown" } );
		
		end
		
	elseif( target:IsItem() ) then
		
		if( target:GetTable().Data ) then
		
			for k, v in pairs( target:GetTable().Data.Actions ) do
			
				n = n + 1;
				table.insert( Options, { v[1], v[2] } );
			
			end
		
		end
	
	end
	
	umsg.Short( n );
	
	for j = 1, n do
	
		umsg.String( Options[j][1] );
		umsg.String( Options[j][2] );
	
	end

end