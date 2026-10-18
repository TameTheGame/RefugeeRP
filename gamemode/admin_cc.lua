
TS.HookToggleCommand( "rp_allowmaxstats", "allow_maxstats" );
TS.HookToggleCommand( "rp_allowtools", "allow_tools" );
TS.HookValueCommand( "rp_oocdelay", "oocdelay" );
TS.HookValueCommand( "rp_maxttprops", "maxttprops" );
TS.HookToggleCommand( "rp_propspawning", "propspawning" );

function ccSWEPSpawn( ply, cmd, args )

	if( not ply:IsAdmin() ) then
		return;
	end
	
	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 75;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	local weap = ents.Create( args[1] );
	weap:SetPos( tr.HitPos );
	weap:Spawn();


end
concommand.Add( "gm_giveswep", ccSWEPSpawn );
concommand.Add( "gm_spawnswep", ccSWEPSpawn );

function ccAdminFindDoorOwner( ply, cmd, args )

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			if( not tr.Entity:GetTable().MainOwner or not tr.Entity:GetTable().MainOwner:IsValid() ) then
			
				ply:PrintMessage( 2, "No one owns this door." );
				return;
			
			end
			
			ply:PrintMessage( 2, tr.Entity:GetTable().MainOwner:Nick() .. " owns this door." );
	
		
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end


end
TS.AdminCommand( "rp_findowner", ccAdminFindDoorOwner, "", true );

function ccAdminUnownProperty( ply, cmd, args )

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			local propertylist = { }
			
			table.insert( propertylist, tr.Entity:GetNWString( "doorparent" ) );
		
			for k, v in pairs( TS.DoorGroups[tr.Entity:GetNWString( "doorparent" )] ) do
										
				if( not table.HasValue( propertylist, v:GetNWString( "doorparent" ) ) ) then
				
					table.insert( propertylist, v:GetNWString( "doorparent" ) );
				
				end
										
			end
		
			for _, v in pairs( propertylist ) do
			
				if( TS.DoorGroups[v] ) then
			
					for _, m in pairs( TS.DoorGroups[v] ) do
												
						m:GetTable().MainOwner = nil;
						m:GetTable().MainOwnerSteamID = nil;
			
						if( m:GetTable().Owners == nil ) then m:GetTable().Owners = { }; end
						if( m:GetTable().OwnersBySteamID == nil ) then m:GetTable().OwnersBySteamID = { }; end
							
						for k, v in pairs( m:GetTable().Owners ) do
							
							m:GetTable().Owners[k] = nil;
							m:GetTable().OwnersBySteamID[k] = nil;
							return;
							
						end
						
						sql.Query( "DELETE FROM `rtrp_doors` WHERE `id` = '" .. m:GetNWInt( "doorid" ) .. "'" );

						m:SetNWInt( "Owned", 0 );
			
												
					end
					
				end
			
				
			end
		
			ply:PrintMessage( 2, "Unowned property!" );
	
		
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end

end
TS.AdminCommand( "rp_unownproperty", ccAdminUnownProperty, "", true );

function ccAdminUnownDoor( ply, cmd, args )

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			tr.Entity:GetTable().MainOwner = nil;
			tr.Entity:GetTable().MainOwnerSteamID = nil;

			if( tr.Entity:GetTable().Owners == nil ) then tr.Entity:GetTable().Owners = { }; end
			if( tr.Entity:GetTable().OwnersBySteamID == nil ) then tr.Entity:GetTable().OwnersBySteamID = { }; end
				
			for k, v in pairs( tr.Entity:GetTable().Owners ) do
				
				tr.Entity:GetTable().Owners[k] = nil;
				tr.Entity:GetTable().OwnersBySteamID[k] = nil;
				return;
				
			end
		
			sql.Query( "DELETE FROM `rtrp_doors` WHERE `id` = '" .. tr.Entity:GetNWInt( "doorid" ) .. "'" );

			tr.Entity:SetNWInt( "Owned", 0 );
			
			ply:PrintMessage( 2, "Unowned door!" );
	
		
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end

end
TS.AdminCommand( "rp_unowndoor", ccAdminUnownDoor, "", true );

function ccGetTTList( ply, cmd, args )

	local query = "SELECT `STEAMID`, `UserName`, `groupID` FROM `rtrp_users` WHERE `groupID` = '2' OR `groupID` = '3'";	
	local tbl = mysql.query( TS.SQL, query );	

	local steamidtable = { }
	
	for k, v in pairs( player.GetAll() ) do
	
		if( not v:IsRick() ) then
		
			steamidtable[v:SteamID()] = v:Nick();
		
		end
	
	end
	
	local c = 0;
	
	for k, v in pairs( tbl ) do
	
		local ingame = false;
		local tooltype = "Basic";
		local name = "";
		
		if( steamidtable[v[1]] ) then
		
			ingame = true;
			name = steamidtable[v[1]];
		
		end
		
		if( tonumber( v[3] ) == 3 ) then
		
			tooltype = "Advanced";
		
		end
		
		local msg = v[1] .. " - " .. tooltype .. " - " .. v[2];
		
		if( ingame ) then
		
			msg = msg .. " - IS INGAME (" .. name .. ")";
		
		end
		
		if( ply:EntIndex() ~= 0 ) then
		
			ply:PrintMessage( 2, msg );
		
		else
		
			Msg( msg );
		
		end
	
		c = c + 1;
	
	end
	
	TS.SendConsole( ply, "COUNT: " .. c );

