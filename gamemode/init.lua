----------------------------
-- TacoScript (March 23, 2007)
-- by Rick Darkaliono
--
-- First beta - June 1, 2007
-- Second beta - July 2, 2007
-- Completion - March 8, 2008
----------------------------

-- Good luck to whoever reads this line of text, and may the scripting prosper.
-- - Rick (March 08 2008)

-- Item flags = 
-- a - Can place in empty bottle
-- b - Can mix with liquid
-- c - Destroyable with container

-- Bone Scale Example

-- local Bone = ent:FindNearestBone( Pos );
-- local VarName = "InflateSize"..Bone
-- ent:SetNetworkedInt( VarName, NewSize )
-- Min: -10
-- Max: 50
--

--CHANGELOGS--

--January 16
-- Updated the script to work with the new GMod update...

--July 25--
--Finished majority of new weapons menu

--July 24--
-- Rewrote target info HUD
-- Enabled door knocking
-- Prevented players from getting "decimal money"
-- Added rp_admintitle command (Rick only)
-- Perma bans are now done both by SteamID AND IP address 

--Later July 24--
-- Fixed door HUD error

--July 9--
-- Fixed players bypassing the sbox_maxprops limit
-- Added rp_propspawning toggle command
-- Added rp_maxttprops (how many props TTers can spawn), tooltrusted players by default can spawn more then non-tooltrusted
-- Lowered stat raising rate for strength
-- Added Stats to help menu
-- You could listen in on radio even if you don't have one
-- Hopefully fixed Combine radio thing

--July 7--
-- Enabled letters/weapons saving
-- Only TS weapons save
-- Backup loading fixed
-- Speed, sprint stat-raising rate lowered
-- Raised black market prices (even higher)
-- Medic stat raising
-- Sneak stat raising
-- Began adding workshop functionality to items

--July 5--
-- Fixed letter appearing to everyone
-- SWEP spawning is super admin only
-- Disabled weapon saving/loading
-- Giving Tooltrust is super admin only
-- Disabled letter item saving/loading

DeriveGamemode( "sandbox" );

include( "NPCAnims.lua" );

TACOSCRIPT_RUNNING = true;
TS = { }

NPC_ANIMS_ENABLED = true;

--TS_DEBUG_MODE = true;



