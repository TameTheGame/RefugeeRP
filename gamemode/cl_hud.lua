
include( "cl_render.lua" );

surface.CreateFont( "ChatFont", 22, 500, true, false, "PlInfoFont" );
surface.CreateFont( "ChatFont", 32, 500, true, false, "AmmoFont" );
surface.CreateFont( "TargetID", 14, 500, true, false, "AmmoNameFont" );

local function DrawEnergyDisplay()
if( ValidEntity( LocalPlayer() ) ) then
	if( GetInt( "isbleeding" ) == 0 ) then
		if( ChristmasMod ) then
			DrawOutlinedMeter( LocalPlayer():Health() / GetInt( "MaxHealth" ), 2, 5, 5, ScrW() * .33, 12, Color( 10, 200, 10, 150 ) );
		else
			DrawOutlinedMeter( LocalPlayer():Health() / GetInt( "MaxHealth" ), 2, 5, 5, ScrW() * .33, 12, Color( 150, 0, 0, 150 ) );
		end
	else
		DrawOutlinedMeter( LocalPlayer():Health() / GetInt( "MaxHealth" ), 2, 5, 5, ScrW() * .33, 12, Color( 255, 20,  20, 255 ) );
	end
	
	if( ChristmasMod ) then
		DrawOutlinedMeter( GetInt( "sprint" ) / 100, 2, 5, 18, ScrW() * .33, 12, Color( 255, 255, 255, 150 ) );
	else
		DrawOutlinedMeter( GetInt( "sprint" ) / 100, 2, 5, 18, ScrW() * .33, 12, Color( 255, 217, 50, 150 ) );
	end
	
	if( GetInt( "armor" ) > 0 ) then
		if( ChristmasMod ) then
			DrawOutlinedMeter( GetInt( "armor" ) / GetInt( "MaxArmor" ), 2, 5, 31, ScrW() * .33, 12, Color( 150, 0, 0, 150 ) );
		else
			DrawOutlinedMeter( GetInt( "armor" ) / GetInt( "MaxArmor" ), 2, 5, 31, ScrW() * .33, 12, Color( 30, 30, 190, 150 ) );
		end
	end
	end
end