end
TS.AdminCommand( "rp_ttlist", ccGetTTList, "", true );

function ccRemoveTTSteamID( ply, cmd, args )

	local steamidtable = { }

	for k, v in pairs( player.GetAll() ) do
	
		steamidtable[v:SteamID()] = v;
	
	end
	
	if( steamidtable[args[1]] ) then

		target = steamidtable[args[1]];

		if( target:GetField( "group_id" ) == 1 ) then
		
			TS.SendConsole( ply, "Doesnt have toolgun" );
			return;			
		
		end
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		target:LoadGroup();
		
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " removed you from the tooltrust group", 4 );
		TS.SendConsole( ply, "Removed tooltrust from " .. target:Nick() );	
		
	else
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. args[1] .. "'";	
		mysql.query( TS.SQL, query );	
		TS.SendConsole( ply, "Removed SteamID " .. args[1] .. " from TT group" );		
	
	end
	
	if( ply:EntIndex() ~= 0 ) then
		TS.Log( "tooltrust.txt", ply:LogInfo() .. " removed TT from " .. args[1] );
	end

end
TS.AdminCommand( "rp_removettsteamid", ccRemoveTTSteamID );
TS.AdminCommand( "rp_removeadvttsteamid", ccRemoveTTSteamID );

function ccAddTTSteamID( ply, cmd, args )

	local group = 2;
	
	if( cmd == "rp_addadvttsteamid" ) then
	
		if( ply:EntIndex() ~= 0 ) then
			TS.Log( "tooltrust.txt", ply:LogInfo() .. " gave AdvTT to " .. args[1] );
		end
		
		group = 3;
	
	else
	
		if( ply:EntIndex() ~= 0 ) then
			TS.Log( "tooltrust.txt", ply:LogInfo() .. " gave TT to " .. args[1] );
		end
		
	end

	local steamidtable = { }

	for k, v in pairs( player.GetAll() ) do
	
		steamidtable[v:SteamID()] = v;
	
	end
	
	if( steamidtable[args[1]] ) then
	
		local target = steamidtable[args[1]];
	
		if( target:GetField( "group_id" ) == 2 or target:GetField( "group_id" ) == 3 ) then
		
			TS.SendConsole( ply, "Already has toolgun" );
			return;			
		
		end
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '" .. group .. "' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		target:LoadGroup();

		TS.Notify( target, TS.GetConsoleNick( ply ) .. " added you to the tooltrust group", 4 );
		TS.SendConsole( ply, "Gave tooltrust to " .. target:Nick() );
	
	else
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '" .. group .. "' WHERE `STEAMID` = '" .. args[1] .. "'";	
		mysql.query( TS.SQL, query );			
		TS.SendConsole( ply, "Added SteamID " .. args[1] .. " to TT group" );
	
	end
	
end
TS.AdminCommand( "rp_addttsteamid", ccAddTTSteamID );
TS.AdminCommand( "rp_addadvttsteamid", ccAddTTSteamID );

function ccAdminGiveStat( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		return;
	end
	
	local target = TS.RunPlayerSearch( ply, args[1], true );

	if( target ) then
	
		target:SetNWFloat( args[2], ply:GetNWFloat( args[2] ) + tonumber( args[3] ) );
		
	end

end
concommand.Add( "rp_admingivestat", ccAdminGiveStat );

function ccAdminAddMoney( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		return;
	end
	
	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target ) then
	
		target:GiveMoney( tonumber( args[2] ) );
		
	end
end
concommand.Add( "rp_adminaddmoney", ccAdminAddMoney );

function ccConSay( ply, cmd, args )

	if( ply:EntIndex() ~= 0 ) then return; end

	local msg = "";

	for n = 1, #args do
	
		msg = msg .. args[n] .. " ";
	
	end
	
	msg = "Console: " .. msg;

	umsg.Start( "AddToChatBox" );
		umsg.String( "" );
		umsg.String( msg );
		umsg.Vector( Vector( 224, 14, 28, 255 ) );
		umsg.Vector( Vector( 224, 14, 28, 255 ) );
		umsg.Short( 1 );
	umsg.End();
	
	TS.PrintMessageAll( 2, msg );

end
concommand.Add( "consay", ccConSay );
concommand.Add( "csay", ccConSay );

TS.NPCTarget = nil;
TS.NPCHealth = 100;

function ccNPCTarget( ply, cmd, args )

	if( ply:IsRick() ) then
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and ValidEntity( tr.Entity ) ) then

			TS.NPCTarget = tr.Entity;
		
		end
	
	end