--[[
local meta = FindMetaTable( "Player" );
   
 /*--------------------------------------------------------- 
    Name:	AddFrozenPhysicsObject 
    Desc:	For the Physgun, adds a frozen object to the player's list 
 ---------------------------------------------------------*/   
 function meta:AddFrozenPhysicsObject( ent, phys ) 
   
 	// Get the player's table 
 	local tab = self:GetTable() 
 	 
 	// Make sure the physics objects table exists 
 	tab.FrozenPhysicsObjects = tab.FrozenPhysicsObjects or {} 
 	 
 	// Make a new table that contains the info 
 	local entry = {} 
 	entry.ent 	= ent 
 	entry.phys 	= phys 
 	 
 	table.insert( tab.FrozenPhysicsObjects, entry ) 
 	 
 	gamemode.Call( "PlayerFrozeObject", self, ent, phys ) 
 	 
 end 
   
 local function PlayerUnfreezeObject( ply, ent, object ) 
   
 	// Not frozen! 
 	if ( object:IsMoveable() ) then return 0 end 
 	 
 	// Unfreezable means it can't be frozen or unfrozen. 
 	// This prevents the player unfreezing the gmod_anchor entity. 
 	if ( ent:GetUnFreezable() ) then return 0 end 
 	 
 	// NOTE: IF YOU'RE MAKING SOME KIND OF PROP PROTECTOR THEN HOOK "CanPlayerUnfreeze" 
 	if ( !gamemode.Call( "CanPlayerUnfreeze", ply, ent, object ) ) then return 0 end 
   
 	object:EnableMotion( true ) 
 	object:Wake() 
 	 
 	gamemode.Call( "PlayerUnfrozeObject", ply, ent, object ) 
 	 
 	return 1 
 	 
 end 
   
   
 /*--------------------------------------------------------- 
    Name:	UnfreezePhysicsObjects 
    Desc:	For the Physgun, unfreezes all frozen physics objects 
 ---------------------------------------------------------*/   
 function meta:PhysgunUnfreeze( weapon ) 
   
 	// Get the player's table 
 	local tab = self:GetTable() 
 	if (!tab.FrozenPhysicsObjects) then return 0 end 
   
 	// Detect double click. Unfreeze all objects on double click. 
 	if ( tab.LastPhysUnfreeze && CurTime() - tab.LastPhysUnfreeze < 0.25 ) then 
 		return self:UnfreezePhysicsObjects() 
 	end 
 		 
 	local tr = self:GetEyeTrace() 
 	if ( tr.HitNonWorld && ValidEntity( tr.Entity ) ) then 
 	 
 		local Ents = constraint.GetAllConstrainedEntities( tr.Entity ) 
 		local UnfrozenObjects = 0 
 		 
 		for k, ent in pairs( Ents ) do 
 					 
 			local objects = ent:GetPhysicsObjectCount() 
 	 
 			for i=1, objects do 
 	 
 				local physobject = ent:GetPhysicsObjectNum( i-1 ) 
 				UnfrozenObjects = UnfrozenObjects + PlayerUnfreezeObject( self, ent, physobject ) 
 		 
 			end 
 		 
 		end 
 	 
   
 		 
 		return UnfrozenObjects 
 	 
 	end 
 	 
 	tab.LastPhysUnfreeze = CurTime()	 
 	return 0 
   
 end 
   
 /*--------------------------------------------------------- 
    Name:	UnfreezePhysicsObjects 
    Desc:	For the Physgun, unfreezes all frozen physics objects 
 ---------------------------------------------------------*/   
 function meta:UnfreezePhysicsObjects() 
   
 	// Get the player's table 
 	local tab = self:GetTable() 
 	 
 	// If the table doesn't exist then quit here 
 	if (!tab.FrozenPhysicsObjects) then return 0 end 
 	 
 	local Count = 0 
 	 
 	// Loop through each table in our table 
 	for k, v in pairs( tab.FrozenPhysicsObjects ) do 
 	 
 		// Make sure the entity to which the physics object 
 		// is attached is still valid (still exists) 
 		if (v.ent:IsValid()) then 
 		 
 			// We can't directly test to see if EnableMotion is false right now 
 			// but IsMovable seems to do the job just fine. 
 			// We only test so the count isn't wrong 
 			if (v.phys && !v.phys:IsMoveable()) then 
 			 
 				// We need to freeze/unfreeze all physobj's in jeeps to stop it spazzing 
 				if (v.ent:GetClass() == "prop_vehicle_jeep") then 
 				 
 					// How many physics objects we have 
 					local objects = v.ent:GetPhysicsObjectCount() 
 	 
 					// Loop through each one 
 					for i=0, objects-1 do 
 		 
 						local physobject = v.ent:GetPhysicsObjectNum( i ) 
 						PlayerUnfreezeObject( self, v.ent, physobject ) 
 				 
 					end 
 					 
 				end 
 			 
 				local physobject = v.ent:GetPhysicsObjectNum( i ) 
 				Count = Count + PlayerUnfreezeObject( self, v.ent, v.phys ) 
 				 
 			end 
 		 
 		end 
 	 
 	end 
 			 
 	// Remove the table 
 	tab.FrozenPhysicsObjects = nil 
 	 
 	return Count 
   
 end 
 
 
 /*--------------------------------------------------------- 
 	Player Eye Trace 
 ---------------------------------------------------------*/ 
 function meta:GetEyeTrace() 
   
 	if ( self.LastPlayertTrace == CurTime() ) then 
 		return self.PlayerTrace 
 	end 
   
 	self.PlayerTrace = util.TraceLine( util.GetPlayerTrace( self, self:GetCursorAimVector() ) ) 
 	self.LastPlayertTrace = CurTime() 
 	 
 	return self:GetTable().PlayerTrace 
   
 end 
   
 /*--------------------------------------------------------- 
 	GetEyeTraceIgnoreCursor 
 	Like GetEyeTrace but doesn't use the cursor aim vector.. 
 ---------------------------------------------------------*/ 
 function meta:GetEyeTraceNoCursor() 
   
 	if ( self:GetTable().LastPlayerAimTrace == CurTime() ) then 
 		return self:GetTable().PlayerAimTrace 
 	end 
   
 	self:GetTable().PlayerAimTrace = util.TraceLine( util.GetPlayerTrace( self ) ) 
 	self:GetTable().LastPlayertAimTrace = CurTime() 
 	 
 	return self:GetTable().PlayerAimTrace 
   
 end  
  
 ]]--
 

