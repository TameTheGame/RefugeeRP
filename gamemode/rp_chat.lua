
--Chat commands lol

local function Help( ply, args, call )

	umsg.Start( "ShowHelpMenu", ply ); umsg.End();

	return "";
	
end
TS.AddChatCommand( "/help", Help );

local function cMeow( ply, args, call )

	local r1 = math.random( 1, 4 );
	
	if( r1 == 1 ) then
		ply:PrintMessage( 3, "Meow!" );
	end
	
	if( r1 == 2 ) then
		ply:PrintMessage( 3, "Mew!" );
	end
	
	if( r1 == 3 ) then
		ply:PrintMessage( 3, "Maow!" );
	end
	
	if( r1 == 4 ) then
		ply:PrintMessage( 3, "Mrow!" );
	end

	return "";

end
--TS.AddChatCommand( "/meow", cMeow );
--TS.AddChatCommand( "/mew", cMeow );
--TS.AddChatCommand( "/maow", cMeow );
--TS.AddChatCommand( "/mrow", cMeow );

local function cCitizenClothes( ply, args, call )

	if( ply:Team() ~= 1 ) then
	
		ply:PrintMessage( 3, "Need to be citizen" );
		return "";
	
	end

	if( ply:HasItem( "rebelvest" ) or ply:HasItem( "medicvest" ) ) then
	
		local model = string.lower( ply:GetModel() );
		model = string.gsub( model, "group03m", "group01" );
		model = string.gsub( model, "group03", "group01" );
		
		ply:SetModel( model );
		
		ply:SetArmor( 0 );
	
	else
	
		ply:PrintMessage( 3, "Need your original clothes" );
	
	end
	
	return "";

end
TS.AddChatCommand( "/citizenclothes", cCitizenClothes );

local function cChangeMedicClothes( ply, args, call )

	if( ply:Team() ~= 1 ) then
	
		ply:PrintMessage( 3, "Need to be citizen" );
		return "";
	
	end

	if( ply:HasItem( "medicvest" ) ) then
	
		local model = string.lower( ply:GetModel() );
		model = string.gsub( model, "group03", "group03m" );
		model = string.gsub( model, "group02", "group03m" );
		model = string.gsub( model, "group01", "group03m" );
		
		ply:SetModel( model );
		
		ply:SetArmor( 20 );
	
	else
	
		ply:PrintMessage( 3, "Need medic clothing" );
	
	end
	
	return "";

end
TS.AddChatCommand( "/medicclothes", cChangeMedicClothes );

local function cChangeClothes( ply, args, call )

	if( ply:Team() ~= 1 ) then
	
		ply:PrintMessage( 3, "Need to be citizen" );
		return "";
	
	end

	if( ply:HasItem( "rebelvest" ) ) then
	
		local model = string.lower( ply:GetModel() );
		model = string.gsub( model, "group03m", "group03" );
		model = string.gsub( model, "group02", "group03" );
		model = string.gsub( model, "group01", "group03" );
		
		ply:SetModel( model );
		
		ply:SetArmor( 35 );
	
	else
	
		ply:PrintMessage( 3, "Need rebel clothing" );
	
	end
	
	return "";

end
TS.AddChatCommand( "/rebelclothes", cChangeClothes );

local function cCID( ply, args, call )

	if( ply:GetNWFloat( "cid" ) > 0 ) then
		ply:PrintMessage( 3, "You already have a CID" );
		return "";
	end
	
	if( ply:Team() ~= 1 ) then
		ply:PrintMessage( 3, "Need to be citizen" );
		return "";		
	end
	
	local newcid = tonumber( args );
	
	if( not newcid ) then

		ply:PrintMessage( 3, "Invalid CID" );
		return "";
	
	end
	
	if( newcid < 10000 or newcid > 99999 ) then
	
		ply:PrintMessage( 3, "CIDs must be 5 digits" );
		return "";
		
	end
	
	if( TS.CIDIsTaken( newcid ) ) then
	
		ply:PrintMessage( 3, "This CID is already taken" );
		return "";
	
	end
	
	newcid = math.floor( newcid );
	
	ply:SetCID( newcid );
	table.insert( TS.CIDs, newcid );
	
	ply:SaveField( "CID", ply:GetField( "cid" ) );
	
	local function SaveCID( ply, newcid )
	
		file.Write( "TacoScript/data/cids.txt", ( file.Read( "TacoScript/data/cids.txt" ) or "" ) .. newcid .. " //" .. ply:Nick() .. "\r\n" );
	
	end
	
	timer.Simple( 2, SaveCID, ply, newcid );
	
	return "";
	
