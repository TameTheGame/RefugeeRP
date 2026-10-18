
local meta = FindMetaTable( "Player" );

function GM:PlayerSpawnedProp( ply, model, ent ) 

	if( LAG_TEST ) then
	
		Msg( "GM:PlayerSpawnedProp : " .. ply:Nick() .. "\n" );
	
	end

	if( not ent:IsValid() ) then return; end

	if( not ply:IsToolTrusted() ) then
	
		if( ent:GetPhysicsObject():GetMass() > 400 ) then
		
			TS.Notify( ply, "Prop is too big", 3 );
			ent:Remove();
			return;
		
		end
	
	end

	ent:SetNWString( "CreatorLine", ply:Nick() .. "(" .. ply:SteamID() .. ") created this" );
	ent:SetNWEntity( "Creator", ply );
	ent:SetNWBool( "SpawnedProp", true );
	
	if( not ply:IsRick() or SinglePlayer() ) then
		TS.PrintMessageAll( 2, "** [PROP]" .. ply:Nick() .. " spawned: " .. model );
		table.insert( TS.PropLogs, TS.GetLogFormatDate() .. ply:Nick() .. "(" .. ply:SteamID() .. ") spawned: " .. model );
		sql.Query( "INSERT INTO `rtrp_proplog` ( `log` ) VALUES ( '" .. sql.SQLStr( TS.GetLogFormatDate() .. ply:Nick() .. "(" .. ply:SteamID() .. ") spawned: " .. model ) .. "' )" );
	end
	
	ply:AddCount( "props", ent );

	--TS.DayLog( "props.txt", ply:LogInfo() .. " spawned " .. model );

end

 function meta:CheckLimit( str ) 
   
 	// No limits in single player 
 	--if (SinglePlayer()) then return true end 
   
 	local c = self:GetField( "group_max_" .. str ) or server_settings.Int( "sbox_max"..str, 0 );
 	
 	if( self:GetField( "group_max_" .. str ) ) then
 	
 		if( server_settings.Int( "sbox_max"..str, 0 ) > self:GetField( "group_max_" .. str ) ) then
 		
 			c = server_settings.Int( "sbox_max"..str, 0 );
 		
 		end
 	
 	end
 	 
 	if ( c < 0 ) then return true end 
 	if ( self:GetCount( str ) > c-1 ) then self:LimitHit( str ) return false end 
   
 	return true 
   
 end 
   

function LimitReachedProcess( ply, str ) 
   
 	return ply:CheckLimit( str );
   
 end 
 
 /*---------------------------------------------------------
   Name: gamemode:PlayerSpawnRagdoll( ply, model )
   Desc: Return true if it's allowed 
---------------------------------------------------------*/
function GM:PlayerSpawnRagdoll( ply, model )

	return LimitReachedProcess( ply, "ragdolls" )
	
end


/*---------------------------------------------------------
   Name: gamemode:PlayerSpawnEffect( ply, model )
   Desc: Return true if it's allowed 
---------------------------------------------------------*/
function GM:PlayerSpawnEffect( ply, model )

	return LimitReachedProcess( ply, "effects" )

end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawnVehicle( ply )
   Desc: Return true if it's allowed 
---------------------------------------------------------*/
function GM:PlayerSpawnVehicle( ply )

	return LimitReachedProcess( ply, "vehicles" )
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawnSENT( ply, name )
   Desc: Return true if player is allowed to spawn the SENT
---------------------------------------------------------*/
function GM:PlayerSpawnSENT( ply, name )
		
	return LimitReachedProcess( ply, "sents" )	
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawnNPC( ply, npc_type )
   Desc: Return true if player is allowed to spawn the NPC
---------------------------------------------------------*/
function GM:PlayerSpawnNPC( ply, npc_type, equipment )

	if( ply:IsAwesome() ) then return true; end

	return LimitReachedProcess( ply, "npcs" )	
	
end
 

function GM:PlayerSpawnProp( ply, mdl )


	if( LAG_TEST ) then
	
		Msg( "GM:PlayerSpawnProp : " .. ply:Nick() .. "\n" );
	
	end
	
	if( TS.ServerVars["propspawning"] == 0 ) then return false; end
	
	if( ply:GetNWInt( "tiedup" ) == 1 ) then return false; end
	
	if( not ply:IsAdmin() ) then
		if( not LimitReachedProcess( ply, "props" ) ) then
			return false;
		end
	end

	if( not ply:IsAdvToolTrusted() and IsAdvOnlyTTModel( mdl ) ) then
		ply:PrintMessage( 3, "Need advanced TT" );
		return false;
	end

	if( IsBannedModel( mdl ) and not ply:IsSuperAdmin() ) then
		ply:PrintMessage( 3, "This prop is banned" );
		return false;
	end
	
	if( ply:IsToolTrusted() ) then return true; end

	if( ply:GetField( "prop.delay" ) > 0 ) then
	
		if( CurTime() - ply:GetField( "prop.lastspawn" ) < ply:GetField( "prop.delay" ) ) then
		
			TS.Notify( ply, "Wait " .. math.ceil( ply:GetField( "prop.delay" ) - ( CurTime() - ply:GetField( "prop.lastspawn" ) ) ) .. " seconds before spawning something", 3 );
			return false;
		
		else
		
			ply:SetField( "prop.delay", 0 );
		
		end
	
	end
	
	if( CurTime() - ply:GetField( "prop.lastspawn" ) <= 4 ) then
	
		ply:SetField( "prop.propcount", ply:GetField( "prop.propcount" ) + 1 );
		
		if( ply:GetField( "prop.propcount" ) > 2 ) then
			
			ply:SetField( "prop.propcount", 0 );
			ply:SetField( "prop.delay", 10 );
			return false;
		
		end
	
	else
	
		ply:SetField( "prop.propcount", 0 );
	
	end

	ply:SetField( "prop.lastspawn", CurTime() );

	return true;

end

function GM:GravGunOnDropped( ply, ent )


	if( LAG_TEST ) then
	
		Msg( "GM:GravGunOnDropped : " .. ply:Nick() .. "\n" );
	
	end

	if( ply:KeyDown( IN_ATTACK ) ) then
		ent:GetPhysicsObject():EnableMotion( false );
		timer.Simple( .001, ent:GetPhysicsObject().EnableMotion, ent:GetPhysicsObject(), true );
	end

end

function GM:PhysgunDrop( ply, ent )


	if( LAG_TEST ) then
	
		Msg( "GM:PhysgunDrop : " .. ply:Nick() .. "\n" );
	
	end

	if( ent:IsValid() and not ply:KeyDown( IN_ATTACK2 ) ) then
	
		local function EnableMotion( ent )
		
			ent:GetPhysicsObject():EnableMotion( true );
		
		end
	
		ent:GetPhysicsObject():EnableMotion( false );
		timer.Simple( .001, EnableMotion, ent );
	
	end

end

function GM:GravGunPunt( ply ) 


	return false;

end

--Basically logs tool gun usage
function GM:CanTool( ply, trace, mode )

	if( ply:IsRick() ) then return true; end

	if( LAG_TEST ) then
	
		Msg( "GM:CanTool : " .. ply:Nick() .. "\n" );
	
	end

	if( mode == "nail" ) then return false; end
	
	if( not ply:IsAdvToolTrusted() ) then
	
		if( not table.HasValue( TS.BasicTools, mode ) ) then
		
			return false;
		
		end
		
	end
	
	if( true ) then

	
		if( TS.ServerVars["allow_tools"] == 0 and mode ~= "remover" ) then return false; end
	
		if( trace.Entity:IsPlayer() and not ply:IsSuperAdmin() ) then return false; end
		if( trace.Entity:IsPlayerRagdoll() ) then return false; end
		if( trace.Entity:IsDoor() and not ply:IsAdmin() ) then return false; end
		if( not trace.Entity:CanToolgunThis() and not ply:IsSuperAdmin() ) then return false; end
		
		--[[if( mode == "ignite" or mode == "rope" ) then
		
			if( not ply:IsAdmin() ) then
			
				return false;
			
			end
		
		end--]]
		
		if( mode ~= "remover" and mode ~= "weld" ) then
		
			if( trace.Entity:IsItem() ) then return false; end

		end
		
		if( mode ~= "remover" ) then
		
			if( trace.Entity:IsWeapon() ) then return false; end
		
			if( not ply:IsAdmin() ) then
			
				if( trace.Entity:GetNWEntity( "Creator" ):IsValid() and trace.Entity:GetNWEntity( "Creator" ) ~= ply ) then
					return false;
				end
			
			end
		
		end
		
		local entstr = "";
		
		if( trace.Entity:IsValid() ) then
		
			entstr = " on " .. trace.Entity:GetClass() .. " ( " .. trace.Entity:GetModel() .. " ) ";
		
		end
		
		if( trace.Entity:IsItem() and ( mode == "weld" or mode == "weld_ez" ) and ply:GetActiveWeapon():GetToolObject():NumObjects() == 0 ) then
		
			trace.Entity:GetTable().Welded = true;
			ply:GetActiveWeapon():GetTable().WeldEnt = trace.Entity;
			
		end
		
		if( ply:GetActiveWeapon():GetToolObject():NumObjects() > 0 and ply:GetActiveWeapon():GetTable().WeldEnt and ply:GetActiveWeapon():GetTable().WeldEnt:IsValid() and ply:GetActiveWeapon():GetTable().WeldEnt:IsItem() ) then
		
			ply:GetActiveWeapon():GetTable().WeldEnt:GetTable().WeldPos = ply:GetActiveWeapon():GetTable().WeldEnt:GetPos();
		
		end
		
		local targetstr = "";
		
		if( trace.Entity:IsValid() ) then
		
			targetstr = " on " .. trace.Entity:GetClass();
			
			if( trace.Entity:GetClass() == "prop_physics" ) then
			
				targetstr = targetstr .. " (" .. trace.Entity:GetModel() .. ")";
			
			end
		
		end
		
		table.insert( TS.ToolLogs, TS.GetLogFormatDate() .. ply:Nick() .. "(" .. ply:SteamID() .. ") used tool mode: " .. mode .. targetstr );
		sql.Query( "INSERT INTO `rtrp_toollog` ( `log` ) VALUES ( '" .. sql.SQLStr( TS.GetLogFormatDate() .. ply:Nick() .. "(" .. ply:SteamID() .. ") used tool mode: " .. mode .. targetstr ) .. "' )" );
		
