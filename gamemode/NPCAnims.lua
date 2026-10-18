
------
-- NPC Animations
-- March 24, 2007
-- Rick Darkaliono
------


--Weapons that are always aimed
AlwaysAimed = 
{

	"weapon_physgun",
	"weapon_physcannon",
	"weapon_frag",
	"weapon_slam",
	"weapon_rpg",
	"gmod_tool",
	"weapon_ts_flashnade"
	
}

--Weapons that are never aimed
NeverAimed =
{

	"ts_keys",
	"weapon_ts_zipties",
	"ts_medic",
	"weapon_ts_godhand",
	

}

--Weapons that can still be usable while not aimed
UsableHolstered =
{

	"ts_keys",
	"weapon_ts_zipties",
	"ts_medic",
	"ts_hands",
	"weapon_ts_godhand",
}

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

function ccModelList( ply, cmd, args )

	ply:PrintMessage( 2, "USE rp_setmodel TO CHANGE MODEL. HERE ARE THE MODELS AVAILABLE: " );
	
	for k, v in pairs( Models ) do
	
		ply:PrintMessage( 2, v );
	
	end

end
--concommand.Add( "rp_modellist", ccModelList );

--[[
function ccSetModel( ply, cmd, args )

	for k, v in pairs( Models ) do
	
		if( v == args[1] ) then
			ply:GetTable().NextModel = args[1];
			ply:PrintMessage( 2, "Model will be changed on next spawn" );
			return;
		end
	
	end
	
	ply:PrintMessage( 2, "No such model: " .. args[1] );

end
--concommand.Add( "rp_setmodel", ccSetModel );
]]--

function HolsterToggle( ply )

	if( not NPC_ANIMS_ENABLED ) then return; end

	if( not ply:GetActiveWeapon():IsValid() ) then
		return;
	end

	if( ply:GetNWInt( "tiedup" ) == 1 ) then 
		return; 
	end
	
	local weap = ply:GetActiveWeapon();


	if( ply:GetNWInt( "holstered" ) == 1 ) then
		
		for j, l in pairs( NeverAimed ) do
			
			if( l == weap:GetClass() ) then
				return;
			end
			
		end
	
		MakeAim( ply );
	else
		
		for j, l in pairs( AlwaysAimed ) do
			
			if( l == weap:GetClass() ) then
				return;
			end
			
		end
		
		MakeUnAim( ply );
	end

end
concommand.Add( "rp_toggleholster", HolsterToggle );

function MakeAim( ply )

	if( not ply:GetActiveWeapon():IsValid() ) then return; end

	if( not ply:GetActiveWeapon():GetTable().Invisible ) then
		ply:DrawViewModel( true );
		ply:DrawWorldModel( true );
	else
		ply:DrawViewModel( false );
		ply:DrawWorldModel( false );
	end
	
	ply:GetActiveWeapon():SetNWBool( "NPCAimed", true );
	ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() );
	
	ply:SetNWInt( "holstered", 0 );
	
	if( ply:GetActiveWeapon().ToggleWeaponHolster ) then
		ply:GetActiveWeapon():ToggleWeaponHolster( true );
	end

	ply:SetField( "WeapAnim", GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 ) );
	

end

function MakeUnAim( ply )

	if( not ply:GetActiveWeapon():IsValid() ) then return; end

	ply:DrawViewModel( false );
	
	if( ply:GetActiveWeapon():IsValid() ) then
		ply:GetActiveWeapon():SetNWBool( "NPCAimed", false );
		
		local delay = true;
		
		for k, v in pairs( UsableHolstered ) do
			if( v == ply:GetActiveWeapon():GetClass() ) then
				delay = false;
			end
		end
		
		if( delay ) then
			ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 999999 );
		end
		
		if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
			ply:GetActiveWeapon():ToggleIronsight();
		end
	end
	
	ply:SetNWInt( "holstered", 1 );
	
	if( ply:GetActiveWeapon().ToggleWeaponHolster ) then
		ply:GetActiveWeapon():ToggleWeaponHolster( false );
	end
	
	ply:SetField( "WeapAnim", GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 ) );
	

end


function NPCPlayerSpawn( ply )

	if( not NPC_ANIMS_ENABLED ) then return; end

	GAMEMODE:PlayerSpawn( ply );

	if( ply:GetTable().NextModel ) then
		ply:SetModel( ply:GetTable().NextModel );
	end
	
	return true;

end
--hook.Add( "PlayerSpawn", "NPCPlayerSpawn", NPCPlayerSpawn );


NPCAnim = { }

NPCAnim.CitizenMaleAnim = { }
NPCAnim.CitizenMaleModels = 
{

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
              "models/Humans/Group03/Male_01.mdl",
              "models/Humans/Group03/male_02.mdl",
              "models/Humans/Group03/male_03.mdl",
              "models/Humans/Group03/Male_04.mdl",
              "models/Humans/Group03/Male_05.mdl",
              "models/Humans/Group03/male_06.mdl",
              "models/Humans/Group03/male_07.mdl",
              "models/Humans/Group03/male_08.mdl",
              "models/Humans/Group03/male_09.mdl",
              "models/Humans/Group03m/Male_01.mdl",
              "models/Humans/Group03m/male_02.mdl",
              "models/Humans/Group03m/male_03.mdl",
              "models/Humans/Group03m/Male_04.mdl",
              "models/Humans/Group03m/Male_05.mdl",
              "models/Humans/Group03m/male_06.mdl",
              "models/Humans/Group03m/male_07.mdl",
              "models/Humans/Group03m/male_08.mdl",
              "models/Humans/Group03m/male_09.mdl"
 
}

for k, v in pairs( NPCAnim.CitizenMaleModels ) do

	NPCAnim.CitizenMaleModels[k] = string.lower( v );

end


