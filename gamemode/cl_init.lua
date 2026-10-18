
--Base gamemode shit. Copy pasta.
--[[
 	GM.ShowScoreboard = false 
 	  surface.CreateFont( "coolvetica", 48, 1000, true, false, "GModToolName" ) 
 surface.CreateFont( "coolvetica", 24, 500, true, false, "GModToolSubtitle" ) 
 surface.CreateFont( "coolvetica", 19, 500, true, false, "GModToolHelp" ) 
 	surface.CreateFont( "coolvetica", 48, 500, true, false, "ScoreboardHead" ) 
 	surface.CreateFont( "coolvetica", 24, 500, true, false, "ScoreboardSub" ) 
 	surface.CreateFont( "Tahoma", 16, 1000, true, false, "ScoreboardText" ) 
 	
 	 function GM:PlayerBindPress( pl, bind, down ) 
   
 	// If we're driving, toggle third person view using duck 
 	if ( down && bind == "+duck" && ValidEntity( pl:GetVehicle() ) ) then 
 	 
 		local iVal = gmod_vehicle_viewmode:GetInt() 
 		if ( iVal == 0 ) then iVal = 1 else iVal = 0 end 
 		RunConsoleCommand( "gmod_vehicle_viewmode", iVal ) 
 		return true 
 		 
 	end 
   
 	return false	 
 	 
 end 
 
  function GM:CallScreenClickHook( bDown, mousecode, AimVector ) 
   
 	local i = 0 
 	if ( bDown ) then i = 1 end 
 	 
 	// Tell the server that we clicked on the screen so it can actually do stuff. 
 	RunConsoleCommand( "cnc", i, mousecode, AimVector.x, AimVector.y, AimVector.z ) 
 	 
 	// And let us predict it clientside 
 	hook.Call( "ContextScreenClick", GAMEMODE, AimVector, mousecode, bDown, LocalPlayer() ) 
   
 end 
   
     
 /*--------------------------------------------------------- 
    Name: gamemode:GUIMousePressed( mousecode ) 
    Desc: The mouse has been pressed on the game screen 
 ---------------------------------------------------------*/ 
 function GM:GUIMousePressed( mousecode, AimVector ) 
   
 	hook.Call( "CallScreenClickHook", GAMEMODE, true, mousecode, AimVector ) 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:GUIMouseReleased( mousecode ) 
    Desc: The mouse has been released on the game screen 
 ---------------------------------------------------------*/ 
 function GM:GUIMouseReleased( mousecode, AimVector ) 
   
 	hook.Call( "CallScreenClickHook", GAMEMODE, false, mousecode, AimVector ) 
   
 end 
 
 
 /*--------------------------------------------------------- 
    Name: gamemode:GUIMouseReleased( mousecode ) 
    Desc: The mouse was double clicked 
 ---------------------------------------------------------*/ 
 function GM:GUIMouseDoublePressed( mousecode, AimVector ) 
 	// We don't capture double clicks by default,  
 	// We just treat them as regular presses 
 	GAMEMODE:GUIMousePressed( mousecode, AimVector ) 
 end 
   

 /*--------------------------------------------------------- 
    Name: gamemode:GetTeamColor( ent ) 
    Desc: Return the color for this ent's team 
 		This is for chat and deathnotice text 
 ---------------------------------------------------------*/ 
 function GM:GetTeamColor( ent ) 
   
 	local team = TEAM_UNASSIGNED 
 	if (ent.Team) then team = ent:Team() end 
 	return GAMEMODE:GetTeamNumColor( team ) 
   
 end 
   
   
 /*--------------------------------------------------------- 
    Name: gamemode:GetTeamNumColor( num ) 
    Desc: returns the colour for this team num 
 ---------------------------------------------------------*/ 
 function GM:GetTeamNumColor( num ) 
   
 	return team.GetColor( num ) 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:OnChatTab( str ) 
    Desc: Tab is pressed when typing (Auto-complete names, IRC style) 
 ---------------------------------------------------------*/ 
 function GM:OnChatTab( str ) 
   
 	local LastWord 
 	for word in string.gmatch( str, "%a+" ) do 
 	     LastWord = word; 
 	end 
 	 
 	if (LastWord == nil) then return str end 
 	 
 	playerlist = player.GetAll() 
 	 
 	for k, v in pairs( playerlist ) do 
 		 
 		local nickname = v:Nick() 
 		 
 		if ( string.len(LastWord) < string.len(nickname) && 
 			 string.find( string.lower(nickname), string.lower(LastWord) ) == 1 ) then 
 				 
 			str = string.sub( str, 1, (string.len(LastWord) * -1) - 1) 
 			str = str .. nickname 
 			return str 
 			 
 		end		 
 		 
 	end 
 		 
 	return str; 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:StartChat( teamsay ) 
    Desc: Start Chat. 
     
 		 If you want to display your chat shit different here's what you'd do: 
 			In StartChat show your text box and return true to hide the default 
 			Update the text in your box with the text passed to ChatTextChanged 
 			Close and clear your text box when FinishChat is called. 
 			Return true in ChatText to not show the default chat text 
 			 
 ---------------------------------------------------------*/ 
 function GM:StartChat( teamsay ) 
 	return false 
 end 
   

 /*--------------------------------------------------------- 
    Name: ChatText 
    Allows override of the chat text 
 ---------------------------------------------------------*/ 
 function GM:ChatText( playerindex, playername, text, filter ) 
   
 	if ( filter == "chat" ) then 
 		Msg( playername, ": ", text, "\n" ) 
 	else 
 		Msg( text, "\n" ) 
 	end 
 	 
 	return false 
   
 end 
   
 /*--------------------------------------------------------- 
    Name:  
 ---------------------------------------------------------*/ 
 function GM:GetSWEPMenu() 
   
 	local columns = {} 
 	columns[ 1 ] = "#Name" 
 	columns[ 2 ] = "#Author" 
 	columns[ 3 ] = "#Admin" 
 	 
 	local ret = {} 
 	 
 	table.insert( ret, columns ) 
   
 	local weaponlist = weapons.GetList() 
 	 
 	for k,v in pairs( weaponlist ) do 
 	 
 		if ( v.Spawnable || v.AdminSpawnable ) then 
 		 
 			local entry = {} 
 			entry[ 1 ] 	= v.PrintName 
 			entry[ 2 ] 	= v.Author 
 			if ( v.AdminSpawnable && !v.Spawnable ) then entry[ 3 ]  = "ADMIN ONLY" else entry[ 3 ]  = "" end 
 			entry[ "command" ]  = "gm_giveswep "..v.Classname 
 			 
 			table.insert( ret, entry )		 
 		 
 		end 
 	 
 	end 
   
 	return ret 
   
 end 
   
 /*--------------------------------------------------------- 
    Name:  
 ---------------------------------------------------------*/ 
 function GM:GetSENTMenu() 
   
 	local columns = {} 
 	columns[ 1 ] = "#Name" 
 	columns[ 2 ] = "#Author" 
 	columns[ 3 ] = "#Admin" 
 	 
 	local ret = {} 
 	 
 	table.insert( ret, columns ) 
   
 	local entlist = scripted_ents.GetList() 
 	 
 	for k,v in pairs( entlist ) do 
 	 
 		if ( v.t.Spawnable || v.t.AdminSpawnable ) then 
 		 
 			local entry = {} 
 			entry[ 1 ] 	= v.t.PrintName 
 			entry[ 2 ] 	= v.t.Author 
 			if ( v.t.AdminSpawnable && !v.t.Spawnable ) then entry[ 3 ]  = "ADMIN ONLY" else entry[ 3 ]  = "" end 
 			entry[ "command" ]  = "gm_spawnsent "..v.t.Classname 
 			 
 			table.insert( ret, entry )		 
 		 
 		end 
 	 
 	end 
   
 	return ret 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:PostProcessPermitted( str ) 
    Desc: return true/false depending on whether this post process should be allowed 
 ---------------------------------------------------------*/ 
 function GM:PostProcessPermitted( str ) 
   
 	return true 
   
 end 
   

 /*--------------------------------------------------------- 
    Name: gamemode:GetVehicles( ) 
    Desc: Gets the vehicles table.. 
 ---------------------------------------------------------*/ 
 function GM:GetVehicles() 
   
 	return vehicles.GetTable() 
 	 
 end 

   
 /*--------------------------------------------------------- 
    Name: CalcVehicleThirdPersonView 
 ---------------------------------------------------------*/ 
 function GM:CalcVehicleThirdPersonView( Vehicle, ply, origin, angles, fov ) 
   
 	local view = {} 
 	view.angles		= angles 
 	view.fov 		= fov 
 	 
 	if ( !Vehicle.CalcView ) then 
 	 
 		Vehicle.CalcView = {} 
 		 
 		// Try to work out the size 
 		local min, max = Vehicle:WorldSpaceAABB() 
 		local size = max - min 
 		 
 		Vehicle.CalcView.OffsetUp = size.z 
 		Vehicle.CalcView.OffsetOut = (size.x + size.y + size.z) * 0.33 
 	 
 	end 
 	 
 	// Offset the origin 
 	local Up = view.angles:Up() * Vehicle.CalcView.OffsetUp * 0.66 
 	local Offset = view.angles:Forward() * -Vehicle.CalcView.OffsetOut 
 	 
 	// Trace back from the original eye position, so we don't clip through walls/objects 
 	local TargetOrigin = Vehicle:GetPos() + Up + Offset 
 	local distance = origin - TargetOrigin 
 	 
 	local trace = { 
 					start = origin, 
 					endpos = TargetOrigin, 
 					filter = Vehicle 
 				  } 
 				   
 				   
 	local tr = util.TraceLine( trace )  
 	 
 	view.origin = origin + tr.Normal * (distance:Length() - 10) * tr.Fraction 
 		 
 	return view 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: CalcView 
    Allows override of the default view 
 ---------------------------------------------------------*/ 
 function GM:CalcView( ply, origin, angles, fov ) 
 	 
 	local Vehicle = ply:GetVehicle() 
 	local wep = ply:GetActiveWeapon() 
   
 	 
 	if ( ValidEntity( Vehicle ) &&  
 		 gmod_vehicle_viewmode:GetInt() == 1  
 		 /*&& ( !ValidEntity(wep) || !wep:IsWeaponVisible() )*/ 
 		) then 
 		 
 		return GAMEMODE:CalcVehicleThirdPersonView( Vehicle, ply, origin*1, angles*1, fov ) 
 		 
 	end 
   
 	local ScriptedVehicle = ply:GetScriptedVehicle() 
 	if ( ValidEntity( ScriptedVehicle ) ) then 
 	 
 		// This code fucking sucks. 
 		local view = ScriptedVehicle.CalcView( ScriptedVehicle:GetTable(), ply, origin, angles, fov ) 
 		if ( view ) then return view end 
   
 	end 
   
 	local view = {} 
 	view.origin 	= origin 
 	view.angles		= angles 
 	view.fov 		= fov 
 	 
 	// Give the active weapon a go at changing the viewmodel position 
 	 
 	if ( ValidEntity( wep ) ) then 
 	 
 		local func = wep.GetViewModelPosition 
 		if ( func ) then 
 			view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) // Note: *1 to copy the object so the child function can't edit it. 
 		end 
 		 
 		local func = wep.CalcView 
 		if ( func ) then 
 			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) // Note: *1 to copy the object so the child function can't edit it. 
 		end 
 	 
 	end 
 	 
 	return view 
 	 
 end 
   
   

 /*--------------------------------------------------------- 
    Name: gamemode:AdjustMouseSensitivity() 
    Desc: Allows you to adjust the mouse sensitivity. 
 		 The return is a fraction of the normal sensitivity (0.5 would be half as sensitive) 
 		 Return -1 to not override. 
 ---------------------------------------------------------*/ 
 function GM:AdjustMouseSensitivity( fDefault ) 
   
 	local ply = LocalPlayer() 
 	if (!ply || !ply:IsValid()) then return -1 end 
   
 	local wep = ply:GetActiveWeapon() 
 	if ( wep && wep.AdjustMouseSensitivity ) then 
 		return wep:AdjustMouseSensitivity() 
 	end 
   
 	return -1 
 	 
 end  
 
 
   
 /*--------------------------------------------------------- 
 	If false is returned then the spawn menu is never created. 
 	This saves load times if your mod doesn't actually use the 
 	spawn menu for any reason. 
 ---------------------------------------------------------*/ 
 function GM:SpawnMenuEnabled() 
 	return false	 
 end 
   
   
 /*--------------------------------------------------------- 
   Called when spawnmenu is trying to be opened.  
    Return false to dissallow it. 
 ---------------------------------------------------------*/ 
 function GM:SpawnMenuOpen() 
 	return true	 
 end 
   
 /*--------------------------------------------------------- 
   Called when context menu is trying to be opened.  
    Return false to dissallow it. 
 ---------------------------------------------------------*/ 
 function GM:ContextMenuOpen() 
 	return false	 
 end 
   
   

   
 /*--------------------------------------------------------- 
 	+menu binds 
 ---------------------------------------------------------*/ 
 concommand.Add( "+menu", function() hook.Call( "OnSpawnMenuOpen", GAMEMODE ) end ) 
 concommand.Add( "-menu", function() hook.Call( "OnSpawnMenuClose", GAMEMODE ) end ) 
   
 /*--------------------------------------------------------- 
 	+menu_context binds 
 ---------------------------------------------------------*/ 
 concommand.Add( "+menu_context", function() hook.Call( "OnContextMenuOpen", GAMEMODE ) end ) 
 concommand.Add( "-menu_context", function() hook.Call( "OnContextMenuClose", GAMEMODE ) end )  


 /*--------------------------------------------------------- 
    Name: gamemode:UpdateAnimation( ) 
    Desc: Animation updates (pose params etc) should be done here 
 ---------------------------------------------------------*/ 
 function GM:UpdateAnimation( pl ) 
   
 	if ( pl:InVehicle() ) then 
   
 		// We only need to do this clientside.. 
 		if ( CLIENT ) then 
 		 
 			// Pass the vehicles steer param down to the player 
 			local steer = pl:GetVehicle():GetPoseParameter( "vehicle_steer" ) 
 			pl:SetPoseParameter( "vehicle_steer", steer )  
 			 
 		end 
 	 
 	end 
   
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:PlayerTraceAttack( ) 
    Desc: A bullet has been fired and hit this player 
 		 Return true to completely override internals 
 ---------------------------------------------------------*/ 
 function GM:PlayerTraceAttack( ply, dmginfo, dir, trace ) 
   
 	if ( SERVER ) then 
 		GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo ) 
 	end 
   
 	return false 
 end 
   
   
 /*--------------------------------------------------------- 
    Name: gamemode:CanPlayerEnterVehicle( player, vehicle, role ) 
    Desc: Return true if player can enter vehicle 
 ---------------------------------------------------------*/ 
 function GM:CanPlayerEnterVehicle( player, vehicle, role ) 
 	return true 
 end 
 
 function GM:PhysgunPickup( ply, ent ) 
   
 	// Don't pick up players 
 	if ( ent:GetClass() == "player" ) then return false end 
   
 	return true 
 end 
  
 /*--------------------------------------------------------- 
    Name: gamemode:PlayerShouldTakeDamage 
    Return true if this player should take damage from this attacker 
 ---------------------------------------------------------*/ 
 function GM:PlayerShouldTakeDamage( ply, attacker ) 
 	return true 
 end 
   
 /*--------------------------------------------------------- 
    Name: gamemode:ContextScreenClick(  aimvec, mousecode, pressed, ply ) 
    'pressed' is true when the button has been pressed, false when it's released 
 ---------------------------------------------------------*/ 
 function GM:ContextScreenClick( aimvec, mousecode, pressed, ply ) 
 	 
 	// We don't want to do anything by default, just feed it to the weapon 
 	local wep = ply:GetActiveWeapon() 
 	if ( ValidEntity( wep ) && wep.ContextScreenClick ) then 
 		wep:ContextScreenClick( aimvec, mousecode, pressed, ply ) 
 	end 
 	 
 end 
   


--End shit

]]--

DeriveGamemode( "sandbox" );

AccountCreation = false;

include( "cl_hud.lua" );
include( "cl_fade.lua" );
include( "cl_view.lua" );
include( "cl_target.lua" );
include( "cl_notify.lua" );
include( "player_shared.lua" );
include( "shared.lua" );
include( "entity.lua" );
include( "cl_inventory.lua" );
include( "cl_playermenu.lua" );
include( "cl_think.lua" );
include( "cl_alterchat.lua" );
include( "cl_help.lua" );
include( "cl_scoreboard.lua" );
include( "cl_charactercreate.lua" );
include( "cl_letters.lua" );
include( "tacovgui/cl_panel.lua" );
include( "cl_actionmenu.lua" );
include( "cl_workshop.lua" );
include( "cl_weaponslotmenu.lua" );
include( "cl_accountcreation.lua" );
include( "cl_rostermenu.lua" );
include( "cl_quiz.lua" );
--include( "networkoverride.lua" );
include( "cl_processbar.lua" );
include( "cl_chatbox.lua" );
include( "cl_adminmenu.lua" );

GUIClickerEnabled = false;
GUIClickerCount = 0;

--ChristmasMod = true;

gui.EnableScreenClicker( false );

if( RickRollWindow ) then
	RickRollWindow:Remove();
