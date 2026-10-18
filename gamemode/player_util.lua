
--Adds help tip to the screen (like the /job text)
--x and y should NOT be bigger then 1 or smaller then 0.  
--These coordinates are multiplied by the client's screen width and height.
function AddHelpTip( ply, x, y, w, h, text )

	DrawFadingRect( ply, x, y, w, h, 4, 40, 40, 40, 255, 10.0, 200 );
	DrawFadingText( ply, x, y, "ChatFont", text, 0, 255, 255, 255, 255, 10.0, 200, false, 4, 4 );

end

function TS.PrintMessageAll( type, msg, ic )
	
	if( ic == nil ) then ic = false; end
	ic = !ic;
	
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( type, msg, ic );
	end

end

function DrawFadingText( ply, x, y, font, str, align, r, g, b, a, delay, speed, forever, xo, yo )

	umsg.Start( "FadingText", ply );
		umsg.Float( x ); umsg.Float( y );
		umsg.String( font ); umsg.String( str );
		umsg.Short( align );
		umsg.Short( r ); umsg.Short( g ); umsg.Short( b ); umsg.Short( a );
		umsg.Short( delay ); 
		umsg.Short( speed );
		umsg.Bool( forever );
		umsg.Short( xo ); umsg.Short( yo );
	umsg.End();
	
end

function DrawFadingRect( ply, x, y, w, h, round, r, g, b, a, delay, speed )

	umsg.Start( "FadingRect", ply );
		umsg.Float( x ); umsg.Float( y );
		umsg.Short( w ); umsg.Short( h );
		umsg.Short( round );
		umsg.Short( r ); umsg.Short( g ); umsg.Short( b ); umsg.Short( a );
		umsg.Short( delay ); 
		umsg.Short( speed );
	umsg.End();
	
end

local meta = FindMetaTable( "Player" );

if( not meta["GetFriendsNick"] ) then
	meta["GetFriendsNick"] = meta["Nick"];
end
function meta:Nick()

	return self:GetField( "gamename" ) or "";

end

--Hopefully this will fix the Snapshot Overflow Error
function meta:DoUmsg( msg )
	if( msg != nil) then
		if( self != nil) then
			umsg.Start( msg, self );
			umsg.End();
		end
	end
end

--[[function meta:DoUmsg( msg )

	umsg.Start( msg, self );
	umsg.End();
	
end--]]

function meta:SetPrivateInt( name, val )

	umsg.Start( "SendPrivateInt", self );
		umsg.String( name );
		umsg.Short( val );
	umsg.End();

end

function meta:SetPrivateFloat( name, val )

	umsg.Start( "SendPrivateFloat", self );
		umsg.String( name );
		umsg.Float( val );
	umsg.End();

end

function meta:SetPrivateString( name, val )

	umsg.Start( "SendPrivateString", self );
		umsg.String( name );
		umsg.String( val );
	umsg.End();

end


if( SinglePlayer() ) then

	function meta:IsSuperAdmin() 
		return true;
	end

	function meta:IPAddress()
	
		return "127.0.0.1";
	
	end
	
	function meta:SteamID()
	
		return "STEAM_ID_LAN";
	
	end
	

end

function meta:IsRDA()

	return self:IsUserGroup( "rda" );

end

function meta:IsAdmin()

	return ( self:IsUserGroup( "rda" ) or self:IsUserGroup( "admin" ) or self:IsSuperAdmin() );

end

function meta:AddMaxStamina( val )

	self:SetField( "MaxStamina", math.Clamp( self:GetField( "MaxStamina" ) + val, 18, 100 ) );

end

local FuncPrintMessage = meta.PrintMessage;

function meta:PrivateMessage( msg )
	
	local teamcolor = team.GetColor( self:Team() );

	umsg.Start( "AddPrintMessage", self );
		umsg.String( msg );
		umsg.Vector( Vector( 91, 166, 221, teamcolor.a ) );
		umsg.Short( 3 );
	umsg.End();
	
end

function meta:PrintMessage( type, msg, ooc )

	if( type ~= 3 ) then
		FuncPrintMessage( self, type, msg );
		return;
	end
	
	local teamcolor = team.GetColor( self:Team() );

	umsg.Start( "AddPrintMessage", self );
		umsg.String( msg );
		umsg.Vector( Vector( 91, 166, 221, teamcolor.a ) );
		if( ooc ) then
			umsg.Short( 1 );
		else
			umsg.Short( 2 );
		end
	umsg.End();
	
	FuncPrintMessage( self, 2, string.gsub( msg, "^p", "%" ) );

end

function meta:MakeSayGlobal( text )

	if( string.gsub( text, " ", "" ) == "" ) then
	
		return;
	
	end

	local teamcolor = team.GetColor( self:Team() );

	umsg.Start( "AddToChatBox" );
		umsg.String( self:Nick() .. ":" );
		umsg.String( self:Nick() .. ": " .. text );
		umsg.Vector( Vector( teamcolor.r, teamcolor.g, teamcolor.b, teamcolor.a ) );
		umsg.Vector( Vector( 255, 255, 255 ) );
		umsg.Short( 4 );
	umsg.End();

end

function meta:RemoveAllTSAmmo()

	if( true ) then return; end

	for k, v in pairs( self:GetWeapons() ) do
	
		v:GetTable().TSAmmoCount = 0;
		
		local ammotype = v:GetTable().TSAmmo;

		self:GetTable().AmmoCount[ammotype] = 0;
	
	end

end

function meta:RemoveTSAmmo( class )

	if( true ) then return; end

	local ammotype = self:GetWeapon( class ):GetTable().TSAmmo;

	self:GetTable().AmmoCount[ammotype] = self:GetTable().AmmoCount[ammotype] - self:GetWeapon( class ):GetTable().TSAmmoCount;
	
end

function meta:ResetGroupInfo()

	self:SetField( "group_id", 1 );
	self:SetField( "group_max_balloons", 0 );
	self:SetField( "group_max_dynamite", 0 );
	self:SetField( "group_max_effects", 0 );
	self:SetField( "group_max_hoverballs", 0 );
	self:SetField( "group_max_lamps", 0 );
	self:SetField( "group_max_npcs", 0 );
	self:SetField( "group_max_props", 0 );
	self:SetField( "group_max_ragdolls", 0 );
	self:SetField( "group_max_thrusters", 0 );
	self:SetField( "group_max_vehicles", 0 );
	self:SetField( "group_max_wheels", 0 );
	self:SetField( "group_max_turrets", 0 );
	self:SetField( "group_max_sents", 0 );
	self:SetField( "group_max_spawners", 0 );
	self:SetField( "group_hastoolgun", 0 );

end

function meta:SetCID( cid )

	self:SetField( "cid", cid );
	self:SetPrivateFloat( "cid", cid );

end

function meta:ClearInventory()

	self:SetField( "Inventory", { } );
	
	self:SetField( "inventory.CrntSize", 0 );
	self:SetPrivateFloat( "inventory.CrntSize", 0 );
	
	self:SetPrivateFloat( "inventory.MaxSize", 4 );
	self:SetField( "inventory.MaxSize", 4 );
	
	umsg.Start( "ResetInventory", self ); umsg.End();

end

function meta:IsPhysgunBanned()

	for k, v in pairs( TS.PhysgunBans ) do
	
		if( v[1] == self:SteamID() ) then
			return true;
		end
	
	end
	
	return false;

end

function meta:GiveDefaultLoadout()

	if( not self:IsPhysgunBanned() and not self:HasWeapon( "weapon_physgun" ) ) then
		self:ForceGive( "weapon_physgun" );
	end
	
	if( not self:HasWeapon( "weapon_physcannon" ) ) then
		self:ForceGive( "weapon_physcannon" );
	end
	
	if( not self:HasWeapon( "ts_keys" ) ) then
		self:ForceGive( "ts_keys" );
	end
	
	if( not self:HasWeapon( "ts_hands" ) ) then
		self:ForceGive( "ts_hands" );
	end
	
	if( not self:HasWeapon( "ts_medic" ) ) then
		self:ForceGive( "ts_medic" );
	end

	if( self:IsToolTrusted() ) then

		if( not self:HasWeapon( "gmod_tool" ) ) then
			self:ForceGive( "gmod_tool" );
		end
	
	end

end

--Get player's log info. (Nick + SteamID)
function meta:LogInfo()

	return self:Nick() .. " (" .. self:SteamID() .. ")";

end


