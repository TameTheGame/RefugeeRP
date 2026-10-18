
local meta = FindMetaTable( "Player" );

MAX_CHARACTERS = 7;

function meta:FormatSteamID()

	local id = self:SteamID();
	
	if( not id ) then return "UNKNOWN"; end
	
	id = string.gsub( id, ":", "" );
	id = string.gsub( id, "_", "" );
	id = string.gsub( id, "STEAM", "" );
	
	return id;

end

function meta:CharacterSaveExists( name )

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local str = file.Read( dir ) or "";	

	if( string.find( string.gsub( str, "-", "@" ), "NEW_CHARACTER \"" .. string.gsub( name, "-", "@" ) .. "\"" ) ) then
	
		return true;
	
	end
	
	return false;

end

function meta:ListOtherSaves()

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local data = self:ExtractCertainSaveInfo( self:Nick() );
	
	local savelist = TS.GetArgumentLists( data );
	local tbl = { }
	
	for k, v in pairs( savelist ) do
	
		if( v[1] == "NEW_CHARACTER" ) then
		
			table.insert( tbl, v[2] );
		
		end
	
	end
	
	return tbl;

end

function meta:ListAllSaves()

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local data = file.Read( "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt" ) or "";
	
	local savelist = TS.GetArgumentLists( data );
	local tbl = { }
	
	for k, v in pairs( savelist ) do
	
		if( v[1] == "NEW_CHARACTER" ) then
		
			table.insert( tbl, v[2] );
		
		end
	
	end
	
	return tbl;

end

function meta:ExtractRawSaveInfo( name )

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local str = file.Read( dir ) or "";
	
	local pos1 = string.find( string.gsub( str, "-", "@" ), "NEW_CHARACTER \"" .. string.gsub( name, "-", "@" ) .. "\"" );
	
	if( not pos1 ) then return ""; end
	
	local pos2 = string.find( string.gsub( str, "-", "@" ), "END_CHARACTER", pos1 );
	
	local info = "";
	
	info = string.sub( str, pos1, pos2 + 12 );

	return info;

end

function meta:ExtractBackupRawSaveInfo( name )

	local dir = "TacoScript/backup_playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local str = file.Read( dir ) or "";
	
	local pos1 = string.find( string.gsub( str, "-", "@" ), "NEW_CHARACTER \"" .. string.gsub( name, "-", "@" ) .. "\"" );
	
	if( not pos1 ) then return ""; end
	
	local pos2 = string.find( string.gsub( str, "-", "@" ), "END_CHARACTER", pos1 );
	
	local info = "";
	
	info = string.sub( str, pos1, pos2 + 12 );

	return info;

end

function meta:ExtractCertainSaveInfo( name )

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	local str = file.Read( dir ) or "";
	
	local pos1 = string.find( string.gsub( str, "-", "@" ), "NEW_CHARACTER \"" .. string.gsub( name, "-", "@" ) .. "\"" );
	
	if( not pos1 ) then return str; end
	
	local pos2 = string.find( string.gsub( str, "-", "@" ), "END_CHARACTER", pos1 );
	
	local info = "";
	
	info = string.sub( str, 1, pos1 - 1 ) .. string.sub( str, pos2 + 14 );

	return info;

end