end
TS.AdminCommand( "rp_npctarget", ccNPCTarget, "" );

function ccNPCHealth( ply, cmd, args )

	if( #args < 1 ) then return; end
	if( not tonumber( args[1] ) ) then return; end
	
	if( ply:IsRick() ) then
	
		TS.NPCHealth = tonumber( args[1] );
	
	end

end
TS.AdminCommand( "rp_npchealth", ccNPCHealth, "" );

function ccNPCCreate( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( ply:IsRick() ) then
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 4096;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
	
		local ent = ents.Create( args[1] );
		ent:SetHealth( TS.NPCHealth );
		ent:SetAngles( ply:GetAngles() );
		ent:SetPos( tr.HitPos );
		ent:Spawn();
		
		ent:SetNPCState( NPC_STATE_ALERT );
		
		if( TS.NPCTarget and TS.NPCTarget:IsValid() ) then
		
			ent:SetEnemy( TS.NPCTarget );
			ent:AddEntityRelationship( TS.NPCTarget, 1, 99 ); 
		
		end
		
		undo.Create( "npc" );
			undo.AddEntity( ent );
			undo.SetPlayer( ply );
		undo.Finish();
			
	end

end
TS.AdminCommand( "rp_npccreate", ccNPCCreate, "" );

function ccAdminSetPlayerModel( ply, cmd, args )

	if( #args < 2 ) then return; end

	if( ply:IsAwesome() ) then
	
		local target = TS.RunPlayerSearch( ply, args[1], true );
	
		if( target ) then
		
			target:SetModel( args[2] );
		
		end
	
	end

end
TS.AdminCommand( "rp_setplayermodel", ccAdminSetPlayerModel, "" );

function ccWhoHasChar( ply, cmd, args )

	if( #args < 1 ) then
		return;
	end

	local tab = mysql.query( TS.SQL, "SELECT `userID` FROM `rtrp_characters` WHERE `charName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'" );

	if( not tab or #tab < 1 ) then
	
		TS.SendConsole( ply, "No such character found: " .. args[1] );
		return;
	
	end
	
	tab[1][1] = tonumber( tab[1][1] );
	
	if( tab[1][1] == 0 ) then
	
		TS.SendConsole( ply, "No one has this character: " .. args[1] );
		return;
	
	end
	
	tab = mysql.query( TS.SQL, "SELECT `UserName`, `STEAMID` FROM `rtrp_users` WHERE `uID` = '" .. tab[1][1] .. "'" );
	
	TS.SendConsole( ply, "The owner of this character is " .. tab[1][1] .. " - " .. tab[1][2] );

end
TS.AdminCommand( "rp_whohaschar", ccWhoHasChar, "" );

function ccFreeChar( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() and not ply:HasAdminFlag( "A" ) ) then
		ply:PrintMessage( 3, "Super admin only" );
		return;
	end

	if( #args < 1 ) then
		return;
	end
	
	local tab = mysql.query( TS.SQL, "SELECT `userID` FROM `rtrp_characters` WHERE `charName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'" );

	if( not tab or #tab < 1 ) then
	
		TS.SendConsole( ply, "No such character found: " .. args[1] );
		return;
	
	end

	mysql.query( TS.SQL, "UPDATE `rtrp_characters` SET `userID` = '0' WHERE `charName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'" );

	TS.SendConsole( ply, "Freed character: " .. args[1] );

end
TS.AdminCommand( "rp_freechar", ccFreeChar, "" );

function ccReloadUserFlags( ply, cmd, args )

	for k, v in pairs( player.GetAll() ) do
	
		--if( v:GetNWString( "combineflags" ) ~= "" or v:GetNWString( "miscflags" ) ~= "" ) then
		if( true ) then
		
			local query = "SELECT `AdminFlags`, `UserFlags` FROM `rtrp_users` WHERE `uID` = '" .. v:GetField( "uid" ) .. "'";	
			
			local tab, succ, err = mysql.query( TS.SQL, query );
		
			if( tab and #tab > 0 ) then
				
				v:SetField( "AdminFlags", tab[1][1] );
				v:SetField( "UserFlags", tab[1][2] );
			
			end
		
		end
	
	end
	
	TS.SendConsole( ply, "Reloaded user flags" );

end
TS.AdminCommand( "rp_reloaduserflags", ccReloadUserFlags, "", true );

function ccReloadFlags( ply, cmd, args )

	for k, v in pairs( player.GetAll() ) do
	
		--if( v:GetNWString( "combineflags" ) ~= "" or v:GetNWString( "miscflags" ) ~= "" ) then
		if( true ) then
		
			local query = "SELECT `playerflags`, `combineflags` FROM `rtrp_characters` WHERE `userID` = '" .. v:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, v:Nick() ) .. "'";	
			
			local tab, succ, err = mysql.query( TS.SQL, query );
		
			if( tab and #tab > 0 ) then
				
				v:SetField( "miscflags", tab[1][1] );
				v:SetPrivateString( "miscflags", tab[1][1] );
				
				v:SetField( "combineflags", tab[1][2] );
				v:SetPrivateString( "combineflags", tab[1][2] );
			
			end
		
		end
	
	end
	
	TS.SendConsole( ply, "Reloaded flags" );

end
TS.AdminCommand( "rp_reloadflags", ccReloadFlags, "", true );

function ccKick( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) ) then	
	
		local reason = "";
	
		for n = 2, #args do
		
			reason = reason .. args[n] .. " ";
		
		end
		
		reason = "Kicked by " .. TS.GetConsoleNick( ply ) .. " for: " .. reason;
		
		if( reason == "" ) then
			reason = "Kicked by " .. TS.GetConsoleNick( ply );
		end
		
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " kicked " .. target:Nick() );
		
		game.ConsoleCommand( "kickid " .. target:UserID() .. " \"" .. reason .. "\"\n" );
	
	end
	
	if( target and not TS.AdminCanTarget( ply, target ) ) then
	
		ply:PrintMessage( 2, "Cannot target this user" );
		ply:PrintMessage( 3, "Cannot target this user" );
	
	end	

end
TS.AdminCommand( "rp_kick", ccKick, "Kick a player" );

function ccGoTo( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target ) then	
	
		local trace = { }
		trace.start = target:EyePos();
		trace.endpos = trace.start + target:GetAngles():Forward() * 50;
		trace.filter = target;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Hit ) then

			trace = { }
			trace.start = target:EyePos();
			trace.endpos = trace.start + target:GetAngles():Forward() * -50;
			trace.filter = target;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = target:EyePos();
			trace.endpos = trace.start + target:GetAngles():Right() * -50;
			trace.filter = target;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = target:EyePos();
			trace.endpos = trace.start + target:GetAngles():Right() * 50;
			trace.filter = target;
			
			tr = util.TraceLine( trace );
			
		end
		
		
		ply:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	end	

end
TS.AdminCommand( "rp_goto", ccGoTo, "Go to a player" );

function ccBring( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) ) then	
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 50;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetForward() * -50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
		
		end
	
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetRight() * -50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
		
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetRight() * 50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
		
		end
		
		target:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	end	

end
TS.AdminCommand( "rp_bring", ccBring, "Bring a player" );

function ccPBan( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) and ( ply:EntIndex() == 0 or ply:IsSuperAdmin() ) ) then	
	
		if( file.Exists( "../cfg/banned_user.cfg" ) ) then
			game.ConsoleCommand( "exec banned_user.cfg\n" );
		end
		
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " permanently banned " .. target:Nick() );

		--game.ConsoleCommand( "addip 0 " .. target:IPAddress() .. "; writeip\n" );
		game.ConsoleCommand( "banid 0 " .. target:SteamID() .. "; writeid\n" );
		game.ConsoleCommand( "kickid " .. target:UserID() .. " \"Permanently Banned By " .. TS.GetConsoleNick( ply ) .. "\"\n" );
	
	end
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 2, "You need to be a super admin" );
		ply:PrintMessage( 3, "You need to be a super admin" );
	end
	
end
TS.AdminCommand( "rp_pban", ccPBan, "Perma ban a player" );

function ccBan( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) ) then	
	
		local amt = tonumber( ( args[2] or "0" ) );
		
		if( file.Exists( "../cfg/banned_user.cfg" ) ) then
			game.ConsoleCommand( "exec banned_user.cfg\n" );
		end
		
		if( amt < 1 or amt > 120 ) then
		
			if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
			
				ply:PrintMessage( 2, "Invalid ban time" );
				ply:PrintMessage( 3, "Invalid ban time" );
				return;
			
			end
			
		end
	
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " banned " .. target:Nick() );
	
		game.ConsoleCommand( "banid " .. amt .. " " .. target:SteamID() .. "\n" );
		game.ConsoleCommand( "kickid " .. target:UserID() .. " \"Banned for " .. amt .. " minutes by " .. TS.GetConsoleNick( ply ) .. "\"\n" );
			
	end
	
	if( target and not TS.AdminCanTarget( ply, target ) ) then
	
		ply:PrintMessage( 2, "Cannot target this user" );
		ply:PrintMessage( 3, "Cannot target this user" );
	
	end