--Checks if player can afford something
function meta:CanAfford( money )

	if( self:GetNWFloat( "money" ) - money < 0 ) then return false; end
	
	return true;
	
end

--Remove money
function meta:TakeMoney( money )

	self:SetNWFloat( "money", self:GetNWFloat( "money" ) - money );

end

function meta:GiveMoney( money )
	
	self:SetNWFloat( "money", self:GetNWFloat( "money" ) + money );
	
end

function meta:OverrideAnimation( sequence, time )

	local id = self:LookupSequence( sequence );
	
	self:SetField( "CrntActID", id );
	self:SetField( "OverrideAnim", true );
	self:Freeze( true );
	
	self:SetSequence( id );
	
	if( time ) then
	
		local function EndAnim( ply )
		
			ply:SetField( "OverrideAnim", false );
			ply:Freeze( false );
			ply:SetPos( ply:GetPos() );
			
		end
		
		timer.Simple( time, EndAnim, self );
	
	end

end

function meta:TryDoorRam()

	if( self:GetField( "isko" ) == 1 or self:GetNWInt( "tiedup" ) == 1 ) then
		return;
	end

  	if( CurTime() - self:GetField( "LastDoorKick" ) > 1.7 ) then

		if( not self:OnGround() ) then return; end

		if( self:GetNWInt( "holstered" ) == 1 ) then
		
			--self:PrintMessage( 3, "Need to be unholstered" );
			return;
		
		end

		local trace = { }
		trace.start = self:EyePos();
		trace.endpos = trace.start + self:GetAimVector() * 75;
		trace.filter = self;
		
		local tr = util.TraceLine( trace );
		
		if( ValidEntity( tr.Entity ) and tr.Entity:IsDoor() and tr.Entity:GetNWInt( "doorstate" ) ~= 7  ) then
		
			self:SetField( "LastDoorKick", CurTime() );
		
			if( tr.Entity:GetPos():Distance( self:GetPos() ) > 65 ) then
			
				tr.Entity:EmitSound( Sound(  "physics/wood/wood_box_impact_hard3.wav" ) );
			
				if( SERVER ) then
				
					self:ViewPunch( Angle( -25, 0, 0 ) );
					self:SetVelocity( Vector( self:GetAimVector().x, self:GetAimVector().y, 0 ) * 500 );
					
					local team = self:Team();
					local dounlock = false;
					
					if( team == 1 ) then
						if( math.random( 1, 5 ) == 2 ) then
							dounlock = true;
						end
					elseif( team == 2 ) then
						if( math.random( 1, 2 ) == 2 ) then
							dounlock = true;
						end
					else
						dounlock = true;
					end
					
					if( dounlock ) then
					
						tr.Entity:Fire( "unlock", "", 0 );
						self:ConCommand( "+use\n" );
						timer.Simple( .1, self.ConCommand, self, "-use\n" );
						
					end
					
				end
			
			else
				self:PrintMessage( 3, "Too close to door" );
			end
		
		end
		
	end

end

--Drop weapon
function meta:DropCertainWeapon( class )

	local undroppable = {
	
		"ts_hands",
		"ts_keys",
		"ts_medic"
	
	}

	for k, v in pairs( undroppable ) do
	
		if( v == class ) then
		
			self:PrintMessage( 3, "Cannot drop this" );
			return;
		
		end
	
	end

	local weap = self:GetActiveWeapon();
	
	local ent = ents.Create( class );
	ent:SetAngles( weap:GetAngles() );
	ent:SetPos( weap:GetPos() );
	ent:Spawn();
	
	--ent:GetTable().TSAmmoCount = weap:GetTable().TSAmmoCount;
	
	self:StripWeapon( class );
	--self:RemoveTSAmmo( class );
	--Remove weapon
	
	--local ammotype = weap:GetPrimaryAmmoType();
	--local count = self:GetAmmoCount( ammotype );
	
	--self:RemoveAmmo( count, ammotype );
	
	self:RemoveInventoryWeapon( class );
			

end