function meta:SaveInfo()
	
	Msg( "Save: " .. self:Nick() .. "\n" );

	local dir = "TacoScript/playerdata/" .. self:FormatSteamID() .. ".txt";
	
	if( not file.Exists( dir ) ) then
		file.Write( dir, "" );
	end
	
	local oldinfo = self:ExtractCertainSaveInfo( self:Nick() );
	
	local saveinfo = { }
	saveinfo["MODEL"] = self:GetField( "citizenmodel" );
	saveinfo["MONEY"] = self:GetNWFloat( "money" );
	saveinfo["TITLE"] = self:GetNWString( "title" );
	saveinfo["CID"] = self:GetField( "cid" );
	saveinfo["INFO.RACE"] = self:GetField( "info.Race" );
	saveinfo["INFO.AGE"] = self:GetField( "info.Age" );
	saveinfo["INFO.BIO"] = self:GetField( "info.Bio" );
	saveinfo["STAT.STRENGTH"] = self:GetNWFloat( "stat.Strength" ) - self:GetField( "stat.StrengthModifier" );
	saveinfo["STAT.ENDURANCE"] = self:GetNWFloat( "stat.Endurance" ) - self:GetField( "stat.EnduranceModifier" );
	saveinfo["STAT.SPRINT"] = self:GetNWFloat( "stat.Sprint" ) - self:GetField( "stat.SprintModifier" );
	saveinfo["STAT.SPEED"] = self:GetNWFloat( "stat.Speed" ) - self:GetField( "stat.SpeedModifier" );
	saveinfo["STAT.AIM"] = self:GetNWFloat( "stat.Aim" ) - self:GetField( "stat.AimModifier" );
	saveinfo["STAT.MEDIC"] = self:GetNWFloat( "stat.Medic" ) - self:GetField( "stat.MedicModifier" );
	saveinfo["STAT.SNEAK"] = self:GetNWFloat( "stat.Sneak" ) - self:GetField( "stat.SneakModifier" );
	saveinfo["CANGETLOAN"] = self:GetField( "cangetloan" );
	saveinfo["BORROWAMOUNT"] = self:GetField( "borrowamount" );
	saveinfo["OWEAMOUNT"] = self:GetField( "oweamount" );
	saveinfo["OWNSBUSINESS"] = self:GetField( "ownsbusiness" );
	saveinfo["SAVE_VERSION"] = self:GetField( "saveversion" );
	saveinfo["SAVE_EOF"] = self:GetField( "saveeof" );
	
	--Add inventory saving
	
	local savestr = "NEW_CHARACTER \"" .. string.gsub( self:Nick(), "\"", "'" ) .. "\"\n";
	
	for k, v in pairs( self:GetField( "Inventory" ) ) do
	
		if( not string.find( k, "ts_letter" ) ) then
			savestr = savestr .. "INV_ITEM " .. k .. " " .. v.Amt .. "\n";
		else
			savestr = savestr .. "LETTER_ITEM " .. v.Table.HandWritten .. " " .. string.gsub( v.Table.Message, "\n", "]n" ) .. "\n";
		end
	
	end
	
	if( self:GetField( "ownsbusiness" ) == 1 ) then
	
		saveinfo["JOB"] = self:GetNWString( "job" );
	
		local id = self:GetNWInt( "businessid" );
	
		savestr = savestr .. "CREATE_BUSINESS \"" .. string.gsub( TS.GetBusinessString( id, "businessname" ), "\"", "'" ) .. "\"\n";
		savestr = savestr .. "SET_BUSINESS_MONEY " .. TS.GetBusinessFloat( id, "bankamount" ) .. "\n";
		savestr = savestr .. "SUPPLYLICENSE " .. TS.GetBusinessInt( id, "supplylicense" ) .. "\n";
		
		local count = TS.GetBusinessInt( id, "itemcount" );
		
		for n = 1, count do
		
			savestr = savestr .. "BUSINESS_ITEM " .. TS.GetBusinessInt( id, "item." .. n .. ".count" ) .. " " .. TS.GetBusinessString( id, "item." .. n .. ".name" ) .. "\n";
		
		end
	
	end
	
	local DontSave =
	{
	
		"gmod_tool",
		"weapon_physgun",
		"weapon_physcannon"
	
	}
	
	if( self:Alive() ) then
	
		for k, v in pairs( self:GetWeapons() ) do
		
			local save = true;
		
			local class = v:GetClass();
			
			if( string.find( class, "ts" ) ) then
			
				for n, m in pairs( DontSave ) do
				
					if( m == class and save ) then
					
						save = false;
					
					end
				
				end
			
			else
			
				save = false;
			
			end
		
			if( save ) then
		
				savestr = savestr .. "WEAPON " .. v:GetClass() .. "\n";
				
				if( v:GetTable().Primary ) then
					savestr = savestr .. "AMMO " .. ( v:GetTable().Primary.Ammo or "-1" ) .. " " .. ( self:GetAmmoCount( ( v:GetTable().Primary.Ammo or "-1" ) ) or 0 ) .. "\n";
				end
				
			end
			
		end
		
	end
		
	for k, v in pairs( saveinfo ) do
	
		savestr = savestr .. k .. " \"" .. string.gsub( v, "\"", "'" ) .. "\"\n";
	
	end
	
	savestr = savestr .. "END_CHARACTER\n";
	
	file.Write( dir, oldinfo .. savestr );
	
	local function BackupSave( ply, str )
	
		local dir = "TacoScript/backup_playerdata/" .. ply:FormatSteamID() .. ".txt";
		file.Write( dir, str );
		
	end
	
	timer.Simple( 2, BackupSave, self, oldinfo .. savestr );
	