require( "mysql" );

--Mysql safe guard
if( not mysql ) then

	MYSQL_DED = true;
	
	mysql = { }
	
	mysql.connect = function() return 1; end
	mysql.disconnect = function() end
	mysql.query = function() return { }; end
	mysql.escape = function( sql, str ) return str; end

end

TS.GlobalInts = { }
TS.GlobalStrings = { }
TS.GlobalFloats = { }

function SetGlobalInt( key, val )

	TS.GlobalInts[key] = val;
	
	umsg.Start( "SetGlobalInt" );
		umsg.String( key );
		umsg.Long( val );
	umsg.End();

end

function SetGlobalFloat( key, val )

	TS.GlobalFloats[key] = val;

	umsg.Start( "SetGlobalFloat" );
		umsg.String( key );
		umsg.Float( val );
	umsg.End();

end

function SetGlobalString( key, val )

	TS.GlobalStrings[key] = val;
	
	umsg.Start( "SetGlobalString" );
		umsg.String( key );
		umsg.String( val );
	umsg.End();

end


function GetGlobalInt( var )

	return TS.GlobalInts[var];

end

function GetGlobalFloat( var )

	return TS.GlobalFloats[var];

end

function GetGlobalString( var )

	return TS.GlobalStrings[var];

end

TS.Models = {

	          "models/Humans/Group01/Male_01.mdl",
              "models/Humans/Group01/male_02.mdl",
              "models/Humans/Group01/male_03.mdl",
              "models/Humans/Group01/Male_04.mdl",
              "models/Humans/Group01/Male_05.mdl",
              "models/Humans/Group01/male_06.mdl",
              "models/Humans/Group01/male_07.mdl",
              "models/Humans/Group01/male_08.mdl",
              "models/Humans/Group01/male_09.mdl",
              "models/Humans/Group02/Male_01.mdl",
              "models/Humans/Group02/male_02.mdl",
              "models/Humans/Group02/male_03.mdl",
              "models/Humans/Group02/Male_04.mdl",
              "models/Humans/Group02/Male_05.mdl",
              "models/Humans/Group02/male_06.mdl",
              "models/Humans/Group02/male_07.mdl",
              "models/Humans/Group02/male_08.mdl",
              "models/Humans/Group02/male_09.mdl",

              "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl",
}



AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_render.lua" );
AddCSLuaFile( "cl_fade.lua" );
AddCSLuaFile( "cl_view.lua" );
AddCSLuaFile( "cl_notify.lua" );
AddCSLuaFile( "cl_target.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "entity.lua" );
AddCSLuaFile( "cl_inventory.lua" );
AddCSLuaFile( "cl_playermenu.lua" );
AddCSLuaFile( "cl_think.lua" );
AddCSLuaFile( "cl_alterchat.lua" );
AddCSLuaFile( "cl_help.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_charactercreate.lua" );
AddCSLuaFile( "cl_letters.lua" );
AddCSLuaFile( "cl_actionmenu.lua" );
AddCSLuaFile( "cl_workshop.lua" );
AddCSLuaFile( "cl_weaponslotmenu.lua" );
AddCSLuaFile( "cl_accountcreation.lua" );
AddCSLuaFile( "cl_rostermenu.lua" );
AddCSLuaFile( "cl_quiz.lua" );
--AddCSLuaFile( "networkoverride.lua" );
AddCSLuaFile( "cl_processbar.lua" );
AddCSLuaFile( "cl_chatbox.lua" );
AddCSLuaFile( "cl_adminmenu.lua" );

AddCSLuaFile( "tacovgui/cl_panel.lua" );
AddCSLuaFile( "tacovgui/cl_button.lua" );
AddCSLuaFile( "tacovgui/cl_closebutton.lua" );
AddCSLuaFile( "tacovgui/cl_titlelabel.lua" );
AddCSLuaFile( "tacovgui/cl_body.lua" );
AddCSLuaFile( "tacovgui/cl_scroll.lua" );
AddCSLuaFile( "tacovgui/cl_tacoentry.lua" );
AddCSLuaFile( "tacovgui/cl_tacoframe.lua" );
AddCSLuaFile( "tacovgui/cl_link.lua" );

AddCSLuaFile( "player_shared.lua" );

include( "admin.lua" );
include( "parse.lua" );
include( "concmd.lua" );
include( "player_shared.lua" );
include( "server_vars.lua" );
include( "player_server.lua" );
include( "player_hooks.lua" );
include( "player_stats.lua" );
include( "player_dmg.lua" );
include( "util.lua" );
include( "entity.lua" );
include( "hash.lua" );
include( "chat.lua" );
include( "rp_chat.lua" );
include( "shared.lua" );
include( "player_doorownership.lua" );
include( "player_status.lua" );
include( "server_events.lua" );
include( "special_chars.lua" );
include( "admin_cc.lua" );
include( "server_util.lua" );
include( "player_sqldata.lua" );
--include( "player_data.lua" );
include( "player_anims.lua" );
include( "player_actionmenu.lua" );
--include( "networkoverride.lua" );
include( "workshop.lua" );
include( "concmd.lua" );
include( "mixtures.lua" );
include( "resources.lua" );
include( "custom_spawnpoints.lua" );
include( "rp_tooltrust.lua" );
include( "item_concmd.lua" );

--game.ConsoleCommand( "lua_networkvar_bytespertick 64\n" );

LAG_TEST = false;

SAVE_VERSION = 1;

TS.QuizFailers = { }

--TS.Port = "27015";

--Useless global int
SetGlobalInt( "waxx", 0 );

local function FillRebelWeaponry()

	SetGlobalInt( "RebelWeaponry", math.Clamp( GetGlobalInt( "RebelWeaponry" ) + 33.333334, 1, 100 ) );

end
timer.Create( "FillRebelWeaponry", 600, 0, FillRebelWeaponry );

SetGlobalInt( "RebelWeaponry", 100 );

--Is there properties? (or just door owning)
SetGlobalInt( "PropertyPaying", 1 );

--Both functions are called 2 seconds after initial map load (for good reason too)
timer.Simple( 2, TS.CreateThirdPersonCamera );

if( GetGlobalInt( "PropertyPaying" ) == 1 ) then
	timer.Simple( 2, TS.CreateDoorInfo );
end

TS.LastSQLReconnect = 0;

function SQLReconnect()

	TS.CheckSQLStatus();

end
timer.Create( "SQLReconnect", 30, 0, SQLReconnect );

TS.LoadMapData();

TS.ConnectToSQL();

--TS.ClearActiveList();

TS.LoadCIDs();

TS.LoadPhysgunBans();

--Open all the item scripts
TS.ParseItems();

--Load teams
TS.ParseTeams();

--Load tooltrust
--TS.LoadToolTrust();

--Load Combine Roster
--TS.LoadCombineRoster();

--Load Misc Flags
--TS.LoadMiscFlags();

--Load admin flags
--TS.LoadAdminFlags();

TS.PropLogs = { }
TS.ToolLogs = { }

--Load economy money amount
SetGlobalFloat( "EconomyMoney", tonumber( file.Read( "TacoScript/data/economymoney.txt" ) or 0 ) );

SetGlobalInt( "CombineRations", 30 );

function GiveRations()

	if( GetGlobalInt( "CombineRations" ) < 30 ) then
	
		SetGlobalInt( "CombineRations", 30 );
		
		for k, v in pairs( player.GetAll() ) do
		
			if( v:IsCombineDefense() ) then
				v:PrintMessage( 3, "Supplies have arrived from outside the valley" );
			end
			
		end
	
	end

end
timer.Create( "GiveRations", 600, 0, GiveRations );

local function PeriodicSave()
	
	local function PlySave( ply )
	
		if( ply:IsValid() and ply:GetTable().SaveLoaded ) then
		
			ply:SaveCharacter();
		
		end
	
	end
	
	local num = 0;
	
	for k, v in pairs( player.GetAll() ) do
	
		timer.Simple( num, PlySave, v );
		num = num + 2;
	
	end
	
end
timer.Create( "PeriodicSave", 180, 0, PeriodicSave );

local function GenerateCombineRadio()

	--Generate random combine radio frequency
	TS.CombineRadioFreq = tonumber( math.random( 100, 850 ) .. "." .. math.random( 0, 9 ) );
	

end

timer.Simple( 5, GenerateCombineRadio );

if( ScriptBusinessID ) then

	for n = 1, ScriptBusinessID do
		
		for j = 1, TS.GetBusinessInt( n, "itemcount" ) do
		
			TS.SetBusinessString( n, "item." .. j .. ".name", "" );
		
		end
		
		TS.SetBusinessInt( n, "itemcount", 0 )
	
	end

end

ScriptBusinessID = 0;

GM.Name = "RefugeeRP 2.0 Relaunched";

function GM:Initialize()

	self.BaseClass:Initialize();

end

local function SQLCheck()

	TS.CheckSQLStatus();
	
end
--timer.Create( "SQLCheck", 90, 0, SQLCheck );

timer.Create( "DonateCheck", 300, 0, TS.DoRealTimeDonation );

local function F1Reminder()

	TS.NotifyAll( "Press F1 for help", 5 );

end
timer.Create( "F1Reminder", 300, 0, F1Reminder );

local function CreateSessionID()

	TS.CrntSessionID = math.random( 1, 255 );

end
timer.Simple( 3, CreateSessionID );

local function DestroyAllOldOwnerships()

	sql.Query( "DELETE FROM `rtrp_doors` WHERE `SessionID` != '" .. TS.CrntSessionID .. "'" );

end
timer.Simple( 720, DestroyAllOldOwnerships );

--Initialize any active players on gamemode reload
for k, v in pairs( player.GetAll() ) do

	if( v:GetField( "isko" ) == 1 ) then
		v:GoConscious();
	end

	GAMEMODE:PlayerInitialSpawn( v );

end

function GM:ShowHelp( ply )

	umsg.Start( "ShowHelpMenu", ply ); umsg.End();

end

--Fixes for gm_showspare because F3 and F4 are binded to "gm_share1" and "gm_spare2" for
--whatever reason..
function ShowSpare1Fix( ply )

	ply:ConCommand( "gm_showspare1\n" );

end
concommand.Add( "gm_spare1", ShowSpare1Fix );

function ShowSpare2Fix( ply )

	ply:ConCommand( "gm_showspare2\n" );

end
concommand.Add( "gm_spare2", ShowSpare2Fix );

TS.DebugFile( "Server start" );


local function SpawnProp( ply, cmd, arg )

	if( not string.find( arg[1], "maps/" ) and not string.find( arg[1], ".bsp" ) ) then
	
		CCSpawn( ply, cmd, arg );
	
	else
	
		TS.Log( "jetboomhax.txt", ply:LogInfo() .. " tried to hax" );
	
	end

end
concommand.Add( "gm_spawn", SpawnProp );

concommand.Add( "impulse", function() end );



--[[
local tquery = mysql.query;
function mysql.query( sqlobj, query )

	sqlobj = mysql.connect( "SQL_HOST", "SQL_USER", "SQL_PASSWORD", "SQL_DATABASE", "3306" );
	
	tquery( sqlobj, query );

end
]]--
