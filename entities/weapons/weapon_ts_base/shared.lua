

if( SERVER ) then

	SWEP.Weight = 5;
	SWEP.AutoSwitchTo = false;
	SWEP.AutoSwitchFrom = false;
	
	SWEP.FOVAmt = 25;
	SWEP.FOV = 90;
	
	AddCSLuaFile( "shared.lua" );

end

if( CLIENT ) then

	SWEP.DrawAmmo = true;
	SWEP.DrawCrosshair = false;
	SWEP.ViewModelFOV = 50;
	SWEP.DefaultFOV = 50;
	SWEP.ViewModelFlip = false;

	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )	

end

SWEP.Author = "JT";
SWEP.Contact = "";
SWEP.Purpose = "";
SWEP.Instructions = "";

SWEP.Spawnable = false;
SWEP.AdminSpawnable = true;

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Ammo = "";
SWEP.Primary.Automatic = false;

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Ammo = "";
SWEP.Secondary.Automatic = false;

SWEP.ViewPunchStray = false; --Enabled or not
SWEP.ViewPunchOffset = Vector( 0, 0, 0 ); --Offset to view punch
SWEP.ViewPunchAdd = Vector( 0, 0, 0 ); --How much to add to the view punch offset
SWEP.StraySpeed = 0; --Multiplier.  How fast the view punch offset is changed

SWEP.SwayUpDownAmt = 0;
SWEP.SwayLeftRightAmt = 0;

SWEP.CanLearn = true;

SWEP.HolsterViewable = false;
SWEP.SprintHolster = false;
SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Vector( 0, 0, 0 );

function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( self.HoldType );
		self.Weapon:SetNWBool( "ironsights", false );
	
		self.Weapon:GetTable().TSAmmoCount = self.TSAmmoCount;
	
	end

end

function SWEP:ToggleWeaponHolster( holster )

	self.Weapon:SetNWBool( "GoHolster", holster );
	self.Weapon:SetNWInt( "HolsterTime", CurTime() );
	
end

function SWEP:CanShootPrimary()

	if( not self:CanPrimaryAttack() ) then return false; end

	if( not self.Weapon:GetNWBool( "NPCAimed" ) ) then
		return false;
	end
	
	return true;

end

function SWEP:Reload()

	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self.Weapon:SetNWBool( "ironsights", false );
	
	if( self.NoDrawOnIronSights ) then
	
		if( SERVER ) then
			self.Owner:DrawViewModel( true );
		end
	
	end
	
	self.ViewPunchOffset = Vector( 0, 0, 0 );
	
	if( SERVER ) then
		self.Owner:SetFOV( self.FOV, .6 );
	end

end

function SWEP:Equip( ply )

	if( self.TSAmmo ) then
		--[[
		if( not ply:GetTable().AmmoCount[self.TSAmmo] ) then
			ply:GetTable().AmmoCount[self.TSAmmo] = 0;
		end
		
		
		ply:GetTable().AmmoCount[self.TSAmmo] = ply:GetTable().AmmoCount[self.TSAmmo] + self.Weapon:GetTable().TSAmmoCount;
		]]--
	end

end

function SWEP:Deploy()

	self.Weapon:SetNWBool( "ironsights", false );
	self.IronSights  = nil;
	
	self.ViewPunchOffset = Vector( 0, 0, 0 );
	
	if( SERVER ) then
		self.Owner:SetFOV( self.FOV, 0 );
	end
	
	self.LearnCurve = 0;
	
	if( SERVER ) then
		self.Owner:DrawViewModel( true );
	end
	
end