end

RickRollWindow = nil;

if( PatDownResult ) then

	PatDownResult:Remove();

end

PatDownResult = nil;
PatDownResultItemCount = 0;

ChristmasCheer = false;
ChristmasCheerAlpha = 0;
ChristmasCheerTime = 0;

function msgChristmasCheer()

	ChristmasCheer = true;
	ChristmasCheerAlpha = 255;
	ChristmasCheerTime = CurTime();

end
usermessage.Hook( "ChristmasCheer", msgChristmasCheer );

if( NewsPaperVGUI ) then

	NewsPaperVGUI:Remove();
	NewsPaperVGUI = nil;

end


function msgShowNewspaper()

	if( NewsPaperVGUI and NewsPaperVGUI:IsVisible() ) then return; end
	
	NewsPaperVGUI = vgui.Create( "Frame" );
	NewsPaperVGUI:SetPos( 0, 0 );
	NewsPaperVGUI:SetSize( ScrW(), ScrH() );
	NewsPaperVGUI:SetVisible( true );
	
	NewsPaperVGUI.HTMLBody = vgui.Create( "HTML", NewsPaperVGUI );
	NewsPaperVGUI.HTMLBody:OpenURL( "http://i239.photobucket.com/albums/ff186/baldrybaldry/Combinepaper.jpg" );
	NewsPaperVGUI.HTMLBody:SetPos( 10, 25 );
	NewsPaperVGUI.HTMLBody:SetSize( ScrW() - 20, ScrH() - 50 );
--	NewsPaperVGUI:AddObject( NewsPaperVGUI.HTMLBody, 0, 0 );


end
usermessage.Hook( "ShowNewspaper", msgShowNewspaper );

if( PickItemMenu ) then
	PickItemMenu:Remove();
	PickItemMenu = nil;
end

local function msgCreateItemPickMenu( msg )
if( ValidEntity( LocalPlayer() ) ) then
	PickItemMenu = vgui.Create( "TacoPanel" );
	PickItemMenu:SetPos( ScrW() / 2 - 90, ScrH() / 2 - 128 );
	PickItemMenu:SetSize( 180, 256 );
	PickItemMenu:SetTitle( "Pick an item" );
	
	PickItemMenu.Pane1 = vgui.Create( "TacoPanel", PickItemMenu );
	PickItemMenu.Pane1:SetPos( 5, 25 );
	PickItemMenu.Pane1:SetSize( 170, 246 );
	PickItemMenu.Pane1:TurnIntoChild();
	
	PickItemMenu.Pane1.Item = { }
	
	local ydisp = 5;

	for k, v in pairs( Inventory ) do

		local id = k;
			
		PickItemMenu.Pane1.Item[id] = { }
				
		PickItemMenu.Pane1.Item[id].SpawnIcon = vgui.Create( "SpawnIcon", PickItemMenu.Pane1 );
		PickItemMenu.Pane1.Item[id].SpawnIcon:SetPos( 5, ydisp );
		PickItemMenu.Pane1.Item[id].SpawnIcon:SetSize( 64, 64 );
		PickItemMenu.Pane1:AddObject( PickItemMenu.Pane1.Item[id].SpawnIcon );
		
		PickItemMenu.Pane1.Item[id].SpawnIcon:SetModel( Inventory[id].Model );
		PickItemMenu.Pane1.Item[id].SpawnIcon:SetMouseInputEnabled( false );
				
		PickItemMenu.Pane1.Item[id].ItemName = PickItemMenu.Pane1:AddLabel( Inventory[id].Name, "Default", 70, ydisp + 10, Color( 255, 255, 255, 255 ) );
		
		PickItemMenu.Pane1.Item[id].DropItem = PickItemMenu.Pane1:AddButton( "Pick", 70, ydisp + 40, 50, 15 );
		PickItemMenu.Pane1.Item[id].DropItem.butID = id;
		PickItemMenu.Pane1.Item[id].DropItem:SetCallback( function() LocalPlayer():ConCommand( "rp_pickitem " .. id ); end );
		PickItemMenu.Pane1.Item[id].DropItem:SetRoundness( 0 );

		ydisp = ydisp + 64;
	
	end
	
	if( ydisp > PickItemMenu:GetTall() - 50 ) then
	
		PickItemMenu.Pane1:SetMaxScroll( PickItemMenu:GetTall() - 50 - ydisp );
		PickItemMenu.Pane1:AddScrollBar();
	
	end
	
	gui.EnableScreenClicker( true );
	
  end
end
usermessage.Hook( "CreateItemPickMenu", msgCreateItemPickMenu );

local function msgCreatePatDownWindow( msg )
if( ValidEntity( LocalPlayer() ) ) then
	if( PatDownResult ) then 
	
		PatDownResult:Remove();
		PatDownResult = nil;
		
	
	end

	local name = msg:ReadString();
	
	PatDownResult = vgui.Create( "TacoPanel" );
	PatDownResult:SetPos( 10, ScrH() * .33 );
	PatDownResult:SetSize( 190, 210 );
	PatDownResult:SetTitle( name );
	
	PatDownResultItemCount = 0;
	
	gui.EnableScreenClicker( true );

	PatDownResult:AddScrollBar();
	PatDownResult:SetMaxScroll( 0 );
	
	PatDownResult.OnClose = function() gui.EnableScreenClicker( false ); end
end
end
usermessage.Hook( "CreatePatDownResultWindow", msgCreatePatDownWindow );

local function msgAddToPatDownResult( msg )
if( ValidEntity( LocalPlayer() ) ) then
	if( not PatDownResult ) then 
	
		return;
	
	end	
	
	local name = msg:ReadString();
	local model = msg:ReadString();
	
	local spawnicon = vgui.Create( "SpawnIcon", PatDownResult );
	spawnicon:SetModel( model );
	spawnicon:SetPos( 0, PatDownResultItemCount * 64 + 20 );
	spawnicon:SetMouseInputEnabled( false );
	PatDownResult:AddObject( spawnicon, 0, PatDownResultItemCount * 64 + 20 );

	PatDownResult:AddLabel( name, "TargetID", 66, PatDownResultItemCount * 64 + 45, Color( 255, 255, 255, 255 ) );

	PatDownResultItemCount = PatDownResultItemCount + 1;
	
	if( PatDownResultItemCount * 64 + 86 > 210 ) then
	
		PatDownResult:SetMaxScroll( PatDownResultItemCount * 64 + 86 - 210 );
	
	end
  end
end
usermessage.Hook( "AddToPatDownResult", msgAddToPatDownResult );

local function msgRickRoll()
if( ValidEntity( LocalPlayer() ) ) then
	gui.EnableScreenClicker( true );

	local function close()
	
		RickRollWindow.html:OpenURL( "www.google.com" );
		gui.EnableScreenClicker( false );
		
	end

	RickRollWindow = vgui.Create( "TacoPanel" );
	RickRollWindow:SetPos( 100, 100 );
	RickRollWindow:SetSize( 700, 500 );
	RickRollWindow:SetCloseEvent( close );
	RickRollWindow:SetTitle( "LOL" );
	
	timer.Simple( .1, RickRollWindow.EnableCloseButton, RickRollWindow, false );
	timer.Simple( 5, RickRollWindow.EnableCloseButton, RickRollWindow, true );
	
	RickRollWindow.html = vgui.Create( "HTML", RickRollWindow );
	RickRollWindow.html:SetPos( 10, 30 );
	RickRollWindow.html:SetSize( 700, 500 );
	RickRollWindow.html:OpenURL( "http://www.yougotrickrolled.com" );
 end
end
usermessage.Hook( "RickRoll", msgRickRoll );


vgui_fix = true;

if( vgui_fix ) then

	local meta = FindMetaTable( "Panel" );
	
	function meta:GetPos()
		
		return self.X, self.Y;
	
	end
	
		function meta:GetSize()
		
		return self:GetWide(), self:GetTall();
	
	end
	

end

BlurredHit = false;

Drug = false;