local function DrawDamagedDisplay()
if( ValidEntity( LocalPlayer() ) ) then
	if( not LocalPlayer():Alive() ) then return; end

	if( BlurredHit ) then
	
		DrawMotionBlur( .425, 1.0, 0 );
	
	end

	if( LocalPlayer():Health() <= 50 ) then
	
		if( LocalPlayer():Health() <= 40 ) then
		
			local blurmul = 0;
			local cutoff = 50;
			
			if( LocalPlayer():Health() <= 30 ) then
				cutoff = 120;
			end
			
			if( LocalPlayer():Health() <= 20 ) then
				cutoff = 200;
			end	
			
			blurmul = 1 - math.Clamp( LocalPlayer():Health() / cutoff, 0, 1 );
			
			-- .149
			-- .955
			-- .068
			DrawMotionBlur( .149 * blurmul, .955 * blurmul, .068 * blurmul );
			
		end
			
		surface.SetDrawColor( 135, 0, 0, 160 * ( 1 - math.Clamp( LocalPlayer():Health() / 50, 0, 1 ) ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
end
end

local AmmoNames = { }

AmmoNames["pistol"] = { "BULLET", "BULLETS" }
AmmoNames["smg1"] = { "BULLET", "BULLETS" }
AmmoNames["buckshot"] = { "BUCKSHOT", "BUCKSHOT" }
AmmoNames["rpg"] = { "ROCKET", "ROCKETS" }
AmmoNames["ar2"] = { "PULSE ROUND", "PULSE ROUNDS" }
AmmoNames["flashbang"] = { "FLASHBANG", "FLASHBANGS" }

local function DrawAmmoDisplay()
if( ValidEntity( LocalPlayer() ) ) then
	if( not LocalPlayer():Alive() ) then return; end

	local pri = 0;
	
	local ammo = nil;
	if( LocalPlayer():GetActiveWeapon():IsValid() ) then
		ammo = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType();
	end
	
	if( LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() > 0 ) then
		pri = LocalPlayer():GetActiveWeapon():Clip1();
	end
	
	local max = 0;
	
	if( LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetAmmoCount( ammo ) > 0 ) then
		max = LocalPlayer():GetAmmoCount( ammo );
	end
	
	if( pri == 0 and max == 0 ) then return; end

	if( GetInt( "holstered" ) == 1 ) then
	
		surface.SetFont( "TargetID" );
		local w, h = surface.GetTextSize( "rp_toggleholster" );
		
		draw.RoundedBox( 4, ScrW() - 35 - w, ScrH() - 65, w + 15, h + 5, Color( 50, 50, 50, 200 ) );
		draw.DrawText( "rp_toggleholster", "TargetID", ScrW() - 25, ScrH() - 62, Color( 0, 0, 0, 255 ), 2 );
		draw.DrawText( "rp_toggleholster", "TargetID", ScrW() - 26, ScrH() - 63, Color( 255, 255, 255, 255 ), 2 );
			
		return;
	
	end
	
	local ammoname = "";
	
	if( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ) and weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary and weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.Ammo and AmmoNames[string.lower( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.Ammo )] ) then
	
		if( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.IsFlashbang ) then
		
			if( pri == 1 ) then
				ammoname = "FLASHBANG";
			else
				ammoname = "FLASHBANGS";
			end
			
		elseif( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.IsFrag ) then
		
			if( pri == 1 ) then
				ammoname = "FRAG GRENADE";
			else
				ammoname = "FRAG GRENADES";
			end
		
		else
	
			ammoname = AmmoNames[string.lower( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.Ammo )][2];
			
			if( pri == 1 ) then
				ammoname = AmmoNames[string.lower( weapons.Get( LocalPlayer():GetActiveWeapon():GetClass() ).Primary.Ammo )][1];
			end
			
		end
		
	else
	
		ammoname = "";
	
	end
	
	local tsize = 0;
	
	surface.SetFont( "AmmoFont" );
	local w, h = surface.GetTextSize( pri );
	
	local prisize = w;
	tsize = w;
	
	surface.SetFont( "AmmoNameFont" );
	w, h = surface.GetTextSize( " " .. ammoname );	
	
	local namesize = w;
	
	tsize = tsize + w;
	
	--local x = ScrW() - tsize - 75;
	--local endx = ScrW() - 20;
	
	if( ChristmasMod ) then
		draw.RoundedBox( 4, ScrW() - 20 - namesize - prisize - 15, ScrH() - 65, tsize + 30, 38, Color( 255, 255, 255, 200 ) );
	else
		draw.RoundedBox( 4, ScrW() - 20 - namesize - prisize - 15, ScrH() - 65, tsize + 30, 38, Color( 50, 50, 50, 200 ) );
	end
	

	
	if( ChristmasMod ) then
	
		draw.DrawText( pri, "AmmoFont", ScrW() - 20 - namesize - 5, ScrH() - 62, Color( 0, 0, 0, 255 ), 2 );
		draw.DrawText( pri, "AmmoFont", ScrW() - 21 - namesize - 5, ScrH() - 63, Color( 255, 0, 0, 255 ), 2 );
		
		draw.DrawText( " " .. ammoname, "AmmoNameFont", ScrW() - 20 - namesize, ScrH() - 48, Color( 0, 0, 0, 255 ) );
		draw.DrawText( " " .. ammoname, "AmmoNameFont", ScrW() - 21 - namesize, ScrH() - 49, Color( 255, 0, 0, 255 ) );
		
	
	else
	
		draw.DrawText( pri, "AmmoFont", ScrW() - 20 - namesize - 5, ScrH() - 62, Color( 0, 0, 0, 255 ), 2 );
		draw.DrawText( pri, "AmmoFont", ScrW() - 21 - namesize - 5, ScrH() - 63, Color( 255, 255, 255, 255 ), 2 );
		
		draw.DrawText( " " .. ammoname, "AmmoNameFont", ScrW() - 20 - namesize, ScrH() - 48, Color( 0, 0, 0, 255 ) );
		draw.DrawText( " " .. ammoname, "AmmoNameFont", ScrW() - 21 - namesize, ScrH() - 49, Color( 255, 255, 255, 255 ) );
		
	end
	
	--draw.DrawText(  " / ", "AmmoFont", ScrW() - 75, ScrH() - 50, Color( 255, 255, 255, 255 ), 1 );
	--draw.DrawText( max, "AmmoFont", ScrW() - 35, ScrH() - 50, Color( 255, 255, 255, 255 ), 1 );
 end
end

local function DrawPlayerInfo()
if( ValidEntity( LocalPlayer() ) ) then
	surface.SetFont( "PlInfoFont" );
	local jobw, jobh = surface.GetTextSize( GetString( "job" ) );

	if( ChristmasMod ) then
		draw.RoundedBox( 4, 10, ScrH() - 125, jobw + 20, 25, Color( 245, 245, 245, 200 ) );
	else
		draw.RoundedBox( 4, 8, ScrH() - 126, jobw + 24, 27, Color( 0, 0, 0, 150 ) );
		draw.RoundedBox( 4, 10, ScrH() - 124, jobw + 20, 23, Color( 90, 90, 90, 100 ) );
	end
	
	
	
	if( ChristmasMod ) then
		draw.DrawText( GetString( "job" ), "PlInfoFont", 18, ScrH() - 125, Color( 0, 160, 0, 255 ), 0 );
	else
		--draw.DrawText( GetString( "job" ), "PlInfoFont", 20, ScrH() - 123, Color( 0, 0, 0, 255 ), 0 );
		draw.SimpleTextOutlined( GetString( "job" ), "PlInfoFont", 18, ScrH() - 125, Color( 255, 255, 255, 255 ), 0, 0, 2, Color( 0, 0, 0, 255 ) );
	end
	
	local titlew, titleh = surface.GetTextSize( GetString( "title" ) );
	titlew = titlew + 10;
	titlew = math.Clamp( titlew - 220, 0, ScrW() );

	if( ChristmasMod ) then
		draw.RoundedBox( 4, 10, ScrH() - 90, 220 + titlew, 70, Color( 0, 150, 0, 200 ) );
	else
		draw.RoundedBox( 4, 10, ScrH() - 90, 220 + titlew, 70, Color( 50, 50, 50, 200 ) );
	end
	
--	draw.DrawText( LocalPlayer():GetNWString( "title" ), "PlInfoFont", 228 + titlew, ScrH() - 85, Color( 0, 0, 0, 255 ), 2 );
	
	draw.SimpleTextOutlined( LocalPlayer():GetNWString( "title" ), "PlInfoFont", 226 + titlew, ScrH() - 87, Color( 255, 255, 255, 255 ), 2, 0, 2, Color( 0, 0, 0, 255 ) );

--	draw.DrawText( LocalPlayer():GetNWFloat( "money" ) .. " tokens", "PlInfoFont", 228 + titlew, ScrH() - 68, Color( 0, 0, 0, 255 ), 2 );
	draw.SimpleTextOutlined( LocalPlayer():GetNWFloat( "money" ) .. " credits", "PlInfoFont", 226 + titlew, ScrH() - 70, Color( 255, 255, 255, 255 ), 2, 0, 2, Color( 0, 0, 0, 255 ) );
	
	if( LocalPlayer():Team() == 1 ) then
	
	--	draw.DrawText( "ID - " .. GetFloat( "cid" ), "PlInfoFont", 228 + titlew, ScrH() - 50, Color( 0, 0, 0, 255 ), 2 );
		--draw.SimpleTextOutlined( "ID - " .. GetFloat( "cid" ), "PlInfoFont", 226 + titlew, ScrH() - 52, Color( 255, 255, 255, 255 ), 2, 0, 2, Color( 0, 0, 0, 255 ) );

		
	end
 end
end

function DrawKO()
if( ValidEntity( LocalPlayer() ) ) then

	if( GetInt( "isko" ) == 1 ) then
	
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 ) );
	
		draw.DrawText( "Consciousness.. " .. math.floor( GetFloat( "conscious" ) ) .. "%", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		
		if( GetFloat( "conscious" ) >= 100 and GetInt( "passedout" ) == 1 ) then
		
			draw.DrawText( "Type /getup to get out of being passed out", "PlInfoFont", ScrW() / 2, ScrH() * .6, Color( 255, 255, 255, 255 ), 1, 1 );
		
		end
		
		local koperc = 1;
		
		koperc = GetFloat( "conscious" ) / 100;
		
		draw.RoundedBox( 4, ScrW() * .33, ScrH() * .55, ScrW() * .33, 20, Color( 60, 60, 60, 255 ) );
		
		if( koperc > 0 ) then
			draw.RoundedBox( 4, ScrW() * .33 + 2, ScrH() * .55 + 2, ( ScrW() * .33 - 4 ) * koperc, 16, Color( 20, 20, 20, 255 ) );
		end
		
	elseif( GetFloat( "conscious" ) <= 30 ) then
	
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, math.Clamp( 255 - ( 255 * ( GetFloat( "conscious" ) / 30 ) ), 0, 200 ) ) );
	
	end
