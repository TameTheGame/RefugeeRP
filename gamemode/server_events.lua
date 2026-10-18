
function TS.DoRealTimeDonation()

	local query = "SELECT * FROM `rtrp_realtimedonations`";
	local tbl = mysql.query( TS.SQL, query );

	local steamidtable = { }
	
	for k, v in pairs( player.GetAll() ) do
	
		steamidtable[v:SteamID()] = v
	
	end

	for k, v in pairs( tbl ) do
	
		local steamid = v[1];
		local charname = v[2];
		local fail = tonumber( v[3] );
		local tokens = tonumber( v[4] );
		local strength = tonumber( v[5] );
		local speed = tonumber( v[6] );
		local sprint = tonumber( v[7] );
		local endurance = tonumber( v[8] );
		local aim = tonumber( v[9] );
		local sneak = tonumber( v[10] );
		local medic = tonumber( v[11] );
	
		local inchar = false;
		
		for n, m in pairs( player.GetAll() ) do 
		
			if( mysql.escape( TS.SQL, m:Nick() ) == mysql.escape( TS.SQL, charname ) ) then
			
				inchar = true;
				break;
			
			end
		
		end
	
		if( fail == 0 ) then
		
			--ingame
			if( steamidtable[steamid] and inchar ) then
			
				local ply = steamidtable[steamid];
				
				ply:GiveMoney( tokens );
				ply:RaiseStat( "Strength", strength );
				ply:RaiseStat( "Endurance", endurance );
				ply:RaiseStat( "Sprint", sprint );
				ply:RaiseStat( "Speed", speed );
				ply:RaiseStat( "Medic", medic );
				ply:RaiseStat( "Sneak", sneak );
				ply:RaiseStat( "Aim", aim );
				
				mysql.query( TS.SQL, "DELETE FROM `rtrp_realtimedonations` WHERE `SteamID` = '" .. steamid .. "'" );
				
			--not ingame
			else 
			
				local tbl = mysql.query( TS.SQL, "SELECT `uID` FROM `rtrp_users` WHERE `STEAMID` = '" .. steamid .. "'" );
				local uid = tonumber( tbl[1][1] );
				
				tbl = mysql.query( "SELECT `charTokens`, `statStrength`, `statEndurance`, `statSprint`, `statSpeed`, `statMedic`, `statSneak`, `statAim` FROM `rtrp_characters` WHERE `userID` = '" .. uid .. "' AND `charName` = '" .. charname .. "'" );
			
				if( not tbl or #tbl < 1 ) then
				
				 	mysql.query( "UPDATE `rtrp_realtimedonations` SET `Fail` = '1' WHERE `SteamID` = '" .. steamid .. "'" );
				
				else
			
					tokens = tokens + tonumber( tbl[1][1] );
					strength = strength + tonumber( tbl[1][2] );
					endurance = endurance + tonumber( tbl[1][3] );
					sprint = sprint + tonumber( tbl[1][4] );
					speed = speed + tonumber( tbl[1][5] );
					medic = medic + tonumber( tbl[1][6] );
					sneak = sneak + tonumber( tbl[1][7] );
					aim = aim + tonumber( tbl[1][8] );
					
					local query = "UPDATE `rtrp_characters` SET ";
					query = query .. "`charTokens` = '" .. tokens .. "', ";
					query = query .. "`statStrength` = '" .. strength .. "', ";
					query = query .. "`statEndurance` = '" .. endurance .. "', ";
					query = query .. "`statSprint` = '" .. sprint .. "', ";
					query = query .. "`statSpeed` = '" .. speed .. "', ";
					query = query .. "`statMedic` = '" .. medic .. "', ";
					query = query .. "`statSneak` = '" .. sneak .. "', ";
					query = query .. "`statAim` = '" .. aim .. "' WHERE `userID` = '" .. uid .. "' AND `charName` = '" .. charname .. "'";
					
					mysql.query( TS.SQL, query );
					mysql.query( TS.SQL, "DELETE FROM `rtrp_realtimedonations` WHERE `SteamID` = '" .. steamid .. "'" );
					
				end
				
			end
		
		end
	
	end

end

function TS.ConnectToSQL()

	local err;
	--If you are to change mysql info here, change below too.
	TS.SQL, err = mysql.connect( "SQL_HOST", "SQL_USER", "SQL_PASSWORD", "SQL_DATABASE", "3306" );
	
	if( TS.SQL == 0 ) then
	
		Msg( "SQL CONNECTION ERROR: " .. err .. "\n" );
	
	else
	
		Msg( "SQL CONNECTION SUCCESS\n" );
	
	end
	
	sql.Query( "CREATE TABLE IF NOT EXISTS `rtrp_doors` ( SteamID CHAR(32), id INTEGER, CheckTime INTEGER, SessionID INTEGER );" );
	sql.Query( "CREATE TABLE IF NOT EXISTS `rtrp_toollog` ( log TEXT );" );
	sql.Query( "CREATE TABLE IF NOT EXISTS `rtrp_proplog` ( log TEXT );" );
	
end

function TS.CheckSQLStatus()

	local tbl = mysql.query( TS.SQL, "SELECT * FROM rtrp_sqlverify" );

	if( not tbl or #tbl < 1 ) then
	
		mysql.disconnect( TS.SQL );
		--If you are to change mysql info here, change above too.
		TS.SQL, err = mysql.connect( "SQL_HOST", "SQL_USER", "SQL_PASSWORD", "SQL_DATABASE", "3306" );
	
	end
	
end

function TS.ClearActiveList()

	local ip = GetConVarString( "ip" );
	local port = TS.Port;
		
	if( string.find( ip, ":" ) ) then
		port = string.gsub( string.sub( ip, string.find( ip, ":" ) + 1 ), " ", "" );
		ip = string.sub( ip, 1, string.find( ip, ":" ) - 1 );
	end

	local query = "UPDATE `rtrp_users` SET `serverIP` = '', `serverPort` = '' WHERE `serverIP` = '" .. ip .. "' AND `serverPort` = '" .. port .. "'";
	mysql.query( TS.SQL, query );

end

TS.DoorID = 1;

--Format a door entity (has to do with properties, etc..)
function TS.FormatDoorEntity( x, y, z, buildingname, name, parent, state, price )

	local ents = ents.FindInBox( Vector( x, y, z ), Vector( x, y, z ) );
	
	for k, v in pairs( ents ) do
	
		if( v:IsDoor() ) then 
		
			local door = v;
			
			door:SetNWString( "buildingname", buildingname );
			door:SetNWString( "doorname", name );
			door:SetNWString( "doorparent", parent );
			door:SetNWInt( "doorstate", state );
			door:SetNWFloat( "doorprice", price );
			door:SetNWBool( "formatteddoor", true );
			door:SetNWInt( "doorid", TS.DoorID );
			door:SetNWFloat( "origx", x );
			door:SetNWFloat( "origy", y );
			door:SetNWFloat( "origz", z );
			
			if( state == 1 or state == 2 or state == 3 ) then
				door:Fire( "lock", "", 0 );
			end
			
			door:GetTable().OrigName = name;
		
			table.insert( TS.DoorGroups[buildingname], door );
			TS.DoorGroupsByID[TS.DoorID] = door;
			
			TS.DoorID = TS.DoorID + 1;
		
		end
	
	end
	
end

TS.DoorGroups = { }
TS.DoorGroupsByID = { }

--Loads map's property info
function TS.CreateDoorInfo()

	if( not file.Exists( "TacoScript/mapdata/" .. game.GetMap() .. ".txt" ) ) then
		SetGlobalInt( "PropertyPaying", 0 ); --Disable property paying if there's no map data
		return;
	end

	local arg = TS.GetArgumentLists( file.Read( "TacoScript/mapdata/" .. game.GetMap() .. ".txt" ) );
	
	if( not arg ) then return; end

	for k, v in pairs( arg ) do
	
		if( v[1] == "BEGINBUILDING" ) then
		
			local buildingname = v[2] or " ";
			k = k + 1;

			if( not TS.DoorGroups[buildingname] ) then
				TS.DoorGroups[buildingname] = { }
			end
			
			while( arg[k][1] ~= "ENDBUILDING" ) do
			
				local x = tonumber( arg[k][1] );
				local y = tonumber( arg[k][2] );
				local z = tonumber( arg[k][3] );
				local doorname = arg[k][4];
				local parent = arg[k][5];
				local doorstate = tonumber( arg[k][6] );
				local doorprice = tonumber( arg[k][7] );
				
				TS.FormatDoorEntity( x, y, z, buildingname, doorname, parent, doorstate, doorprice );
				k = k + 1;
			
			end
			
		end
	
	end
	
end

function TS.LoadMapData()
	
	local curmap = game.GetMap();

	include( "maps/rp_rtrp_city45_v01.lua" );

end

TS.TT = nil;
TS.TT = { }

function TS.LoadToolTrust()

	local filedata = file.Read( "TacoScript/data/tooltrust.txt" ) or "";
	TS.TT = TS.GetArgumentLists( filedata );
	
end

TS.CombineRoster = nil;
TS.CombineRoster = { }

function TS.LoadCombineRoster()

	local filedata = file.Read( "TacoScript/data/combine_roster.txt" ) or "";
	TS.CombineRoster = TS.GetArgumentLists( filedata );

end

TS.MiscFlags = nil;
TS.MiscFlags = { }

function TS.LoadMiscFlags()

	local filedata = file.Read( "TacoScript/data/misc_flags.txt" ) or "";
	TS.MiscFlags = TS.GetArgumentLists( filedata );	

end

TS.AdminFlags = nil;
TS.AdminFlags = { }

function TS.LoadAdminFlags()

	local filedata = file.Read( "TacoScript/data/admin_flags.txt" ) or "";
	TS.AdminFlags = TS.GetArgumentLists( filedata );	

	for k, v in pairs( TS.AdminFlags ) do
	
		TS.AdminFlags[v[1]] = v[2];
		TS.AdminFlags[k] = nil;
	
	end

end

TS.CIDs = nil;
TS.CIDs = { }

function TS.LoadCIDs()

	local filedata = file.Read( "TacoScript/data/cids.txt" ) or "";
	TS.CIDs = TS.GetArgumentLists( filedata );		

end

TS.PhysgunBans = nil;
TS.PhysgunBans = { }

function TS.LoadPhysgunBans()

	local filedata = file.Read( "TacoScript/data/physgunbans.txt" ) or "";
	TS.PhysgunBans = TS.GetArgumentLists( filedata );		
	
end

TS.TeamData = nil;
TS.ClientTeamData = nil;

TS.TeamData = { }
TS.ClientTeamData = { }

function TS.SendClientTeamData( ply )

	for k, v in pairs( TS.ClientTeamData ) do
	
		umsg.Start( "CreateTeam" );
			umsg.Short( v.ID );
			umsg.String( v.Name );
			umsg.Short( v.Color.r ); umsg.Short( v.Color.g ); 
			umsg.Short( v.Color.b ); umsg.Short( v.Color.a );
		umsg.End();
	
	end

end

function TS.ParseTeams()

	local filedata = file.Read( "TacoScript/data/teams.txt" ) or "";
	local rawdata = TS.GetArgumentLists( filedata );

	local tName, tID, tJob, tColor, tArmor, tModels, tWeapons, tWeaponAmmo, tHealth, tItems;

	for _, v in pairs( rawdata ) do
	
		local cmd = v[1];

		if( cmd == "TEAM_START" ) then
		
			tName = "";
			tID = 0;
			tJob = "";
			tColor = Color( 255, 255, 255, 255 );
			tWeapons = { }
			tWeaponAmmo = { }
			tModels = { }
			tItems = { }
			tArmor = 0;
			tHealth = 0;
		
		end
		
		if( cmd == "TEAM_ITEM" ) then
		
			table.insert( tItems, v[2] );
		
		end
		
		if( cmd == "TEAM_BONUSHEALTH" ) then
		
			tHealth = tonumber( v[2] );
		
		end
		
		if( cmd == "TEAM_NAME" ) then
		
			tName = v[2];
		
		end
		
		if( cmd == "TEAM_WEAPON" ) then
		
			table.insert( tWeapons, v[2] );
		
		end
		
		if( cmd == "TEAM_WEAPONAMMO" ) then
		
			table.insert( tWeaponAmmo, { Type = v[2], Amount = tonumber( v[3] ) } );
		
		end
		
		if( cmd == "TEAM_MODEL" ) then

			table.insert( tModels, v[2] );
		
		end
		
		if( cmd == "TEAM_ARMOR" ) then
		
			tArmor = tonumber( v[2] );
		
		end
		
		if( cmd == "TEAM_JOB" ) then
		
			tJob = v[2];
		
		end
		
		if( cmd == "TEAM_ID" ) then
		
			tID = tonumber( v[2] );
		
		end
		
		if( cmd == "TEAM_COLOR" ) then
		
			local r = tonumber( v[2] );
			local g = tonumber( v[3] );
			local b = tonumber( v[4] );
			local a = tonumber( v[5] );
		
			tColor = Color( r, g, b, a );
		
		end
		
		if( cmd == "TEAM_END" ) then
		
			team.SetUp( tID, tName, tColor );
			
			table.insert( TS.TeamData, { Items = tItems, Weapons = tWeapons, Ammo = tWeaponAmmo, Armor = tArmor, Health = tHealth, Models = tModels, Job = tJob, Name = tName, ID = tID, Color = tColor } );
			table.insert( TS.ClientTeamData, { Name = tName, ID = tID, Color = tColor } );
		
		end
	
	end

end

TS.ItemData = { }
TS.FactoryItems = { }

--Item callbacks: PickupFunc, UseFunc
--Misc item vars: Message

function TS.CreateTempItem( id, name, size, weight, model, desc )

	local NewItem = { }
	
	NewItem.UniqueID = id;
	NewItem.Name = name;
	NewItem.Size = size;
	NewItem.Weight = weight;
	NewItem.Model = model;
	NewItem.Desc = desc;
	NewItem.Usable = false;
	NewItem.BlackMarket = false;
	NewItem.FactoryBuyable = false;
	
	TS.ItemData[id] = NewItem;
	
	return id;

end

--Load item scripts into TS.ItemData
function TS.ParseItems()

	local list = file.FindInLua( "TacoScript/gamemode/items/*.lua" );
	
	for _, v in pairs( list ) do
		
		ITEM = nil;
		ITEM = { }
		
		include( "items/" .. v );
		
		ITEM.UniqueID = string.gsub( v, ".lua", "" );
			
		ITEM.Name = ITEM.Name or "";
		ITEM.Size = ITEM.Size or 1;
		ITEM.Usable = ITEM.Usable or false;
		ITEM.Weight = ITEM.Weight or 1;
		ITEM.Model = ITEM.Model or "";
		ITEM.Desc = ITEM.Desc or "";
		ITEM.SupplyLicense = ITEM.License or 0;
		ITEM.Flags = ITEM.Flags or "";
		
		if( ITEM.BlackMarket == nil ) then
			ITEM.BlackMarket = false;
		end
		
		if( ITEM.FactoryBuyable == nil ) then
			ITEM.FactoryBuyable = false;
		end
		
		if( ITEM.RebelCost == nil ) then
			ITEM.RebelCost = -1;
		end
		
		ITEM.FactoryPrice = ITEM.FactoryPrice or 0;
		ITEM.FactoryStock = ITEM.FactoryStock or 0;
		
		TS.ItemData[ITEM.UniqueID] = ITEM;
		
		if( ITEM.FactoryBuyable ) then
		
			local factoryitem = { }
			factoryitem.ID = ITEM.UniqueID;
			factoryitem.Name = ITEM.Name;
			factoryitem.Desc = ITEM.Desc;
			factoryitem.Model = ITEM.Model;
			factoryitem.StockPrice = ITEM.FactoryPrice;
			factoryitem.StockCount = ITEM.FactoryStock;
			factoryitem.BlackMarket = ITEM.BlackMarket;
			factoryitem.SupplyLicense = ITEM.SupplyLicense;
			factoryitem.RebelCost = ITEM.RebelCost;
			factoryitem.Flags = ITEM.Flags;
			
			table.insert( TS.FactoryItems, factoryitem );
			
		end
		
	end


end

function GM:ShutDown()

	mysql.disconnect( TS.SQL );

end