end

function meta:LoadInfo()

	local data = self:ExtractRawSaveInfo( self:Nick() );
	self:LoadInfoFromData( data );
	
end

function meta:LoadInfoFromData( data, backup )

	Msg( "Load: " .. self:Nick() .. "\n" );

	local args = TS.GetArgumentLists( data );
	
	umsg.Start( "ResetPlayerMenu", self ); umsg.End();
	umsg.Start( "ResetInventory", self ); umsg.End();
	
	self:SetNWInt( "businessid", 0 );
	self:SetPrivateString( "businessflags", "" );
	
	self:StripWeapons();
	self:RemoveAllTSAmmo();
	--Remove weapons
	
	self:SetField( "Inventory", { } );
		
	self:SetField( "inventory.CrntSize", 0 );
	self:SetPrivateFloat( "inventory.CrntSize", 0 );
	
	self:SetField( "inventory.MaxSize", 4 );
	self:SetPrivateFloat( "inventory.MaxSize", 4 );

	self:SetField( "stat.StrengthModifier", 0 );
	self:SetField( "stat.SpeedModifier", 0 );
	self:SetField( "stat.SprintModifier", 0 );
	self:SetField( "stat.EnduranceModifier", 0 );
	self:SetField( "stat.AimModifier", 0 );
	self:SetField( "stat.MedicModifier", 0 );
	self:SetField( "stat.SneakModifier", 0 );
	
	self:SetNWFloat( "cid", 0 );
	
	for _, v in pairs( args ) do
	
		local cmd = v[1];
		
		if( cmd == "MODEL" ) then
		
			self:SetField( "citizenmodel", v[2] );
			self:SetField( "model", v[2] );
		
		elseif( cmd == "MONEY" ) then
		
			self:SetNWFloat( "money",  math.floor( tonumber( v[2] ) ) );
		
		elseif( cmd == "JOB" ) then
		
			self:SetNWString( "job", v[2] );
		
		elseif( cmd == "TITLE" ) then
		
			self:SetNWString( "title", v[2] );
			
		elseif( cmd == "CID" ) then
		
			self:SetNWFloat( "cid", tonumber( v[2] ) );
		
		elseif( string.sub( cmd, 1, 5 ) == "INFO." ) then
		
			self:SetNWString( "info." .. string.sub( cmd, 6, 6 ) .. string.lower( string.sub( cmd, 7 ) ), v[2] );
		
		elseif( string.sub( cmd, 1, 5 ) == "STAT." ) then
		
			self:SetNWFloat( "stat." .. string.sub( cmd, 6, 6 ) .. string.lower( string.sub( cmd, 7 ) ), tonumber( v[2] ) );
		
		elseif( cmd == "INV_ITEM" ) then
		
			if( TS.ItemData[v[2]] ) then
		
				self:GiveItem( v[2], false, true );
				self:GetTable().Inventory[v[2]].Amt = tonumber( v[3] );
				
				umsg.Start( "SetInventoryAmt", self );
					umsg.String( v[2] );
					umsg.Short( tonumber( v[3] ) );
				umsg.End();
				
			end
		
		elseif( cmd == "LETTER_ITEM" ) then

			local hw = tonumber( v[2] );
			
			local msg = "";
			
			if( #v > 2 ) then
			
				for n = 3, #v do
				
					msg = msg .. v[n] .. " ";
				
				end
				
			end

			msg = string.gsub( msg, "]n", "\n" );
			
			TS.CreateLetter( msg, nil, hw, true );
					
			self:GiveItem( "ts_letter" .. TS.LetterNum, false, true );
			self:GetTable().Inventory["ts_letter" .. TS.LetterNum].Amt = 1;
				
			umsg.Start( "SetInventoryAmt", self );
				umsg.String( "ts_letter" .. TS.LetterNum );
				umsg.Short( 1 );
			umsg.End();

		elseif( cmd == "OWNSBUSINESS" ) then
		
			self:SetField( "ownsbusiness", tonumber( v[2] ) );
		
		elseif( cmd == "CANGETLOAN" ) then
		
			self:SetField( "cangetloan", v[2] );
			
		elseif( cmd == "BORROWAMOUNT" ) then
		
			self:SetNWFloat( "borrowamount", v[2] );
		
		elseif( cmd == "OWEAMOUNT" ) then
		
			self:SetNWFloat( "oweamount", v[2] );
		
		elseif( cmd == "CREATE_BUSINESS" ) then
		
			ccCreateBusiness( self, "", { v[2] } )
		
		elseif( cmd == "SET_BUSINESS_MONEY" ) then
		
			local function SetBusinessMoney( ply, amount )
			
				TS.SetBusinessFloat( ply:GetNWInt( "businessid" ), "bankamount", tonumber( amount ) );
				
			end
			
			SetBusinessMoney( self, v[2] );

		elseif( cmd == "SUPPLYLICENSE" ) then
		
			local function SetSupplyLicense( ply, license )

				TS.SetBusinessInt( ply:GetNWInt( "businessid" ), "supplylicense", tonumber( license ) );		
				
			end	

			SetSupplyLicense( self, v[2] );
		
		elseif( cmd == "BUSINESS_ITEM" ) then
		
			local function GiveBusinessItem( ply, count, name )
		
				local id = ply:GetNWInt( "businessid" );
		
				TS.SetBusinessInt( id, "itemcount", TS.GetBusinessInt( id, "itemcount" ) + 1 );
				local n = TS.GetBusinessInt( id, "itemcount" );
				
				TS.SetBusinessInt( id, "item." .. n .. ".count", tonumber( count ) );
				TS.SetBusinessString( id, "item." .. n .. ".name", name );
				
			end
			
			GiveBusinessItem( self, v[2], v[3] );
		
		elseif( cmd == "WEAPON" ) then
		
			local function GiveWeap( class ) 
			
				if( not self:HasWeapon( class ) ) then
					self:ForceGive( class );
				end
				
			end
			
			timer.Simple( 2, GiveWeap, v[2] );
		
		elseif( cmd == "AMMO" ) then
		
			local type = v[2];
			local amt = tonumber( v[3] );
			
			if( amt ) then
				self:GiveAmmo( amt - self:GetAmmoCount( type ), type );
			end
			
		elseif( cmd == "SAVE_VERSION" ) then
		
			self:SetField( "saveversion", tonumber( v[2] ) );
			
		elseif( cmd == "SAVE_EOF" ) then
		
			self:SetField( "saveeof", tonumber( v[2] ) );
			
		elseif( cmd == "END_CHARACTER" ) then
			
			break;
			
		end
	
	end
	
	self:HandleLoadSave( backup );
	
	self:CheckFlags();
	
	self:GetTable().WalkSpeed = 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
	self:GetTable().SprintSpeed = 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 200 );
	self:GetTable().SprintDegradeAmt = math.Clamp( 3 / self:GetNWFloat( "stat.Sprint" ), .01, 2 );
	
	self:GetTable().SaveLoaded = true;
	
	if( self:Team() == 1 ) then
	
		self:SetModel( self:GetField( "citizenmodel" ) );
	
	end

	
end

function meta:TryBackupLoad()

	if( file.Exists( "TacoScript/backup_playerdata/" .. self:FormatSteamID() .. ".txt" ) ) then

		local data = self:ExtractBackupRawSaveInfo( self:Nick() );
		self:LoadInfoFromData( data, true );
		
	end

end

function meta:HandleLoadSave( backup )

	local v = tonumber( self:GetField( "saveversion" ) );
	
	--Save update: Wipe the debts, and give some money, and restore teh economy
	if( v == 0 ) then
	
		--[[
		
		self:SetNWFloat( "oweamount", 0 );
		
		local money = self:GetNWFloat( "money" );
		
		if( self:GetNWInt( "ownsbusiness" ) == 1 ) then
		
			money = 1000;
		
		else
		 
		 	money = 200;
		 
		end
		
		self:SetNWFloat( "money", self:GetNWFloat( "money" ) + money );
		
		TS.GiveEconomy( 15000 );
		
		]]--
		
		if( not backup ) then
		--	self:TryBackupLoad();
		end
		
	end
	
	self:SetField( "saveversion", SAVE_VERSION );

end