end
TS.AddChatCommand( "/cid", cCID );

local function cPM( ply, args, call )

	if( string.find( args, " " ) ) then
	
		local targetname = string.sub( args, 1, string.find( args, " " ) - 1 );
		local target = TS.RunPlayerSearch( ply, targetname, true );
	
		if( target ) then
	
			ply:PrivateMessage( "[PM to " .. target:Nick() .. "] " .. string.sub( args, string.find( args, " " ) + 1 ) );
			target:PrivateMessage( "[PM from " .. ply:Nick() .. "] " .. string.sub( args, string.find( args, " " ) + 1 ) );
			
			TS.DayLog( "chatlog.txt", ply:LogInfo() .. "[PM to " .. target:Nick() .. "] " .. string.sub( args, string.find( args, " " ) + 1 ) );

		end
		
	else
		
		ply:PrintMessage( 3, "Specify a target" );
		
	end
	
	return "";

end
TS.AddChatCommand( "/pm ", cPM );

local function SpeakOOC( ply, args, call )

	if( not ply:IsAdmin() and CurTime() - ply:GetField( "lastooc" ) <= TS.ServerVars["oocdelay"] ) then
	
		TS.Notify( ply, "Wait " .. math.ceil( TS.ServerVars["oocdelay"] - ( CurTime() - ply:GetField( "lastooc" ) ) ), 3 );
		return "";
	
	end

	if( string.lower( call ) == "[ooc]" ) then
	
		AddHelpTip( ply, .05, .5, 285, 68, "You silly little man.  You can just type\n// or /a before your text to speak in OOC\n(Out-Of-Character)" );
		
	end
	
	if( ply:IsAdmin() and TS.ServerVars["oocdelay"] > 0 ) then
	
		TS.Notify( ply, "OOC delay is " .. TS.ServerVars["oocdelay"], 3 );
	
	end
	
	TS.DayLog( "chatlog.txt", "[GLOBAL]" .. ply:LogInfo() .. ": " .. args );
	
	ply:SetField( "lastooc", CurTime() );
	
	return "[OOC] " .. args;

end
TS.AddChatCommand( "//", SpeakOOC );
TS.AddChatCommand( "/a ", SpeakOOC );
TS.AddChatCommand( "((", SpeakOOC );
TS.AddChatCommand( "/ooc", SpeakOOC );
TS.AddChatCommand( "[OOC]", SpeakOOC );

local function SpeakLocalOOC( ply, args, call )

	TS.DayLog( "chatlog.txt", "[LOCAL-OOC]" .. ply:LogInfo() .. ": " .. args );
	
	TS.TalkToRange( ply:Nick() .. ": [LOCAL-OOC] " .. args, ply:EyePos(), TS.ServerVars["talkrange"] );
			
	return "";

end
TS.AddChatCommand( ".//", SpeakLocalOOC );
TS.AddChatCommand( "[[", SpeakLocalOOC );

local function RadioTalk( ply, args, call )

	if( not ply:HasItem( "radio" ) ) then
	
		ply:PrintMessage( 3, "You need a radio" );
		return "";
	
	end
	
	if( math.floor( ply:GetField( "radiofreq" ) ) == 0 ) then
	
		ply:PrintMessage( 3, "0.0 is not a valid radio frequency" );
		return "";
	
	end
	
	if( ply:GetField( "radiofreq" ) > 999.9 ) then
	
		ply:PrintMessage( 3, "Cannot speak in this radio frequency (have to be registered to do so)" );
		return "";
	
	end
	
	if( ply:GetField( "radiofreq" ) < 0 or ply:GetField( "radiofreq" ) > 9999.9 ) then
	
		ply:PrintMessage( 3, "Invalid radio frequency" );
		return "";
	
	end

	TS.TalkToFreq( ply:GetField( "radiofreq" ), ply:Nick() .. ": " .. args );
	TS.TalkToRange( ply:Nick() .. ": " .. args, ply:EyePos(), TS.ServerVars["talkrange"] );
	TS.DayLog( "chatlog.txt", "[RADIO]" .. ply:LogInfo() .. ": " .. args );
				
	return "";