end
TS.AdminCommand( "rp_ban", ccBan, "Ban a player" );

function ccSlay( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) ) then	
	
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " slayed " .. target:Nick() );
	
		target:Slay();
	
	end
	
	if( target and not TS.AdminCanTarget( ply, target ) ) then
	
		ply:PrintMessage( 2, "Cannot target this user" );
		ply:PrintMessage( 3, "Cannot target this user" );
	
	end

end
TS.AdminCommand( "rp_slay", ccSlay, "Slay a player" );

function ccSlap( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) ) then	
	
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " slapped " .. target:Nick() );
	
		local norm = target:GetAngles():Up();
		
		target:SetVelocity( norm * 500 + target:GetAngles():Forward() * math.random( -1000, 1000 ) );
		target:SetHealth( math.Clamp( target:Health() - 5, 1, 1000 ) );
	
	end
	
	if( target and not TS.AdminCanTarget( ply, target ) ) then
	
		ply:PrintMessage( 2, "Cannot target this user" );
		ply:PrintMessage( 3, "Cannot target this user" );
	
	end

end
TS.AdminCommand( "rp_slap", ccSlap, "Slap a player" );

function ccAdminTitle( ply, cmd, args )

	if( not ply:IsRick() ) then return; end

	local target = TS.RunPlayerSearch( ply, args[1], true );

	if( target ) then
	
		local title = "";
		
		for n = 2, #args do
		
			title = title .. args[n] .. " ";
		
		end
		
		target:SetNWString( "admintitle", title );
	
	end

