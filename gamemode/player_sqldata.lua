


local meta = FindMetaTable( "Player" );

MAX_CHARACTERS = 9;

function meta:HandleDuplicateSaves()
--[[
	local query = "SELECT `charName`, `charID` FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );
	
	for k, v in pairs( tab ) do
	
		for n, m in pairs( tab ) do
		
			if( v[1] == m[1] and k ~= n ) then
			
				mysql.query( TS.SQL, "DELETE FROM `rtrp_characters` WHERE `charID` = '" .. m[2] .. "'" );
			
			end
		
		end
	
	end	
]]--
end

function meta:HandleUID()

	local query = "SELECT * FROM `rtrp_users` WHERE `STEAMID` = '" .. self:SteamID() .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );
	
	if( tab and #tab > 0 ) then 

		self:SetField( "uid", tab[1][1] );
		
		self:SetField( "UserFlags", tab[1][4] );
		self:SetField( "AdminFlags", tab[1][5] );
		
		--[[
		local ip = GetConVarString( "ip" );
		local port = TS.Port;
		
		if( string.find( ip, ":" ) ) then
			port = string.gsub( string.sub( ip, string.find( ip, ":" ) + 1 ), " ", "" );
			ip = string.sub( ip, 1, string.find( ip, ":" ) - 1 );
		end
		
		--query = "UPDATE `rtrp_users` SET `serverIP` = '" .. ip .. "', `serverPort` = '" .. port .. "' WHERE `uID` = '" .. tab[1][1] .. "'";	
		--mysql.query( TS.SQL, query );
		]]--
		
		self:LoadGroup();
		
	elseif( not MYSQL_DED ) then
	
		self:SetField( "firsttimelogin", 1 );
		self:SetPrivateInt( "firsttimelogin", 1 );
		
		timer.Simple( 2, self.DoUmsg, self, "CreateQuestionPanel" );
	
		self:SetNoDraw( true );
		self:SetNotSolid( true );
	 	
	 	
	end
	

end

function meta:LoadGroup()


	local query = "SELECT `groupID` FROM `rtrp_users` WHERE `STEAMID` = '" .. self:SteamID() .. "'";	
	local tab = mysql.query( TS.SQL, query );	

	local id = tab[1][1];
	
	if( not id or id == "" ) then
	
		id = 1;
		
		query = "UPDATE `rtrp_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. self:SteamID() .. "'";	
		tab = mysql.query( TS.SQL, query );			
	
	end
	
	
	self:ResetGroupInfo();
	
	self:SetField( "group_id", tonumber( id ) );
	
	if( self:IsRick() ) then
	
		self:SetField( "group_id", 10 );
	
	end
	
	if( self:GetGroupID() == 1 ) then
	
		self:SetField( "group_max_props", 10 );
	
	elseif( self:GetGroupID() == 2 ) then --TT
	
		self:SetField( "group_hastoolgun", 1 )
		self:SetField( "group_max_props", 15 );
	
	elseif( self:GetGroupID() >= 3 ) then --Adv TT
	
		self:SetField( "group_hasadvtoolgun", 1 )
		self:SetField( "group_max_props", 15 );
	
	end
	
	--[[
	elseif( self:GetGroupID() == 3 ) then --Gold
	
		self:SetField( "group_hastoolgun", 1 )
		self:SetField( "group_max_props", 30 );
	
	elseif( self:GetGroupID() == 4 ) then --Platinum
	
		self:SetField( "group_hastoolgun", 1 )
		self:SetField( "group_max_props", 45 );
		self:SetField( "group_max_ragdolls", 1 );
		
	elseif( self:GetGroupID() == 5 ) then --Dolomite
	]]--
		

	query = "SELECT `MaxRagdolls`, `MaxProps`, `CustomModel`, `CustomAvatar` FROM `rtrp_donations` WHERE `STEAMID` = '" .. self:SteamID() .. "'";	
	tab = mysql.query( TS.SQL, query );	
	
	if( tab and #tab > 0 ) then
	
		self:SetField( "group_max_ragdolls", tonumber( tab[1][1] ) );
		
		if( tonumber( tab[1][2] ) > 0 ) then
			self:SetField( "group_max_props", tonumber( tab[1][2] ) );
		else
			self:SetField( "group_max_props", nil );
		end
		
		self:SetField( "CustomModel", tab[1][3] );
		self:SetNWString( "IngameAvatar", tab[1][4] );
	
	end
	
	if( self:IsRick() ) then -- JT :)
	
		self:SetField( "group_max_balloons", 1000 );
		self:SetField( "group_max_dynamite", 1000 );
		self:SetField( "group_max_effects", 1000 );
		self:SetField( "group_max_hoverballs", 1000 );
		self:SetField( "group_max_lamps", 1000 );
		self:SetField( "group_max_npcs", 1000 );
		self:SetField( "group_max_props", 1000 );
		self:SetField( "group_max_ragdolls", 1000 );
		self:SetField( "group_max_thrusters", 1000 );
		self:SetField( "group_max_vehicles", 1000 );
		self:SetField( "group_max_wheels", 1000 );
		self:SetField( "group_max_turrets", 1000 );
		self:SetField( "group_max_sents", 1000 );
		self:SetField( "group_max_spawners", 1000 );
		self:SetField( "group_hasadvtoolgun", 1 );		
	
	end
	
	--[[
	query = "SELECT * FROM `rtrp_groups` WHERE `groupID` = '" .. id .. "'";	
	tab = mysql.query( TS.SQL, query );	
	
	if( not tab or #tab < 1 ) then
		return;
	end
	
	for n = 7, 21 do
	
		tab[1][n] = tonumber( tab[1][n] );
	
	end
	
	self:SetField( "group_max_balloons", tab[1][7] );
	self:SetField( "group_max_dynamite", tab[1][8] );
	self:SetField( "group_max_effects", tab[1][9] );
	self:SetField( "group_max_hoverballs", tab[1][10] );
	self:SetField( "group_max_lamps", tab[1][11] );
	self:SetField( "group_max_npcs", tab[1][12] );
	self:SetField( "group_max_props", tab[1][13] );
	self:SetField( "group_max_ragdolls", tab[1][14] );
	self:SetField( "group_max_thrusters", tab[1][15] );
	self:SetField( "group_max_vehicles", tab[1][16] );
	self:SetField( "group_max_wheels", tab[1][17] );
	self:SetField( "group_max_turrets", tab[1][18] );
	self:SetField( "group_max_sents", tab[1][19] );
	self:SetField( "group_max_spawners", tab[1][20] );
	
	self:SetField( "group_hastoolgun", tab[1][21] );
	]]--


	if( self:GetTable().SaveLoaded ) then

		if( self:IsToolTrusted() ) then
		
			if( not self:HasWeapon( "gmod_tool" ) ) then
				self:ForceGive( "gmod_tool" );
			end
		
		else
		
			if( self:HasWeapon( "gmod_tool" ) ) then
				self:StripWeapon( "gmod_tool" );
			end
		
		end

	end
	
end

function meta:ListAllSaves()

	local uid = self:GetField( "uid" );
	
	local query = "SELECT * FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );	

	local list = { }
	
	for k, v in pairs( tab ) do
	
		table.insert( list, v[4] );

	end
	
	return list;

end


function meta:ListOtherSaves( nick )

	local uid = self:GetField( "uid" );
	
	local query = "SELECT * FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );	
	
	local list = { }
	
	for k, v in pairs( tab ) do
	
		if( mysql.escape( TS.SQL, v[4] ) ~= mysql.escape( TS.SQL, nick ) ) then
		
			table.insert( list, v[4] );
		
		end
	
	end
	
	return list;

end

function meta:GetNumberOfSaves()

	local uid = self:GetField( "uid" );
	
	local query = "SELECT `userID` FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );	
	
	if( not tab ) then return 0; end
	
	return #tab;

end

function meta:SaveExists( nick )

	local uid = self:GetField( "uid" );
	
	local query = "SELECT `userID` FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, nick ) .. "'";
	
	local tab, succ, err = mysql.query( TS.SQL, query );	
	
	if( not tab or #tab < 1 ) then return false; end
	
	return true;

end

function meta:SaveField( field, val )

	Msg( "Saving field " .. field .. " to " .. val .. " for " .. self:Nick() .. "\n" );

	--if( self:SaveExists( self:Nick() ) ) then
	
		mysql.query( TS.SQL, "UPDATE `rtrp_characters` SET `" .. field .. "` = '" .. mysql.escape( TS.SQL, val ) .. "' WHERE `userID` = '" .. self:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, self:Nick() ) .. "'" );
	
	--end

end

function meta:SaveWeapons()

	if( true ) then return; end

	local dontsave = 
	{
	
		"weapon_ts_zipties",
		"ts_hands",
		"ts_keys",
		"ts_medic"
	
	}
	
	local weaponstr = "";
	local ammostr = "";
	
	for k, v in pairs( self:GetWeapons() ) do
	
		local cansave = true;
	
		for n, m in pairs( dontsave ) do
		
			if( cansave and v:GetClass() == m ) then
			
				cansave = false;
			
			end
		
		end
		
		if( not string.find( v:GetClass(), "ts_" ) ) then
			
			cansave = false;
			
		end
		
		if( cansave ) then
		
			weaponstr = weaponstr .. v:GetClass() .. ";";
			
			if( v:GetTable().Primary ) then
				ammostr = ammostr .. ( v:GetTable().Primary.Ammo or "-1" ) .. ";" .. ( self:GetAmmoCount( ( v:GetTable().Primary.Ammo or "-1" ) ) or 0 ) .. ";";
			end
				
		end
		
	end
	
	self:SaveField( "weapons", weaponstr );
	self:SaveField( "ammo", ammostr );

end

function meta:SaveLicenses()

	local id = self:GetNWInt( "businessid" );

	local savestr = "";

	for n = 1, 4 do
	
		if( TS.GetBusinessInt( id, "haslicense." .. n ) == 1 ) then
	
			savestr = n .. ";" .. savestr;
	
		end
	
	end
	
	self:SaveField( "BusinessSupplyLicenseTypes", savestr );

end

function meta:SaveItems()

	local itemstr = "";

	for k, v in pairs( self:GetField( "Inventory" ) ) do
	
		if( not string.find( k, "ts_letter" ) ) then
			if( v.Table.IsWeapon ) then
				itemstr = itemstr .. "WEAPON_" .. k .. ";1;";
			else
				itemstr = itemstr .. k .. ";" .. v.Amt .. ";";
			end
		else
			--savestr = savestr .. "LETTER_ITEM " .. v.Table.HandWritten .. " " .. string.gsub( v.Table.Message, "\n", "]n" ) .. "\n";
		end
	
	end	
	
	self:SaveField( "items", itemstr );

end

function meta:SaveCharacter()

	Msg( "Saving character " .. self:Nick() .. "\n" );

	local fields = { }
	
	local id = self:GetNWInt( "businessid" );
	
	fields["CID"] = self:GetField( "cid" );
	fields["charTokens"] = self:GetNWFloat( "money" );
	fields["charName"] = self:Nick();
	fields["charModel"] = self:GetField( "citizenmodel" );
	fields["charAge"] = self:GetField( "info.Age" );
	fields["charJob"] = self:GetField( "job" );
	fields["charTitle"] = self:GetNWString( "title" );
	fields["charBio"] = self:GetField( "info.Bio" );
	fields["weapons"] = "";
	fields["ammo"] = "";
	--[[
	local dontsave = 
	{
	
		"weapon_ts_zipties",
		"ts_hands",
		"ts_keys",
		"ts_medic"
	
	}
	
	for k, v in pairs( self:GetWeapons() ) do
	
		local cansave = true;
	
		for n, m in pairs( dontsave ) do
		
			if( cansave and v:GetClass() == m ) then
			
				cansave = false;
			
			end
		
		end
		
		if( not string.find( v:GetClass(), "ts_" ) ) then
			
			cansave = false;
			
		end
		
		if( cansave ) then
		
			fields["weapons"] = fields["weapons"] .. v:GetClass() .. ";";
			
			if( v:GetTable().Primary ) then
				fields["ammo"] = fields["ammo"] .. ( v:GetTable().Primary.Ammo or "-1" ) .. ";" .. ( self:GetAmmoCount( ( v:GetTable().Primary.Ammo or "-1" ) ) or 0 ) .. ";";
			end
				
		end
		
	end]]--
	
	fields["items"] = "";
	
	for k, v in pairs( self:GetField( "Inventory" ) ) do
	
		if( not string.find( k, "ts_letter" ) and k ~= "newspaper" ) then
			if( v.Table.IsWeapon ) then
				fields["items"] = fields["items"] .. "WEAPON_" .. k .. ";1;";
			else
				fields["items"] = fields["items"] .. k .. ";" .. v.Amt .. ";";
			end
		else
			--savestr = savestr .. "LETTER_ITEM " .. v.Table.HandWritten .. " " .. string.gsub( v.Table.Message, "\n", "]n" ) .. "\n";
		end
	
	end
	
	fields["statStrength"] = self:GetNWFloat( "stat.Strength" ) - self:GetField( "stat.StrengthModifier" );
	fields["statAIM"] = self:GetNWFloat( "stat.Aim" ) - self:GetField( "stat.AimModifier" );
	fields["statEndurance"] = self:GetNWFloat( "stat.Endurance" ) - self:GetField( "stat.EnduranceModifier" );
	fields["statSprint"] = self:GetNWFloat( "stat.Sprint" ) - self:GetField( "stat.SprintModifier" );
	fields["statMedic"] = self:GetNWFloat( "stat.Medic" ) - self:GetField( "stat.MedicModifier" );
	fields["statSpeed"] = self:GetNWFloat( "stat.Speed" ) - self:GetField( "stat.SpeedModifier" );
	fields["statSneak"] = self:GetNWFloat( "stat.Sneak" ) - self:GetField( "stat.SneakModifier" );
	fields["loanAmount"] = self:GetField( "borrowamount" );
	fields["loanRemain"] = self:GetField( "oweamount" );
	fields["loanCanGet"] = self:GetField( "cangetloan" );
	fields["BusinessOwn"] = self:GetField( "ownsbusiness" );
	fields["BusinessName"] = string.gsub( TS.GetBusinessString( id, "businessname" ), "\"", "'" );
	fields["BusinessMoney"] = TS.GetBusinessFloat( id, "bankamount" );
	fields["BusinessSupplyLicense"] = TS.GetBusinessInt( id, "supplylicense" );
	fields["BusinessItems"] = "";
	
	local id = self:GetNWInt( "businessid" );
	
	if( id ~= 0 ) then
	
		local count = TS.GetBusinessInt( id, "itemcount" );
		
		for n = 1, count do
			
			fields["BusinessItems"] = fields["BusinessItems"] .. TS.GetBusinessString( id, "item." .. n .. ".name" ) .. ";" .. TS.GetBusinessInt( id, "item." .. n .. ".count" ) .. ";";
			
		end
		
	end
	
	fields["SaveVersion"] = SAVE_VERSION;
	fields["charRace"] = self:GetField( "info.Race" );
	fields["userID"] = self:GetField( "uid" );
	fields["playerflags"] = self:GetField( "miscflags" );
	fields["combineflags"] = self:GetField( "combineflags" );
	
	fields["BusinessSupplyLicenseTypes"] = "";
	
	for n = 1, 4 do
	
		if( TS.GetBusinessInt( id, "haslicense." .. n ) == 1 ) then
	
			fields["BusinessSupplyLicenseTypes"] = n .. ";" .. fields["BusinessSupplyLicenseTypes"];
	
		end
	
	end
	
	for k, v in pairs( fields ) do
	
		fields[k] = mysql.escape( TS.SQL, fields[k] );
	
	end
	
	local saveinfo = "";
	local n = false;
	
	if( not self:SaveExists( self:Nick() ) ) then
	
		saveinfo = "INSERT INTO `rtrp_characters` (";
		
		for k, v in pairs( fields ) do
		
			if( n ) then
			
				saveinfo = saveinfo .. ", ";
			
			end
		
			saveinfo = saveinfo .. "`" .. k .. "`";
		
			n = true;
		
		end
		
		saveinfo = saveinfo .. ") VALUES ( ";
		
		n = false;
		
		for k, v in pairs( fields ) do
		
			if( n ) then
			
				saveinfo = saveinfo .. ", ";
			
			end
		
			saveinfo = saveinfo .. "'" .. v.. "'";
		
			n = true;
		
		end	
		
		saveinfo = saveinfo .. " )";
		
	else
	
		saveinfo = "UPDATE `rtrp_characters` SET ";

		for k, v in pairs( fields ) do
		
			if( n ) then
			
				saveinfo = saveinfo .. ", ";
			
			end
		
			saveinfo = saveinfo .. "`" .. k .. "` = '" .. v .. "'";
		
			n = true;
		
		end
		
		saveinfo = saveinfo .. " WHERE `userID` = '" .. self:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, self:Nick() ) .. "'";
	
	end
	
	
	local tab, succ, err = mysql.query( TS.SQL, saveinfo );


end

function blarp()

	Msg( mysql.query( TS.SQL,  "SELECT `STEAMID` FROM `rtrp_users`"  ) );

end

function meta:LoadCharacter( nick )

	if( MYSQL_DED ) then
	
		local mdl = TS.Models[math.random( 1, 29 )];
	
		ply:SetField( "model", mdl );
		ply:SetField( "citizenmodel", mdl );
		ply:SetModel( mdl );
		return;
	
	end


	TS.DebugFile( "Load character for " .. nick .. "\n" );

	umsg.Start( "ResetPlayerMenu", self ); umsg.End();
	umsg.Start( "ResetInventory", self ); umsg.End();
	
	TS.RemoveSupplyLicenses( self:GetNWInt( "businessid" ) )
	self:SetField( "ownsbusiness", 0 );
	self:SetPrivateInt( "ownsbusiness", 0 );
	self:SetNWInt( "businessid", 0 );
	
	self:SetField( "businessflags", "abcdefghijklmnopqrstvuwxyz" );
	self:SetPrivateString( "businessflags", "abcdefghijklmnopqrstvuwxyz" );
	
	if( self:GetTable().SaveLoaded ) then
	
		self:StripWeapons();
		self:RemoveAllTSAmmo();
	
	end
	

	--Remove weapons
	
	self:SetField( "Inventory", { } );
	
	self:SetPrivateFloat( "inventory.CrntSize", 0 );
	self:SetField( "inventory.CrntSize", 0 );
	
	self:SetPrivateFloat( "inventory.MaxSize", 4 );
	self:SetField( "inventory.MaxSize", 4 );
	
	self:SetField( "stat.StrengthModifier", 0 );
	self:SetField( "stat.SpeedModifier", 0 );
	self:SetField( "stat.SprintModifier", 0 );
	self:SetField( "stat.EnduranceModifier", 0 );
	self:SetField( "stat.AimModifier", 0 );
	self:SetField( "stat.MedicModifier", 0 );
	self:SetField( "stat.SneakModifier", 0 );
	
	self:SetField( "cid", 0 );
	self:SetPrivateFloat( "cid", 0 );

	local query = "SELECT `CID`, `charTokens`, `charModel`, `charAge`, `charJob`, `charTitle`, `charBio`, `weapons`, `ammo`, `items`, `statStrength`, `statAIM`, `statEndurance`, `statSprint`, `statMedic`, `statSpeed`, `statSneak`, `loanAmount`, `loanRemain`, `loanCanGet`, `BusinessOwn`, `BusinessName`, `BusinessMoney`, `BusinessSupplyLicense`, `BusinessItems`, `SaveVersion`, `charRace`, `playerflags`, `combineflags`, `BusinessSupplyLicenseTypes` FROM `rtrp_characters` WHERE `userID` = '" .. self:GetField( "uid" ) .. "' AND `charName` = '" .. mysql.escape( TS.SQL, nick ) .. "'";	
	
	local data = mysql.query( TS.SQL, query )[1];
	
	if( not data ) then return; end
	
	for n = 1, 29 do
	
		data[n] = data[n] or 0;
	
	end
	
	self:SetField( "cid", tonumber( data[1] ) );
	self:SetPrivateFloat( "cid", tonumber( data[1] ) );

	self:SetNWFloat( "money",  math.floor( tonumber( data[2] ) ) );
	
	self:SetField( "citizenmodel", data[3] );
	self:SetField( "model", data[3] );

	self:SetField( "info.Age", data[4] );
	self:SetPrivateString( "info.Age", data[4] );
	
	self:SetField( "job", data[5] );
	self:SetPrivateString( "job", data[5] );
		
	self:SetNWString( "title", data[6] );
	
	self:SetField( "info.Bio", data[7] );
	self:SetPrivateString( "info.Bio", data[7] ); 
	
	--[[
			
	local weaps = string.Explode( ";", data[8] );
	
	for k, v in pairs( weaps ) do
	
		if( v ~= "" ) then
	
			if( not self:HasWeapon( v ) ) then
			
				self:ForceGive( v );
			
			end
			
		end
	
	end
	]]--
	
	local ammo = string.Explode( ";", data[9] );
	
	local j = 1;
	
	for n = 1, #ammo do

		if( ammo[j] and ammo[j + 1] and ammo[j] ~= "" and ammo[j + 1] ~= "" ) then
			self:GiveAmmo( tonumber( ammo[j + 1] ), ammo[j] );
		end
		
		j = j + 2;
		
		if( j > #ammo ) then break; end
	
	end
	
	local items = string.Explode( ";", data[10] );
	
	j = 1;

	for n = 1, #items do
	
		if( items[j] and items[j + 1] and items[j] ~= "" and items[j + 1] ~= "" ) then
		
		
			if( string.sub( items[j], 1, 10 ) == "weapcrate_" ) then
			
				local weap = string.sub( items[j], 11 );
				
				if( not TS.ItemData[items[j]] ) then
					TS.CreateTempItem( items[j], "Crate for " .. TS.GetWeaponName( weap ), 6, 5, "models/items/item_item_crate.mdl", "Weapon crate" );
					TS.ItemData[items[j]].UseFunc = function( ply, item )
					
						ply:ForceGive( item.Weapon );
					
						ply:DropOneItem( item.ID );
						ply:CheckInventory();
					
					end
					
					TS.ItemData[items[j]].Weapon = weap;
					
				end
				
				
			
			end

			if( string.sub( items[j], 1, 7 ) == "WEAPON_" ) then

				timer.Simple( 2, self.ForceGive, self, string.sub( items[j], 8 ), false );
				
			end
			
			if( TS.ItemData[items[j]] ) then

					self:GiveItem( items[j], false, true, false );
					self:GetTable().Inventory[items[j]].Amt = tonumber( items[j + 1] );
						
					umsg.Start( "SetInventoryAmt", self );
						umsg.String( items[j] );
						umsg.Short( tonumber( items[j + 1] ) );
					umsg.End();

			end
			
		end
		
		j = j + 2;
		
		if( j > #items ) then break; end
		

	end
		
	self:SaveItems();

	self:SetNWFloat( "stat.Strength", tonumber( data[11] ) );
	self:SetNWFloat( "stat.Aim", tonumber( data[12] ) );
	self:SetNWFloat( "stat.Endurance", tonumber( data[13] ) );
	self:SetNWFloat( "stat.Sprint", tonumber( data[14] ) );
	self:SetNWFloat( "stat.Medic", tonumber( data[15] ) ); 
	self:SetNWFloat( "stat.Speed", tonumber( data[16] ) ); 
	self:SetNWFloat( "stat.Sneak", tonumber( data[17] ) ); 
	
	self:SetField( "borrowamount", tonumber( data[18] ) );
	self:SetPrivateFloat( "borrowamount", tonumber( data[18] ) );
	
	self:SetPrivateFloat( "oweamount", tonumber( data[19] ) );
	self:SetField( "oweamount", tonumber( data[19] ) );
	
	self:SetField( "cangetloan", tonumber( data[20] ) );
	
	self:SetField( "ownsbusiness", tonumber( data[21] ) );
	self:SetPrivateInt( "ownsbusiness", tonumber( data[21] ) );
	
	if( tonumber( data[21] ) == 0 and not self:IsCombine() ) then
	
		self:SetJob( "Unemployed" );
	
	end

	if( tonumber( data[21] ) == 1 ) then
		ccCreateFreeBusiness( self, "", { data[22] } )
	end
		
	local function SetBusinessMoney( ply, amount )
		TS.SetBusinessFloat( ply:GetNWInt( "businessid" ), "bankamount", tonumber( amount ) );	
	end
	SetBusinessMoney( self, data[23] );

	local function SetSupplyLicense( ply, license )
		--If they have the default license, just give em' all
		if( tonumber( license ) == 1 ) then
			local id = ply:GetNWInt( "businessid" );
			TS.AddSupplyLicense( id, 1 );
			TS.AddSupplyLicense( id, 2 );
			TS.AddSupplyLicense( id, 3 );
			ply:SaveLicenses();
		end		
	end	
	SetSupplyLicense( self, data[24] );

	
	local function GiveBusinessItem( ply, count, name )
		local id = ply:GetNWInt( "businessid" );
		TS.SetBusinessInt( id, "itemcount", TS.GetBusinessInt( id, "itemcount" ) + 1 );
		local n = TS.GetBusinessInt( id, "itemcount" );
		TS.SetBusinessInt( id, "item." .. n .. ".count", tonumber( count ) );
		TS.SetBusinessString( id, "item." .. n .. ".name", name );
	end

	local bitems = string.Explode( ";", data[25] );
	
	j = 1;
	
	for n = 1, #bitems do
	
		if( bitems[j] and bitems[j + 1] and bitems[j] ~= "" and bitems[j + 1] ~= "" ) then
			
			if( TS.ItemData[bitems[j]] ) then
				GiveBusinessItem( self, bitems[j + 1], bitems[j] );
			end
			
		end
		
		j = j + 2;
	
		if( j > #bitems ) then break; end
	
	end
	
	self:SetField( "saveversion", tonumber( data[26] ) );
	
	self:SetField( "info.Race", data[27] ); 
	self:SetPrivateString( "info.Race", data[27] ); 
	
	self:SetField( "miscflags", data[28] );
	self:SetPrivateString( "miscflags", data[28] );
	
	self:SetField( "combineflags", data[29] );
	self:SetPrivateString( "combineflags", data[29] );

	local licenses = string.Explode( ";", data[30] );
	
	for j = 1, #licenses do
		
		TS.AddSupplyLicense( self:GetNWInt( "businessid" ), licenses[j] );
	
	end

	self:GetTable().WalkSpeed = 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
	self:GetTable().SprintSpeed = 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 150 );
	self:GetTable().SprintDegradeAmt = math.Clamp( 3 / self:GetNWFloat( "stat.Sprint" ), .01, 2 );
	
	if( self:GetTable().SaveLoaded ) then
	
		self:GiveDefaultLoadout();
	
	end
	
	self:GetTable().SaveLoaded = true;
	

	if( MYSQL_DED ) then
	
		ply:SetField( "citizenmodel", TS.Models[math.random( 1, #TS.Models )] );
	
	end

	
	if( self:Team() == 1 ) then
	
		self:SetModel( self:GetField( "citizenmodel" ) );
	
	end
	
	data = nil;

end