function SWEP:Think()

	if( SERVER ) then

		if( self.Weapon:GetNWBool( "ironsights" ) ) then
		
			if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then
			
				self:ToggleIronsight();
			
			end
		
		end
		
	end

	if( not self.Owner:KeyDown( IN_ATTACK ) ) then
	
		if( self.ViewPunchStray and self.ViewPunchOffset.x ~= 0 and self.ViewPunchOffset.y ~= 0 and self.ViewPunchOffset.z ~= 0 ) then
		
			self.ViewPunchOffset.x = math.Clamp( FrameTime() * self.ViewPunchOffset.x - self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
			self.ViewPunchOffset.y = math.Clamp( FrameTime() * self.ViewPunchOffset.y - self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
			self.ViewPunchOffset.z = math.Clamp( FrameTime() * self.ViewPunchOffset.z - self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
		
		end
		
	end

end

function SWEP:ToggleIronsight()

	self.Weapon:SetNWBool( "ironsights", !self.Weapon:GetNWBool( "ironsights" ) );

	if( self.NoDrawOnIronSights ) then
	
		if( SERVER ) then
			timer.Simple( .2, self.Owner.DrawViewModel, self.Owner, !self.Weapon:GetNWBool( "ironsights" ) );
		end
		
	end

	if( not self.Weapon:GetNWBool( "NPCAimed" ) ) then
		self.Weapon:SetNWBool( "ironsights", false );
	end
	
	if( self.Weapon:GetNWBool( "ironsights" ) and not self.NoIronSightFovChange ) then
	
		if( SERVER ) then
			self.Owner:SetFOV( self.FOV - self.FOVAmt, .5 );
		end
	
	else
	
		if( SERVER ) then
			self.Owner:SetFOV( self.FOV, .5 );
		end	
	
	end
	
	if( self.IronSightSound ) then
		self.Weapon:EmitSound( self.IronSightSound );
	end
	
end


function SWEP:PrimaryAttack()

	if( self.Owner:GetNWInt( "tiedup" ) == 1 ) then 
		return; 
	end

	if( not self:CanShootPrimary() ) then return; end

	if( self.Weapon:GetNWBool( "ironsights" ) and self.NoIronSightAttack ) then return; end
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then return; end

	if( CLIENT ) then
		self.Weapon:EmitSound( self.Primary.Sound );
	else
		self.Weapon:EmitSound( self.Primary.Sound, self.Volume, 100 );
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or .5 ) );
	
	self:TakePrimaryAmmo( 1 );
	self:TSShootBullet();
	
	local punchmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );

	self.Owner:ViewPunch( self.Primary.ViewPunch * punchmul );

	if( self.ViewPunchStray ) then
	
		self.ViewPunchOffset.x = math.Clamp( self.ViewPunchOffset.x + self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.y = math.Clamp( self.ViewPunchOffset.y + self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.z = math.Clamp( self.ViewPunchOffset.z + self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
			
	end
	
end

function SWEP:SecondaryAttack()

	if( self.Owner:GetNWInt( "tiedup" ) == 1 ) then 
		return; 
	end

	if( self.Weapon:GetNWBool( "ironsights" ) or not self.Owner:KeyDown( IN_SPEED ) or ( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() < 120 ) ) then
			
			self:ToggleIronsight();
	end

end

function SWEP:TSShootBullet()

	local bullet = { }

	bullet.Num = self.Primary.NumBullets or 1;
	bullet.Src = self.Owner:GetShootPos();
	bullet.Dir = self.Owner:GetAimVector();
	bullet.Spread = self.Primary.SpreadCone or Vector( 0, 0, 0 );
	bullet.AmmoType = self.Primary.Ammo;
	--[[
	if( SERVER and self.TSAmmoCount ) then
	
		self.Weapon:GetTable().TSAmmoCount = self.Weapon:GetTable().TSAmmoCount - 1;
		self.Owner:GetTable().AmmoCount[self.TSAmmo] = self.Owner:GetTable().AmmoCount[self.TSAmmo] - 1;
	
		
	
	end
]]--
	if( self.Weapon:GetNWBool( "ironsights" ) ) then
	
		if( self.AimSway ) then
	
			
		end

	end
	
	if( self.Owner:KeyDown( IN_DUCK ) ) then
	
		bullet.Spread = self.Primary.CrouchSpreadCone or bullet.Spread;
	
	elseif( self.Owner:KeyDown( IN_SPEED ) ) then
	
		bullet.Spread = self.Primary.RunCone or bullet.Spread;
	
	end
	
	local spreadmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );
	local aimoffset = math.Clamp( 30 / self.Owner:GetNWFloat( "stat.Aim" ), .1, 2.7 );
	
	if( self.AimStatNoEffect ) then
	
		aimoffset = 1;
		spreadmul = 1;
	
	end
	
	bullet.Spread = bullet.Spread * aimoffset;
	
	if( self.Owner:Health() <= 35 ) then
	
		spreadmul = spreadmul + math.random( .1, 1 );
		
	end
	
	bullet.Spread = bullet.Spread * spreadmul;
	bullet.Spread = bullet.Spread + self.ViewPunchOffset;
	
	bullet.Tracer = 4;
	bullet.Force = self.Primary.Force or 10;
	bullet.Damage = self.Primary.Damage or 10;
	
	self.Owner:FireBullets( bullet );
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if( self.Weapon:Clip1() == 0 and self.ReloadAtEnd ) then
	
		self:Reload();
	
	end

end

function SWEP:GetViewModelPosition( pos, ang )

	local doironsights = false;

	self.BobScale = 1;
	self.SwayScale = 1;
	
	if( self.Weapon:GetNWBool( "HolsterSwitch" ) ) then

		self.HolsterMul = math.Clamp( ( CurTime() - self.HolsterTime ), 0, 1 )

		ang:RotateAroundAxis( ang:Right(), self.HolsterAng.x * self.HolsterMul );
		ang:RotateAroundAxis( ang:Up(), self.HolsterAng.y * self.HolsterMul );
		ang:RotateAroundAxis( ang:Forward(), self.HolsterAng.z * self.HolsterMul );
		
		pos = pos + self.HolsterPos.x * ang:Right() * self.HolsterMul;
		pos = pos + self.HolsterPos.y * ang:Up() * self.HolsterMul;
		pos = pos + self.HolsterPos.z * ang:Forward() * self.HolsterMul;

	elseif( self.Weapon:GetNWBool( "ironsights" ) ) then

		self.BobScale = .4;
		self.SwayScale = .4;

		if( not self.IronSights ) then

			self.IronSightTime = CurTime();
			self.IronSightMul = self.IronSightMul or 0;
			self.IronSights = true;
		
		end

		self.IronSightMul = math.Clamp( ( CurTime() - self.IronSightTime ) * 2.5, 0, 1 );
		doironsights = true;
	
	elseif( self.IronSightMul and self.IronSightMul > 0.0 ) then
	
		if( self.IronSights ) then
		
			self.IronSights = false;
			self.IronSightTime = CurTime();
			self.OldIronSightMul = self.IronSightMul or 0;
		
		end

		self.IronSightMul = self.OldIronSightMul - math.Clamp( ( ( CurTime() - self.IronSightTime ) * 2.5 ), 0, 1 );
		doironsights = true;
		
		if( self.IronSightMul == 0 ) then
			self.IronSightTime = nil;
		end
	
	else
	--	self.ViewModelFOV = self.DefaultFOV;
	end

	if( doironsights ) then

		ang:RotateAroundAxis( ang:Right(), self.IronSightAng.x * self.IronSightMul );
		ang:RotateAroundAxis( ang:Up(), self.IronSightAng.y * self.IronSightMul );
		ang:RotateAroundAxis( ang:Forward(), self.IronSightAng.z * self.IronSightMul );

		pos = pos + self.IronSightPos.x * ang:Right() * self.IronSightMul;
		pos = pos + self.IronSightPos.y * ang:Up() * self.IronSightMul;
		pos = pos + self.IronSightPos.z * ang:Forward() * self.IronSightMul;
	
		if( self.AimSway ) then
	
			ang:RotateAroundAxis( ang:Up(), self.SwayCone.x * math.sin( self.SwayLeftRightAmt ) );
			ang:RotateAroundAxis( ang:Right(), self.SwayCone.y * math.sin( self.SwayUpDownAmt ) );
			
			self.SwayUpDownAmt = self.SwayUpDownAmt + math.random( 0, 1 ) * FrameTime();
			self.SwayLeftRightAmt = self.SwayLeftRightAmt + math.random( 0, 1 ) * FrameTime();
			
			if( self.SwayUpDownAmt > 360 ) then self.SwayUpDownAmt = 0; end
			if( self.SwayLeftRightAmt > 360 ) then self.SwayLeftRightAmt = 0; end
		
		end
	
	
	end
	
	if( LocalPlayer():Health() <= 50 ) then 
	
		if( LocalPlayer():Health() <= 15 ) then
			self.BobScale = 1.2;
			self.SwayScale = 1.2;
		elseif( LocalPlayer():Health() <= 30 ) then
			self.BobScale = 1;
			self.SwayScale = 1;
		elseif( LocalPlayer():Health() <= 40 ) then
			self.BobScale = .8;
			self.SwayScale = .8;
		else
			self.BobScale = .6;
			self.SwayScale = .6;
		end
		
	end
	
	self.BobScale = self.BobScale * math.Clamp( ( 20 / LocalPlayer():GetNWFloat( "stat.Aim" ) ), .2, 5 );
	self.SwayScale = self.SwayScale * math.Clamp( ( 20 / LocalPlayer():GetNWFloat( "stat.Aim" ) ), .2, 5 );
	
	return pos, ang;

end

function SWEP:DrawHUD()

	if( self.DrawDotCrosshair and self.Owner:GetNWInt( "holstered" ) == 0 ) then
	
		draw.DrawText( "O", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
	
	end

end

