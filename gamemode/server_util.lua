
function TS.GetConsoleNick( ply )

	if( ply:EntIndex() == 0 ) then
		return "Console";
	else
		return ply:Nick();
	end
	
end

function TS.FragTimedThrow( self, force )


	local pos = self.Owner:GetPos() + Vector( 0, 0, 40 ) + self.Owner:GetForward() * 15 + self.Owner:GetRight() * 15;
	
	if( self.Owner:Crouching() ) then
	
		pos = pos - Vector( 0, 0, 30 ) - self.Owner:GetForward() * 10 - self.Owner:GetRight() * 18;
	
	end
	
	local nade = ents.Create( "prop_physics" );
	nade:SetPos( pos );
	nade:SetAngles( self.Owner:GetAngles() );
	nade:SetModel( "models/weapons/w_grenade.mdl" );
	nade:Spawn();
	
	nade:SetOwner( self.Owner );


	timer.Simple( .1, nade:GetPhysicsObject().SetVelocity, nade:GetPhysicsObject(), ( self.Owner:EyeAngles():Forward() * ( 800 * force ) ) + self:GetUp() * 150 );
	
	local function RemoveNade( nade )
	
		local exp = ents.Create( "env_explosion" );
			exp:SetKeyValue( "spawnflags", 128 );
			exp:SetPos( nade:GetPos() );
		exp:Spawn();
		exp:Fire( "explode", "", 0 );
	
		local exp = ents.Create( "env_physexplosion" )
			exp:SetKeyValue( "magnitude", 200 )
			exp:SetPos( nade:GetPos() );
		exp:Spawn();
		exp:Fire( "explode", "", 0 );

		if( nade and nade:IsValid() ) then
			timer.Simple( .2, nade.Remove, nade );
		end
	
	end
	
	timer.Simple( 1.6, RemoveNade, nade );
	
end


function TS.CIDIsTaken( cid )

	for k, v in pairs( TS.CIDs ) do
	
		if( v == cid ) then
			return true;
		end
	
	end
	
	return false;

end

function TS.CreateItem( id, pos, ang )

	local item = ents.Create( "item_prop" );
		item:SetModel( TS.ItemData[id].Model );
		item:SetData( TS.ItemData[id] );
		item:SetPos( pos );
		item:SetAngles( ang or Angle( 0, 0, 0 ) );
	item:Spawn();
	
	if( TS.ItemData[id].PostSpawn ) then
		TS.ItemData[id].PostSpawn( TS.ItemData[id], item );
	end
	
	return item;

end

TS.LetterNum = 0;

function TS.LetterPickup( ply, ent, item )

	if( ent:GetTable().Welded == nil ) then
		ent:GetTable().Welded = false;
	end

	umsg.Start( "DisplayLetter", ply );
		umsg.Bool( !ent:GetTable().Welded );
		umsg.Entity( ent );
	umsg.End();
	
	if( not ent:GetTable().Welded ) then
	
		ply:SetField( "letter.Ent", ent:EntIndex() );
		ply:SetField( "letter.Item", item.UniqueID );
	
	end
	
	local sub = 1;
	
	while sub < string.len( item.Message ) do
	
		umsg.Start( "SendLetterPiece", ply );
			umsg.String( string.sub( item.Message, sub, sub + 254 ) );
		umsg.End();
		
		sub = sub + 255;
	
	end

end

function TS.LetterUse( ply, item )

	umsg.Start( "DisplayLetter", ply );
		umsg.Bool( false );
	umsg.End();	
	
	local sub = 1;
	
	if( string.len( item.Message ) > 1024 ) then return; end
	
	while sub < string.len( item.Message ) do
	
		umsg.Start( "SendLetterPiece", ply );
			umsg.String( string.sub( item.Message, sub, sub + 254 ) );
		umsg.End();
		
		sub = sub + 255;
	
	end

end

function TS.CreateLetter( msg, pos, handwritten, noprop )

	msg = string.sub( msg, 1, 1024 );

	if( not handwritten ) then 
		handwritten = 1;
	end

	TS.LetterNum = TS.LetterNum + 1;
	
	local title;

	if( string.find( msg, "(%w+)" ) ) then
		title = string.sub( msg, string.find( msg, "(%w+)" ) );
	end
	
	if( string.find( title, "\n" ) ) then
	
		title = string.sub( title, 1, string.find( title, "\n" ) - 1 );
	
	end

	if( string.len( msg ) > 10 ) then
	 title = title .. "...";
	end
	
	local id = TS.CreateTempItem( "ts_letter" .. TS.LetterNum, string.gsub( title, "\n", "" ), .4, .01, "models/props_c17/paper01.mdl", "Written letter" )
	TS.ItemData[id].Message = msg;
	TS.ItemData[id].PickupFunc = TS.LetterPickup;
	TS.ItemData[id].UseFunc = TS.LetterUse;
	TS.ItemData[id].Usable = true;
	TS.ItemData[id].HandWritten = handwritten;
	
	if( not noprop ) then
		local ent = TS.CreateItem( id, pos );
		ent:SetNWBool( "CanRead", true );
	end
	
end

function TS.GiveEconomy( val )

	local n = GetGlobalFloat( "EconomyMoney" );

	SetGlobalFloat( "EconomyMoney", n + val );
	file.Write( "TacoScript/data/economymoney.txt", GetGlobalFloat( "EconomyMoney" ) );

end

function TS.TalkToFreq( freq, text )
	
	for k, v in pairs( player.GetAll() ) do

		if( v:HasItem( "radio" ) and v:GetField( "radiofreq" ) == freq ) then

			v:PrintMessage( 2, text );

			umsg.Start( "AddChatLine", v );
				umsg.String( text );
			umsg.End();
			
		end
		
	end

end

function TS.BusinessHasItem( id, item )

	local n = TS.GetBusinessInt( id, "itemcount" );
	
	for j = 1, n do
	
		if( TS.GetBusinessString( id, "item." .. j .. ".name" ) == item ) then
		
			return true;
		
		end
	
	end
	
	return false;

end

function TS.RemoveBusinessItem( id, item )

	local n = TS.GetBusinessInt( id, "itemcount" );

	for j = 1, n do
	
		if( TS.GetBusinessString( id, "item." .. j .. ".name" ) == item ) then
			TS.SetBusinessInt( id, "item." .. j .. ".count", TS.GetBusinessInt( id, "item." .. j .. ".count" ) - 1 );
		
			if( TS.GetBusinessInt( id, "item." .. j .. ".count" ) <= 0 ) then
		
				local rec = RecipientFilter();
				
				for k, v in pairs( player.GetAll() ) do
				
					if( v:GetNWInt( "businessid" ) == id ) then
					
						rec:AddPlayer( v );
					
					end
				
				end
				
				umsg.Start( "TakeStoreItem", rec );
					umsg.String( item );
				umsg.End();
				
			end
		
		end
			
	end
	
	--if( TS.GetBusinessInt( id, "item." .. n .. ".count" ) <= 0 ) then

	--	TS.SetBusinessInt( id, "itemcount", TS.GetBusinessInt( id, "itemcount" ) - 1 );
	
	--end

end

function TS.RemoveSupplyLicenses( id  )

	for n = 1, 5 do
		TS.SetBusinessInt( id, "haslicense." .. n, 0 );
	end

end

function TS.GetSupplyLicenseString( id ) 

	local str = "";

	for n = 1, 5 do
	
		if( TS.HasSupplyLicense( id, n ) ) then
		
			str = str .. n .. ";";
		
		end		

	end	
	
	return str;

end

function TS.HasSupplyLicense( id, license )

	if( TS.GetBusinessInt( id, "haslicense." .. license ) == 1 ) then
		return true;
	end
	
	return false;

end

function TS.AddSupplyLicense( id, license )

	TS.SetBusinessInt( id, "haslicense." .. license, 1 );

end