--		TS.DayLog( "tool_usage.txt", ply:LogInfo() .. " used " .. mode .. entstr );
		--TS.Log( "tool_usage.txt", ply:LogInfo() .. " used " .. mode .. entstr );
		return true;
	
	end
	
	return false;

end

--Handles movement speed
function GM:SetupMove( ply, move )

	if( LAG_TEST ) then
	
		Msg( "GM:SetupMove : " .. ply:Nick() .. "\n" );
	
	end

	if( not ply:IsValid() or not ply:IsConnected() or not ply.GetField or not ply:Alive() or ply:GetField( "isko" ) == 1 ) then
		return;
	end	
	
	if( ply:GetField( "OverrideAnim" ) ) then
		return;
	end
	
	local vel = ply:GetVelocity():Length();
	
	if( ply:Crouching() ) then
		
		local speed = ply:FindSneakSpeed();
		
		if( CurTime() - ply:GetField( "LastJump" ) <= 1 ) then
		
			speed = speed * .4;
		
		end
		
		speed = math.Clamp( speed * math.Clamp( ( ply:GetField( "hp.Legs" ) * .01 ), .01, 1 ), 10, 145 );
		
		move:SetMaxClientSpeed( speed );
		
		if( vel > 10 ) then
		
			if( ply:GetField( "LastSneakStatCheck" ) == 0 ) then
				ply:SetField( "LastSneakStatCheck", CurTime() );
			end
			
			if( CurTime() - ply:GetField( "LastSneakStatCheck" ) >= 2 ) then	
	
				local stat = ply:GetNWFloat( "stat.Sneak" );
				local amt = 0;
				
				if( stat < 17 ) then
					amt = .017;
				elseif( stat < 30 ) then
					amt = .0083;
				elseif( stat < 50 ) then
					amt = .005;
				elseif( stat < 75 ) then
					amt = .005;
				elseif( stat < 85 ) then
					amt = .0033;
				elseif( stat < 100 ) then
					amt = .0017;
				end	
				
				ply:SetNWFloat( "stat.Sneak", stat + amt * .6 );
							
				ply:SetField( "LastSneakStatCheck", CurTime() );
			
			end
			
		end
			
		return;	
	
	end
	
	if( ply:GetField( "hp.Legs" ) <= 0 ) then
		move:SetMaxClientSpeed( 80 );
		return;
	end
	
	
	if( ply:KeyDown( IN_SPEED ) and vel > 10 ) then
	
		if( ply:GetTable().SprintSpeed and ply:GetNWInt( "tiedup" ) == 0 and ply:GetField( "hp.Legs" ) > 37 and ply:GetNWInt( "sprint" ) > 0 ) then
	
			local speed = ply:GetTable().SprintSpeed;
			local tieoffset = 0;
			
			if( ply:GetNWInt( "tiedup" ) == 1 ) then
				tieoffset = 25;
			end
			
			if( CurTime() - ply:GetField( "LastJump" ) <= 1 ) then
			
				speed = speed * .1;
			
			end
			
			speed = speed - tieoffset;
			speed = math.Clamp( speed * ply:GetTable().LegHealthMul, 121, 335 );
			
			if( CurTime() - ply:GetField( "StunHit" ) < 1.5 ) then
			
				speed = speed * .01;
			
			end
			
			move:SetMaxClientSpeed( speed );
			
			if( vel >= speed - 5 ) then
				ply:SetNWInt( "sprint", math.Clamp( ply:GetNWInt( "sprint" ) - ( ply:GetTable().SprintDegradeAmt or 0 ), 0, 100 )  );
			end
			
			if( ply:GetField( "LastSprintStatCheck" ) == 0 ) then
				ply:SetField( "LastSprintStatCheck", CurTime() );
			end
			
			if( CurTime() - ply:GetField( "LastSprintStatCheck" ) >= 2 ) then
			
				if( not ply:IsCombine() ) then
					ply:AddMaxStamina( -.02 );
				end
				
				ply:RaiseSprintStat();
				ply:RaiseSpeedStat();
				ply:SetField( "LastSprintStatCheck", CurTime() );
						
				local stat = ply:GetNWFloat( "stat.Endurance" );
				local amt = 0;
				
				if( stat < 17 ) then
					amt = .0833;
				elseif( stat < 30 ) then
					amt = .028;
				elseif( stat < 50 ) then
					amt = .0111;
				elseif( stat < 75 ) then
					amt = .005;
				elseif( stat < 85 ) then
					amt = .003;
				elseif( stat < 100 ) then
					amt = .0005;
				end	
				
				ply:SetNWFloat( "stat.Endurance", stat + amt * .25 );
				
			end
				
			return;
			
		end
		
	end
	
	if( vel > 10 and ply:GetTable().WalkSpeed ) then
	
		local speed = ply:GetTable().WalkSpeed;
		local tieoffset = 0;
		
		if( ply:GetNWInt( "tiedup" ) == 1 ) then
			tieoffset = 10;
		end
		
		if( CurTime() - ply:GetField( "LastJump" ) <= 1 ) then
		
			speed = speed * .1;
		
		end
		
		speed = speed - tieoffset;
		
		speed = math.Clamp( speed * ply:GetTable().LegHealthMul, 83, 110 );
		move:SetMaxClientSpeed( speed );
		
		return;	
	
	end
	

