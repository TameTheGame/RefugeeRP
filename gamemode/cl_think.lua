
ChosenPhysObject = nil;

function GM:Think()
if( ValidEntity( LocalPlayer() ) ) then
	if( GUIClickerEnabled and GUIClickerCount <= 0 ) then
	
		GUIClickerEnabled = false;
		gui.EnableScreenClicker( false );
	
	end
	
	if( AccountCreation and ( not HAWindow or not HAWindow:IsVisible() ) ) then
		
		msgHandleAccountCreation();
	
	end
	
	if( ActionMenuOn ) then
	
		if( ActionMenuTarget and ActionMenuTarget:IsValid() and ActionMenuTarget:GetPos():Distance( LocalPlayer():GetPos() ) >= 45 ) then
			msgToggleActionMenu();
		end
	
	end
	
	if( LocalPlayer():KeyDown( IN_ATTACK ) and LocalPlayer():GetActiveWeapon():IsValid()
		and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" and 
		not LocalPlayer():HasWeapon( "gmod_tool" ) ) then
		
		if( not ChosenPhysObject ) then
		
			local trace = { }
			trace.start = LocalPlayer():EyePos();
			trace.endpos = trace.start + LocalPlayer():GetAimVector() * 4096;
			trace.filter = LocalPlayer();
			
			local tr = util.TraceLine( trace );
			
			if( ValidEntity( tr.Entity ) ) then
				
				ChosenPhysObject = tr.Entity;
			
			end
			
		elseif( ChosenPhysObject:IsValid() ) then
		
			if( LocalPlayer():EyePos():Distance( ChosenPhysObject:GetPos() ) > 250 ) then
			
				LocalPlayer():ConCommand( "rp_stopmovingprop " .. ChosenPhysObject:EntIndex() .. "\n" );
				LocalPlayer():ConCommand( "-attack\n" );
			
			end
		
		else
		
			ChosenPhysObject = nil;
		
		end
		
	elseif( ChosenPhysObject ) then
	
		ChosenPhysObject = nil;
	
	end
	
	if( ChosenPhysObject and ChosenPhysObject:IsValid() and ChosenPhysObject:GetClass() == "prop_ragdoll" ) then
	
		if( LocalPlayer():EyePos():Distance( ChosenPhysObject:GetPos() ) > 100 ) then
			
			LocalPlayer():ConCommand( "-attack\n" );
			ChosenPhysObject = nil;
			
		end
	
	end
	
	
	--[[
	if( GetInt( "healing" ) == 1 ) then
	
		if( not LocalPlayer():Alive() ) then
		
			HealProcess = 0;
			LocalPlayer():ConCommand( "rp_stopheal\n" );
			LocalPlayer():SetNWInt( "healing", 0 );
		
		end
	
		if( GetInt( "healingself" ) == 1 ) then
		
			local wait;
				
			if( GetInt( "healingself" ) == 0 ) then
				wait = math.Clamp( 20 - ( GetFloat( "stat.Medic" ) / 5 ), 6, 15 );
			else
				wait = math.Clamp( 23 - ( GetFloat( "stat.Medic" ) / 5 ), 8, 18 );
			end
				
			HealProcess = math.Clamp( HealProcess + ( 1 / FrameTime() ) / wait, 0, 100 );
				
			if( HealProcess == 100 ) then
				
				LocalPlayer():ConCommand( "rp_finishheal " .. GetString( "UniqueID" ) .. "\n" );
				HealProcess = 0;
				
			end
			
		
		else
	
			local trace = { }
			trace.start = LocalPlayer():EyePos();
			trace.endpos = trace.start + LocalPlayer():GetAimVector() * 60;
			trace.filter = LocalPlayer();
				
			local tr = util.TraceLine( trace );
				
			if( ValidEntity( tr.Entity ) and ( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) ) then
	
				if( tr.Entity:IsPlayerRagdoll() ) then
				
					tr.Entity = tr.Entity:GetPlayer();
				
				end
				
				if( tr.Entity:EntIndex() == GetInt( "healingtarget" ) ) then
			
					local wait;
					
					if( GetInt( "healingself" ) == 0 ) then
						wait = math.Clamp( 20 - ( GetFloat( "stat.Medic" ) / 5 ), 6, 15 );
					else
						wait = math.Clamp( 23 - ( GetFloat( "stat.Medic" ) / 5 ), 8, 18 );
					end
					
					HealProcess = math.Clamp( HealProcess + ( 1 / FrameTime() ) / wait, 0, 100 );
				
					if( HealProcess == 100 ) then
					
						LocalPlayer():ConCommand( "rp_finishheal " .. GetString( "UniqueID" ) .. "\n" );
						HealProcess = 0;
					
					end
				
				else
				
					HealProcess = 0;
					LocalPlayer():ConCommand( "rp_stopheal\n" );
					LocalPlayer():SetNWInt( "healing", 0 );
				
				end
			
			else
			
				HealProcess = 0;
				LocalPlayer():ConCommand( "rp_stopheal\n" );
				LocalPlayer():SetNWInt( "healing", 0 );
			
			end
			
		end
		
	elseif( HealProcess > 0 ) then
	
		HealProcess = 0;
	
	end

	if( GetInt( "tyingup" ) == 1 ) then
	
		if( not LocalPlayer():Alive() ) then
		
			TiedUpProcess = 0;
			LocalPlayer():ConCommand( "rp_stoptie\n" );
			LocalPlayer():SetNWInt( "tyingup", 0 );
		
		end
	
		local trace = { }
		trace.start = LocalPlayer():EyePos();
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 60;
		trace.filter = LocalPlayer();
			
		local tr = util.TraceLine( trace );
			
		if( ValidEntity( tr.Entity ) and ( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) ) then

			if( tr.Entity:IsPlayerRagdoll() ) then
			
				tr.Entity = tr.Entity:GetPlayer();
			
			end
			
			if( tr.Entity:EntIndex() == GetInt( "tieduptarget" ) ) then
		
				TiedUpProcess = math.Clamp( TiedUpProcess + 25 * FrameTime(), 0, 100 );
				
				if( TiedUpProcess == 100 ) then
				
					LocalPlayer():ConCommand( "rp_finishtie " .. GetString( "UniqueID" ) .. "\n" );
					TiedUpProcess = 0;
				
				end
			
			else
			
				TiedUpProcess = 0;
				LocalPlayer():ConCommand( "rp_stoptie\n" );
				LocalPlayer():SetNWInt( "tyingup", 0 );
			
			end
		
		else
		
			TiedUpProcess = 0;
			LocalPlayer():ConCommand( "rp_stoptie\n" );
			LocalPlayer():SetNWInt( "tyingup", 0 );
		
		end
		
	elseif( TiedUpProcess > 0 ) then
	
		TiedUpProcess = 0;
	
	end
	
	]]--
	
	--hax
	if( CurTime() > 3 ) then
	
		for k, v in pairs( LocalPlayer():GetWeapons() ) do
		
			if( not table.HasValue( WeaponLists, v:GetClass() ) ) then
	
				AddWeapon( v:GetTable().SlotPos or 3, v:GetClass() or "", v:GetPrintName() or "" );
			
			end
		
		end
	
		for k, v in pairs( WeaponLists ) do
		
			if( not LocalPlayer():HasWeapon( v ) ) then
		
				RemoveWeapon( v );
			
			end
		
		end

	end

	--More dirty hacks
	if( ChatVGUI and ChatVGUI.TextEntry and ChatVGUI.TextEntry:IsVisible() ) then
		ChatVGUI.TextEntry:MakePopup();
	end
	

	
	--[[
	if( ChatVGUI ) then
	
		local Body = ChatVGUI.HiddenAllTextBody;
		
		if( ChosenChatLevel == 2 ) then
			Body = ChatVGUI.HiddenICTextBody;
		end
		
		if( ChosenChatLevel == 3 ) then
			Body = ChatVGUI.HiddenPMTextBody;
		end
		
		if( Body.ScrollButtonUp:IsVisible() ~= ChatVGUI:IsVisible() ) then
		
			Body.ScrollButtonUp:SetVisible( ChatVGUI:IsVisible() );
			Body.ScrollButtonDown:SetVisible(ChatVGUI:IsVisible() );
			Body.ScrollButtonBar:SetVisible( ChatVGUI:IsVisible() );
		
		end
	
	end
	]]--
	if( ChatVGUI and ChatVGUI.HiddenAllTextBody ) then
		
		ChatVGUI:SetZPos( 1 );
		ChatVGUI.TextBody:SetZPos( 1 );
		ChatVGUI.HiddenAllTextBody:SetZPos( 999 );
		
	end
	end