end
end

function DrawPatDown()
if( ValidEntity( LocalPlayer() ) ) then
	if( GetInt( "beingpatdown" ) == 1 ) then
	
		draw.DrawText( "Being pat down", "PlInfoFont", ScrW() / 2, 5, Color( 255, 255, 255, 255 ), 1 );
	
	end

	for k, v in pairs( player.GetAll() ) do
	
		if( v:IsPlayer() and ( v:GetNWInt( "beingpatdown" ) == 1 or GetInt( "pattingdown" ) == 1 ) and LocalPlayer():CanTraceTo( v ) and LocalPlayer():GetPos():Distance( v:GetPos() ) <= 130 ) then
		
			local ent, offset;
			
			if( v:IsRagdolled() ) then
				ent = v:GetRagdoll();
				offset = Vector( 0, 0, 10 );
			else
				ent = v;
				offset = Vector( 0, 0, 55 );
			end
		
			local pos = ( ent:GetPos() + offset ):ToScreen();
			local char = "";
			local color = Color( 255, 255, 255, 255 );
			
			if( v:GetNWInt( "beingpatdown" ) == 1 ) then
				color = Color( 255, 50, 50, 255 );
				char = "p";
			else
				char = "P";
			end
			
			draw.DrawText( char, "TargetID", pos.x, pos.y, color, 1 );
		
		end
	
	end
 end