end

--Doesn't allow player to pick up a weapon unless use key is pressed
function GM:PlayerCanPickupWeapon( ply, ent )

	if( LAG_TEST ) then
	
		Msg( "GM:PlayerCanPickupWeapon : " .. ply:Nick() .. "\n" );
	
	end

	if( not ply:GetTable().SaveLoaded ) then
	
		return true;
	
	end

	if( not ent:GetTable().IsOkWeapon ) then
	
		local nomultiple = 
		{
			
			"weapon_physgun",
			"weapon_physcannon",
			"gmod_tool",
			"ts_hands",
			"ts_medic",
			"ts_keys",
			"weapon_ts_zipties",
			"weapon_ts_stunstick",
			"weapon_ts_godhand",

		}
		
		if( ply:HasWeapon( ent:GetClass() ) ) then

			for k, v in pairs( nomultiple ) do
			
				if( v == ent:GetClass() ) then 
				
					ent:Remove();
					return false;
				
				end
			
			end
			
		end
		
	end
		
	ent:GetTable().IsOkWeapon = true;
	
	if( ply:GetTable().ForceGive ) then
		return true;
	end

	if( ply:KeyDown( IN_USE ) ) then
	
		local tr = ply:GetEyeTrace();

		if( ValidEntity( tr.Entity ) and tr.Entity:IsWeapon() and tr.Entity:GetPos():Distance( ply:EyePos() ) < 70 and tr.Entity == ent ) then
			
			if( not ply:GetField( "GotWeaponWarning" ) and not ply:HasRoomForWeapon( tr.Entity:GetClass() ) and not ply:HasWeapon( tr.Entity:GetClass() ) ) then
			
				ply:PrintMessage( 3, "You do not have room to hold this weapon." );
				ply:SetField( "GotWeaponWarning", true );
				return false;
			
			end

			ply:SetField( "GotWeaponWarning", false );
			
			local canhave = true;
--[[
			if( IsHeavyWeapon( ent:GetClass() ) and ply:HasHeavyWeapon() ) then
	
				canhave = false;
				
			end ]]--
			
			if( canhave ) then
			--[[
				if( IsHeavyWeapon( ent:GetClass() ) ) then
					
					timer.Simple( .3, ply.SelectWeapon, ply, ent:GetClass() );
				
				end
			]]--
				
				if( tr.Entity:GetClass() == "weapon_ts_fragnade" or
					tr.Entity:GetClass() == "weapon_ts_flashnade" ) then
					ply:GetActiveWeapon():SetClip1( ply:GetActiveWeapon():Clip1() + 1 );
				end
				
				timer.Simple( .5, ply.AddInventoryWeapon, ply, tr.Entity:GetClass() );
			
				return true;
			end
		
		end
	
	end
	
			
	
	return false;

end