--Drop weapon
function meta:DropWeapon()

	local undroppable = {
	
		"ts_hands",
		"ts_keys",
		"ts_medic"
	
	}
	
	local class = self:GetActiveWeapon():GetClass();
	
	for k, v in pairs( undroppable ) do
	
		if( v == class ) then
		
			self:PrintMessage( 3, "Cannot drop this" );
			return;
		
		end
	
	end

	local weap = self:GetActiveWeapon();
	
	local ent = ents.Create( weap:GetClass() );
	ent:SetAngles( weap:GetAngles() );
	ent:SetPos( weap:GetPos() );
	ent:Spawn();
	
	ent:GetTable().TSAmmoCount = weap:GetTable().TSAmmoCount;
	
	self:StripWeapon( weap:GetClass() );
	self:RemoveTSAmmo( weap:GetClass() );
	--Remove weapon
	
	local ammotype = weap:GetPrimaryAmmoType();
	local count = self:GetAmmoCount( ammotype );
	
	self:RemoveAmmo( count, ammotype );
	
	self:RemoveInventoryWeapon( weap:GetClass() );
			

end

function meta:DropLastPlayerWeapon()

	local weap = self:GetNWString( "lastweapon" );
	
	local ent = ents.Create( weap );
	ent:SetAngles( self:GetAngles() );
	ent:SetPos( self:GetPos() + Vector( 0, 0, 32 ) );
	ent:Spawn();
	
end

function meta:SetTitle( str )

	self:SetNWString( "title", str );

end

function meta:SetJob( str )

	self:SetField( "job", str );
	self:SetPrivateString( "job", str );

end
--[[
function meta:BecomeCA()

	self:SetTeam( 5 );
	self:SlaySilent();
	
	self:SetJob( "Combine City Administrator" );
	self:SetTitle( "City Administrator" );

end
--]]
function meta:BecomeNRD()

	self:SetTeam( 2 );
	self:SlaySilent();
	
	self:SetJob( "National Republic Dawn" );
	self:SetTitle( "National Republic Dawn" );

end

function meta:BecomeNSRF()

	self:SetTeam( 3 );
	self:SlaySilent();
	
	self:SetJob( "New Soviet Revolutionary Front" );
	self:SetTitle( "New Soviet Revolutionary Front" );

end
--[[
function meta:BecomeOW()

	self:SetTeam( 3 );
	self:SlaySilent();
	
	self:SetJob( "Combine OverWatch Military" );
	self:SetTitle( "OverWatch" );
	
	self:SetField( "radiofreq", tonumber( TS.CombineRadioFreq ) );
	self:SetPrivateFloat( "radiofreq", tonumber( TS.CombineRadioFreq ) );

	self:SetField( "stat.StrengthModifier", 0 );
	self:SetField( "stat.SpeedModifier", 0 );
	self:SetField( "stat.SprintModifier", 0 );
	self:SetField( "stat.EnduranceModifier", 0 );
	self:SetField( "stat.AimModifier", 0 );
	self:SetField( "stat.MedicModifier", 0 );
	self:SetField( "stat.SneakModifier", 0 );
	
	self:TempStatBoost( "Strength", 20, 0 )
	self:TempStatBoost( "Endurance", 30, 0 );
	self:TempStatBoost( "Sprint", 20, 0 );
	
end

function meta:BecomeCE()

	self:SetTeam( 4 );
	self:SlaySilent();
	
	self:SetJob( "Combine Elite OverWatch Military" );
	self:SetTitle( "Elite OverWatch" );
	
	self:SetField( "radiofreq", tonumber( TS.CombineRadioFreq ) );
	self:SetPrivateFloat( "radiofreq", tonumber( TS.CombineRadioFreq ) );
	
	self:SetField( "stat.StrengthModifier", 0 );
	self:SetField( "stat.SpeedModifier", 0 );
	self:SetField( "stat.SprintModifier", 0 );
	self:SetField( "stat.EnduranceModifier", 0 );
	self:SetField( "stat.AimModifier", 0 );
	self:SetField( "stat.MedicModifier", 0 );
	self:SetField( "stat.SneakModifier", 0 );

	self:TempStatBoost( "Strength", 30, 0 )
	self:TempStatBoost( "Endurance", 35, 0 );
	self:TempStatBoost( "Sprint", 25, 0 );
	self:TempStatBoost( "Speed", 15, 0 );
	self:TempStatBoost( "Aim", 25, 0 );

end
--]]

function meta:BecomeCitizen()

	if( self:IsCombineDefense() ) then
		self:SetField( "radiofreq", 0 );
		self:SetPrivateFloat( "radiofreq", 0 );
	end

	self:SetTeam( 1 );
	self:SlaySilent();
	
	self:SetTitle( "Survivor" );
	self:SetJob( "Unemployed" );
	
	self:SetField( "model", self:GetField( "citizenmodel" ) );

end

function meta:HasItem( id )

	if( self:GetTable().Inventory[id] and self:GetItemCount( id ) > 0 ) then return true; end
	
	return false;

end

function meta:GetItemCount( id )

	if( self:GetTable().Inventory[id] ) then
		return self:GetTable().Inventory[id].Amt;
	end

	return 0;

end

function meta:HasRoomForWeapon( id )

	if( ( weapons.Get( id ).InvSize or 0 ) + self:GetField( "inventory.CrntSize" ) > self:GetField( "inventory.MaxSize" ) ) then
	
		return false;
	
	end
	
	return true;

end

function meta:HasRoomForItem( id )

	if( self:GetField( "inventory.CrntSize" ) + TS.ItemData[id].Size > self:GetField( "inventory.MaxSize" ) ) then
		return false;	
	end
	
	return true;

end

function meta:AddInventoryWeapon( id, shouldsave )

	if( shouldsave == nil ) then shouldsave = true; end

	local badweapons =
	{
	
		"ts_hands",
		"ts_keys",
		"ts_medic",
		"weapon_ts_godhand",
		"gmod_tool"
	
	}
	
	for k, v in pairs( badweapons ) do

		if( v == id ) then return; end
	
	end

	if( not self:GetTable().Inventory[id] and weapons.Get( id ) ) then
		
		self:GetTable().Inventory[id] = { }
		self:GetTable().Inventory[id].Table = { }
			
		self:GetTable().Inventory[id].Table.Owner = self;
		self:GetTable().Inventory[id].Amt = 1;
		self:GetTable().Inventory[id].NoSize = false;
		
		self:GetTable().Inventory[id].Table.IsWeapon = true;
		self:GetTable().Inventory[id].Table.Name = id or "";
		self:GetTable().Inventory[id].Table.Size = weapons.Get( id ).InvSize or 0;
		self:GetTable().Inventory[id].Table.Usable = false;
		self:GetTable().Inventory[id].Table.Weight = weapons.Get( id ).InvWeight or 0;
		self:GetTable().Inventory[id].Table.Model = weapons.Get( id ).WorldModel or "";

		
		umsg.Start( "AddWeaponToInventory", self );
			umsg.String( id );
			umsg.String( self:GetTable().Inventory[id].Table.Name );
			umsg.String( self:GetTable().Inventory[id].Table.Model );
			umsg.Float( self:GetTable().Inventory[id].Table.Weight );
			umsg.Float( self:GetTable().Inventory[id].Table.Size );
		umsg.End();
		
		self:SetField( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) + self:GetTable().Inventory[id].Table.Size );
		self:SetPrivateFloat( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) );
	
		if( shouldsave ) then
			self:SaveItems();
		end

	end

end

function meta:RemoveInventoryWeapon( id )

	if( not self:GetTable().Inventory[id] ) then return; end

	self:GetTable().Inventory[id].Amt = 0;
	
	self:SetField( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) - self:GetTable().Inventory[id].Table.Size );
	self:SetPrivateFloat( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) );
	
	umsg.Start( "DropWeaponFromInventory", self );
		umsg.String( id );
	umsg.End();
	
	self:CheckInventory();
	
	self:SaveItems();

end

function meta:GiveItem( id, err, forcegive, saveplayer )
	
	if( err == nil ) then err = true; end
	
	if( not TS.ItemData[id] ) then return; end
	
	local size = TS.ItemData[id].Size;
	local nosize = false;
	
	if( TS.ItemData[id].Wearable ) then
	
		if( not self:HasItem( id ) ) then
			nosize = true;
		end
	
	end
	
	if( saveplayer == nil ) then saveplayer = true; end
	
	if( not forcegive and not nosize and not self:HasRoomForItem( id ) ) then
		if( err ) then
			self:PrintMessage( 3, TS.ItemData[id].Name .. ": You cannot fit this item in to your inventory" );
		end
		return;	
	end
	
	if( nosize ) then size = 0; end
	
	local canpickup = true;
	
	self:SetField( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) + size );
	self:SetPrivateFloat( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) );
	
	if( TS.ItemData[id].CanPickup ) then
		canpickup = TS.ItemData[id].CanPickup( TS.ItemData[id], self );
	end
	
	if( canpickup ) then

		if( not self:GetTable().Inventory[id] ) then
		
			self:GetTable().Inventory[id] = { }
			self:GetTable().Inventory[id].Table = { }
			
			for k, v in pairs( TS.ItemData[id] ) do
				self:GetTable().Inventory[id].Table[k] = v;
			end
			
			self:GetTable().Inventory[id].Table.Owner = self;
			self:GetTable().Inventory[id].Amt = 1;
			self:GetTable().Inventory[id].NoSize = nosize;
		
		else
		
			self:GetTable().Inventory[id].Amt = self:GetTable().Inventory[id].Amt + 1;
		
		end
		
		if( self:GetTable().Inventory[id].Table.OnPickup ) then
			self:GetTable().Inventory[id].Table.OnPickup( self:GetTable().Inventory[id].Table );
		end
		
		umsg.Start( "AddInventory", self );
			umsg.String( id );
			umsg.String( TS.ItemData[id].Name or "" );
			umsg.String( TS.ItemData[id].Model or "" );
			umsg.Bool( TS.ItemData[id].Usable or false );
			umsg.Float( TS.ItemData[id].Weight or 0 );
			umsg.Float( size or 0 );
			umsg.String( TS.ItemData[id].Desc or "" );
			umsg.String( TS.ItemData[id].Flags or "" );
		umsg.End();
		
	end
	
	if( saveplayer ) then
		self:SaveItems();
	end

end

function meta:DropOneItem( id )

	if( not self:GetTable().Inventory[id] ) then return; end

	self:GetTable().Inventory[id].Amt = math.Clamp( self:GetTable().Inventory[id].Amt - 1, 0, 999 );
	
	if( not self:GetTable().Inventory[id].NoSize ) then
	
		self:SetField( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) - TS.ItemData[id].Size );
		self:SetPrivateFloat( "inventory.CrntSize", self:GetField( "inventory.CrntSize" ) );
	
	end
	
	umsg.Start( "DropInventory", self );
		umsg.String( id );
	umsg.End();

end

function meta:RemoveFromInventory( id )

	self:GetTable().Inventory[id] = nil;
	
	umsg.Start( "RemoveInventory", self );
		umsg.String( id );
	umsg.End();

end

function meta:CheckInventory()

	for k, v in pairs( self:GetTable().Inventory ) do
	
		if( v.Amt == 0 ) then
		
			self:RemoveFromInventory( k );
		
		end
	
	end

end

function meta:CanTakeLoan( val )

	if( val + self:GetField( "oweamount" ) > TS.ServerVars["maxoweamount"] ) then
	
		return false;
	
	end
	
	return true;

end



--Record all the weapons a player has
function meta:RecordWeaponList()

	local weaps = { }
	
	

end

--Force gives weapons to player, use this instead of Player:Give()!!!
function meta:ForceGive( class, shouldsave ) 

	if( not self:IsValid() ) then return; end

	if( self:HasWeapon( class ) ) then
		return;
	end
	
	if( shouldsave == nil ) then shouldsave = true; end

	self:GetTable().ForceGive = true;
	self:Give( class );
	self:GetTable().ForceGive = false;
	
	self:AddInventoryWeapon( class, shouldsave );

end

function meta:CheckFlags()

	self:SetField( "combineflags", "" );
	self:SetPrivateString( "combineflags", "" );

	for k, v in pairs( TS.CombineRoster ) do
	
		if( v[1] == self:SteamID() ) then
		
			self:SetField( "combineflags", v[2] );
			self:SetPrivateString( "combineflags", v[2] );
		
		end
	
	end
	
	self:SetField( "miscflags", "" );
	self:SetPrivateString( "miscflags", "" );
	
	for k, v in pairs( TS.MiscFlags ) do
	
		if( v[1] == self:SteamID() ) then
		
			self:SetField( "miscflags", v[2] );
			self:SetPrivateString( "miscflags", v[2] );
		
		end
	
	end

end