end

function DrawTieUp()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( player.GetAll() ) do
	
		if( v:IsPlayer() and ( v:GetNWInt( "beingtiedup" ) == 1 or v:GetNWInt( "tyingup" ) == 1 ) and LocalPlayer():CanTraceTo( v ) and LocalPlayer():GetPos():Distance( v:GetPos() ) <= 130 ) then
		
			local ent, offset;
			
			if( v:IsRagdolled() ) then
				ent = v:GetRagdoll();
				offset = Vector( 0, 0, 10 );
			else
				ent = v;
				offset = Vector( 0, 0, 55 );
			end
		
			local pos = ( ent:GetPos() + offset ):ToScreen();
			local char = "";
			local color = Color( 255, 255, 255, 255 );
			
			if( v:GetNWInt( "tyingup" ) == 1 ) then
				
				if( v:GetNWInt( "untying" ) == 1 ) then
					char = "O";
				else
					char = "X";
				end
			
			end
			
			if( v:GetNWInt( "beingtiedup" ) == 1 ) then
			
				color = Color( 255, 50, 50, 255 );
			
				if( v:GetNWInt( "untying" ) == 1 ) then
					char = "O";
				else
					char = "X";
				end				
			
			end
			
			draw.DrawText( char, "TargetID", pos.x, pos.y, color, 1 );
		
		end
	
	end
	
	if( GetInt( "beingtiedup" ) == 1 ) then
	
		if( GetInt( "untying" ) == 0 and GetInt( "isko" ) == 0 ) then
			draw.DrawText( "Being tied up", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		elseif( GetInt( "isko" ) == 0 ) then
			draw.DrawText( "Being untied", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		end
		
	end
	
	if( GetInt( "tiedup" ) == 1 ) then
	
		draw.DrawText( "Tied Up", "PlInfoFont", ScrW() / 2, 5, Color( 255, 255, 255, 255 ), 1 );
	
	end
--[[
	if( GetInt( "tyingup" ) == 1 ) then
	
		if( GetInt( "untying" ) == 0 and player.GetByID( GetInt( "tieduptarget" ) ):GetNWInt( "tiedup" ) == 1 ) then
			return;
		end
	
		if( GetInt( "untying" ) == 0 ) then
			draw.DrawText( "Tying up", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		else
			draw.DrawText( "Untying", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		end
		
		local perc = 1;
		
		perc = TiedUpProcess / 100;
		
		draw.RoundedBox( 4, ScrW() * .33, ScrH() * .55, ScrW() * .33, 20, Color( 60, 60, 60, 255 ) );
		
		if( perc > 0 ) then
			draw.RoundedBox( 4, ScrW() * .33 + 2, ScrH() * .55 + 2, ( ScrW() * .33 - 4 ) * perc, 16, Color( 20, 20, 20, 255 ) );
		end

	end
	]]--
 end
end

function DrawHeal()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( player.GetAll() ) do
	
		if( v:IsPlayer() and ( v:GetNWInt( "beinghealed" ) == 1 or v:GetNWInt( "healing" ) == 1 ) and LocalPlayer():CanTraceTo( v ) and LocalPlayer():GetPos():Distance( v:GetPos() ) <= 130 ) then
		
			local ent, offset;
			
			if( v:IsRagdolled() ) then
				ent = v:GetRagdoll();
				offset = Vector( 0, 0, 10 );
			else
				ent = v;
				offset = Vector( 0, 0, 55 );
			end
		
			local pos = ( ent:GetPos() + offset ):ToScreen();
			local char = "+";
			local color = Color( 255, 255, 255, 255 );
			
			if( v:GetNWInt( "beinghealed" ) == 1 ) then
			
				color = Color( 255, 50, 50, 255 );		
			
			end
			
			draw.DrawText( char, "TargetID", pos.x, pos.y, color, 1 );
		
		end
	
	end
	
	if( GetInt( "beinghealed" ) == 1 ) then
	
		if( GetInt( "healtype" ) == 0 ) then
			draw.DrawText( "Getting Medical Aid", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		else
			draw.DrawText( "Getting Bandaged", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		end
		
	end
	
	
	--[[

	if( GetInt( "healing" ) == 1 ) then
	
		if( GetInt( "healtype" ) == 0 and GetInt( "healingself" ) == 0 ) then
			draw.DrawText( "Giving Medical Aid", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		elseif( GetInt( "healingself" ) == 0 ) then
			draw.DrawText( "Bandaging", "PlInfoFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		end
		
		local perc = 1;
		
		perc = HealProcess / 100;
		
		draw.RoundedBox( 4, ScrW() * .33, ScrH() * .55, ScrW() * .33, 20, Color( 60, 60, 60, 255 ) );
		
		if( perc > 0 ) then
			draw.RoundedBox( 4, ScrW() * .33 + 2, ScrH() * .55 + 2, ( ScrW() * .33 - 4 ) * perc, 16, Color( 20, 20, 20, 255 ) );
		end

	end
	
	]]--
 end
end

surface.CreateFont( "TargetID", 14, 500, true, false, "WeaponDesc" );

function DrawWeaponSlots()
if( ValidEntity( LocalPlayer() ) ) then	
	local perc = ( ( CurTime() - ( LastWeaponSlotUpdate + 6 ) ) / .8 );

	local basicfade = 60;
	local basictext = 100;
	
	local weaponryfade = 60;
	local weaponrytext = 100;
	
	local miscfade = 60;
	local misctext = 100;
	
	if( CurrentWeaponSlot == 1 ) then
		basicfade = 140;
		basictext = 225;
	elseif( CurrentWeaponSlot == 2 ) then
		weaponryfade = 140;
		weaponrytext = 225;
	else
		miscfade = 140;
		misctext = 225;
	end

	if( ( CurTime() - LastWeaponSlotUpdate ) > 3 ) then
		basicfade = math.Clamp( basicfade - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
		basictext = math.Clamp( basictext - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
		
		weaponryfade = math.Clamp( weaponryfade - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
		weaponrytext = math.Clamp( weaponrytext - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
		
		miscfade = math.Clamp( miscfade - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
		misctext = math.Clamp( misctext - math.Clamp(  60 * perc, 0, 255 ), 0, 255 );
	
	end

	draw.RoundedBox( 4, ScrW() * .35, 5, 110,  30, Color( 60, 60, 60, basicfade ) );
	draw.RoundedBox( 4, ScrW() * .35 + 5, 10, 100,  20, Color( 60, 60, 60, basicfade ) );
	
	draw.DrawText( "Basic", "TargetID", ScrW() * .35 + 55, 8, Color( 255, 255, 255, basictext ), 1, 1 );

	draw.RoundedBox( 4, ScrW() * .35 + 115, 5, 110,  30, Color( 60, 60, 60, weaponryfade ) );
	draw.RoundedBox( 4, ScrW() * .35 + 120, 10, 100,  20, Color( 60, 60, 60, weaponryfade ) );
	
	draw.DrawText( "Weaponry", "TargetID", ScrW() * .35 + 170, 8, Color( 255, 255, 255, weaponrytext ), 1, 1 );

	draw.RoundedBox( 4, ScrW() * .35 + 230, 5, 110, 30, Color( 60, 60, 60, miscfade ) );
	draw.RoundedBox( 4, ScrW() * .35 + 235, 10, 100, 20, Color( 60, 60, 60, miscfade ) );
	
	draw.DrawText( "Misc", "TargetID", ScrW() * .35 + 285, 8, Color( 255, 255, 255, misctext ), 1, 1 );

	if( WeaponSlots[CurrentWeaponSlot] ) then
	
		local fade = 255;
		
		if( CurrentWeaponSlot == 1 ) then
			fade = basicfade;
		elseif( CurrentWeaponSlot == 2 ) then
			fade = weaponryfade;
		else
			fade = miscfade;
		end
		
		local y = 40;
	
		for k, v in pairs( WeaponSlots[CurrentWeaponSlot] ) do
		
			local h = 25;
			local color = Color( 40, 40, 40, fade );
			
			local desc = "";
			
			if( weapons.Get( v.class ) )then
				desc = weapons.Get( v.class ).Instructions or "";
			end
			
		 	desc = FormatLine( desc, "WeaponDesc", 290 );
			
			local tw, th = surface.GetTextSize( desc );
			
			if( k == CurrentSlotPos ) then
			
				h = 80;
				color = Color( 40, 40, 128, fade );
				
				if( th + 30 > h ) then
			
					h = th + 30;
			
				end
			
			end
			
			if( ChristmasMod ) then
		
				color = Color( 245, 245, 245, fade );
		
				draw.RoundedBox( 4, ScrW() * .35, y, 340, h - 2, color );
				
				draw.DrawText( v.printname, "TargetID", ScrW() * .35 + 4, y + 2, Color( 0, 0, 0, fade ) );
				draw.DrawText( v.printname, "TargetID", ScrW() * .35 + 3, y + 1, Color( 0, 255, 0, fade ) );
				
				
				if( k == CurrentSlotPos ) then
				
					draw.DrawText( desc, "WeaponDesc", ScrW() * .35 + 3, y + 25, Color( 0, 200, 0, fade ) );			
				
				end
			
			else
			
				draw.RoundedBox( 4, ScrW() * .35, y, 340, h - 2, color );
				
				draw.DrawText( v.printname, "TargetID", ScrW() * .35 + 4, y + 2, Color( 0, 0, 0, fade ) );
				draw.DrawText( v.printname, "TargetID", ScrW() * .35 + 3, y + 1, Color( 255, 255, 255, fade ) );
				
				
				if( k == CurrentSlotPos ) then
				
					draw.DrawText( desc, "WeaponDesc", ScrW() * .35 + 3, y + 25, Color( 255, 255, 255, fade ) );			
				
				end
				
			end
			
			y = y + h;
		
		end
	
	end
 end
end

FadingBlackScreen = false;

function DrawFadingBlackScreen()
if( ValidEntity( LocalPlayer() ) ) then
	if( FadingBlackScreen ) then
	
		BlackScreenAlpha = math.Clamp( BlackScreenAlpha - 100 * FrameTime(), 0, 255 );
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, BlackScreenAlpha ) );
		
		if( BlackScreenAlpha <= 0 ) then
			FadingBlackScreen = false;
		end
	
	end
end
end

function DrawRPNameWarn()
if( ValidEntity( LocalPlayer() ) ) then
	if( NameWarnAlpha > -1 ) then
	
		local dir = 1;
		
		if( CurTime() - NameWarnStartTime > 10 ) then
			dir = -1;
			
			if( NameWarnAlpha <= 0 ) then
				NameWarnAlpha = -1;
			end
			
		end
		
		if( NameWarnAlpha > -1 ) then
		
			NameWarnAlpha = math.Clamp( NameWarnAlpha + FrameTime() * dir * 500, 0, 190 );
		
			draw.RoundedBox( 4, 10, ScrH() / 2 - 50, ScrW() - 20, 100, Color( 0, 0, 0, NameWarnAlpha ) );
			draw.DrawText( LocalPlayer():Nick() .. ": ", "GModToolSubtitle", ScrW() / 2, ScrH() / 2 - 30, Color( 255, 0, 0, NameWarnAlpha ), 1 );
			draw.DrawText( "CHANGE YOUR NAME TO A SERIOUS ROLEPLAY NAME (FIRST AND LAST) OR YOU WILL BE KICKED/BANNED", "GModToolSubtitle", ScrW() / 2, ScrH() / 2 + 10, Color( 255, 0, 0, NameWarnAlpha ), 1 );
			
		end
	
	end
  end
end

function DrawTargetInfo()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( TargetInfo ) do
	
		local ent = v.Ent;
		
		if( ent:IsValid() ) then
		
			--Fade in
			if( CurTargetEnt == ent ) then
			
				v.alpha = math.Clamp( v.alpha + 250 * FrameTime(), 0, 255 );
				
			else --Fade out
			
				v.alpha = math.Clamp( v.alpha - 200 * FrameTime(), 0, 255 );
			
			end
			
			if( ent:IsPlayer() ) then
			
				local str = "";
				local tieduptext = "";
				
			
				if( ent:GetNWInt( "tiedup" ) == 1 ) then
					tieduptext = "(Tied up)\n";
				end
			
			
				local pos = ent:EyePos();
				pos.z = pos.z + 15;
				pos = pos:ToScreen();
			
				local ncolor = { }
				ncolor = team.GetColor( ent:Team() );
				
				draw.DrawText( ent:Nick(), "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
				draw.DrawText( ent:Nick(), "TargetID", pos.x, pos.y, Color( ncolor.r, ncolor.g, ncolor.b, v.alpha ), 1 );
				
				str = "\n" .. tieduptext .. ent:GetNWString( "title" );
			
				draw.DrawText( str, "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
				draw.DrawText( str, "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );
			
			elseif( ent:IsWeapon() and not ent:IsNPC() ) then
			
				local pos = ent:GetPos():ToScreen();
			
				draw.DrawText( "[Use Key]", "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
				draw.DrawText( "[Use Key]", "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );
						
			elseif( ent:IsVehicle() ) then
			
				local pos = ent:GetPos():ToScreen();
				
				if( ent:GetNWInt( "Owned" ) == 1 ) then
			
					draw.DrawText( "Owned", "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( "Owned", "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );				
	
				else
	
					draw.DrawText( "Not Owned", "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( "Not Owned", "TargetID", pos.x, pos.y, Color( 200, 0, 0, v.alpha ), 1 );	
	
				end
				
			elseif( ent:IsDoor() ) then
			
				local pos = v.LastLookPos:ToScreen();
			
				if( ent:GetNWInt( "Owned" ) == 1 ) then
	
					draw.DrawText( ent:GetNWString( "doorname" ), "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( ent:GetNWString( "doorname" ), "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );	
				
				else
				
					local str = ent:GetNWString( "buildingname" ) .. "\n" .. ent:GetNWString( "doorname" ) ;
								
					if( ent:GetNWInt( "doorstate" ) == 0 or
						( ent:GetNWInt( "doorstate" ) == 1 and LocalPlayer():IsCombine() ) ) then
								
						local price = ent:GetNWFloat( "doorprice" );
						
						if( not ent:GetNWBool( "formatteddoor" ) or GetGlobalInt( "PropertyPaying" ) == 0 ) then
							price = 50;
						end
								
						str = str .. "\n" .. price .. " credits needed to purchase";
							
					end
										
					draw.DrawText( str, "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( str, "TargetID", pos.x, pos.y, Color( 200, 0, 0, v.alpha ), 1 );	
					
				end		
							
			elseif( ent:IsItem() ) then
			
				local pos = ent:GetPos():ToScreen();
	
				if( not ent:IsPaper() ) then
					
					draw.DrawText( ent:GetItemName() .. "\nSize: " .. ent:GetItemSize() .. "\nTake with [Use Key]", "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( ent:GetItemName() .. "\nSize: " .. ent:GetItemSize() .. "\nTake with [Use Key]", "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );	
	
				else
							
					draw.DrawText( "Read with [Use Key]", "TargetID", pos.x + 1, pos.y + 1, Color( 0, 0, 0, v.alpha ), 1 );
					draw.DrawText( "Read with [Use Key]", "TargetID", pos.x, pos.y, Color( 255, 255, 255, v.alpha ), 1 );	
					
				end		
			
			end
			
		end
		
		if( v.alpha <= 0 or not ent:IsValid() ) then
		
			TargetInfo[k] = nil;	
		
		end
		
	end
 end
end

function DrawPropInfo()
	if( ValidEntity( LocalPlayer() ) ) then
	if( LocalPlayer():KeyDown( IN_USE ) ) then

		local trace = { }
		trace.start = LocalPlayer():EyePos();
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 300;
		trace.filter = LocalPlayer();
		
		local tr = util.TraceLine( trace );
		
		if( ValidEntity( tr.Entity ) and tr.Entity:GetNWBool( "SpawnedProp" ) ) then
		
			local pos = tr.HitPos:ToScreen();
			draw.DrawText( tr.Entity:GetNWString( "CreatorLine" ), "ChatFont", pos.x, pos.y, Color( 255, 0, 0, 255 ) );
		
		end
		
	end
 end
end

function DrawAdminTitles() 
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( player.GetAll() ) do
	
		if( v ~= LocalPlayer() and v:GetNWString( "admintitle" ) ~= "" ) then
		
			local pos = v:EyePos();
			pos.z = pos.z + 5;
			pos = pos:ToScreen();
			
			draw.DrawText( v:GetNWString( "admintitle" ), "GmodToolName", pos.x, pos.y, Color( 255, 0, 0, 255 ), 1 );
		
		end
	
	end
 end
end

function DrawProcessBars()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( ProcessBars ) do

		draw.DrawText( v.name, "TargetID", v.x + ScrW() * .33 * .5, v.y - 25, Color( 255, 255, 255, 255 ), 1 ); 
	
		draw.RoundedBox( 4, v.x, v.y, ScrW() * .33, v.h, Color( 60, 60, 60, 255 ) );
		
		if( v.Process > 0 ) then
			draw.RoundedBox( 4, v.x + 2, v.y + 2, ( ( ScrW() * .33 ) - 4 ) * v.Process, v.h - 4, Color( 20, 20, 20, 255 ) );
		end
	
	end
 end
end

function DrawFlashBang()
if( ValidEntity( LocalPlayer() ) ) then
	if( FlashBangOn ) then
	
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 255, 255, FlashBangAlpha ) );
		
		if( CurTime() - FlashBangStart > 6 ) then
		
			FlashBangAlpha = FlashBangAlpha - 50 * FrameTime();
		
		end
		
		if( FlashBangAlpha <= 0 ) then
		
			FlashBangOn = false;
		
		end
	
	end
 end
end

function DrawRebelMeter()
if( ValidEntity( LocalPlayer() ) ) then
	if( LocalPlayer():HasPlayerFlag( "F" ) and LocalPlayer():HasPlayerFlag( "X" ) ) then
	
		if( PlayerMenuParent and PlayerMenuParent:IsVisible() ) then
		
			draw.RoundedBox( 4, 5, 45, ScrW() / 2, 18, Color( 0, 0, 0, 255 ) );
			draw.RoundedBox( 4, 7, 47, ( ScrW() / 2 - 4 ) * GetGlobalInt( "RebelWeaponry" ) / 100, 14, Color( 0, 128, 0, 255 ) );
			draw.DrawText( "Rebel Weaponry Meter: " .. GetGlobalInt( "RebelWeaponry" ) .. "%", "TargetID", 11, 43, Color( 0, 0, 0, 255 ) );
			draw.DrawText( "Rebel Weaponry Meter: " .. GetGlobalInt( "RebelWeaponry" ) .. "%", "TargetID", 10, 42, Color( 255, 255, 255, 255 ) );
		
		end
	
	end
 end
end

function GM:HUDPaint()
if( ValidEntity( LocalPlayer() ) ) then
	if( GetInt( "charactercreate" ) == 1 ) then
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		return true;
	end

	if( LocalPlayer():GetNWInt( "initializing" ) == 0 ) then

		DrawPropInfo();
		
		DrawDamagedDisplay();
		if( not Drug ) then
		DrawEnergyDisplay();
		DrawAmmoDisplay();
		DrawPlayerInfo();
		end
		
		if( Drug ) then
			DrawMotionBlur( .032, .990, 0 );
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 200, 0, 200, 50 ) );
		end
		
		if( CrackDrug ) then
			DrawSharpen( 1.561, 2.262 );
			if( not Drug ) then
				DrawMotionBlur( .158, .937, 0 );
			end
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 255, 255, 128 ) );
			
			draw.RoundedBox( 0, 0, ScrW(), ScrW() / 2, ScrH() / 3, Color( 255, 255, 0, 20 ) );
			draw.RoundedBox( 0, ScrW() / 2, ScrH() / 3, ScrW() / 2, ScrH() / 2, Color( 255, 0, 200, 20 ) );
			draw.RoundedBox( 0, 0, 0, ScrW() / 2, ScrH() / 3, Color( 255, 0, 0, 20 ) );
		
			if( CurTime() - DrugTime > 8 ) then
		
				for n = 1, 100 do 
				
					local str = "RUN!";
					local num = math.random( 0, 2 );
					
					if( num == 0 ) then str = "HEADCRABS"; end
					if( num == 1 ) then str = "OH SHIT!"; end
				
					draw.DrawText( str, "ChatFont", math.random( 0, ScrW() ), math.random( 0, ScrH() ), Color( 255, math.random( 0, 255 ), 255, 100 ) );
				
				end
				
			end
	
		end
		
		FadeThink();
	
	end
	
	if( LocalPlayer():GetNWInt( "initializing" ) == 0 ) then
		
		DrawTargetInfo();
		DrawChatLines();
		DrawKO();
		DrawTieUp();
		DrawHeal();
		DrawPatDown();
		
	end
	
	DrawRebelMeter();
	
	if( LocalPlayer():GetNWInt( "initializing" ) == 1 ) then
	
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
	
	end
	
	DrawFlashBang();
	
	DrawProcessBars();
	
	--DrawChatBoxLines();
	
	if( LocalPlayer():GetNWInt( "initializing" ) == 0 ) then
		
		DrawWeaponSlots();
		DrawAdminTitles();
		
		DrawNotify();
		
		DrawRPNameWarn();
	
		DrawFadingBlackScreen();

		if( SeeAll ) then
		
			for k, v in pairs( player.GetAll() ) do
			
				if( v ~= LocalPlayer() and v:GetNWInt( "IsRick" ) ~= 1 ) then
				
					local pos = v:GetPos():ToScreen();
				
					draw.DrawText( v:Nick(), "ChatFont", pos.x, pos.y, Color( 255, 0, 0, 255 ) );
				
				end
			
			end
		
		end
	
		if( GetInt( "firsttimelogin" ) == 1 ) then
		
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 ) );
		
		end
		
	end
	
	if( ChristmasCheer ) then
	
		if( CurTime() - ChristmasCheerTime > 2 ) then
		
			ChristmasCheerAlpha = math.Clamp( ChristmasCheerAlpha - 255 * FrameTime(), 0, 255 );
		
		end
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 128, 0, ChristmasCheerAlpha ) );
		
		for n = 1, 6 do 
		
			draw.DrawText( "YOU GOT HIT BY CHRISTMAS CHEER!", "GModToolName", math.random( -100, ScrW() - 100 ), math.random( 0, ScrH() ), Color( 255, 255, 255, ChristmasCheerAlpha ) );
		
		end
		
		if( ChristmasCheerAlpha <= 0 ) then
		
			ChristmasCheer = false;
		
		end
	
	end
 end
end

function GM:HUDShouldDraw( name )
if( ValidEntity( LocalPlayer() ) ) then
	if( ( LocalPlayer():GetNWInt( "initializing" ) == 1 and GetInt( "firsttimelogin" ) == 1 or ( HAWindow ) or GetInt( "charactercreate" ) == 1 ) and name ~= "CHudGMod" ) then
	
		return false;
	
	end
	
	local nodraw = 
	{
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
		"CHudChat",
		"CHudWeaponSelection"
	
	}
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end
	
	return true;
 end
end
