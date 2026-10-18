
local function MetroPlayerPush( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 35;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() ) then
	
		local norm = ( tr.Entity:GetPos() - ply:GetPos() ):Normalize();
		local push = 100 * norm;
					
		tr.Entity:SetVelocity( push );
		
		tr.Entity:EmitSound( Sound( "weapons/crossbow/hitbod1.wav" ) );
	
	end

end

AnimsList = { }

local function AddAnim( team, time, seq, desc, cb )

	table.insert( AnimsList, { team = team, seq = seq, desc = desc, time = time, cb = cb } );

end

AddAnim( 2, 30, "pushplayer", "Metrocop-push a player", MetroPlayerPush );
AddAnim( 3, 30, "melee_gunhit", "OverWatch-push a player", MetroPlayerPush );
AddAnim( 4, 30, "melee_gunhit", "OverWatch-push a player", MetroPlayerPush );

function ccAnimList( ply, cmd, args )

	ply:PrintMessage( 2, "Use rp_playanim <id> to play an animation on yourself.  You cannot move while the animation is in effect" );
	
	local team = ply:Team();
	
	ply:PrintMessage( 2, "ID   |   ANIMATION" );

	if( team == 2 and ply:IsTempCP() ) then return; end
	
	local n = 1;

	for k, v in pairs( AnimsList ) do
	
		if( v.team == 0 or v.team == team ) then
			ply:PrintMessage( 2, n .. ") " .. v.desc );
			n = n + 1;
		end
	
	end

end
concommand.Add( "rp_animslist", ccAnimList );

function ccPlayAnim( ply, cmd, args )

	if( ply:GetField( "OverrideAnim" ) ) then
		ply:PrintMessage( 2, "Another animation is playing" );
		return;
	end


	local anims = { }

	local team = ply:Team();
	local n = 1;

	if( team == 2 and ply:IsTempCP() ) then return; end

	for k, v in pairs( AnimsList ) do
	
		if( v.team == 0 or v.team == team ) then
			anims[n] = { }
			anims[n].seq = v.seq;
			anims[n].time = v.time;
			anims[n].cb = v.cb;
			n = n + 1;
		end
	
	end
	
	local chosen = tonumber( args[1] );
	
	if( not anims[chosen] ) then
	
		ply:PrintMessage( 2, "Unknown animation" );
		return;
	
	end
	
	ply:OverrideAnimation( anims[chosen].seq, anims[chosen].time * FrameTime() );
	
	if( anims[chosen].cb ) then
		anims[chosen].cb( ply );
	end

end
concommand.Add( "rp_playanim", ccPlayAnim );