function meta:HasValidCitizenModel()

	for k, v in pairs( Models ) do
	
		if( self:GetModel() == v ) then
			return true;
		end
	
	end
	
	return false;

end

function meta:GetValidCitizenModel()

	return Models[math.random(1,#Models)];

end

function meta:Slay()

	self:SetField( "slay", 1 );
	self:Kill();

end

function meta:SlaySilent()

	self:SetField( "slay", 1 );
	self:KillSilent();

end

function meta:CreateServerRagdoll()

	local ragdoll = ents.Create( "prop_ragdoll" );
	ragdoll:SetPos( self:GetPos() );
	ragdoll:SetAngles( self:GetAngles() );
	ragdoll:SetModel( self:GetModel() );
	ragdoll:Spawn();
	
	self:Freeze( true );
	
	ragdoll:SetNWInt( "playerragdoll", 1 );
	ragdoll:SetNWInt( "player", self:EntIndex() );
	
	self:SelectWeapon( "ts_hands" );
	self:Flashlight( false );
	self:SetNoDraw( true );
	self:SetNotSolid( true );
	
	ragdoll:GetPhysicsObject():Sleep();
	
	self:SetField( "ragdolled", 1 );
	self:SetPrivateInt( "ragdolled", 1 );
	
	self:SetField( "ragdoll", ragdoll:EntIndex() );
	self:SetPrivateInt( "ragdoll", ragdoll:EntIndex() );
	
	timer.Simple( 1.5, FreezeRagdoll, ragdoll );
	
end

function meta:SnapFromServerRagdoll()

	self:CleanServerRagdoll();
		
	self:SetField( "ragdolled", 0 );
	self:SetPrivateInt( "ragdolled", 0 );
		
	self:Freeze( false );
	self:SetNoDraw( false );
	self:SetNotSolid( false );

end

function meta:CleanServerRagdoll()

	local ragid = self:GetField( "ragdoll" );
	
	local ragdoll = self:GetRagdoll();
	
	if( ragdoll:IsValid() ) then
	
		ragdoll:Remove();
		
	end

end


function meta:IsTiedUp() 

	if( self:GetNWInt( "tiedup" ) == 1 ) then
	
		return true;
	
	end
	
	return false;

end



function meta:CanBroadcast()

	if( self:IsSuperAdmin() ) then
		return true;
	end
	
	return false;

end
--[[
function meta:IsTempCP()

	if( self:HasCombineFlag( "F" ) or self:HasCombineFlag( "A" ) or self:HasCombineFlag( "H" ) or self:HasCombineFlag( "I" ) ) then
		return false;
	end
	
	return true;

end
--]]
function meta:CanBecomeNRD()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end

	if( self:HasCombineFlag( "A" ) ) then
		return true;
	end
	
	return false;

end

function meta:CanBecomeNSRF()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end

	if( self:HasCombineFlag( "B" ) ) then
		return true;
	end
	
	return false;

end
--[[
function meta:CanBecomeOW()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end

	return self:HasCombineFlag( "B" );

end

function meta:CanBecomeCE()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end

	if( self:HasCombineFlag( "C" ) or self:HasCombineFlag( "J" ) ) then
		return true;
	end
	
	return false;

end


function meta:CanBecomeST()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end
	
	return self:HasCombineFlag( "H" );

end


function meta:CanBecomeCA()

	if( self:IsAdmin() or self:IsSuperAdmin() ) then return true; end

	return self:HasCombineFlag( "D" );

end
]]--
-- no u stfu
function meta:IsRick()
--------- Don't turn RTRP into a minge server by adding a bunch of steam ID's here. Try not to even use it.
	if( self:SteamID() == "UNKNOWN" or self:SteamID() == "STEAM_ID_LAN" ) then return true; end
	
	return false;

end

function meta:IsAwesome()

	if( self:IsRick() or self:IsRDA() ) then
		return true;
	end
	
	return false;

end



function meta:HasAdminFlag( flag )

	if( string.find( self:GetField( "AdminFlags" ), flag ) ) then return true; end
	
	return false;

end

function meta:HasUserFlag( flag )

	if( string.find( self:GetField( "UserFlags" ), flag ) ) then return true; end
	
	return false;

end


function meta:GetGroupID()

	return tonumber( self:GetField( "group_id" ) );

end