end
TS.AdminCommand( "rp_admintitle", ccAdminTitle, "Subliminal advertising" );

function ccExplode( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target and TS.AdminCanTarget( ply, target ) and ( ply:EntIndex() == 0 or ply:IsSuperAdmin() ) ) then	
	
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " exploded " .. target:Nick() );
	
		local exp = ents.Create( "env_explosion" );
			exp:SetKeyValue( "spawnflags", 128 );
			exp:SetPos( target:EyePos() );
		exp:Spawn();
		
		exp:Fire( "explode", "", 0 );
		
		timer.Simple( .2, target.SlaySilent, target );
		
	end
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 2, "You need to be a super admin" );
		ply:PrintMessage( 3, "You need to be a super admin" );
	end

end
TS.AdminCommand( "rp_explode", ccExplode, "Explode a player" );

function ccRickRoll( ply, cmd, args )

	if( not ply:IsRick() ) then return; end
	
	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target ) then	
	
		ply:ConCommand( "rp_slap " .. args[1] .. "\n" );
		timer.Simple( .5, ply.ConCommand, ply, "rp_slap " .. args[1] .. "\n" );
		timer.Simple( .8, ply.ConCommand, ply, "rp_slap " .. args[1] .. "\n" );
		timer.Simple( 1.1, ply.ConCommand, ply, "rp_slap " .. args[1] .. "\n" );
		timer.Simple( 1.6, ply.ConCommand, ply, "rp_explode " .. args[1] .. "\n" );
		
		local function RickRoll( name )
		
			local target = TS.RunPlayerSearch( ply, name, true );
			umsg.Start( "RickRoll", target ); umsg.End();
			
		end
		
		timer.Simple( 2, RickRoll, args[1] );
		
	end	

end
TS.AdminCommand( "rp_rickroll", ccRickRoll, "Fuck yeah" );

function ccAdminTalk( ply, cmd, args )

	local msg = "";

	for n = 1, #args do
		msg = msg .. args[n] .. " ";
	end
	
	msg = ply:Nick() .. " to admins: " .. msg;
	
	for k, v in pairs( player.GetAll() ) do
	
		if( v:IsAdmin() ) then
		
			v:PrintMessage( 3, msg, true );
			v:PrintMessage( 2, msg, true );
		
		end
	
	end
	
	Msg( msg );

end
concommand.Add( "rp_asay", ccAdminTalk );