function TS.AddBusinessItem( id, item )

	local n = TS.GetBusinessInt( id, "itemcount" );

	if( not TS.BusinessHasItem( id, item ) ) then

		TS.SetBusinessInt( id, "itemcount", TS.GetBusinessInt( id, "itemcount" ) + 1 );
		n = n + 1;
		
		TS.SetBusinessInt( id, "item." .. n .. ".count", TS.GetBusinessInt( id, "item." .. n .. ".count" ) + TS.ItemData[item].FactoryStock );
		TS.SetBusinessString( id, "item." .. n .. ".name", item );

	else
	
		for j = 1, n do
	
			if( TS.GetBusinessString( id, "item." .. j .. ".name" ) == item ) then
				TS.SetBusinessInt( id, "item." .. j .. ".count", TS.GetBusinessInt( id, "item." .. j .. ".count" ) + TS.ItemData[item].FactoryStock );
			end
			
		end
	
	end

end


function TS.GetTeamData( id )


	for k, v in pairs( TS.TeamData ) do
	
		if( v.ID == id ) then
		
			return TS.TeamData[k];
		
		end
	
	end

end

function TS.FindPlayer( name, filtertable )

	local ply = nil;
	
	filtertable = filtertable or { }
	
	for k, v in pairs( player.GetAll() ) do
	
		if( not table.HasValue( filtertable, v ) ) then
			
			if( string.find( v:Nick(), name ) ) then
				ply = v;
			end
		
			if( v:SteamID() == name ) then
				ply = v;
			end
		
		end
	
	end
	
	return ply;

end

function TS.RunPlayerSearch( ply, name, chatsend, send )

	if( send == nil ) then send = true; end

	local possible = { }
	
	if( ply:EntIndex() == 0 ) then
		chatsend = false;
	end
	
	for k, v in pairs( player.GetAll() ) do
	
		local newply = TS.FindPlayer( name, possible );
		
		if( not newply ) then
			break;
		else
			table.insert( possible, newply );
		end
	
	end
	
	if( #possible > 1 ) then
	
		if( send ) then 
		
			TS.SendConsole( ply, "Multiple players found with that name/ID" );
			
			if( chatsend ) then
				ply:PrintMessage( 3, "Multiple players found with that name/ID" );
			end
			
		end
		
		return nil;
	
	end
	
	if( #possible == 0 ) then
	
		if( send ) then 
	
			TS.SendConsole( ply, "No player found with that name/ID" );
			
			if( chatsend ) then
				ply:PrintMessage( 3, "No player found with that name/ID" );
			end
			
		end
		
		return nil;
			
	end
	
	return possible[1];

end

function TS.IncludeResourcesInFolder( dir )

	local files = file.FindInLua( "TacoScript/content/" .. dir .. "*" );

	for k, v in pairs( files ) do

		if( string.find( v, ".vmt" ) or string.find( v, ".vtf" ) or string.find( v, ".mdl" ) ) then
		
			resource.AddFile( dir .. v );
		
		end
	
	end

end

function FreezeRagdoll( ent )

	--THIS SHIT IS FROM GARRY'S STATUE TOOL
	
	if( ent:GetTable().StatueInfo ) then
		return;
	end
 	 
 	ent:GetTable().StatueInfo = {} 
 	ent:GetTable().StatueInfo.Welds = {} 
 	 
 	local bones = ent:GetPhysicsObjectCount() 
 	 
 	local forcelimit = 0 
 	 
 	// Weld each physics object together 
 	for bone=1, bones do 
 	 
 		local bone1 = bone - 1 
 		local bone2 = bones - bone 
 		 
 		// Don't do identical two welds 
 		if ( !ent:GetTable().StatueInfo.Welds[bone2] ) then 
 		 
 			local constraint1 = constraint.Weld( ent, ent, bone1, bone2, forcelimit ) 
 			 
 			if ( constraint1 ) then 
 			 
 				ent:GetTable().StatueInfo.Welds[bone1] = constraint1 
 			 
 			end 
 			 
 		end 
 		 
 		local constraint2 = constraint.Weld( ent, ent, bone1, 0, forcelimit ) 
 		 
 		if ( constraint2 ) then 
 		 
 			ent:GetTable().StatueInfo.Welds[bone1+bones] = constraint2 
 		 
 		end 
 		 
 	end 

end