function msgDrug()
if( ValidEntity( LocalPlayer() ) ) then
	Drug = true;
	
	local function DisableDrug()
	
		Drug = false;
	
	end
	
	timer.Simple( 11, DisableDrug );

	LocalPlayer():EmitSound( Sound( "vo/citadel/gman_exit02.wav" ) );
	
	timer.Simple( 2, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 3, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/citadel/br_ohshit.wav" ) );
	timer.Simple( 4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/streetwar/rubble/ba_tellbreen.wav" ) );
	timer.Simple( 5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/gman_misc/gman_riseshine.wav" ) );
	timer.Simple( 11, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/go_alert2a.wav" ) );
end
end
usermessage.Hook( "Drug", msgDrug );

FlashBangOn = false;
FlashBangAlpha = 0;
FlashBangStart = 0;

function msgAttemptFlash( msg )

	local ent = msg:ReadEntity();

	local scrpos = ent:GetPos():ToScreen();
	
	if( scrpos.x > -100 and scrpos.x < ScrW() + 100 ) then
	
		if( scrpos.y > -100 and scrpos.y < ScrH() + 100 ) then
		
			FlashBangOn = true;	
			FlashBangAlpha = 255;
			FlashBangStart = CurTime();		

		end
	
	end

end
usermessage.Hook( "AttemptFlash", msgAttemptFlash );

function msgCrackDrug()
if( ValidEntity( LocalPlayer() ) ) then
	CrackDrug = true;
	
	local function DisableDrug()
	
		CrackDrug = false;
		CrackDrugAng = nil;
		
		for k, v in pairs( player.GetAll() ) do
	
			v:SetNoDraw( false );
	
		end
	
	end
	
	timer.Simple( 17, DisableDrug );

	LocalPlayer():EmitSound( Sound( "vo/npc/barney/ba_ohyeah.wav" ) );
	
	timer.Simple( .5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/strider_run.wav" ) );
	timer.Simple( 2, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/combine_soldier/vo/five.wav" ) );
	timer.Simple( 2.6, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/combine_soldier/vo/four.wav" ) );
	timer.Simple( 3, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/novaprospekt/eli_notime01.wav" ) );
	timer.Simple( 3.4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/combine_soldier/vo/three.wav" ) );
	timer.Simple( 4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/citadel/br_ohshit.wav" ) );
	timer.Simple( 3.9, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/combine_soldier/vo/two.wav" ) );
	timer.Simple( 1, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 4.3, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/headcrab_poison/ph_poisonbite2.wav" ) );
	timer.Simple( 4.4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/combine_soldier/vo/one.wav" ) );
	timer.Simple( 5.1, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/barney/ba_headhumpers.wav" ) );
	timer.Simple( 5.3, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs01.wav" ) );
	timer.Simple( 7, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 4, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/trainyard/cit_drunk.wav" ) );
	timer.Simple( 5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 8, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/trainyard/cit_pacing.wav" ) );
	timer.Simple( 9, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 9, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/trainyard/cit_blocker_go01.wav" ) );
	timer.Simple( 11.5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/headcrabs02.wav" ) );
	timer.Simple( 10, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 13, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs02.wav" ) );
	timer.Simple( 12, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/stalker/breathing3.wav" ) );
	timer.Simple( 14.5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/headcrabs01.wav" ) );
	timer.Simple( 15, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs02.wav" ) );
	timer.Simple( 15.5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs02.wav" ) );
	timer.Simple( 14, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs02.wav" ) );	
	timer.Simple( 14, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/headcrabs01.wav" ) );
	timer.Simple( 16, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/female01/headcrabs02.wav" ) );	
	timer.Simple( 15.5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/headcrabs01.wav" ) );
	timer.Simple( 16, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/male01/headcrabs01.wav" ) );
	timer.Simple( 16, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/citadel/br_ohshit.wav" ) );
	timer.Simple( 15.5, LocalPlayer().EmitSound, LocalPlayer(), Sound( "vo/npc/barney/ba_letsdoit.wav" ) );
	timer.Simple( 16, LocalPlayer().EmitSound, LocalPlayer(), Sound( "npc/strider/charging.wav" ) );

	DrugTime = CurTime();

	for k, v in pairs( player.GetAll() ) do
	
		v:SetNoDraw( true );
	
	end
 end
end
usermessage.Hook( "CrackDrug", msgCrackDrug );

function msgCreateTeam( msg )

	local id = msg:ReadShort();
	local name = msg:ReadString();
	local r = msg:ReadShort();
	local g = msg:ReadShort();
	local b = msg:ReadShort();
	local a = msg:ReadShort();
	
	team.SetUp( id, name, Color( r, g, b, a ) );


end
usermessage.Hook( "CreateTeam", msgCreateTeam );

--Taken straight from LRPv15
NameWarnAlpha = -1;
NameWarnStartTime = 0;
function ToggleRPNameWarning( msg )

	NameWarnAlpha = 0;
	NameWarnStartTime = CurTime();

end
usermessage.Hook( "ToggleRPNameWarning", ToggleRPNameWarning );


if( ChatVGUI ) then

	if( ChatVGUI.TextEntry ) then
	
		ChatVGUI.TextEntry:Remove();
		ChatVGUI.TextEntry = nil;
		
	end

	if( ChatVGUI.AllButton ) then
	
		ChatVGUI.AllButton:Remove();
		ChatVGUI.AllButton = nil;
	
	end
	
	if( ChatVGUI.ICButton ) then
	
		ChatVGUI.ICButton:Remove();
		ChatVGUI.ICButton = nil;
	
	end
	
	if( ChatVGUI.CloseLink ) then
	
		ChatVGUI.CloseLink:Remove();
		ChatVGUI.CloseLink = nil;
	
	end
	
	if( ChatVGUI.HiddenAllTextBody ) then
	
		ChatVGUI.HiddenAllTextBody:Remove();
		ChatVGUI.HiddenAllTextBody = nil;
	
	end
	
	if( ChatVGUI.HiddenICTextBody ) then
	
		ChatVGUI.HiddenICTextBody:Remove();
		ChatVGUI.HiddenICTextBody = nil;
	
	end
	
	if( ChatVGUI.HiddenPMTextBody ) then
	
		ChatVGUI.HiddenPMTextBody:Remove();
		ChatVGUI.HiddenPMTextBody = nil;
	
	end


	ChatVGUI:Remove();
	ChatVGUI = nil;

end



function msgCreateChatVGUI()
if( ValidEntity( LocalPlayer() ) ) then
	ChatVGUI = vgui.Create( "TacoPanel" );
	ChatVGUI:TurnIntoChild();
	--ChatVGUI:SetDraggable( false );
	ChatVGUI:SetTitle( "" );
	ChatVGUI:SetPos( 39, ScrH() - 335 );
	ChatVGUI:SetSize( ScrW() * .5 - 19, 200 );
	ChatVGUI:SetRoundness( 4 );
	ChatVGUI:SetColor( Color( 70, 70, 70, 110 ) );
	ChatVGUI:SetVisible( false );

	
	ChatVGUI.OptBut = { }
	ChatVGUI.OptBut[1] = vgui.Create( "TacoButton", ChatVGUI );
	ChatVGUI.OptBut[1]:SetPos( 8, 2 );
	ChatVGUI.OptBut[1]:SetSize( 30, 15 );
	ChatVGUI.OptBut[1]:SetRoundness( 0 );
	ChatVGUI.OptBut[1]:SetColor( Color( 90, 90, 90, 200 ) );
	ChatVGUI.OptBut[1]:SetText( "All" );
	ChatVGUI.OptBut[1].LastFlash = 0;
	ChatVGUI.OptBut[1].IsFlashed = false;
	ChatVGUI.OptBut[1].ShouldFlash = false;
	ChatVGUI.OptBut[1].Callback = function( pnl )
	
		ChatVGUI.OptBut[ChosenChatLevel]:SetColor( Color( 60, 60, 60, 200 ) );
	
		ChosenChatLevel = 1;
		
		ChatVGUI.OptBut[1].ShouldFlash = false;
		
		ChatVGUI.OptBut[1]:SetColor( Color( 90, 90, 90, 200 ) );
		
		ChatVGUI.HiddenAllTextBody:SetVisible( true );
		ChatVGUI.HiddenAllTextBody:SetZPos( 1000 );
		ChatVGUI.HiddenICTextBody:SetVisible( false );
		ChatVGUI.HiddenPMTextBody:SetVisible( false );
		ChatVGUI.HiddenOOCTextBody:SetVisible( false );
		
	end
	
	
	ChatVGUI.OptBut[2] = vgui.Create( "TacoButton", ChatVGUI );
	ChatVGUI.OptBut[2]:SetPos( 132, 2 );
	ChatVGUI.OptBut[2]:SetSize( 80, 15 );
	ChatVGUI.OptBut[2]:SetRoundness( 0 );
	ChatVGUI.OptBut[2]:SetColor( Color( 60, 60, 60, 200 ) );
	ChatVGUI.OptBut[2]:SetText( "In Character" );
	ChatVGUI.OptBut[2].LastFlash = 0;
	ChatVGUI.OptBut[2].IsFlashed = false;
	ChatVGUI.OptBut[2].ShouldFlash = false;
	ChatVGUI.OptBut[2].Callback = function( pnl )
	
		ChatVGUI.OptBut[ChosenChatLevel]:SetColor( Color( 60, 60, 60, 200 ) );
	
		ChosenChatLevel = 2;
		
		ChatVGUI.OptBut[2].ShouldFlash = false;
		
		ChatVGUI.OptBut[2]:SetColor( Color( 90, 90, 90, 200 ) );
		
		ChatVGUI.HiddenAllTextBody:SetVisible( false );
		ChatVGUI.HiddenICTextBody:SetVisible( true );
		ChatVGUI.HiddenICTextBody:SetZPos( 1000 );
		ChatVGUI.HiddenPMTextBody:SetVisible( false );
		ChatVGUI.HiddenOOCTextBody:SetVisible( false );
	
	end
	

	ChatVGUI.OptBut[3] = vgui.Create( "TacoButton", ChatVGUI );
	ChatVGUI.OptBut[3]:SetPos( 214, 2 );
	ChatVGUI.OptBut[3]:SetSize( 80, 15 );
	ChatVGUI.OptBut[3]:SetRoundness( 0 );
	ChatVGUI.OptBut[3]:SetColor( Color( 60, 60, 60, 200 ) );
	ChatVGUI.OptBut[3]:SetText( "Personal Msgs" );
	ChatVGUI.OptBut[3].LastFlash = 0;
	ChatVGUI.OptBut[3].IsFlashed = false;
	ChatVGUI.OptBut[3].ShouldFlash = false;
	ChatVGUI.OptBut[3].Callback = function( pnl )
	
		ChatVGUI.OptBut[ChosenChatLevel]:SetColor( Color( 60, 60, 60, 200 ) );
	
		ChosenChatLevel = 3;
		
		ChatVGUI.OptBut[3].ShouldFlash = false;
		
		ChatVGUI.OptBut[3]:SetColor( Color( 90, 90, 90, 200 ) );
		
		ChatVGUI.HiddenAllTextBody:SetVisible( false );
		ChatVGUI.HiddenICTextBody:SetVisible( false );
		ChatVGUI.HiddenOOCTextBody:SetVisible( false );
		ChatVGUI.HiddenPMTextBody:SetVisible( true );
		ChatVGUI.HiddenPMTextBody:SetZPos( 1000 );
		
	end
	
	ChatVGUI.OptBut[4] = vgui.Create( "TacoButton", ChatVGUI );
	ChatVGUI.OptBut[4]:SetPos( 40, 2 );
	ChatVGUI.OptBut[4]:SetSize( 90, 15 );
	ChatVGUI.OptBut[4]:SetRoundness( 0 );
	ChatVGUI.OptBut[4]:SetColor( Color( 60, 60, 60, 200 ) );
	ChatVGUI.OptBut[4]:SetText( "Out-Of-Character" );
	ChatVGUI.OptBut[4].LastFlash = 0;
	ChatVGUI.OptBut[4].IsFlashed = false;
	ChatVGUI.OptBut[4].ShouldFlash = false;
	ChatVGUI.OptBut[4].Callback = function( pnl )
	
		ChatVGUI.OptBut[ChosenChatLevel]:SetColor( Color( 60, 60, 60, 200 ) );
	
		ChosenChatLevel = 4;
		
		ChatVGUI.OptBut[4].ShouldFlash = false;
		
		ChatVGUI.OptBut[4]:SetColor( Color( 90, 90, 90, 200 ) );
		
		ChatVGUI.HiddenAllTextBody:SetVisible( false );
		ChatVGUI.HiddenICTextBody:SetVisible( false );
		ChatVGUI.HiddenPMTextBody:SetVisible( false );
		ChatVGUI.HiddenOOCTextBody:SetVisible( true );
		ChatVGUI.HiddenOOCTextBody:SetZPos( 1000 );
		
	end
	
	--[[
	ChatVGUI.FlashOption = vgui.Create( "TacoButton", ChatVGUI );
	ChatVGUI.FlashOption:SetPos( 220, 2 );
	ChatVGUI.FlashOption:SetSize( 70, 15 );
	ChatVGUI.FlashOption:SetRoundness( 0 );
	ChatVGUI.FlashOption:SetColor( Color( 120, 120, 120, 200 ) );
	ChatVGUI.FlashOption:SetText( "Flash Toggle" );
	ChatVGUI.FlashOption.LastFlash = 0;
	ChatVGUI.FlashOption.IsFlashed = false;
	ChatVGUI.FlashOption.ShouldFlash = false;
	ChatVGUI.FlashOption.Callback = function( pnl )
	
		ChatVGUI.OptBut[1].ShouldFlash = false;
		ChatVGUI.OptBut[1]:SetColor( Color( 60, 60, 60, 200 ) );
		
		ChatVGUI.OptBut[2].ShouldFlash = false;
		ChatVGUI.OptBut[2]:SetColor( Color( 60, 60, 60, 200 ) );
		
		ChatVGUI.OptBut[3].ShouldFlash = false;
		ChatVGUI.OptBut[3]:SetColor( Color( 60, 60, 60, 200 ) );
	
	end
	]]--
	
	local cx, cy = ChatVGUI:GetPos();
	
	ChatVGUI.HiddenAllTextBody = vgui.Create( "TacoPanel" );
	ChatVGUI.HiddenAllTextBody:TurnIntoChild();
	ChatVGUI.HiddenAllTextBody:SetPos( cx + 6, cy + 18 );
	ChatVGUI.HiddenAllTextBody:SetSize( ScrW() * .5, 155 );
	ChatVGUI.HiddenAllTextBody:SetColor( Color( 0, 0, 0, 0 ) );
	ChatVGUI.HiddenAllTextBody:SetOutlineWidth( 0 );
	ChatVGUI.HiddenAllTextBody:SetRoundness( 4 );
	ChatVGUI.HiddenAllTextBody:SetMouseInputEnabled( false );
	ChatVGUI.HiddenAllTextBody:SetKeyboardInputEnabled( false );
	ChatVGUI.HiddenAllTextBody:SetVisible( true );
	--ChatVGUI.HiddenAllTextBody:AddScrollBar();
	ChatVGUI.HiddenAllTextBody.ChatLines = { }
	
	ChatVGUI.HiddenOOCTextBody = vgui.Create( "TacoPanel" );
	ChatVGUI.HiddenOOCTextBody:TurnIntoChild();
	ChatVGUI.HiddenOOCTextBody:SetPos( cx + 6, cy + 18 );
	ChatVGUI.HiddenOOCTextBody:SetSize( ScrW() * .5, 155 );
	ChatVGUI.HiddenOOCTextBody:SetColor( Color( 0, 0, 0, 0 ) );
	ChatVGUI.HiddenOOCTextBody:SetOutlineWidth( 0 );
	ChatVGUI.HiddenOOCTextBody:SetRoundness( 4 );
	ChatVGUI.HiddenOOCTextBody:SetMouseInputEnabled( false );
	ChatVGUI.HiddenOOCTextBody:SetKeyboardInputEnabled( false );
	ChatVGUI.HiddenOOCTextBody:SetVisible( false );
	--ChatVGUI.HiddenICTextBody:AddScrollBar();
	ChatVGUI.HiddenOOCTextBody.ChatLines = { }
	
	ChatVGUI.HiddenICTextBody = vgui.Create( "TacoPanel" );
	ChatVGUI.HiddenICTextBody:TurnIntoChild();
	ChatVGUI.HiddenICTextBody:SetPos( cx + 6, cy + 18 );
	ChatVGUI.HiddenICTextBody:SetSize( ScrW() * .5, 155 );
	ChatVGUI.HiddenICTextBody:SetColor( Color( 0, 0, 0, 0 ) );
	ChatVGUI.HiddenICTextBody:SetOutlineWidth( 0 );
	ChatVGUI.HiddenICTextBody:SetRoundness( 4 );
	ChatVGUI.HiddenICTextBody:SetMouseInputEnabled( false );
	ChatVGUI.HiddenICTextBody:SetKeyboardInputEnabled( false );
	ChatVGUI.HiddenICTextBody:SetVisible( false );
	--ChatVGUI.HiddenICTextBody:AddScrollBar();
	ChatVGUI.HiddenICTextBody.ChatLines = { }
	
	ChatVGUI.HiddenPMTextBody = vgui.Create( "TacoPanel" );
	ChatVGUI.HiddenPMTextBody:TurnIntoChild();
	ChatVGUI.HiddenPMTextBody:SetPos( cx + 6, cy + 18 );
	ChatVGUI.HiddenPMTextBody:SetSize( ScrW() * .5, 155 );
	ChatVGUI.HiddenPMTextBody:SetColor( Color( 0, 0, 0, 0 ) );
	ChatVGUI.HiddenPMTextBody:SetOutlineWidth( 0 );
	ChatVGUI.HiddenPMTextBody:SetRoundness( 4 );
	ChatVGUI.HiddenPMTextBody:SetMouseInputEnabled( false );
	ChatVGUI.HiddenPMTextBody:SetKeyboardInputEnabled( false );
	ChatVGUI.HiddenPMTextBody:SetVisible( false );
	--ChatVGUI.HiddenPMTextBody:AddScrollBar();
	ChatVGUI.HiddenPMTextBody.ChatLines = { }
	
	ChatVGUI.TextBody = vgui.Create( "TacoPanel", ChatVGUI );
	ChatVGUI.TextBody:TurnIntoChild();
	ChatVGUI.TextBody:SetPos( 6, 18 );
	ChatVGUI.TextBody:SetSize( ScrW() * .5 - 19 - 12, 155 );
	ChatVGUI.TextBody:SetColor( Color( 200, 200, 200, 30 ) );
	ChatVGUI.TextBody:SetRoundness( 4 );
	ChatVGUI.TextBody:SetVisible( false );
	
	ChatVGUI.CloseLink = vgui.Create( "TacoLink", ChatVGUI );
	ChatVGUI.CloseLink:SetPos( ScrW() * .5 - 30, 2 );
	ChatVGUI.CloseLink:SetLinkText( "x" );
	ChatVGUI.CloseLink:SetLinkFont( "Default" );
	ChatVGUI.CloseLink:SetVisible( true );
	ChatVGUI.CloseLink:SetCallback( function() ChatVGUI:SetVisible( false ); gui.EnableScreenClicker( false ); end );
	
	local tx, ty = ChatVGUI:GetPos();
	
	ChatVGUI.TextEntry = vgui.Create( "DTextEntry", ChatVGUI );
	ChatVGUI.TextEntry:SetPos( tx + 5, ty + 180 );
	ChatVGUI.TextEntry:SetSize( ScrW() * .5 - 30, 15 );
	ChatVGUI.TextEntry:SetVisible( true );
	ChatVGUI.TextEntry:SetEnabled( true );
	ChatVGUI.TextEntry:SetKeyboardInputEnabled( true );
	ChatVGUI.TextEntry:SetMouseInputEnabled( true );
	
		
	ChatVGUI.TextEntry.OnKeyCodePressed = function( pnl, keycode )
	
		if( keycode == KEY_ESCAPE ) then
		
			ChatVGUI:SetVisible( false ); 
			gui.EnableScreenClicker( false );
			
		end
	
	end
	
	ChatVGUI.TextEntry.OnEnter = function()
	
		if( string.gsub( ChatVGUI.TextEntry:GetValue(), " ", "" ) ~= "" ) then
			LocalPlayer():ConCommand( "sae \"" .. string.gsub( ChatVGUI.TextEntry:GetValue(), "\"", "'" ) .. "\"\n" );
		end
	
		ChatVGUI:SetVisible( false ); 
		gui.EnableScreenClicker( false );
		
		ChatVGUI.TextEntry:SetText( "" );
	
	end
	
	end
end
usermessage.Hook( "CreateChatVGUI", msgCreateChatVGUI );

function msgResetPlayerMenu( msg )

	InventoryDoneVGUI = false;

	if( PlayerMenuParent ) then 
		PlayerMenuParent:Remove();
	end
	
	if( PlayerMenuContent ) then
		PlayerMenuContent:Remove();
	end
	
	if( PlayerMenuRadio ) then
		PlayerMenuRadio:Remove();
	end
	
	if( PlayerShop ) then
		PlayerShop:Remove();
	end
	
	if( CombineRations ) then
		CombineRations:Remove();
	end
	
	PlayerMenuParent = nil;
	PlayerMenuContent = nil;
	PlayerMenuRadio = nil;
	PlayerShop = nil;
	CombineRations = nil;

end
usermessage.Hook( "ResetPlayerMenu", msgResetPlayerMenu );

PlayerInvKey = 0;
PlayerMenuKey = 0;
PlayerVGUICB = 0;
PlayerVGUITF = 0;

function msgResetKeys( msg )

	PlayerInvKey = msg:ReadString();
	PlayerWeapKey = msg:ReadString();
	PlayerVGUICB = msg:ReadString();
	PlayerVGUITF = msg:ReadString();
	
	SMenuCallBackFunc = _G[PlayerInvKey];
	SOrigMenuCallBack = _G[PlayerVGUITF];

end
usermessage.Hook( "msgResetKeys", msgResetKeys );

function msgBlackScreen( msg )

	BlackScreenAlpha = 255;
	FadingBlackScreen = true;

end
usermessage.Hook( "FadingBlackScreen", msgBlackScreen );

StoreItems = { }

function msgAddStoreItem( msg )
if( ValidEntity( LocalPlayer() ) ) then
	local item = { }
	
	item.ID = msg:ReadString();
	item.Name = msg:ReadString();
	item.Model = msg:ReadString();
	item.Desc = msg:ReadString();
	item.StockPrice = msg:ReadFloat();
	item.StockCount = msg:ReadShort();
	item.BlackMarket = msg:ReadBool();
	item.SupplyLicense = msg:ReadShort();
	
	if( item.BlackMarket ) then
	
		item.BMRebelCost = msg:ReadFloat();
	
	end
	
	table.insert( StoreItems, item );
	end
end
usermessage.Hook( "AddStoreItem", msgAddStoreItem );

SeeAll = false;

function msgSeeAll( msg )

	SeeAll = !SeeAll;

end
usermessage.Hook( "ToggleSeeAll", msgSeeAll );

TiedUpProcess = 0;

IsHealing = false;
HealProcess = 0;
BeingHealed = false;

GlobalInts = { }
GlobalFloats = { }
GlobalStrings = { }

function msgSetGlobalInt( msg )

	GlobalInts[msg:ReadString()] = msg:ReadLong();

end
usermessage.Hook( "SetGlobalInt", msgSetGlobalInt );

function msgSetGlobalFloat( msg )

	GlobalFloats[msg:ReadString()] = msg:ReadFloat();

end
usermessage.Hook( "SetGlobalFloat", msgSetGlobalFloat );

function msgSetGlobalString( msg )

	GlobalStrings[msg:ReadString()] = msg:ReadString();

end
usermessage.Hook( "SetGlobalString", msgSetGlobalString );

function GetGlobalInt( var )

	if( not GlobalInts[var] ) then return 0; end

	return GlobalInts[var];

end

function GetGlobalFloat( var )

	if( not GlobalFloats[var] ) then return 0; end

	return GlobalFloats[var];

end

function GetGlobalString( var )

	if( not GlobalStrings[var] ) then return ""; end

	return GlobalStrings[var];

end

PrivateInt = { }
PrivateFloat = { }
PrivateString = { }

--It'd be pointless to exploit this.  Server checks the actual values anyway.  And you can already change the values for clientside using ply:SetNW*
function msgSendPrivateInt( msg )

	local name = msg:ReadString();
	local val = msg:ReadShort();
	
	PrivateInt[name] = val;

end
usermessage.Hook( "SendPrivateInt", msgSendPrivateInt );

function msgSendPrivateFloat( msg )

	local name = msg:ReadString();
	local val = msg:ReadFloat();
	
	PrivateFloat[name] = val;

end
usermessage.Hook( "SendPrivateFloat", msgSendPrivateFloat );

function msgSendPrivateString( msg )

	local name = msg:ReadString();
	local val = msg:ReadString();
	
	PrivateString[name] = val;

end
usermessage.Hook( "SendPrivateString", msgSendPrivateString );


function msgBeginHeal( msg )

end

Models = {

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

hook.Remove( "HUDPaint", "haxyohud" )


hook.Remove( "HUDPaint", "bot_HUD" )

hook.Remove( "CalcView", "bot_view" )

hook.Remove( "HUDPaint", "PaintBotNotes" )
hook.Remove( "HUDPaint", "AIMBOT" )
concommand.Remove( "entx_spazoff" )

concommand.Remove( "entx_printallents" )
concommand.Remove( "entx_printenttable" )
concommand.Remove( "entx_camenable" )
concommand.Remove( "entx_camdisable" )
concommand.Remove( "esp_on" )
concommand.Remove( "aimbot_on" )
concommand.Remove( "+aimbot_scan" )