function ccAdminDropItem( ply, cmd, args )

	if( not ply:IsRick() ) then return; end

	if( #args < 1 ) then return; end
	if( not TS.ItemData[args[1]] ) then return; end
	
	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 75;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	TS.CreateItem( args[1], tr.HitPos, Angle( 0, 0, 0 ) );

end
concommand.Add( "dropitem", ccAdminDropItem );

function ccAdminDropSwep( ply, cmd, args )

	if( not ply:IsRick() ) then return; end

	if( #args < 1 ) then return; end

	if( not string.find( args[1], "ts" ) and not string.find( args[1], "gmod" ) and not ply:IsRick() ) then
		ply:PrintMessage( 2, "Cannot spawn non-TS weapons" );
		return;
	end
	
	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 75;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	local weap = ents.Create( args[1] );
	weap:SetPos( tr.HitPos );
	weap:Spawn();

end
concommand.Add( "dropswep", ccAdminDropSwep );

function ccRcon( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() and not ply:HasAdminFlag( "A" ) ) then
	
		ply:PrintMessage( 3, "You do not have access" );
		return;
		
	end

	local BlackList =
	{
	
		"banid",
		"banip",
		"addip",
		"addid",
		"rp_cp",
		"writeid",
		"rp_setgroup",
		"alias",
		"rp_ow",
		"rp_ce",
		"rp_ca",
		"rp_explode",
		"rp_slap",
		"lua_run",
		"rp_pban",
		"killserver"
	
	}

	local cmd = TS.MergeArgs( args ) .. "\n";
	
	if( ply:EntIndex() == 0 or ply:IsSuperAdmin() ) then
	
		game.ConsoleCommand( cmd );
		return;
		
	end
	
	for k, v in pairs( BlackList ) do
	
		if( string.find( cmd, v ) ) then
		
			ply:PrintMessage( 2, "Found blacklisted keyword: " .. v );
			ply:PrintMessage( 2, "Cannot execute RCON command" );
			return;
		
		end
	
	end

	game.ConsoleCommand( cmd );

end
TS.AdminCommand( "rp_rcon", ccRcon, "Execute console command" );

function ccSeeAll( ply, cmd, args )

	umsg.Start( "ToggleSeeAll", ply ); umsg.End();

end
TS.AdminCommand( "rp_seeall", ccSeeAll, "", true );

function ccGiveMoney( ply, cmd, args )

	if( ply:IsAwesome() ) then
	
		local target = TS.RunPlayerSearch( ply, args[1] );
		
		if( not tonumber( args[2] ) ) then
		
			ply:PrintMessage( 2, "Invalid money" );
			return;
		
		end
	
		if( target ) then
			target:SetNWFloat( "money", target:GetNWFloat( "money" ) + tonumber( args[2] ) );
			ply:PrintMessage( 2, "Gave money" );
		end		
	
	end

end
TS.AdminCommand( "rp_givemoney", ccGiveMoney, "Give a player money" );

function ccNoclip( ply, cmd, args )

	if( not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "Super admin only" );
		return; 
	end

	if( not ply:GetTable().Noclip ) then

		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		ply:GetTable().Noclip = true;
		
	else
	
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		ply:GetTable().Noclip = false;
		
	end

end
TS.AdminCommand( "rp_noclip", ccNoclip, "", true );

function ccGod( ply, cmd, args )

	if( not ply:IsRick() ) then return; end
	
	ply:GodEnable();
	
end
TS.AdminCommand( "rp_god", ccGod, "", true );

function ccObserve( ply, cmd, args )

	--I bet wolf is the first to edit this
	-- if( not ply:IsRick() ) then return; end DAMN YOU WAXX
	
	if( not ply:IsRick() and not ply:IsAdmin() and not ply:IsRDA() and not ply:IsSuperAdmin() ) then return; end

	if( not ply:GetTable().Observe ) then

		if( not ply:IsRick() ) then
	
			TS.PrintMessageAll( 3, ply:Nick() .. " went into observe mode" );
	
		end

		ply:GodEnable();
		ply:SetNoDraw( true );
		
		if( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():SetNoDraw( true );
		end
		
		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		
		ply:GetTable().Observe = true;
		
	else
	
		if( not ply:IsRick() ) then
	
			TS.PrintMessageAll( 3, ply:Nick() .. " went out of observe mode" );
	
		end
	
		ply:GodDisable();
		ply:SetNoDraw( false );
		
		if( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():SetNoDraw( false );
		end
		
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		
		ply:GetTable().Observe = false;
		
	end

end
TS.AdminCommand( "rp_observe", ccObserve, "", true );

function ccRPName( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );

	if( target ) then
		target:PrintMessage( 2, ply:Nick() .. " has given you a name warning." );
		umsg.Start( "ToggleRPNameWarning", target ); umsg.End();
	end

end
TS.AdminCommand( "rp_name", ccRPName, "Make player get an RP name" );

function ccMakeNRD( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeNRD();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you a NRD soldier." );
	
	end

end
TS.AdminCommand( "rp_nrd", ccMakeNRD, "Make a player become a NRD soldier" );

function ccMakeNSRF( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeNSRF();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you a NSRF soldier." );
	
	end

end
TS.AdminCommand( "rp_nsrf", ccMakeNSRF, "Make a player become a NSRF soldier" );
--[[
function ccMakeOW( ply, cmd, args )

	if( not ply:IsAwesome() ) then
	
		--ply:PrintMessage( 3, "Super admin only" );
		return;
		
	end

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeOW();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you OW" );
	
	end

end
TS.AdminCommand( "rp_ow", ccMakeOW, "Make a player join OW" );

function ccMakeCE( ply, cmd, args )

	if( not ply:IsAwesome() ) then
	
		--ply:PrintMessage( 3, "Super admin only" );
		return;
		
	end

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeCE();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you CE" );
	
	end

end
TS.AdminCommand( "rp_ce", ccMakeCE, "Make a player join CE" );

function ccMakeCA( ply, cmd, args )

	if( not ply:IsAwesome() ) then
	
		--ply:PrintMessage( 3, "Super admin only" );
		return;
		
	end

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeCA();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you City Administrator" );
	
	end

end
TS.AdminCommand( "rp_ca", ccMakeCA, "Make a player join CA" );
--]]
function ccMakeCitizen( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:BecomeCitizen();
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has made you citizen" );
	
	end

end
TS.AdminCommand( "rp_survivor", ccMakeCitizen, "Make a player become a regular survivor" );

function ccSetPlayerFlags( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() and not ply:HasPlayerFlag( "E" ) ) then
		return;
	end

	args[2] = args[2] or " ";

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		target:SetField( "miscflags", args[2] );
		target:SetPrivateString( "miscflags", args[2] );
		
		if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		
			if( target:HasPlayerFlag( "E" ) ) then
			
				if( not string.find( args[2], "E" ) ) then
				
					args[2] = args[2] .. "E";
				
				end
			
			end
			
			if( string.find( args[2], "X" ) ) then
				
				args[2] = string.gsub( args[2], "X", "" );
				
			end
		
		end
		
		target:PrintMessage( 3, "Your player flags were set to " .. args[2] .. " by " .. TS.GetConsoleNick( ply ) );
		TS.SendConsole( ply, "Player flags set for " .. target:Nick() .. " to " .. args[2] );
		
		local query = "UPDATE `rtrp_characters` SET `playerflags` = '" .. args[2] .. "' WHERE `userID` = '" .. target:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, target:Nick() ) .. "'";	
		
		mysql.query( TS.SQL, query );
		
	end


end
concommand.Add( "rp_setplayerflag", ccSetPlayerFlags );

--A - cp
--B - ow
--C - ce
--D - ca
--E - can set combine flags
function ccSetFactionFlags( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() and not ply:HasAdminFlag( "A" ) and not ply:HasCombineFlag( "E" ) ) then
		return;
	end

	args[2] = args[2] or " ";

	local target = TS.RunPlayerSearch( ply, args[1], false, false );
	
	if( target ) then
	
		target:SetField( "combineflags", args[2] );
		target:SetPrivateString( "combineflags", args[2] );
		
		if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		
			if( target:HasCombineFlag( "E" ) ) then
			
				if( not string.find( args[2], "E" ) ) then
				
					args[2] = args[2] .. "E";
				
				end
			
			end
		
		end
		
		target:PrintMessage( 3, "Your faction flags were set to " .. args[2] .. " by " .. TS.GetConsoleNick( ply ) );
		TS.SendConsole( ply, "Faction flags set for " .. target:Nick() .. " to " .. args[2] );
		
		local query = "UPDATE `rtrp_characters` SET `combineflags` = '" .. args[2] .. "' WHERE `userID` = '" .. target:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, target:Nick() ) .. "'";	
		
		mysql.query( TS.SQL, query );
		
	else
	
		local tab = mysql.query( TS.SQL, "SELECT `userID` FROM `rtrp_characters` WHERE `charName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'" );
	
		if( tab and #tab == 1 ) then
		
			local query = "UPDATE `rtrp_characters` SET `combineflags` = '" .. args[2] .. "' WHERE `charName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'";	
			
			mysql.query( TS.SQL, query );
			
			TS.SendConsole( ply, "Faction flag for " .. args[1] .. " set to " .. args[2] );		
			
		elseif( tab and #tab > 1 ) then
		
			TS.SendConsole( ply, "Multiple characters in the database named: " .. args[1] );		
		
		else
		
			TS.SendConsole( ply, "No character found in the database named: " .. args[1] );		
		
		end
	
	end


end
concommand.Add( "rp_setfactionflags", ccSetFactionFlags );

function ccBanPhysgun( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		if( not target:IsPhysgunBanned() ) then
		
			file.Write( "TacoScript/data/physgunbans.txt", ( file.Read( "TacoScript/data/physgunbans.txt" ) or "" ) .. "\r\n" .. target:SteamID()  );
		
			table.insert( TS.PhysgunBans, { target:SteamID() } );
			
			if( target:HasWeapon( "weapon_physgun" ) ) then
				target:StripWeapon( "weapon_physgun" );
			end
			
			TS.SendConsole( ply, "Banned " .. target:Nick() .. " from physgun" );
			TS.Notify( target, TS.GetConsoleNick( ply ) .. " has banned you from the physgun", 4 );
		
		else
		
			TS.SendConsole( ply, "Player is already banned from the physgun" );
		
		end
	
	end

end
TS.AdminCommand( "rp_physgunban", ccBanPhysgun, "Ban a player from using the physgun" );

function ccUnBanPhysgun( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( target ) then
	
		if( target:IsPhysgunBanned() ) then
		
			file.Write( "TacoScript/data/physgunbans.txt", string.gsub( ( file.Read( "TacoScript/data/physgunbans.txt" ) or "" ), "\r\n" .. target:SteamID(), "" ) );
		
			for k, v in pairs( TS.PhysgunBans ) do
			
				if( v[1] == target:SteamID() ) then
					TS.PhysgunBans[k] = nil;
					break;
				end
			
			end
			
			if( not target:HasWeapon( "weapon_physgun" ) ) then
				target:ForceGive( "weapon_physgun" );
			end
			
			TS.SendConsole( ply, "Un-Banned " .. target:Nick() .. " from physgun" );
			TS.Notify( target, TS.GetConsoleNick( ply ) .. " has un-banned you from the physgun", 4 );
		
		else
		
			TS.SendConsole( ply, "Player is not banned from the physgun" );
		
		end
	
	end

end
TS.AdminCommand( "rp_physgununban", ccUnBanPhysgun, "Un-Ban a player from using the physgun" );

function ccReloadCharacter( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "Super admin only" );
		return;
	end
	
	if( target ) then
	
		if( target:SaveExists( target:Nick() ) ) then
		
			target:LoadCharacter( target:Nick() );
			TS.SendConsole( ply, "Reloaded character" );
		
		end
		
	end

end
TS.AdminCommand( "rp_reloadcharacter", ccReloadCharacter, "Reload character" );

function ccSaveCharacter( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "Super admin only" );
		return;
	end
	
	if( target ) then
	
		if( target:SaveExists( target:Nick() ) ) then
		
			target:SaveCharacter();
			TS.SendConsole( ply, "Saved character" );
		
		end
		
	end

end
TS.AdminCommand( "rp_savecharacter", ccSaveCharacter, "Save character" );

function ccSendNotice( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "Super admin only" );
		return;
	end
	
	local len = tonumber( args[1] );
		
	if( not len ) then
		
		TS.SendConsole( ply, "Invalid time length" );
		return;
		
	end
		
	local msg = "";
		
	for n = 2, #args do
		
		msg = msg .. args[n] .. " ";
		
	end
	
	TS.NotifyAll( msg, len, true );

end
TS.AdminCommand( "rp_sendnotice", ccSendNotice, "Send a notice - <time> <msg>" );

function ccSetGroup( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "Super admin only" );
		return;
	end
	
	if( target ) then
	
		local id = tonumber( args[2] );
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '" .. id .. "' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		target:LoadGroup();

		TS.Notify( target, TS.GetConsoleNick( ply ) .. " has changed your group", 4 );
		TS.SendConsole( ply, "Changed group for " .. target:Nick() .. " to " .. id );
	
	end

end
TS.AdminCommand( "rp_setgroup", ccSetGroup, "Set a player to a group" );

function ccSetAdminFlag( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "You do not have access to this command" );
		return;
	end
	
	if( target ) then

		local query = "UPDATE `rtrp_users` SET `AdminFlags` = '" .. args[2] .. "' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		TS.SendConsole( ply, "Set flag for " .. target:Nick() .. " to " .. args[2] );
		target:SetField( "AdminFlags", args[2] ); 
	
	end

end
TS.AdminCommand( "rp_setadminflag", ccSetAdminFlag, "" );

function ccResetMap( ply, cmd, args )

	for k, v in pairs( player.GetAll() ) do
	
		v:PrintMessage( 3, TS.GetConsoleNick( ply ) .. " is restarting the map" );
	
	end
	
	timer.Simple( 5, game.ConsoleCommand, "changelevel " .. game.GetMap() .. "\n" );

end
TS.AdminCommand( "rp_restartmap", ccResetMap, "", true );

function ccAddToolTrust( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );
	
	
	if( target ) then

		if( target:GetField( "group_id" ) == 2 or target:GetField( "group_id" ) == 3 ) then
		
			TS.SendConsole( ply, "Already has toolgun" );
			return;			
		
		end
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '2' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		target:LoadGroup();

		TS.Notify( target, TS.GetConsoleNick( ply ) .. " added you to the tooltrust group", 4 );
		TS.SendConsole( ply, "Gave tooltrust to " .. target:Nick() );
		TS.Log( "tooltrust.txt", ply:LogInfo() .. " gave TT to " .. target:LogInfo() );
	
	end

end
TS.AdminCommand( "rp_addtooltrust", ccAddToolTrust, "Add a player to tooltrust group" );

function ccRemoveToolTrust( ply, cmd, args )

	local target = TS.RunPlayerSearch( ply, args[1] );

	if( target ) then
	
		if( target:GetField( "group_id" ) == 1 ) then
		
			TS.SendConsole( ply, "Doesnt have toolgun" );
			return;			
		
		end
	
		local query = "UPDATE `rtrp_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. target:SteamID() .. "'";	
		mysql.query( TS.SQL, query );	
	
		target:LoadGroup();
		
		TS.Notify( target, TS.GetConsoleNick( ply ) .. " removed you from the tooltrust group", 4 );
		TS.SendConsole( ply, "Removed tooltrust from " .. target:Nick() );		
		TS.Log( "tooltrust.txt", ply:LogInfo() .. " removed TT from " .. target:LogInfo() );

	end

end
TS.AdminCommand( "rp_removetooltrust", ccRemoveToolTrust, "Remove a player from tooltrust group" );