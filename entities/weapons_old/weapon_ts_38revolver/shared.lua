
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
	SWEP.FOVAmt = 0;
	
end

SWEP.PrintName			= ".38 Revolver"		

if ( CLIENT ) then

		
	SWEP.Author				= "Waxx"

	SWEP.Slot				= 2
	SWEP.SlotPos			= 2
	SWEP.IconLetter			= "f"
	
	killicon.AddFont( "weapon_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "weapon_ts_base"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_38revolver.mdl"
SWEP.WorldModel			= "models/weapons/w_38revolver.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 28
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.ViewPunch = Angle( -5, 0, 0 );

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightPos = Vector( 3.6, -0.1, 4.0 );
SWEP.IronSightAng = Vector( 3.0, -1.0, 0.0 );