end
TS.AddChatCommand( "/r ", RadioTalk );

local function AddPropertyOwner( ply, args, call )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then

			if( string.find( args, " " ) ) then

				local targetname = string.sub( args, string.find( args, " " ) + 1 );
				
				local target = TS.RunPlayerSearch( ply, targetname, true );
	
				if( target ) then
				
					if( tr.Entity:OwnsProperty( target ) ) then
					
						ply:PrintMessage( 3, target:Nick() .. " already co owns this property" );
					
					else
				
						tr.Entity:OwnProperty( target );
						ply:PrintMessage( 3, target:Nick() .. " has been made co owner of this property" );
					
					end
					
				end
				
			else
			
				ply:PrintMessage( 3, "Specify a target" );
			
			end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/addpropertyowner" , AddPropertyOwner );

local function RemoveDoorOwner( ply, args, call )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then

			if( string.find( args, " " ) ) then

				local targetname = string.sub( args, string.find( args, " " ) + 1 );
				
				local target = TS.RunPlayerSearch( ply, targetname, true );
	
				if( target ) then
				
					if( target == tr.Entity:GetTable().MainOwner ) then
					
						ply:PrintMessage( 3, "Cannot remove main owner" );
						return "";
					
					end
				
					if( tr.Entity:OwnsDoor( target ) ) then
					
						ply:PrintMessage( 3, target:Nick() .. " has been removed from co ownership of this door" );
						tr.Entity:UnownDoor( target );
					
					else
				
						ply:PrintMessage( 3, target:Nick() .. " doesnt co own this door" );
						
					end
					
				end
				
			else
			
				ply:PrintMessage( 3, "Specify a target" );
			
			end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/removedoorowner" , RemoveDoorOwner );


local function RemovePropertyOwner( ply, args, call )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then

			if( string.find( args, " " ) ) then

				local targetname = string.sub( args, string.find( args, " " ) + 1 );
				
				local target = TS.RunPlayerSearch( ply, targetname, true );
	
				if( target ) then
				
					if( target == tr.Entity:GetTable().MainOwner ) then
					
						ply:PrintMessage( 3, "Cannot remove main owner" );
						return "";
					
					end
				
					if( tr.Entity:OwnsAnyOfProperty( target ) ) then
					
						ply:PrintMessage( 3, target:Nick() .. " has been removed from co ownership of this property" );
						tr.Entity:UnownProperty( target );
					
					else
				
						ply:PrintMessage( 3, target:Nick() .. " doesnt co own any of this property" );
						
					end
					
				end
				
			else
			
				ply:PrintMessage( 3, "Specify a target" );
			
			end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/removepropertyowner" , RemovePropertyOwner );


local function GetDoorOwners( ply, args, call )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then

			local tbl = tr.Entity:GetDoorOwnersList();
		
			ply:PrintMessage( 3, "A list has been printed in your console" );
			ply:PrintMessage( 2, "OWNERS: " );
		
			for k, v in pairs( tbl ) do
			
				ply:PrintMessage( 2, v:Nick() );
			
			end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/getdoorowners" , GetDoorOwners );


local function AddDoorOwner( ply, args, call )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then

			if( string.find( args, " " ) ) then

				local targetname = string.sub( args, string.find( args, " " ) + 1 );
				
				local target = TS.RunPlayerSearch( ply, targetname, true );
	
				if( target ) then
				
					if( tr.Entity:OwnsDoor( target ) ) then
					
						ply:PrintMessage( 3, target:Nick() .. " already co owns this door" );
					
					else
				
						tr.Entity:OwnDoor( target );
						ply:PrintMessage( 3, target:Nick() .. " has been made co owner of this door" );
					
					end
					
				end
				
			else
			
				ply:PrintMessage( 3, "Specify a target" );
			
			end
		
		else
		
			ply:PrintMessage( 3, "You don't own this door" );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/adddoorowner" , AddDoorOwner );

local function DoMe( ply, args, call )

	TS.DayLog( "chatlog.txt", "[ACTION]" .. ply:LogInfo() .. " " .. args );
	
	TS.TalkToRange( "**" .. ply:Nick()  .. args, ply:EyePos(), TS.ServerVars["talkrange"] );
			
	return "";

end
TS.AddChatCommand( "/me", DoMe );

local function WriteLetter( ply, args )

	if( ply:HasItem( "paper" ) ) then

		umsg.Start( "msgCreateLetterEditor", ply ); 
			umsg.String( string.sub( string.gsub( args, "//", "\n" ), 2 ) or "" );
		umsg.End();
	
	end
	
	return "";

end
TS.AddChatCommand( "/write", WriteLetter );

local function DropMoney( ply, args )
	
    if( args == "" ) then return ""; end
	
	local amount = tonumber( args );
	
	if( not ply:CanAfford( n ) ) then return ""; end
	
	if( amount < 1 ) then
	
		Notify( ply, 1, 4, "You must drop at least 1 credit." );
		return "";
	
	end
	
	ply:AddMoney( amount * -1 );
	
	local trace = { }
	
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 85;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	local moneybag = ents.Create( "prop_physics" );
	moneybag:SetModel( "models/props/cs_assault/money.mdl" );
	moneybag:SetPos( tr.HitPos );
	moneybag:Spawn();
	
	return "";
end
TS.AddChatCommand( "/dropmoney", DropMoney );
TS.AddChatCommand( "/moneydrop", DropMoney );
TS.AddChatCommand( "/dropcredits", DropMoney );
TS.AddChatCommand( "/creditsdrop", DropMoney );

local function GiveMoney( ply, args )

	local n = tonumber( args );

	if( not n ) then return ""; end

	if( n <= 0 ) then
	
		return "";
	
	end

	if( not ply:CanAfford( n ) ) then return ""; end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 120 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() ) then
	
		n = math.floor( n );
	
		ply:TakeMoney( n );
		tr.Entity:SetNWFloat( "money", n + tr.Entity:GetNWFloat( "money" ) );
		tr.Entity:PrintMessage( 3, ply:Nick() .. " has given you " .. n .. " credits" );
		ply:PrintMessage( 3, "Gave " .. tr.Entity:Nick() .. " " .. n .. " credits" );

		ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
		tr.Entity:SaveField( "charTokens", tr.Entity:GetNWFloat( "money" ) );
		
	end


	return "";

end
TS.AddChatCommand( "/givemoney", GiveMoney );
TS.AddChatCommand( "/givecash", GiveMoney );
TS.AddChatCommand( "/givecredits", GiveMoney );

local function SetDoorTitle( ply, args )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 120 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsOwnable() ) then
	
		if( tr.Entity:OwnsDoor( ply ) ) then
		
			tr.Entity:SetNWString( "doorname", args );
		
		end
	
	end
	
	return "";

end
TS.AddChatCommand( "/doortitle", SetDoorTitle );

local function GiveWeapon( ply, args )

	if( not ply:GetActiveWeapon():IsValid() ) then
	
		ply:PrintMessage( 3, "Must have a weapon out" );
		return "";
	
	end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() ) then
	
		if( tr.Entity:EyePos():Distance( ply:EyePos() ) <= 50 ) then
		
			local activeweap = ply:GetActiveWeapon();
			
			ply:StripWeapon( activeweap:GetClass() );
			ply:RemoveTSAmmo( activeweap:GetClass() );
			--Remove weapon
			
			local ammotype = activeweap:GetPrimaryAmmoType();
			local count = ply:GetAmmoCount( ammotype );
			
			ply:RemoveAmmo( count, ammotype );
			
			ply:RemoveInventoryWeapon( activeweap:GetClass() );
			
			tr.Entity:ForceGive( activeweap:GetClass() );
		
			ply:SaveItems();
			tr.Entity:SaveItems();
		
		else
		
			ply:PrintMessage( 3, "Not close enough to player" );
		
		end
		
	else
	
		ply:PrintMessage( 3, "Must be looking at a player" );
	
	end
	
	return "";

end
TS.AddChatCommand( "/givegun", GiveWeapon );
TS.AddChatCommand( "/giveweapon", GiveWeapon );

local function DropWeapon( ply, args )
--[[
	if( true ) then
	
		ply:PrintMessage( 3, "Disabled due to abuse" );
		return "";
	
	end
]]--
	if( not ply:GetActiveWeapon():IsValid() ) then
	
		ply:PrintMessage( 3, "Must have a weapon out" );
		return "";
	
	end	

	ply:DropWeapon();

	ply:SaveItems();

	return "";

end
TS.AddChatCommand( "/dropgun", DropWeapon );
TS.AddChatCommand( "/dropweapon", DropWeapon );

local function Whisper( ply, args )

	TS.TalkToRange( ply:Nick() .. ": [WHISPER] " .. args, ply:EyePos(), TS.ServerVars["whisperrange"] );
	
	TS.DayLog( "chatlog.txt", "[WHISPER]" .. ply:LogInfo() .. ": " .. args );
	
	return "";
		
end
TS.AddChatCommand( "/w ", Whisper );

local function Yell( ply, args )

	TS.TalkToRange( ply:Nick() .. ": [YELL] " .. args, ply:EyePos(), TS.ServerVars["yellrange"] );
	
	TS.DayLog( "chatlog.txt", "[YELL]" .. ply:LogInfo() .. ": " .. args );
	
	return "";
		
end
TS.AddChatCommand( "/y ", Yell );
TS.AddChatCommand( "/yell ", Yell );

local function Anon( ply, args )

	TS.PrintMessageAll( 2, ply:Nick() .. " used anon talk" );
	TS.TalkToRange( "???: " .. args, ply:EyePos(), TS.ServerVars["talkrange"] );
	
	TS.DayLog( "chatlog.txt", "[ANON]" .. ply:LogInfo() .. ": " .. args );
	
	return "";	

end
TS.AddChatCommand( "/an ", Anon );

local function SetTitle( ply, args, call )

	if( string.len( args ) > 32 ) then
	
		ply:PrintMessage( 3, "Title too long" );
		return "";
	
	end

	if( call == "/job " and ply:GetField( "jobnotify" ) == 0 ) then
		AddHelpTip( ply, .05, .5, 285, 68, "/job!?  You're not setting your job, you're\nsetting your character's title.  Sorry, but\nthere are no magical pay days for setting\nyour job anymore!" );
		ply:SetField( "jobnotify", 1 );
	end
	
	ply:SetNWString( "title", args );
	
	return "";

end
TS.AddChatCommand( "/title ", SetTitle );
TS.AddChatCommand( "/job ", SetTitle );

local function Advertise( ply, args, call )

	if( not ply:CanAfford( 25 ) ) then 
		ply:PrintMessage( 2, "Need 25 credits to advertise" );
		return ""; 
	end
	
	ply:TakeMoney( 25 );
	
	ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
	
	TS.PrintMessageAll( 2, ply:Nick() .. " created an advertisement: " );
	TS.PrintMessageAll( 3, "[ADVERTISEMENT] " .. args, true );
	return "";

end
TS.AddChatCommand( "/adv ", Advertise );

local function Passout( ply, args, call )

	if( ply:GetField( "isko" ) == 0 ) then

		ply:GoUnconscious();
		ply:SetField( "passedout", 1 );
		ply:SetNWFloat( "conscious", 0 );
		
		umsg.Start( "SendPrivateInt", ply );
			umsg.String( "passedout" );
			umsg.Short( 1 );
		umsg.End();
		
	end
	
	return "";

end
TS.AddChatCommand( "/passout", Passout );

local function GetUp( ply, args, call )

	if( ply:GetField( "isko" ) == 1 and ply:GetField( "passedout" ) == 1 and ply:GetNWFloat( "conscious" ) >= 100 ) then

		ply:GoConscious();
		ply:SetField( "passedout", 0 );
		
		ply:SetPrivateInt( "passedout", 0 );
		
	end
	
	return "";	

end
TS.AddChatCommand( "/getup", GetUp );

--[[local function CPRequest( ply, args, call )

	if( ply:IsCombineDefense() ) then return ""; end

	TS.TalkToFreq( TS.CombineRadioFreq, ply:Nick() .. ": [COMBINE-REQUEST]" .. args );
	
	TS.DayLog( "chatlog.txt", "[LOCAL]" .. ply:LogInfo() .. ": " .. args );
	TS.TalkToRange( ply:Nick() .. ": " .. args, ply:EyePos(), TS.ServerVars["talkrange"] );		

	ply:PrintMessage( 3, "Request sent" );

	return "";

end
TS.AddChatCommand( "/cr ", CPRequest );--]]

local function Broadcast( ply, args, call )

	if( not ply:IsCombine() ) then
		return "";
	end

	TS.PrintMessageAll( 3, "[BROADCAST]" .. ply:Nick() .. ": " .. args, true );
	return "";