NPCAnim.CitizenMaleAnim["idle"] = 1
NPCAnim.CitizenMaleAnim["walk"] = 6
NPCAnim.CitizenMaleAnim["run"] = 10
NPCAnim.CitizenMaleAnim["glide"] = 27
NPCAnim.CitizenMaleAnim["sit"] = 277
NPCAnim.CitizenMaleAnim["crouch"] = 5
NPCAnim.CitizenMaleAnim["crouchwalk"] = 8
 
NPCAnim.CitizenMaleAnim["pistolidle"] = 75 --
NPCAnim.CitizenMaleAnim["pistolrun"] = 10 --
NPCAnim.CitizenMaleAnim["pistolwalk"] = 6 --*
NPCAnim.CitizenMaleAnim["pistolaimidle"] = 74 --
NPCAnim.CitizenMaleAnim["pistolaimwalk"] = 321 -- NO GO
NPCAnim.CitizenMaleAnim["pistolcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["pistolcrouch"] = 5 --*
NPCAnim.CitizenMaleAnim["pistolaimcrouch"] = 293--*
NPCAnim.CitizenMaleAnim["pistolaimcrouchwalk"] = 373 --*
NPCAnim.CitizenMaleAnim["pistolaimrun"] = 321 --* NO GO
NPCAnim.CitizenMaleAnim["pistolreload"] = 377 --*
NPCAnim.CitizenMaleAnim["pistolfire"] = 334;
 
NPCAnim.CitizenMaleAnim["smgidle"] = 309 --
NPCAnim.CitizenMaleAnim["smgrun"] = 12 -- NO GO
NPCAnim.CitizenMaleAnim["smgwalk"] = 307 --*
NPCAnim.CitizenMaleAnim["smgaimidle"] = 74 --
NPCAnim.CitizenMaleAnim["smgaimwalk"] = 321 -- NO GO
NPCAnim.CitizenMaleAnim["smgcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["smgcrouch"] = 5 --*
NPCAnim.CitizenMaleAnim["smgaimcrouch"] = 279 --*
NPCAnim.CitizenMaleAnim["smgaimcrouchwalk"] = 373 --*
NPCAnim.CitizenMaleAnim["smgaimrun"] = 367 --*
NPCAnim.CitizenMaleAnim["smgreload"] = 377 --*(
NPCAnim.CitizenMaleAnim["smgfire"] = 74 --(
 
NPCAnim.CitizenMaleAnim["ar2idle"] = 29 --
NPCAnim.CitizenMaleAnim["ar2run"] = 27 --
NPCAnim.CitizenMaleAnim["ar2walk"] = 307 --*
NPCAnim.CitizenMaleAnim["ar2aimidle"] = 73 --
NPCAnim.CitizenMaleAnim["ar2aimwalk"] = 336 --
NPCAnim.CitizenMaleAnim["ar2crouchwalk"] = 8
NPCAnim.CitizenMaleAnim["ar2crouch"] = 342 --*
NPCAnim.CitizenMaleAnim["ar2aimcrouch"] = 341 --*
NPCAnim.CitizenMaleAnim["ar2aimcrouchwalk"] = 373 --*
NPCAnim.CitizenMaleAnim["ar2aimrun"] = 336 --*
NPCAnim.CitizenMaleAnim["ar2reload"] = 310 --*
NPCAnim.CitizenMaleAnim["ar2fire"] = 289
 
NPCAnim.CitizenMaleAnim["shotgunidle"] = 309 --
NPCAnim.CitizenMaleAnim["shotgunwalk"] = 307 --
NPCAnim.CitizenMaleAnim["shotgunrun"] = 310 --
NPCAnim.CitizenMaleAnim["shotgunaimidle"] = 145 --
NPCAnim.CitizenMaleAnim["shotgunaimwalk"] = 336
NPCAnim.CitizenMaleAnim["shotgunaimrun"] = 367 --
NPCAnim.CitizenMaleAnim["shotguncrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["shotguncrouch"] = 342 --
NPCAnim.CitizenMaleAnim["shotgunaimcrouch"] = 341 --
NPCAnim.CitizenMaleAnim["shotgunaimcrouchwalk"] = 373 --
NPCAnim.CitizenMaleAnim["shotgunreload"] = 310 --
NPCAnim.CitizenMaleAnim["shotgunfire"] = 288
 
NPCAnim.CitizenMaleAnim["crossbowidle"] = 316
NPCAnim.CitizenMaleAnim["crossbowwalk"] = 309
NPCAnim.CitizenMaleAnim["crossbowrun"] = 310
NPCAnim.CitizenMaleAnim["crossbowaimidle"] = 256
NPCAnim.CitizenMaleAnim["crossbowaimwalk"] = 336
NPCAnim.CitizenMaleAnim["crossbowaimrun"] = 340
NPCAnim.CitizenMaleAnim["crossbowcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["crossbowcrouch"] = 5
NPCAnim.CitizenMaleAnim["crossbowaimcrouch"] = 275
NPCAnim.CitizenMaleAnim["crossbowaimcrouchwalk"] = 338
NPCAnim.CitizenMaleAnim["crossbowreload"] = 359
NPCAnim.CitizenMaleAnim["crossbowfire"] = 288
 
NPCAnim.CitizenMaleAnim["meleeidle"] = 1
NPCAnim.CitizenMaleAnim["meleewalk"] = 6
NPCAnim.CitizenMaleAnim["meleerun"] = 10
NPCAnim.CitizenMaleAnim["meleeaimidle"] = 336
NPCAnim.CitizenMaleAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["meleeaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["meleecrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["meleecrouch"] = 5
NPCAnim.CitizenMaleAnim["meleeaimwalk"] = 6
NPCAnim.CitizenMaleAnim["meleeaimrun"] = 10
NPCAnim.CitizenMaleAnim["meleefire"] = 273
 
NPCAnim.CitizenMaleAnim["rpgidle"] = 316
NPCAnim.CitizenMaleAnim["rpgwalk"] = 309
NPCAnim.CitizenMaleAnim["rpgrun"] = 310
NPCAnim.CitizenMaleAnim["rpgaimidle"] = 327
NPCAnim.CitizenMaleAnim["rpgaimwalk"] = 336
NPCAnim.CitizenMaleAnim["rpgaimrun"] = 340
NPCAnim.CitizenMaleAnim["rpgcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["rpgcrouch"] = 5
NPCAnim.CitizenMaleAnim["rpgaimcrouch"] = 275
NPCAnim.CitizenMaleAnim["rpgaimcrouchwalk"] = 338
NPCAnim.CitizenMaleAnim["rpgfire"] = 272
 
NPCAnim.CitizenMaleAnim["grenadeidle"] = 1
NPCAnim.CitizenMaleAnim["grenadewalk"] = 6
NPCAnim.CitizenMaleAnim["grenaderun"] = 10
NPCAnim.CitizenMaleAnim["grenadeaimidle"] = 1
NPCAnim.CitizenMaleAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["grenadeaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["grenadecrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["grenadecrouch"] = 5
NPCAnim.CitizenMaleAnim["grenadeaimwalk"] = 6
NPCAnim.CitizenMaleAnim["grenadeaimrun"] = 10
NPCAnim.CitizenMaleAnim["grenadefire"] = 273
 
NPCAnim.CitizenMaleAnim["slamidle"] = 1
NPCAnim.CitizenMaleAnim["slamwalk"] = 6
NPCAnim.CitizenMaleAnim["slamrun"] = 10
NPCAnim.CitizenMaleAnim["slamaimidle"] = 1
NPCAnim.CitizenMaleAnim["slamaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["slamaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["slamcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["slamcrouch"] = 5
NPCAnim.CitizenMaleAnim["slamaimwalk"] = 6
NPCAnim.CitizenMaleAnim["slamaimrun"] = 10
NPCAnim.CitizenMaleAnim["slamfire"] = 273
 
NPCAnim.CitizenMaleAnim["physgunidle"] = 256
NPCAnim.CitizenMaleAnim["physgunwalk"] = 336
NPCAnim.CitizenMaleAnim["physgunrun"] = 340
NPCAnim.CitizenMaleAnim["physgunaimidle"] = 256
NPCAnim.CitizenMaleAnim["physgunaimwalk"] = 336
NPCAnim.CitizenMaleAnim["physgunaimrun"] = 340
NPCAnim.CitizenMaleAnim["physgunaimcrouchwalk"] = 338
NPCAnim.CitizenMaleAnim["physgunaimcrouch"] = 275


NPCAnim.CitizenFemaleAnim = { }
NPCAnim.CitizenFemaleModels = 
{
	
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
              "models/Humans/Group03/Female_01.mdl",
              "models/Humans/Group03/Female_02.mdl",
              "models/Humans/Group03/Female_03.mdl",
              "models/Humans/Group03/Female_04.mdl",
              "models/Humans/Group03/Female_06.mdl",
              "models/Humans/Group03/Female_07.mdl",
              "models/Humans/Group03m/Female_01.mdl",
              "models/Humans/Group03m/Female_02.mdl",
              "models/Humans/Group03m/Female_03.mdl",
              "models/Humans/Group03m/Female_04.mdl",
              "models/Humans/Group03m/Female_06.mdl",
              "models/Humans/Group03m/Female_07.mdl"
}

for k, v in pairs( NPCAnim.CitizenFemaleModels ) do

	NPCAnim.CitizenFemaleModels[k] = string.lower( v );

end

NPCAnim.CitizenFemaleAnim["idle"] = 1
NPCAnim.CitizenFemaleAnim["walk"] = 6
NPCAnim.CitizenFemaleAnim["run"] = 10
NPCAnim.CitizenFemaleAnim["glide"] = 27
NPCAnim.CitizenFemaleAnim["sit"] = 370
NPCAnim.CitizenFemaleAnim["crouch"] = 5
NPCAnim.CitizenFemaleAnim["crouchwalk"] = 8
 
NPCAnim.CitizenFemaleAnim["pistolidle"] = 1
NPCAnim.CitizenFemaleAnim["pistolwalk"] = 6
NPCAnim.CitizenFemaleAnim["pistolrun"] = 10
NPCAnim.CitizenFemaleAnim["pistolcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["pistolcrouch"] = 5
NPCAnim.CitizenFemaleAnim["pistolaimidle"] = 270
NPCAnim.CitizenFemaleAnim["pistolaimwalk"] = 316
NPCAnim.CitizenFemaleAnim["pistolaimrun"] = 318
NPCAnim.CitizenFemaleAnim["pistolaimcrouch"] = 292
NPCAnim.CitizenFemaleAnim["pistolaimcrouchwalk"] = 302
NPCAnim.CitizenFemaleAnim["pistolreload"] = 358
NPCAnim.CitizenFemaleAnim["pistolfire"] = 303
 
NPCAnim.CitizenFemaleAnim["smgidle"] = 307; --
NPCAnim.CitizenFemaleAnim["smgrun"] = 336; --
NPCAnim.CitizenFemaleAnim["smgwalk"] = 334; --
NPCAnim.CitizenFemaleAnim["smgaimidle"] = 270; --
NPCAnim.CitizenFemaleAnim["smgaimwalk"] = 308; --
NPCAnim.CitizenFemaleAnim["smgcrouchwalk"] = 8; --
NPCAnim.CitizenFemaleAnim["smgcrouch"] = 274; --
NPCAnim.CitizenFemaleAnim["smgaimcrouch"] = 292; --
NPCAnim.CitizenFemaleAnim["smgaimcrouchwalk"] = 302; --
NPCAnim.CitizenFemaleAnim["smgreload"] = 358
NPCAnim.CitizenFemaleAnim["smgfire"] = 303


NPCAnim.CitizenFemaleAnim["ar2idle"] = 307
NPCAnim.CitizenFemaleAnim["ar2walk"] = 309
NPCAnim.CitizenFemaleAnim["ar2run"] = 310
NPCAnim.CitizenFemaleAnim["ar2aimidle"] = 256
NPCAnim.CitizenFemaleAnim["ar2aimwalk"] = 336
NPCAnim.CitizenFemaleAnim["ar2aimrun"] = 340
NPCAnim.CitizenFemaleAnim["ar2crouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["ar2crouch"] = 5
NPCAnim.CitizenFemaleAnim["ar2aimcrouch"] = 275
NPCAnim.CitizenFemaleAnim["ar2aimcrouchwalk"] = 338
NPCAnim.CitizenFemaleAnim["ar2reload"] = 359
NPCAnim.CitizenFemaleAnim["ar2fire"] = 281

NPCAnim.CitizenFemaleAnim["shotgunidle"] = 316
NPCAnim.CitizenFemaleAnim["shotgunwalk"] = 309
NPCAnim.CitizenFemaleAnim["shotgunrun"] = 310
NPCAnim.CitizenFemaleAnim["shotgunaimidle"] = 256
NPCAnim.CitizenFemaleAnim["shotgunaimwalk"] = 336
NPCAnim.CitizenFemaleAnim["shotgunaimrun"] = 340
NPCAnim.CitizenFemaleAnim["shotguncrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["shotguncrouch"] = 5
NPCAnim.CitizenFemaleAnim["shotgunaimcrouch"] = 275
NPCAnim.CitizenFemaleAnim["shotgunaimcrouchwalk"] = 338
NPCAnim.CitizenFemaleAnim["shotgunreload"] = 359
NPCAnim.CitizenFemaleAnim["shotgunfire"] = 288

NPCAnim.CitizenFemaleAnim["crossbowidle"] = 316
NPCAnim.CitizenFemaleAnim["crossbowwalk"] = 309
NPCAnim.CitizenFemaleAnim["crossbowrun"] = 310
NPCAnim.CitizenFemaleAnim["crossbowaimidle"] = 256
NPCAnim.CitizenFemaleAnim["crossbowaimwalk"] = 336
NPCAnim.CitizenFemaleAnim["crossbowaimrun"] = 340
NPCAnim.CitizenFemaleAnim["crossbowcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["crossbowcrouch"] = 5
NPCAnim.CitizenFemaleAnim["crossbowaimcrouch"] = 275
NPCAnim.CitizenFemaleAnim["crossbowaimcrouchwalk"] = 338
NPCAnim.CitizenFemaleAnim["crossbowreload"] = 359
NPCAnim.CitizenFemaleAnim["crossbowfire"] = 288

NPCAnim.CitizenFemaleAnim["meleeidle"] = 1
NPCAnim.CitizenFemaleAnim["meleewalk"] = 6
NPCAnim.CitizenFemaleAnim["meleerun"] = 10
NPCAnim.CitizenFemaleAnim["meleeaimidle"] = 273
NPCAnim.CitizenFemaleAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["meleeaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["meleecrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["meleecrouch"] = 5
NPCAnim.CitizenFemaleAnim["meleeaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["meleeaimrun"] = 10
NPCAnim.CitizenFemaleAnim["meleefire"] = 273

NPCAnim.CitizenFemaleAnim["rpgidle"] = 316
NPCAnim.CitizenFemaleAnim["rpgwalk"] = 309
NPCAnim.CitizenFemaleAnim["rpgrun"] = 310
NPCAnim.CitizenFemaleAnim["rpgaimidle"] = 327
NPCAnim.CitizenFemaleAnim["rpgaimwalk"] = 336
NPCAnim.CitizenFemaleAnim["rpgaimrun"] = 340
NPCAnim.CitizenFemaleAnim["rpgcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["rpgcrouch"] = 5
NPCAnim.CitizenFemaleAnim["rpgaimcrouch"] = 275
NPCAnim.CitizenFemaleAnim["rpgaimcrouchwalk"] = 338
NPCAnim.CitizenFemaleAnim["rpgfire"] = 272

NPCAnim.CitizenFemaleAnim["grenadeidle"] = 1
NPCAnim.CitizenFemaleAnim["grenadewalk"] = 6
NPCAnim.CitizenFemaleAnim["grenaderun"] = 10
NPCAnim.CitizenFemaleAnim["grenadeaimidle"] = 1
NPCAnim.CitizenFemaleAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["grenadeaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["grenadecrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["grenadecrouch"] = 5
NPCAnim.CitizenFemaleAnim["grenadeaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["grenadeaimrun"] = 10
NPCAnim.CitizenFemaleAnim["grenadefire"] = 273

NPCAnim.CitizenFemaleAnim["slamidle"] = 1
NPCAnim.CitizenFemaleAnim["slamwalk"] = 6
NPCAnim.CitizenFemaleAnim["slamrun"] = 10
NPCAnim.CitizenFemaleAnim["slamaimidle"] = 1
NPCAnim.CitizenFemaleAnim["slamaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["slamaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["slamcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["slamcrouch"] = 5
NPCAnim.CitizenFemaleAnim["slamaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["slamaimrun"] = 10
NPCAnim.CitizenFemaleAnim["slamfire"] = 273

NPCAnim.CitizenFemaleAnim["physgunidle"] = 256
NPCAnim.CitizenFemaleAnim["physgunwalk"] = 336
NPCAnim.CitizenFemaleAnim["physgunrun"] = 340
NPCAnim.CitizenFemaleAnim["physgunaimidle"] = 256
NPCAnim.CitizenFemaleAnim["physgunaimwalk"] = 336
NPCAnim.CitizenFemaleAnim["physgunaimrun"] = 340
NPCAnim.CitizenFemaleAnim["physgunaimcrouchwalk"] = 338
NPCAnim.CitizenFemaleAnim["physgunaimcrouch"] = 275

NPCAnim.CombineMetroAnim = { }
NPCAnim.CombineMetroModels =
{
	 "models/police.mdl",
	 "models/leet_police2.mdl",
	 "models/yellowlake/BlaCop.mdl"
}

for k, v in pairs( NPCAnim.CombineMetroModels ) do

	NPCAnim.CombineMetroModels[k] = string.lower( v );

end


NPCAnim.CombineMetroAnim["idle"] = 1
NPCAnim.CombineMetroAnim["walk"] = 6
NPCAnim.CombineMetroAnim["run"] = 10
NPCAnim.CombineMetroAnim["glide"] = 27
NPCAnim.CombineMetroAnim["sit"] = 0
NPCAnim.CombineMetroAnim["crouch"] = 358
NPCAnim.CombineMetroAnim["crouchwalk"] = 8
 
NPCAnim.CombineMetroAnim["pistolidle"] = 1
NPCAnim.CombineMetroAnim["pistolwalk"] = 6
NPCAnim.CombineMetroAnim["pistolrun"] = 10
NPCAnim.CombineMetroAnim["pistolcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["pistolcrouch"] = 282
NPCAnim.CombineMetroAnim["pistolaimidle"] = 270 --
NPCAnim.CombineMetroAnim["pistolaimwalk"] = 352 --
NPCAnim.CombineMetroAnim["pistolaimrun"] = 353 --
NPCAnim.CombineMetroAnim["pistolaimcrouch"] = 360 --
NPCAnim.CombineMetroAnim["pistolaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["pistolreload"] = 124
NPCAnim.CombineMetroAnim["pistolfire"] = 271
 
NPCAnim.CombineMetroAnim["smgidle"] = 301; --
NPCAnim.CombineMetroAnim["smgrun"] = 343; --
NPCAnim.CombineMetroAnim["smgwalk"] = 339; --
NPCAnim.CombineMetroAnim["smgaimidle"] = 302; --
NPCAnim.CombineMetroAnim["smgaimwalk"] = 340; --
NPCAnim.CombineMetroAnim["smgcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["smgcrouch"] = 358; --
NPCAnim.CombineMetroAnim["smgaimcrouch"] = 360; --
NPCAnim.CombineMetroAnim["smgaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["smgaimrun"] = 344; --
NPCAnim.CombineMetroAnim["smgreload"] = 124
NPCAnim.CombineMetroAnim["smgfire"] = 271

NPCAnim.CombineMetroAnim["ar2idle"] = 297
NPCAnim.CombineMetroAnim["ar2walk"] = 335
NPCAnim.CombineMetroAnim["ar2run"] = 339
NPCAnim.CombineMetroAnim["ar2aimidle"] = 298
NPCAnim.CombineMetroAnim["ar2aimwalk"] = 336
NPCAnim.CombineMetroAnim["ar2aimrun"] = 340
NPCAnim.CombineMetroAnim["ar2crouchwalk"] = 8
NPCAnim.CombineMetroAnim["ar2crouch"] = 279
NPCAnim.CombineMetroAnim["ar2aimcrouch"] = 278
NPCAnim.CombineMetroAnim["ar2aimcrouchwalk"] = 338
NPCAnim.CombineMetroAnim["ar2reload"] = 359
NPCAnim.CombineMetroAnim["ar2fire"] = 281

NPCAnim.CombineMetroAnim["shotgunidle"] = 297
NPCAnim.CombineMetroAnim["shotgunwalk"] = 335
NPCAnim.CombineMetroAnim["shotgunrun"] = 339
NPCAnim.CombineMetroAnim["shotgunaimidle"] = 298
NPCAnim.CombineMetroAnim["shotgunaimwalk"] = 336
NPCAnim.CombineMetroAnim["shotgunaimrun"] = 340
NPCAnim.CombineMetroAnim["shotguncrouchwalk"] = 8
NPCAnim.CombineMetroAnim["shotguncrouch"] = 279
NPCAnim.CombineMetroAnim["shotgunaimcrouch"] = 278
NPCAnim.CombineMetroAnim["shotgunaimcrouchwalk"] = 338
NPCAnim.CombineMetroAnim["shotgunreload"] = 359
NPCAnim.CombineMetroAnim["shotgunfire"] = 281

NPCAnim.CombineMetroAnim["crossbowidle"] = 316
NPCAnim.CombineMetroAnim["crossbowwalk"] = 309
NPCAnim.CombineMetroAnim["crossbowrun"] = 310
NPCAnim.CombineMetroAnim["crossbowaimidle"] = 256
NPCAnim.CombineMetroAnim["crossbowaimwalk"] = 336
NPCAnim.CombineMetroAnim["crossbowaimrun"] = 340
NPCAnim.CombineMetroAnim["crossbowcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["crossbowcrouch"] = 278
NPCAnim.CombineMetroAnim["crossbowaimcrouch"] = 278
NPCAnim.CombineMetroAnim["crossbowaimcrouchwalk"] = 338
NPCAnim.CombineMetroAnim["crossbowreload"] = 359
NPCAnim.CombineMetroAnim["crossbowfire"] = 288

NPCAnim.CombineMetroAnim["meleeidle"] = 1
NPCAnim.CombineMetroAnim["meleewalk"] = 6
NPCAnim.CombineMetroAnim["meleerun"] = 10
NPCAnim.CombineMetroAnim["meleeaimidle"] = 328 --
NPCAnim.CombineMetroAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["meleeaimcrouch"] = 278
NPCAnim.CombineMetroAnim["meleecrouchwalk"] = 8
NPCAnim.CombineMetroAnim["meleecrouch"] = 278
NPCAnim.CombineMetroAnim["meleeaimwalk"] = 6
NPCAnim.CombineMetroAnim["meleeaimrun"] = 82; --
NPCAnim.CombineMetroAnim["meleefire"] = 105; --

NPCAnim.CombineMetroAnim["rpgidle"] = 297
NPCAnim.CombineMetroAnim["rpgwalk"] = 335
NPCAnim.CombineMetroAnim["rpgrun"] = 339
NPCAnim.CombineMetroAnim["rpgaimidle"] = 298
NPCAnim.CombineMetroAnim["rpgaimwalk"] = 336
NPCAnim.CombineMetroAnim["rpgaimrun"] = 340
NPCAnim.CombineMetroAnim["rpgcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["rpgcrouch"] = 279
NPCAnim.CombineMetroAnim["rpgaimcrouch"] = 278
NPCAnim.CombineMetroAnim["rpgaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["rpgreload"] = 359
NPCAnim.CombineMetroAnim["rpgfire"] = 281

NPCAnim.CombineMetroAnim["grenadeidle"] = 1
NPCAnim.CombineMetroAnim["grenadewalk"] = 6
NPCAnim.CombineMetroAnim["grenaderun"] = 10
NPCAnim.CombineMetroAnim["grenadeaimidle"] = 1
NPCAnim.CombineMetroAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["grenadeaimcrouch"] = 278
NPCAnim.CombineMetroAnim["grenadecrouchwalk"] = 8
NPCAnim.CombineMetroAnim["grenadecrouch"] = 278
NPCAnim.CombineMetroAnim["grenadeaimwalk"] = 6
NPCAnim.CombineMetroAnim["grenadeaimrun"] = 10
NPCAnim.CombineMetroAnim["grenadefire"] = 273

NPCAnim.CombineMetroAnim["slamidle"] = 1
NPCAnim.CombineMetroAnim["slamwalk"] = 6
NPCAnim.CombineMetroAnim["slamrun"] = 10
NPCAnim.CombineMetroAnim["slamaimidle"] = 1
NPCAnim.CombineMetroAnim["slamaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["slamaimcrouch"] = 278
NPCAnim.CombineMetroAnim["slamcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["slamcrouch"] = 278
NPCAnim.CombineMetroAnim["slamaimwalk"] = 6
NPCAnim.CombineMetroAnim["slamaimrun"] = 10
NPCAnim.CombineMetroAnim["slamfire"] = 273

NPCAnim.CombineMetroAnim["physgunidle"] = 256
NPCAnim.CombineMetroAnim["physgunwalk"] = 336
NPCAnim.CombineMetroAnim["physgunrun"] = 340
NPCAnim.CombineMetroAnim["physgunaimidle"] = 298
NPCAnim.CombineMetroAnim["physgunaimwalk"] = 336
NPCAnim.CombineMetroAnim["physgunaimrun"] = 340
NPCAnim.CombineMetroAnim["physgunaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["physgunaimcrouch"] = 278

NPCAnim.CombineOWAnim = { }

NPCAnim.CombineOWModels =
{
	
	"models/combine_super_soldier.mdl",
	"models/Combine_Soldier.mdl",
	"models/Combine_Black_Soldier.mdl",
	"models/urbantrenchcoat.mdl"

}

for k, v in pairs( NPCAnim.CombineOWModels ) do

	NPCAnim.CombineOWModels[k] = string.lower( v );

end


NPCAnim.CombineOWAnim["idle"] = 1
NPCAnim.CombineOWAnim["walk"] = 344
NPCAnim.CombineOWAnim["run"] = 344
NPCAnim.CombineOWAnim["glide"] = 27
NPCAnim.CombineOWAnim["sit"] = 0
NPCAnim.CombineOWAnim["crouch"] = 279
NPCAnim.CombineOWAnim["crouchwalk"] = 341
 
NPCAnim.CombineOWAnim["pistolidle"] = 1
NPCAnim.CombineOWAnim["pistolwalk"] = 344 --
NPCAnim.CombineOWAnim["pistolrun"] = 344 --
NPCAnim.CombineOWAnim["pistolcrouchwalk"] = 341 --
NPCAnim.CombineOWAnim["pistolaimidle"] = 75 --
NPCAnim.CombineOWAnim["pistolaimwalk"] = 344 --
NPCAnim.CombineOWAnim["pistolaimrun"] = 344 --
NPCAnim.CombineOWAnim["pistolaimcrouch"] = 4
NPCAnim.CombineOWAnim["pistolaimcrouchwalk"] = 341 --
NPCAnim.CombineOWAnim["pistolreload"] = 349
NPCAnim.CombineOWAnim["pistolfire"] = 118
 
NPCAnim.CombineOWAnim["smgidle"] = 1
NPCAnim.CombineOWAnim["smgwalk"] = 344 --
NPCAnim.CombineOWAnim["smgrun"] = 344 --
NPCAnim.CombineOWAnim["smgcrouchwalk"] = 341 --
NPCAnim.CombineOWAnim["smgaimidle"] = 51 --
NPCAnim.CombineOWAnim["smgaimwalk"] = 344 --
NPCAnim.CombineOWAnim["smgaimrun"] = 344 --
NPCAnim.CombineOWAnim["smgaimcrouch"] = 68
NPCAnim.CombineOWAnim["smgaimcrouchwalk"] = 341 --
NPCAnim.CombineOWAnim["smgreload"] = 349
NPCAnim.CombineOWAnim["smgfire"] = 118

NPCAnim.CombineOWAnim["ar2idle"] = 1
NPCAnim.CombineOWAnim["ar2walk"] = 335
NPCAnim.CombineOWAnim["ar2run"] = 339
NPCAnim.CombineOWAnim["ar2aimidle"] = 73
NPCAnim.CombineOWAnim["ar2aimwalk"] = 336
NPCAnim.CombineOWAnim["ar2aimrun"] = 340
NPCAnim.CombineOWAnim["ar2crouchwalk"] = 337
NPCAnim.CombineOWAnim["ar2crouch"] = 5
NPCAnim.CombineOWAnim["ar2aimcrouch"] = 5
NPCAnim.CombineOWAnim["ar2aimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["ar2reload"] = 359
NPCAnim.CombineOWAnim["ar2fire"] = 281

NPCAnim.CombineOWAnim["shotgunidle"] = 1
NPCAnim.CombineOWAnim["shotgunwalk"] = 335
NPCAnim.CombineOWAnim["shotgunrun"] = 339
NPCAnim.CombineOWAnim["shotgunaimidle"] = 301
NPCAnim.CombineOWAnim["shotgunaimwalk"] = 344
NPCAnim.CombineOWAnim["shotgunaimrun"] = 345
NPCAnim.CombineOWAnim["shotguncrouchwalk"] = 337
NPCAnim.CombineOWAnim["shotguncrouch"] = 5
NPCAnim.CombineOWAnim["shotgunaimcrouch"] = 5
NPCAnim.CombineOWAnim["shotgunaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["shotgunreload"] = 359
NPCAnim.CombineOWAnim["shotgunfire"] = 281

NPCAnim.CombineOWAnim["crossbowidle"] = 1
NPCAnim.CombineOWAnim["crossbowwalk"] = 309
NPCAnim.CombineOWAnim["crossbowrun"] = 339
NPCAnim.CombineOWAnim["crossbowaimidle"] = 256
NPCAnim.CombineOWAnim["crossbowaimwalk"] = 336
NPCAnim.CombineOWAnim["crossbowaimrun"] = 340
NPCAnim.CombineOWAnim["crossbowcrouchwalk"] = 337
NPCAnim.CombineOWAnim["crossbowcrouch"] = 5
NPCAnim.CombineOWAnim["crossbowaimcrouch"] = 5
NPCAnim.CombineOWAnim["crossbowaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["crossbowreload"] = 359
NPCAnim.CombineOWAnim["crossbowfire"] = 281

NPCAnim.CombineOWAnim["meleeidle"] = 1
NPCAnim.CombineOWAnim["meleewalk"] = 335
NPCAnim.CombineOWAnim["meleerun"] = 339
NPCAnim.CombineOWAnim["meleeaimidle"] = 73
NPCAnim.CombineOWAnim["meleeaimcrouchwalk"] = 336
NPCAnim.CombineOWAnim["meleeaimcrouch"] = 5
NPCAnim.CombineOWAnim["meleecrouchwalk"] = 337
NPCAnim.CombineOWAnim["meleecrouch"] = 5
NPCAnim.CombineOWAnim["meleeaimwalk"] = 336
NPCAnim.CombineOWAnim["meleeaimrun"] = 340
NPCAnim.CombineOWAnim["meleefire"] = 281

NPCAnim.CombineOWAnim["rpgidle"] = 1
NPCAnim.CombineOWAnim["rpgwalk"] = 335
NPCAnim.CombineOWAnim["rpgrun"] = 339
NPCAnim.CombineOWAnim["rpgaimidle"] = 298
NPCAnim.CombineOWAnim["rpgaimwalk"] = 336
NPCAnim.CombineOWAnim["rpgaimrun"] = 340
NPCAnim.CombineOWAnim["rpgcrouchwalk"] = 337
NPCAnim.CombineOWAnim["rpgcrouch"] = 5
NPCAnim.CombineOWAnim["rpgaimcrouch"] = 5
NPCAnim.CombineOWAnim["rpgaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["rpgreload"] = 359
NPCAnim.CombineOWAnim["rpgfire"] = 281

NPCAnim.CombineOWAnim["grenadeidle"] = 1
NPCAnim.CombineOWAnim["grenadewalk"] = 335
NPCAnim.CombineOWAnim["grenaderun"] = 339
NPCAnim.CombineOWAnim["grenadeaimidle"] = 1
NPCAnim.CombineOWAnim["grenadeaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["grenadeaimcrouch"] = 5
NPCAnim.CombineOWAnim["grenadecrouchwalk"] = 337
NPCAnim.CombineOWAnim["grenadecrouch"] = 5
NPCAnim.CombineOWAnim["grenadeaimwalk"] = 336
NPCAnim.CombineOWAnim["grenadeaimrun"] = 340
NPCAnim.CombineOWAnim["grenadefire"] = 273

NPCAnim.CombineOWAnim["slamidle"] = 1
NPCAnim.CombineOWAnim["slamwalk"] = 335
NPCAnim.CombineOWAnim["slamrun"] = 339
NPCAnim.CombineOWAnim["slamaimidle"] = 1
NPCAnim.CombineOWAnim["slamaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["slamaimcrouch"] = 5
NPCAnim.CombineOWAnim["slamcrouchwalk"] = 337
NPCAnim.CombineOWAnim["slamcrouch"] = 5
NPCAnim.CombineOWAnim["slamaimwalk"] = 336
NPCAnim.CombineOWAnim["slamaimrun"] = 339
NPCAnim.CombineOWAnim["slamfire"] = 281

NPCAnim.CombineOWAnim["physgunidle"] = 1
NPCAnim.CombineOWAnim["physgunwalk"] = 336
NPCAnim.CombineOWAnim["physgunrun"] = 340
NPCAnim.CombineOWAnim["physgunaimidle"] = 298
NPCAnim.CombineOWAnim["physgunaimwalk"] = 336
NPCAnim.CombineOWAnim["physgunaimrun"] = 340
NPCAnim.CombineOWAnim["physgunaimcrouchwalk"] = 337
NPCAnim.CombineOWAnim["physgunaimcrouch"] = 5

WeapActivityTranslate = { }

WeapActivityTranslate[ACT_HL2MP_IDLE_PISTOL] = "pistol";
WeapActivityTranslate[ACT_HL2MP_IDLE_SMG1] = "smg";
WeapActivityTranslate[ACT_HL2MP_IDLE_AR2] = "ar2";
WeapActivityTranslate[ACT_HL2MP_IDLE_RPG] = "rpg";
WeapActivityTranslate[ACT_HL2MP_IDLE_GRENADE] = "grenade";
WeapActivityTranslate[ACT_HL2MP_IDLE_SHOTGUN] = "shotgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_PHYSGUN] = "ar2";
WeapActivityTranslate[ACT_HL2MP_IDLE_CROSSBOW] = "shotgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_SLAM] = "slam";
WeapActivityTranslate[ACT_HL2MP_IDLE_MELEE] = "melee";
WeapActivityTranslate[ACT_HL2MP_IDLE] = "";
WeapActivityTranslate["weapon_pistol"] = "pistol";
WeapActivityTranslate["weapon_357"] = "pistol";
WeapActivityTranslate["gmod_tool"] = "pistol";
WeapActivityTranslate["weapon_smg1"] = "smg";
WeapActivityTranslate["weapon_ar2"] = "ar2";
WeapActivityTranslate["weapon_rpg"] = "rpg";
WeapActivityTranslate["weapon_frag"] = "grenade";
WeapActivityTranslate["weapon_slam"] = "slam";
WeapActivityTranslate["weapon_physgun"] = "ar2";
WeapActivityTranslate["weapon_physcannon"] = "ar2";
WeapActivityTranslate["weapon_crossbow"] = "shotgun";
WeapActivityTranslate["weapon_shotgun"] = "shotgun";
WeapActivityTranslate["weapon_crowbar"] = "melee";
WeapActivityTranslate["weapon_stunstick"] = "melee";

function GetWeaponAct( ply, act )

	local weap = ply:GetActiveWeapon();
	local class = weap:GetClass();
	
	local trans = "";
	local posttrans = "";
	
	if( weap:GetNWBool( "NPCAimed" ) ) then
		posttrans = "aim";	
	else
		
		if( weap:GetTable().NotHolsterAnim ) then
		
			act = weap:GetTable().NotHolsterAnim;
		
		end
	
	end

	if( act ~= -1 ) then
		trans = WeapActivityTranslate[act];
	else
		trans = WeapActivityTranslate[class];
	end
	
	if( ply:Team() == 2 ) then
	
		if( trans == "shotgun" or
		trans == "ar2" ) then trans = "smg"; end	

	else
	
		if( trans == "shotgun" or
		trans == "ar2" ) then trans = "smg"; end
	
	end
	
	return trans .. ( posttrans or "" );

end




function GM:SetPlayerAnimation( ply, weapanim )

	if( not NPC_ANIMS_ENABLED ) then return; end
	
	if( not ply:IsValid() or not ply:Alive() or ply:GetField( "isko" ) == 1 ) then
		return;
	end	
		
	if( LAG_TEST ) then
		
		Msg( "NPCAnim.SetPlayerAnimation : " .. ply:Nick() .. "\n" );
		
	end
	
	local seq = 0;
	
	if( not ply:GetField( "OverrideAnim" ) ) then
	
		--ply:SetField( "ChangeAnim", false );
	
		local weap = ply:GetActiveWeapon();
		local animname = ply:GetField( "WeapAnim" );
		
		if( ply:GetModel() == "models/stalker.mdl" or
			ply:GetModel() == "models/vortigaunt.mdl" ) then 

			animname = "";
			
		end
		
		
		local seqname = "";
		
		local speed = ply:GetVelocity():Length();
		
		if( speed >= 120 ) then
		
			if( ply:OnGround() and ply:Crouching() ) then
				seqname = animname .. "crouchrun";
			else
				seqname = animname .. "run";
			end
		
		elseif( speed >= 10 ) then
		
			if( ply:OnGround() and ply:Crouching() ) then
				seqname = animname .. "crouchwalk";
			else
				seqname = animname .. "walk";
			end
		
		else
			
			if( ply:OnGround() and ply:Crouching() ) then
				seqname = animname .. "crouch";
			else
				seqname = animname .. "idle";
			end
			
		end

		local AnimTable = ply:GetTable().AnimTable;
		
		if( not AnimTable ) then
		
			local model = string.lower( ply:GetModel() );
	
			ply:GetTable().AnimTable = NPCAnim.CitizenMaleAnim;
			
			if( table.HasValue( NPCAnim.CitizenFemaleModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CitizenFemaleAnim; end
			if( table.HasValue( NPCAnim.CombineMetroModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineMetroAnim; end
			if( table.HasValue( NPCAnim.CombineOWModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineOWAnim; end
			
			AnimTable = ply:GetTable().AnimTable;
		
		end
		
		if( ( weapanim == PLAYER_ATTACK1 or weapanim == PLAYER_RELOAD ) and weap:IsValid() ) then
	
			local act = nil;
		
			if( weapanim == PLAYER_RELOAD ) then
	
				local actname = string.gsub( seqname, "aim", "" ) .. "reload";
				actname = string.gsub( actname, "idle", "" );
			
				local act = tonumber( AnimTable[actname] );
				
				if( act == nil ) then
					return;
				end
	
				--ply:RestartGesture( act );
			
				--return true;
				 
			else
			
				if( ply:Team() == 2 and string.find( seqname, "melee" ) or string.find( seqname, "grenade" ) or string.find( seqname, "slam" ) ) then
				
					local actname = string.gsub( seqname, "aim", "" ) .. "fire";
					actname = string.gsub( actname, "idle", "" );
				
					local act = tonumber( AnimTable[actname] );
					
					if( act == nil ) then
						return;
					end
	
					ply:RestartGesture( act );
					ply:Weapon_SetActivity( act, 0 );
					
					return true;
					
				end
			
				return;
				
			end
		
		end
	
		if ( ( not ply:OnGround() or ply:WaterLevel() > 4 ) and 
			   not ply:InVehicle() ) then
			seqname = "glide";
		end

		local actid = AnimTable[seqname];
	
		if( actid == nil or actid == -1 ) then
			seq = ply:GetSequence();
		else
			seq = ply:SelectWeightedSequence( actid );
		end
		
		--ply:SetField( "CrntActID", seq );
		
	else
	
		seq = ply:GetField( "CrntActID" );
	
	end


	if ( ply:GetSequence() == seq ) then return true; end

	ply:SetPlaybackRate( 1 );
	ply:ResetSequence( seq );
	ply:SetCycle( 1 );
	
	return true;

end