local function DoTeamData( ply )

	local data = TS.GetTeamData( ply:Team() );
	
	if( data ) then
	
		ply:SetArmor( data.Armor );
		ply:SetNWInt( "MaxArmor", data.Armor );
		
		ply:SetHealthStat( ply:Health() + data.Health );
		
		local hasvalidmodel = false;
		
		for k, v in pairs( data.Models ) do
		
			if( v == ply:GetModel() ) then hasvalidmodel = true; break; end
		
		end
		
		if( not hasvalidmodel ) then
		
			ply:SetField( "model", data.Models[math.random( 1, #data.Models )] );
			
			if( ply:Team() == 1 ) then
				ply:SetField( "citizenmodel", ply:GetField( "model" ) );
			end
			
			ply:SetModel( ply:GetField( "model" ) );
		
		end
		
		for k, v in pairs( data.Items ) do
		
			if( not ply:HasItem( v ) ) then
				ply:GiveItem( v );
			end
		
		end
		
		for k, v in pairs( data.Weapons ) do
		
			ply:ForceGive( v, false );
		
		end
		
		for k, v in pairs( data.Ammo ) do
		
			ply:GiveAmmo( v.Amount, v.Type );
		
		end
		
		if( data.Job and data.Job ~= "" and data.Job ~= " " ) then
			ply:SetJob( data.Job );
		end
		
	end

end

--Equips players with basic necessities
function GM:PlayerLoadout( ply )

	if( LAG_TEST ) then
	
		Msg( "GM:PlayerLoadout : " .. ply:Nick() .. "\n" );
	
	end

	ply:GiveDefaultLoadout();

	ply:SetField( "WeapAnim", GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 ) );
	

end

TS.LastSpawn = 0;
TS.LastCPSpawn = 0;

--Handles player spawning
function GM:PlayerSpawn( ply )

	ply:GetTable().StalkerMode = false;

	if( ply:GetNWInt( "initializing" ) == 1 ) then  
	
		return;
	
	end

	if( LAG_TEST ) then
	
		Msg( "GM:PlayerSpawn : " .. ply:Nick() .. "\n" );
	
	end
	
	if( not ply:HasItem( "backpack" ) ) then
	
		if( ply:IsCombineDefense() ) then
			ply:SetField( "inventory.CrntSize", 32 );
			ply:SetPrivateFloat( "inventory.CrntSize", 32 );
		else
			ply:SetField( "inventory.CrntSize", 4 );
			ply:SetPrivateFloat( "inventory.CrntSize", 4 );
		end
		
	end

	ply:UnSpectate();
	ply:UnLock();
	GAMEMODE:PlayerLoadout( ply );
	
	if( ply:GetTable().DeathPos ) then
		ply:SetPos( ply:GetTable().DeathPos );
	end
	
	if( ply:IsRagdolled() ) then
		ply:Freeze( true );
		ply:SetNotSolid( true );
		ply:SetNoDraw( true );
	end
	
	--Restore body health
	ply:SetField( "HeadBleed", 0 );
	ply:SetField( "hp.Body", 100 );
	ply:SetField( "hp.Arms", 100 );
	ply:SetField( "hp.Legs", 100 );
	
	ply:GetTable().LegHealthMul = 1;
	
	ply:StopBleed();
	
	if( ply:GetField( "isko" ) == 0 ) then
	
		ply:SetNWFloat( "conscious", 100 );
	
	end

	ply:SetNWInt( "MaxArmor", 0 );
	
	--The default player health is 65 plus how much endurance they have
	ply:SetHealthStat( 65 + ply:GetNWFloat( "stat.Endurance" ) );

	local team = ply:Team();
	
	ply:SetModel( ply:GetField( "model" ) );
	
	DoTeamData( ply );
	
	CheckSpecialCharacter( ply );
	
	if( ply:IsCombineDefense() and not ply:HasItem( "radio" ) ) then
		
		ply:GiveItem( "radio", false );
		
	end
	
	
	if( ply:Team() == 2 ) then
	
		ply:SetModel( "models/ODST/male_0"..math.random( 1, 9 ).."_odst.mdl" );
		ply:SetArmor( 50 );
		ply:SetJob( "National Republic Dawn" );
		ply:SetTitle( "National Republic Dawn" );
		ply:ForceGive( "weapon_ts_pistol", false );
		ply:ForceGive( "weapon_ts_mp7", false );

	elseif( ply:Team() == 3 ) then

		ply:SetModel( "models/srpmodels/loner"..math.random( 1, 3 )..".mdl" );
		ply:SetArmor( 50 );
		ply:SetJob( "New Soviet Revolutionary Front" );
		ply:SetTitle( "New Soviet Revolutionary Front" );
		ply:ForceGive( "weapon_ts_hkp46", false );
		ply:ForceGive( "weapon_ts_ak47", false );
		ply:ForceGive( "weapon_ts_mp5k", false );

	end
	
	if( ply:Team() == 5 ) then
	
		local crntmodel = string.lower( ply:GetField( "citizenmodel" ) );
	
		if( string.find( crntmodel, "female" ) ) then
		
			ply:SetModel( "models/humans/Group01/drconnors.mdl" );
		
		else
		
			ply:SetModel( "models/characters/gallaha.mdl" );
		
		end
	
	end
	
	if( ply:Team() == 6 ) then
	
		local crntmodel = string.lower( ply:GetField( "citizenmodel" ) );
		crntmodel = string.gsub( string.lower( crntmodel ), "group02", "Group03" );
		crntmodel = string.gsub( string.lower( crntmodel ), "group01", "Group03" );
		
		ply:SetModel( crntmodel );	

		ply:ForceGive( "weapon_ts_hkp46", false );
		ply:GiveAmmo( 8, "Pistol" );

	end
		
	if( ply:IsRick() ) then
	
		ply:ForceGive( "weapon_ts_godhand", false );
	
	end
	
	if( ply:IsCombine() ) then
	
		ply:SetField( "MaxStamina", 100 );
	
	end
	
	ply:SetNWInt( "sprint", 100 );
	
	local model = string.lower( ply:GetModel() );

	ply:GetTable().AnimTable = NPCAnim.CitizenMaleAnim;
	
	if( table.HasValue( NPCAnim.CitizenFemaleModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CitizenFemaleAnim; end
	if( table.HasValue( NPCAnim.CombineMetroModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineMetroAnim; end
	if( table.HasValue( NPCAnim.CombineOWModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineOWAnim; end
	
	
	ply:SetNWString( "lastweapon", "" )
	
	ply:GetTable().WalkSpeed = 90 + math.Clamp( ply:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
	ply:GetTable().SprintSpeed = 165 + math.Clamp( ply:GetNWFloat( "stat.Speed" ) * 1.7, 0, 150 );
	ply:GetTable().SprintDegradeAmt = math.Clamp( 3 / ply:GetNWFloat( "stat.Sprint" ), .01, 2 );
	
	local map = game.GetMap();

	if( ply:Team() == 1 or not CustomCPSpawnPoints ) then
	
		if( CustomSpawnPoints[map] ) then 
	
			if( math.random( 1, 7 ) ~= 3 ) then
			
				local num = math.random( 1, #CustomSpawnPoints[map] );
				
				while( num == TS.LastSpawn ) do
				
					num = math.random( 1, #CustomSpawnPoints[map] );
				
				end
				
				TS.LastSpawn = num;
			
				local sp = CustomSpawnPoints[map][num];
			
				ply:SetPos( sp.Pos );
				ply:SetEyeAngles( sp.Ang );
			
			end
	
		end
	
	else
	
		if( CustomCPSpawnPoints[map] ) then
	
			local num = math.random( 1, #CustomCPSpawnPoints[map] );
			
			while( num == TS.LastCPSpawn ) do
			
				num = math.random( 1, #CustomCPSpawnPoints[map] );
			
			end
			
			TS.LastCPSpawn = num;
		
			local sp = CustomCPSpawnPoints[map][num];

			ply:SetPos( sp.Pos );
			ply:SetEyeAngles( sp.Ang );
			
		end
	
	
	end

end

function GM:KeyRelease( ply, code )

	if( code == IN_SPEED or code == IN_RUN ) then
	
		ply:GetTable().SprintHeal = math.Clamp( ply:GetNWFloat( "stat.Sprint" ) / 200, .01, 1.5 );
	
	end

end

function GM:KeyPress( ply, code )

	if( LAG_TEST ) then
	
		Msg( "GM:KeyPress : " .. ply:Nick() .. "\n" );
	
	end
	
	if( code == IN_SPEED or code == IN_RUN ) then
	
		ply:GetTable().SprintHeal = math.Clamp( ply:GetNWFloat( "stat.Sprint" ) / 300, .01, 1.5 );
	
	
	end

	if( code == IN_JUMP ) then
	
		ply:SetField( "LastJump", CurTime() );
		ply:SetNWInt( "sprint", math.Clamp( ply:GetNWInt( "sprint" ) - 15, 0, 100 )  );
	
	end

	if( code == IN_USE ) then
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 70;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( ValidEntity( tr.Entity ) and tr.Entity:IsItem() ) then
		
			local canpickup = true;
			
			if( true ) then
				if( not TS.ItemData[tr.Entity:GetTable().Data.UniqueID].PickupFunc ) then
					
					if( tr.Entity:GetTable().Welded ) then
		
						if( tr.Entity:GetTable().WeldPos:Distance( tr.Entity:GetPos() ) > 2 ) then
						
							tr.Entity:GetTable().Welded = false;
							
						else
						
							ply:PrintMessage( 3, "Cannot pickup.  This item is attached to a surface" );
							canpickup = false;
						
						end
					
					end
					
					if( canpickup ) then
						tr.Entity:GiveTo( ply );
					end
				else
					TS.ItemData[tr.Entity:GetTable().Data.UniqueID].PickupFunc( ply, tr.Entity, TS.ItemData[tr.Entity:GetTable().Data.UniqueID] );
				end
			end
		
		end
		
		if( ValidEntity( tr.Entity ) and tr.Entity:GetNWInt( "doorstate" ) == 7 and
			 ( ply:IsCombine() or ply:GetTable().StalkerMode ) ) then
		
			tr.Entity:Fire( "toggle", "", 0 );
		
		end
	
	end

end

--Log player death
function GM:PlayerDeath( ply, weapon, attacker )

	if( LAG_TEST ) then
	
		Msg( "GM:PlayerDeath : " .. ply:Nick() .. "\n" );
	
	end
	
	umsg.Start( "DropAllWeaponsFromInventory", ply );
	umsg.End();	
	
	local scount = 0;
	
	for k, v in pairs( ply:GetWeapons() ) do
	
		local id = v:GetClass();
	
		if( not ply:GetTable().Inventory[id] ) then return; end
		ply:GetTable().Inventory[id].Amt = 0;
		
		scount =  scount + ply:GetTable().Inventory[id].Table.Size;
	
	end
	
	ply:SetField( "inventory.CrntSize", ply:GetField( "inventory.CrntSize" ) - scount );
	ply:SetPrivateFloat( "inventory.CrntSize", ply:GetField( "inventory.CrntSize" ) );
	
	ply:CheckInventory();
	ply:SaveItems();
	
	ply:StripWeapons();

	local recordpos = false;
	
	ply:Freeze( false );
	
	if( ply:EntIndex() ~= attacker:EntIndex() or ply:GetField( "slay" ) == 1 ) then
	
		if( ply:GetNWInt( "tiedup" ) == 1 ) then
		
			ply:SetNWInt( "tiedup", 0 );
			ply:SetNWInt( "beingtiedup", 0 );
		
		end
	
	end
	
	if( ply:GetField( "slay" ) == 0 ) then
	
		if( ply == attacker ) then
		
			TS.PrintMessageAll( 2, ply:Nick() .. " suicided" );
		
		end
	
	end
	
	if( ply:GetField( "slay" ) == 1 ) then
	
		if( ply == attacker ) then
		
			TS.PrintMessageAll( 2, ply:Nick() .. " was killed" );
		
		end
	
		ply:SetField( "slay", 0 );
		
		if( ply:GetField( "isko" ) == 1 ) then
			ply:GoConscious();
			
			umsg.Start( "SendPrivateInt", ply );
				umsg.String( "passedout" );
				umsg.Short( 0 );
			umsg.End();
			
		end
		
		if( ply:IsRagdolled() ) then
		
			ply:CleanServerRagdoll();
		
		end
	
	elseif( ply:IsRagdolled() ) then
	
		recordpos = true;
	
	elseif( ply:IsTiedUp() ) then
		
		recordpos = true;
		
	end	
	
	if( recordpos ) then
		ply:GetTable().DeathPos = ply:GetPos();
	else
		ply:GetTable().DeathPos = nil;
	end
	
	local weapstr = "";
	
	if( weapon:IsValid() ) then
	
		weapstr = " with " .. weapon:GetClass();
	
	end
	
	if( attacker:IsPlayer() ) then
		
		if( attacker ~= ply ) then
		
			--[[if( ply:IsCombineDefense() ) then
				TS.TalkToFreq( ply:GetField( "radiofreq" ), "Vital signs for CCA unit " .. ply:Nick() .. " have ceased." );
			end--]]

			TS.PrintMessageAll( 2, ply:Nick() .. " was killed by " .. attacker:Nick() .. weapstr );
				
			local NotDroppable =
			{
			
				"ts_hands",
				"ts_keys",
				"weapon_physgun",
				"weapon_physcannon"
			
			}
			
			if( ply:GetNWString( "lastweapon" ) ~= "" and ply:GetField( "slay" ) == 0 ) then
			
				local class = ply:GetNWString( "lastweapon" );
				local drop = true;
				
				for k, v in pairs( NotDroppable ) do
				
					if( v == class ) then
					
						drop = false;
						break;
					
					end
				
				end
				
				if( drop ) then
				
					ply:DropLastPlayerWeapon();
				
				end
			
			end
		
		end
	
		TS.DayLog( "kills.txt", attacker:LogInfo() .. " killed " .. ply:LogInfo() .. weapstr );
		TS.Log( "kills.txt", attacker:LogInfo() .. " killed " .. ply:LogInfo() .. weapstr );
	else
		
		TS.PrintMessageAll( 2, ply:Nick() .. " was killed by " .. attacker:GetClass() .. weapstr );
	
		TS.DayLog( "kills.txt", attacker:GetClass() .. " killed " .. ply:LogInfo() .. weapstr );
		TS.Log( "kills.txt", attacker:GetClass() .. " killed " .. ply:LogInfo() .. weapstr );
	end

	ply:RemoveAllTSAmmo();
	--Remove weapons

	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
  
	if( not ply:IsRagdolled() ) then
		ply:CreateRagdoll();
	end	
 
end

function GM:PlayerDeathSound()

	return true;

end
   

function GM:PhysgunPickup( ply, ent )

	if( ent:IsWeapon() and not ent:IsNPC() ) then return false; end
	if( ent:IsDoor() ) then return false; end
	if( ply:IsSuperAdmin() ) then return true; end
	--if( ply:GetField( "group_id" ) == 4 ) then return true; end
	if( ent:IsNPC() ) then return false; end
		
	if( ent:IsPlayer() ) then
		return false;
	end
	
	if( not ply:IsAdmin() and not ply:IsToolTrusted() ) then
	
		if( ent:GetNWBool( "SpawnedProp" ) and ent:GetNWEntity( "Creator" ):IsValid() and ent:GetNWEntity( "Creator" ) ~= ply and ent:GetNWEntity( "Creator" ):IsToolTrusted() ) then
		
			return false;
		
		end
	
	end
	
	return ent:CanPhysgun();

end

--Handles how much damage is dealt to players
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if( LAG_TEST ) then
	
		Msg( "GM:ScalePlayerDamage : " .. ply:Nick() .. "\n" );
	
	end

	if( not dmginfo:GetAttacker():IsPlayer() and not dmginfo:GetAttacker():IsNPC() ) then
		return;
	end
	
	local headarmor = false;
	local bodyarmor = false;
	
	if( ply:IsCombineDefense() ) then
	
		headarmor = true;
		
		if( ply:Team() == 2 and ply:IsTempCP() ) then
			headarmor = false;
		end
	
	end
	
	if( ply:Armor() > 0 ) then
	
		bodyarmor = true;
	
	end
	
	local attackweap = dmginfo:GetAttacker():GetActiveWeapon();
	--Msg( "First Damage: " .. dmginfo:GetDamage() .. "\n" );
	
	--This part changes the damage based on the distance from attacker to victim
	--Closer means more damage unless this is melee

	if( attackweap:IsValid() and not attackweap:GetTable().Melee ) then
	
		local distmultprc = 1;
	
		local distmult = 1;
		local distlen = ( dmginfo:GetAttacker():GetPos() - ply:GetPos() ):Length();
		distmult = math.Clamp( 1500 / distlen, 1, 1.5 );
		
		if( hitgroup == HITGROUP_HEAD ) then
		
			if( headarmor ) then
				distmultprc = .7;
			end
		
		elseif( hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH ) then
			if( bodyarmor ) then
				distmultprc = .6;
			end
		end
		
		dmginfo:ScaleDamage( distmult * distmultprc );
		
	end

	
	--Msg( "Pre Damage: " .. dmginfo:GetDamage() .. "\n" );
	
	--Hitgroup damage:
	
	if( hitgroup == HITGROUP_HEAD ) then
	 
	 	if( not headarmor ) then
			dmginfo:ScaleDamage( 9.3 );
		else
			dmginfo:ScaleDamage( 2.5 );
		end
		
		--Make the player bleed is the damage is over 40 or player's health is under 40
		if( not headarmor and ( dmginfo:GetDamage() >= 40 or ply:Health() <= 40 ) ) then
		
			ply:MakeBleed();
			ply:SetBleedAmount( 4 + ply:GetBleedAmount() );
			ply:SetField( "HeadBleed", 1 );
		
		end
	 
	 end
	 
	if( hitgroup == HITGROUP_CHEST ) then
	
		if( not bodyarmor ) then
			dmginfo:ScaleDamage( 2.5 );
		else
			dmginfo:ScaleDamage( .5 );
		end
		
		ply:HandleBodyShot( dmginfo );
		
	end
	
	if( hitgroup == HITGROUP_STOMACH ) then
	
		if( not bodyarmor ) then
			dmginfo:ScaleDamage( 2 );
		else
			dmginfo:ScaleDamage( .6 );
		end
		
		ply:HandleBodyShot( dmginfo );
	
	end
	
	if( hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM ) then
	 
		dmginfo:ScaleDamage( 0.45 );
		ply:HandleArmShot( dmginfo );
		dmginfo:ScaleDamage( 0.001 );
	 
	 end
	 
	 if( hitgroup == HITGROUP_LEFTLEG or
	 	 hitgroup == HITGROUP_RIGHTLEG ) then
	 	
		dmginfo:ScaleDamage( 0.45 );
		ply:HandleLegShot( dmginfo );
		dmginfo:ScaleDamage( 0.001 );
	 	 
	 end
	 
	 ply:SetField( "LastJump", CurTime() );
	 
	 if( not bodyarmor ) then
	 	ply:SetNWInt( "sprint", math.Clamp( ply:GetNWInt( "sprint" ) - 5, 0, 100 )  );
	 end
	 
	 --Change damage based on endurance
	 dmginfo:ScaleDamage( math.Clamp( 50 / ply:GetNWFloat( "stat.Endurance" ), 1.1, 1.6 ) );
	--Msg( "Post Damage: " .. dmginfo:GetDamage() .. " Hitgroup: " .. hitgroup .. "\n" );
	
	
	return dmginfo;
	
end

--For ragdolls
function GM:EntityTakeDamage( ent, inflictor, attacker, amount )
  
	if( ent:IsPlayerRagdoll() and attacker:IsPlayer() and attacker:GetActiveWeapon() and attacker:GetActiveWeapon():GetClass() ~= "weapon_physgun" and attacker:KeyDown( IN_ATTACK ) ) then
		
		local ply = ent:GetPlayer();
		
		ply:SetHealth( ply:Health() - amount * math.random( .5, 1.2 ) );
		
		if( ply:Health() <= 0 ) then
			ply:Slay();
		end
	
	end
	
	if( attacker:IsPlayer() and ent:GetPos():Distance( attacker:GetPos() ) > 350 and attacker:GetActiveWeapon():IsValid() and attacker:GetActiveWeapon():GetTable().CanLearn ) then
	
		attacker:RaiseAimStat();
	
	end
  
end 

--F3:
function GM:ShowSpare1( ply )

	umsg.Start( "TogglePlayerMenu", ply ); umsg.End();

end