end
TS.AddChatCommand( "/bc", Broadcast );
--[[
local function cBecomeCA( ply, args, call )

	if( ply:CanBecomeCA() ) then
		ply:BecomeCA();
	end
	
	return "";

end
TS.AddChatCommand( "/ca", cBecomeCA );


local function cBecomeCE( ply, args, call )

	if( ply:CanBecomeCE() ) then
		ply:BecomeCE();
	end
	
	return "";

end
TS.AddChatCommand( "/ce", cBecomeCE );
--]]

local function cBecomeNRD( ply, args, call )

	if( ply:CanBecomeNRD() ) then
		ply:BecomeNRD();
	end
	
	return "";

end
TS.AddChatCommand( "/nrd", cBecomeNRD );

local function cBecomeNSRF( ply, args, call )

	if( ply:CanBecomeNSRF() ) then
		ply:BecomeNSRF();
	end
	
	return "";

end
TS.AddChatCommand( "/nsrf", cBecomeNSRF );
--[[
local function cBecomeGHM( ply, args, call )

	if( true ) then
	
		ply:PrintMessage( 3, "Currently disabled" );
		return "";
	
	end

	if( ply:HasPlayerFlag( "G" ) ) then
	
		ply:SetTeam( 6 );
		ply:SlaySilent();
	
	end
	
	return "";

end
TS.AddChatCommand( "/ghm", cBecomeGHM );

local function cBecomeOW( ply, args, call )

	if( ply:CanBecomeOW() ) then
		ply:BecomeOW();
	end
	
	return "";

end
TS.AddChatCommand( "/ow", cBecomeOW );

local function cBecomeStalker( ply, args, call )

	if( ply:HasPlayerFlag( "S" ) ) then
	
		ply:PrintMessage( 3, "Became Stalker" );
		ply:SetModel( "models/stalker.mdl" );
		ply:SelectWeapon( "ts_keys" );
		ply:GetTable().StalkerMode = true;
	
	end
	
	return "";

end
TS.AddChatCommand( "/stalker", cBecomeStalker );

local function cBecomeVortigaunt( ply, args, call )

	if( ply:HasPlayerFlag( "V" ) ) then
	
		ply:PrintMessage( 3, "Became Vortigaunt" );
		ply:SetModel( "models/vortigaunt.mdl" );
		ply:SelectWeapon( "ts_keys" );
	
	end
	
	return "";

end
TS.AddChatCommand( "/vort", cBecomeVortigaunt );
--]]
local function cBecomeCitizen( ply, args, call )

	ply:BecomeCitizen();
	
	return "";

end
TS.AddChatCommand( "/survivor", cBecomeCitizen );

local function cKick( ply, args, call )

	ply:ConCommand( "rp_kick " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!kick", cKick );

local function cBan( ply, args, call )

	ply:ConCommand( "rp_ban " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!ban", cBan );

local function cSlay( ply, args, call )

	ply:ConCommand( "rp_slay " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!slay", cSlay );

local function cSlap( ply, args, call )

	ply:ConCommand( "rp_slap " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!slap", cSlap );

local function cExplode( ply, args, call )

	ply:ConCommand( "rp_explode " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!explode", cExplode );

local function cASay( ply, args, call )

	ply:ConCommand( "rp_asay " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!a", cASay );

local function cGoto( ply, args, call )

	ply:ConCommand( "rp_goto " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!goto", cGoto );

local function cBring( ply, args, call )

	ply:ConCommand( "rp_bring " .. args .. "\n" );
	
	return "";

end
TS.AddChatCommand( "!bring", cBring );

local function cNoclip( ply, args, call )

	ply:ConCommand( "rp_noclip\n" );
	
	return "";

end
TS.AddChatCommand( "!noclip", cNoclip );

local function DoIt( ply, args, call )

	----TS.DayLog( "chatlog.txt", "[ACTION]" .. ply:LogInfo() .. " " .. args );
	
	TS.TalkToRange( "**" .. args .. "**", ply:EyePos(), TS.ServerVars["talkrange"] );
			
	return "";

end
TS.AddChatCommand( "/it", DoIt );


local function Event( ply, args, call )

	if( not ply:IsAdmin() ) then
		return "";
	end

	TS.PrintMessageAll( 3, "[EVENT]**" .. args .. "**" );
	return "";

end
TS.AddChatCommand( "/ev", Event );