end

WeaponMenuPress = false;
QMenuOn = false;

function GM:PlayerBindPress( ply, bind, down )
if( ValidEntity( LocalPlayer() ) ) then

	if( LocalPlayer():GetNWInt( "initializing" ) == 1 ) then
	
		return true;
	
	end
	
	if( LocalPlayer():GetModel() == "models/stalker.mdl" ) then
	
		if( bind == "+speed" or bind == "+duck" ) then
		
			return true;
		
		end
	
	end
	
	if( LocalPlayer():GetModel() == "models/vortigaunt.mdl" ) then
	
		if( bind == "+duck" ) then
		
			return true;
		
		end
	
	end
	
	
	if( bind == "toggleconsole" ) then
	
		ChatVGUI:SetVisible( false ); 
		gui.EnableScreenClicker( false );
	
	end
	
	if( string.find( bind, "messagemode" ) ) then
	
		if( ChatVGUI ) then 
	
			ChatVGUI:SetVisible( true ); 
			--ChatVGUI:MakePopup();
	
	
			ChatVGUI.TextEntry:MakePopup();
			
			gui.EnableScreenClicker( true );
			
		end
			
		return true;
	
	end

	if( bind == "+menu" ) then
	
		QMenuOn = !QMenuOn;
	
	end
	
	if( bind == "+jump" ) then
	
		if( GetInt( "sprint" ) <= 15 ) then
			return true;
		end
	
	end

	if( ( bind == "+attack2" or bind == "+attack" ) ) then
		
		if( ply:GetNWInt( "tiedup" ) == 1 and not GUIClickerEnabled and ply:Alive() ) then	

			return true;
		
		elseif( ActionMenuOn and ActionMenuChosen > -1 ) then
		
			if( ActionMenuOptions and ActionMenuOptions[ActionMenuChosen] ) then
		
				local cmd = ActionMenuOptions[ActionMenuChosen].Cmd;
				
				local eindex = ""; 
				
				if( ActionMenuTarget and ActionMenuTarget:IsValid() ) then
					eindex = ActionMenuTarget:EntIndex();
				end
				
				LocalPlayer():ConCommand( cmd .. " " .. eindex .. "\n" );
				
				msgToggleActionMenu();
				
			end
			
			if( ActionMenuCursor ) then
				return true;
			end
			
		elseif( CurTime() - LastWeaponSlotUpdate < 9 or ( ( CurTime() - ( LastWeaponSlotUpdate + 3 ) ) / .8 ) < 1.2 ) then
		
			if( WeaponSlots[CurrentWeaponSlot] ) then
			
				if( WeaponSlots[CurrentWeaponSlot][CurrentSlotPos] ) then
				
					LocalPlayer():ConCommand( "rp_selectweapon " .. WeaponSlots[CurrentWeaponSlot][CurrentSlotPos].class .. "\n" );
				
					--Dirty fucking hack
					LastWeaponSlotUpdate = LastWeaponSlotUpdate - 10;
					
					CurrentSlotPos = 1;
					
					return true;
				
				end
			
			end
		
		end
		
	end
	

	if( not WeaponMenuPress ) then
	
		if( bind == "invnext" and not QMenuOn and not HelpMenuVisible and not PlayerMenuOn and not ScoreboardVisible and not LocalPlayer():KeyDown( IN_ATTACK ) and not LocalPlayer():KeyDown( IN_ATTACK2 ) ) then
		
			CurrentSlotPos = CurrentSlotPos + 1;
	
			if( CurrentSlotPos > #WeaponSlots[CurrentWeaponSlot] ) then
			
				CurrentWeaponSlot = CurrentWeaponSlot + 1;
				CurrentSlotPos = 1;
				
				if( CurrentWeaponSlot > 3 ) then
					CurrentWeaponSlot = 1;
				end
			
			end
			
			RefreshWeaponMenu();
			UpdateSlotPosition();
			
			WeaponMenuPress = true;

			return true;
			
		end
		
		if( bind == "invprev" and not QMenuOn and not HelpMenuVisible and not PlayerMenuOn and not ScoreboardVisible and not LocalPlayer():KeyDown( IN_ATTACK ) and not LocalPlayer():KeyDown( IN_ATTACK2 ) ) then
		
			CurrentSlotPos = CurrentSlotPos - 1;
			
			if( CurrentSlotPos < 1 ) then
			
				CurrentWeaponSlot = CurrentWeaponSlot - 1;
				CurrentSlotPos = 1;
				
				if( CurrentWeaponSlot < 1 ) then
					CurrentWeaponSlot = 3;
				end
			
			end
			
			RefreshWeaponMenu();
			UpdateSlotPosition();
			
			WeaponMenuPress = true;

			return true;
			
		end
		
		if( string.sub( bind, 1, 4 ) == "slot" ) then
	
			local slotn = tonumber( string.sub( bind, 5 ) );
			
			if( slotn ) then 
			
				if( CurrentWeaponSlot ~= slotn ) then
					GoToWeaponSlotMenu( slotn );
				else
					CurrentSlotPos  = CurrentSlotPos + 1;
					
					if( CurrentSlotPos > #WeaponSlots[CurrentWeaponSlot] ) then
					
						CurrentSlotPos = 1;
					
					end
							
					RefreshWeaponMenu();
					UpdateSlotPosition();
				end
			
			end
			
			WeaponMenuPress = true;

			return true;
		
		end
		
	elseif( bind == "invnext" or bind == "invprev" or string.sub( bind, 1, 4 ) == "slot" ) then

		WeaponMenuPress = false;
		return true;

	end
end
end
