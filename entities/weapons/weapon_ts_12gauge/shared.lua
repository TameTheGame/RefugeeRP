


if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "smg";

end

SWEP.PrintName = "SPAS-12 Shotgun";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	--SWEP.ViewModelFlip		= true	
	--SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"

SWEP.InvSize = 3;
SWEP.InvWeight = 1;
SWEP.TSAmmo = "buckshot";
SWEP.TSAmmoCount = 12;

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_Shotgun.Single" )

SWEP.ViewModelFOV		= 60

SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 12;
SWEP.Primary.Ammo = "buckshot";
SWEP.Primary.Delay = 1.1;
SWEP.Primary.Damage = 8;
SWEP.Primary.Force = 1;
SWEP.Primary.NumBullets = 9;
SWEP.Primary.RunCone = Vector( .1, .1, 0 );
SWEP.Primary.SpreadCone = Vector( .09, .09, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .09, .09, 0 );
SWEP.Primary.ViewPunch = Angle( -6.5, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.AimStatNoEffect = true;
SWEP.ReloadAtEnd = true;

SWEP.IronSightPos = Vector( -9, 3.7, -2.0 );
SWEP.IronSightAng = Vector( 0.0, 0.0, 0.0 );

/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end



function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then
		self:ToggleIronsight();
	end
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
			
			end
			
			self.Weapon:EmitSound( Sound( "Weapon_Shotgun.Reload" ) );
			
		end
	
	end

end

function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_12gauge" )

	end
end
hook.Add( "PlayerDeath", "spasdeath", weaponremove )
