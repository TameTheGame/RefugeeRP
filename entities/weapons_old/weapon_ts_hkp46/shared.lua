
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "pistol";

end

SWEP.PrintName = "HK P46";

if( CLIENT ) then

	
	SWEP.Slot = 1;
	SWEP.SlotPos = 3;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel			= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )

SWEP.ViewModelFOV		= 83

SWEP.InvSize = 1;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 40;
SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Delay = .3;
SWEP.Primary.Damage = 5;
SWEP.Primary.Force = 1;
SWEP.Primary.RunCone = Vector( .05, .05, 0 );
SWEP.Primary.SpreadCone = Vector( .035, .035, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( 4.3, 2.8, 2.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );