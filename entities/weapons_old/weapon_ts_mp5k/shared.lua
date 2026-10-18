
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "smg";

end

SWEP.PrintName = "MP5K";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83;	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel			= "models/weapons/v_smg2.mdl"
SWEP.WorldModel			= "models/weapons/w_smg2.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )

SWEP.ViewModelFOV		= 55;

SWEP.InvSize = 2;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 60;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .065;
SWEP.Primary.Damage = 7;
SWEP.Primary.Force = 1;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .052, .052, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -0.5, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( -6.5, 1.7, -3.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );